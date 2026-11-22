USE db_test_7b;

CALL sp_p04_create_user('C3', 'buyer', @buyer_ID);
CALL sp_p04_create_user('C3', 'seller', @seller_ID);
SET @token = REPLACE(UUID(), '-', '');

SELECT pc.category_ID INTO @category_ID
FROM tbd_products_categories pc
JOIN tb_products p ON p.ID = pc.product_ID
WHERE pc.status = b'1' AND p.status = b'1' AND p.current_stock >= 10
GROUP BY pc.category_ID
HAVING COUNT(*) >= 3
ORDER BY RAND()
LIMIT 1;

DROP TEMPORARY TABLE IF EXISTS p04_items;
CREATE TEMPORARY TABLE p04_items (
    product_ID INT UNSIGNED NOT NULL PRIMARY KEY,
    quantity INT UNSIGNED NOT NULL
);

INSERT INTO p04_items (product_ID, quantity)
SELECT p.ID, 1 + FLOOR(RAND() * 10)
FROM tb_products p
JOIN tbd_products_categories pc ON pc.product_ID = p.ID
WHERE pc.category_ID = @category_ID
  AND pc.status = b'1' AND p.status = b'1' AND p.current_stock >= 10
ORDER BY RAND()
LIMIT 3;

SET @item_count = (SELECT COUNT(*) FROM p04_items);
CALL sp_p04_assert_count(@item_count, 3,
    'Caso 3: no se encontraron tres productos activos de una categoría con stock.');

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
VALUES (@buyer_ID, 'Casa Papás', 'Usuario de prueba C3',
        '5550000000', 0, b'1');
SET @address_ID = LAST_INSERT_ID();
INSERT INTO tbd_address_components (address_ID, value, component_type)
VALUES
    (@address_ID, 'Calle Familiar 300', 'street'),
    (@address_ID, 'Colonia Centro', 'neighborhood'),
    (@address_ID, 'Puebla', 'city'),
    (@address_ID, 'Puebla', 'state'),
    (@address_ID, '72000', 'postal_code'),
    (@address_ID, 'MX', 'country');

INSERT INTO tbd_user_payment_methods
    (user_ID, payment_method_type_ID, provider, provider_method_ref,
     label, last_four, is_default, status)
SELECT @buyer_ID, ID, 'P04_SIM', CONCAT('spin-', @token),
       'Spin simulado', '1234', 1, b'1'
FROM tbc_payment_methods_types
WHERE code = 'SPIN';
SET @user_payment_method_ID = LAST_INSERT_ID();
CALL sp_p04_assert_count(@user_payment_method_ID, 1,
    'Caso 3: falta el tipo SPIN en tbc_payment_methods_types.');

INSERT INTO tb_payments
    (order_ID, user_payment_method_ID, amount, payment_method, provider,
     provider_reference, payment_status)
VALUES (@order_ID, @user_payment_method_ID, @total, 'Cash', 'P04_SIM',
        CONCAT('P04-C3-', @token), 'Pending');
SET @payment_ID = LAST_INSERT_ID();
UPDATE tb_payments SET payment_status = 'Authorized'
WHERE ID = @payment_ID;
UPDATE tb_payments SET payment_status = 'Paid', paid_date = NOW()
WHERE ID = @payment_ID;

UPDATE tb_products p
JOIN p04_items i ON i.product_ID = p.ID
SET p.current_stock = p.current_stock - i.quantity;

SELECT oi.ID, oi.product_ID, oi.product_name, oi.quantity, oi.unit_price
INTO @cancel_order_item_ID, @cancel_product_ID, @cancel_product_name,
     @cancel_quantity, @cancel_unit_price
FROM tbd_order_items oi
WHERE oi.seller_order_ID = @order_ID
ORDER BY oi.ID
LIMIT 1;
SET @refund_amount = @cancel_quantity * @cancel_unit_price;

INSERT INTO tb_cancellations
    (buyer_order_ID, user_ID, cancellation_reason, cancellation_status)
VALUES (@order_ID, @buyer_ID, 'Cancelación parcial solicitada por el cliente',
        'Approved');
SET @cancellation_ID = LAST_INSERT_ID();
INSERT INTO tbd_cancellation_items
    (cancellation_ID, order_item_ID, quantity, unit_amount, item_reason)
VALUES (@cancellation_ID, @cancel_order_item_ID, @cancel_quantity,
        @cancel_unit_price, 'Cancelar este producto completo');
UPDATE tb_products
SET current_stock = current_stock + @cancel_quantity
WHERE ID = @cancel_product_ID;

UPDATE tb_buyer_orders
SET subtotal = GREATEST(subtotal - @refund_amount, 0)
WHERE ID = @order_ID;
UPDATE tb_cancellations
SET cancellation_status = 'Completed', resolved_date = NOW(),
    resolution_notes = 'Se actualizó el subtotal y se autorizó el reembolso'
WHERE ID = @cancellation_ID;

INSERT INTO tb_refunds
    (payment_ID, cancellation_ID, amount, refund_reason,
     refund_status, processed_date, resolution_notes)
VALUES (@payment_ID, @cancellation_ID, @refund_amount,
        'Reembolso del producto cancelado', 'Completed', NOW(),
        'Reembolso parcial de la simulación');
SET @refund_ID = LAST_INSERT_ID();
UPDATE tb_payments
SET refunded_amount = @refund_amount, payment_status = 'PartiallyRefunded'
WHERE ID = @payment_ID;

INSERT INTO tb_shipments
    (buyer_order_ID, address_ID, carrier, tracking_number,
     shipping_cost, shipment_status, delivery_mode)
VALUES (@order_ID, @address_ID, 'P04_SIM',
        CONCAT('P04-C3-', @token), 0, 'Pending', 'Home');
SET @shipment_ID = LAST_INSERT_ID();
UPDATE tb_shipments
SET shipment_status = 'Delivered', shipped_date = NOW(), delivered_date = NOW()
WHERE ID = @shipment_ID;
UPDATE tb_buyer_orders SET fulfillment_status = 'Delivered'
WHERE ID = @order_ID;

INSERT INTO p04_case_runs
    (case_code, run_token, buyer_ID, seller_ID, cart_ID, buyer_order_ID, address_ID)
VALUES ('C3', @token, @buyer_ID, @seller_ID, @cart_ID, @order_ID, @address_ID);

SELECT 'Caso 3 completado: Spin guardado, cobro en efectivo' AS resultado,
       @order_ID AS buyer_order_ID, @cancellation_ID AS cancellation_ID,
       @refund_ID AS refund_ID, @refund_amount AS monto_reembolsado,
       @shipment_ID AS shipment_ID;

COMMIT;
