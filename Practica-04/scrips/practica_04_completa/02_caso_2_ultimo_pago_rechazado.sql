USE db_test_7b;

CALL sp_p04_create_user('C2', 'buyer', @buyer_ID);
CALL sp_p04_create_user('C2', 'seller', @seller_ID);
SET @token = REPLACE(UUID(), '-', '');

DROP TEMPORARY TABLE IF EXISTS p04_items;
CREATE TEMPORARY TABLE p04_items (
    product_ID INT UNSIGNED NOT NULL PRIMARY KEY,
    quantity INT UNSIGNED NOT NULL
);

INSERT INTO p04_items (product_ID, quantity)
SELECT p.ID, 1 + FLOOR(RAND() * 5)
FROM tb_products p
WHERE p.status = b'1' AND p.current_stock >= 6
ORDER BY RAND()
LIMIT 10;

SET @item_count = (SELECT COUNT(*) FROM p04_items);
CALL sp_p04_assert_count(@item_count, 10,
    'Caso 2: se requieren diez productos activos con stock mínimo de cinco.');

START TRANSACTION;

INSERT INTO tbd_products_users
    (user_ID, product_ID, type_ownership, status, avalaible_date)
SELECT @seller_ID, product_ID, 'Reseller', b'1', NOW()
FROM p04_items
ON DUPLICATE KEY UPDATE status = b'1', avalaible_date = NOW();

INSERT INTO tb_carts (user_ID, status) VALUES (@buyer_ID, b'1');
SET @cart_ID = LAST_INSERT_ID();
INSERT INTO tbd_carts_items (cart_ID, provider_ID, product_ID, quantity)
SELECT @cart_ID, @seller_ID, product_ID, quantity FROM p04_items;

SELECT SUM(i.quantity * p.current_price) INTO @total
FROM p04_items i
JOIN tb_products p ON p.ID = i.product_ID;

INSERT INTO tb_buyer_orders
    (buyer_ID, seller_ID, subtotal, shipping_cost, fulfillment_status, status)
VALUES (@buyer_ID, @seller_ID, @total, 0, 'Accepted', b'1');
SET @order_ID = LAST_INSERT_ID();

INSERT INTO tbd_order_items
    (seller_order_ID, product_ID, provider_ID, product_name, quantity, unit_price)
SELECT @order_ID, p.ID, @seller_ID, p.name, i.quantity, p.current_price
FROM p04_items i
JOIN tb_products p ON p.ID = i.product_ID;

INSERT INTO tb_user_addresses
    (user_ID, address_label, recipient_name, recipient_phone, is_default, status)
VALUES (@buyer_ID, 'Trabajo caso 2', 'Usuario de prueba C2',
        '5550000000', 0, b'1');
SET @address_ID = LAST_INSERT_ID();
INSERT INTO tbd_address_components (address_ID, value, component_type)
VALUES
    (@address_ID, 'Av. Trabajo 200', 'street'),
    (@address_ID, 'Colonia Industrial', 'neighborhood'),
    (@address_ID, 'Puebla', 'city'),
    (@address_ID, 'Puebla', 'state'),
    (@address_ID, '72000', 'postal_code'),
    (@address_ID, 'MX', 'country');

INSERT INTO tbd_user_payment_methods
    (user_ID, payment_method_type_ID, provider, provider_method_ref,
     label, last_four, is_default, status)
SELECT @buyer_ID, ID, 'P04_SIM', CONCAT('credit-', @token),
       'Crédito simulado', '5555', 1, b'1'
FROM tbc_payment_methods_types
WHERE code = 'CREDIT_CARD';
SET @user_payment_method_ID = LAST_INSERT_ID();
CALL sp_p04_assert_count(@user_payment_method_ID, 1,
    'Caso 2: falta el tipo CREDIT_CARD en tbc_payment_methods_types.');

DROP TEMPORARY TABLE IF EXISTS p04_installments;
CREATE TEMPORARY TABLE p04_installments (n SMALLINT UNSIGNED PRIMARY KEY);
INSERT INTO p04_installments VALUES (1), (2), (3), (4), (5), (6);

INSERT INTO tb_payments
    (order_ID, user_payment_method_ID, amount, payment_method, provider,
     provider_reference, payment_status, installment_number, installment_count)
SELECT @order_ID, @user_payment_method_ID,
       IF(n < 6, ROUND(@total / 6, 2), @total - ROUND(@total / 6, 2) * 5),
       'Card', 'P04_SIM', CONCAT('P04-C2-', @token, '-', n),
       'Pending', n, 6
FROM p04_installments;

UPDATE tb_payments
SET payment_status = 'Authorized'
WHERE order_ID = @order_ID AND installment_number BETWEEN 1 AND 5;
UPDATE tb_payments
SET payment_status = 'Paid', paid_date = NOW()
WHERE order_ID = @order_ID AND installment_number BETWEEN 1 AND 5;
UPDATE tb_payments
SET failure_reason = 'Límite excedido de crédito',
    payment_status = 'Failed'
WHERE order_ID = @order_ID AND installment_number = 6;

/* La práctica pide entregar aunque falle el sexto pago; es solo una simulación. */
UPDATE tb_products p
JOIN p04_items i ON i.product_ID = p.ID
SET p.current_stock = p.current_stock - i.quantity;

INSERT INTO tb_shipments
    (buyer_order_ID, address_ID, carrier, tracking_number,
     shipping_cost, shipment_status, delivery_mode)
VALUES (@order_ID, @address_ID, 'P04_SIM',
        CONCAT('P04-C2-', @token), 0, 'Pending', 'Home');
SET @shipment_ID = LAST_INSERT_ID();
UPDATE tb_shipments
SET shipment_status = 'Delivered', shipped_date = NOW(), delivered_date = NOW()
WHERE ID = @shipment_ID;
UPDATE tb_buyer_orders SET fulfillment_status = 'Delivered'
WHERE ID = @order_ID;

SELECT ID INTO @damaged_order_item_ID
FROM tbd_order_items
WHERE seller_order_ID = @order_ID
ORDER BY ID
LIMIT 1;
SELECT product_ID, unit_price
INTO @damaged_product_ID, @damaged_unit_price
FROM tbd_order_items
WHERE ID = @damaged_order_item_ID;

INSERT INTO tb_returns
    (buyer_order_ID, order_item_ID, user_ID, quantity,
     return_reason, return_status)
VALUES (@order_ID, @damaged_order_item_ID, @buyer_ID, 1,
        'Producto recibido dañado; solicitar reenvío', 'Requested');
SET @return_ID = LAST_INSERT_ID();
INSERT INTO tbd_return_items
    (return_ID, order_item_ID, quantity, unit_amount, item_reason, item_condition)
VALUES (@return_ID, @damaged_order_item_ID, 1, @damaged_unit_price,
        'Daño reportado por el cliente', 'Damaged');
UPDATE tb_products
SET current_stock = current_stock - 1
WHERE ID = @damaged_product_ID AND current_stock > 0;
UPDATE tb_returns
SET return_status = 'Completed', resolved_date = NOW(),
    resolution_notes = 'Reenvío autorizado para la simulación'
WHERE ID = @return_ID;

INSERT INTO tb_shipments
    (buyer_order_ID, address_ID, carrier, tracking_number,
     shipping_cost, shipment_status, delivery_mode)
VALUES (@order_ID, @address_ID, 'P04_SIM',
        CONCAT('P04-C2-RE-', @token), 0, 'Pending', 'Home');
SET @replacement_shipment_ID = LAST_INSERT_ID();
UPDATE tb_shipments
SET shipment_status = 'Delivered', shipped_date = NOW(), delivered_date = NOW()
WHERE ID = @replacement_shipment_ID;

INSERT INTO p04_case_runs
    (case_code, run_token, buyer_ID, seller_ID, cart_ID, buyer_order_ID, address_ID)
VALUES ('C2', @token, @buyer_ID, @seller_ID, @cart_ID, @order_ID, @address_ID);

SELECT 'Caso 2 completado según el flujo solicitado' AS resultado,
       @buyer_ID AS buyer_ID, @order_ID AS buyer_order_ID,
       @return_ID AS return_ID, @replacement_shipment_ID AS reenvio_ID;
SELECT installment_number, amount, payment_status, failure_reason
FROM tb_payments
WHERE order_ID = @order_ID
ORDER BY installment_number;

COMMIT;
