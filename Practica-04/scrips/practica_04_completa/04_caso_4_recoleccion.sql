USE db_test_7b;

CALL sp_p04_create_user('C4', 'buyer', @buyer_ID);
CALL sp_p04_create_user('C4', 'seller', @seller_ID);
SET @token = REPLACE(UUID(), '-', '');

DROP TEMPORARY TABLE IF EXISTS p04_items;
CREATE TEMPORARY TABLE p04_items (
    product_ID INT UNSIGNED NOT NULL PRIMARY KEY,
    quantity INT UNSIGNED NOT NULL
);

INSERT INTO p04_items (product_ID, quantity)
SELECT p.ID, 1 + FLOOR(RAND() * 3)
FROM tb_products p
WHERE p.status = b'1' AND p.current_stock >= 3
ORDER BY RAND()
LIMIT 3;

SET @item_count = (SELECT COUNT(*) FROM p04_items);
CALL sp_p04_assert_count(@item_count, 3,
    'Caso 4: se requieren tres productos activos con stock mínimo de tres.');

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
VALUES (@buyer_ID, 'Casa caso 4', 'Usuario de prueba C4',
        '5550000000', 1, b'1');
SET @address_ID = LAST_INSERT_ID();
INSERT INTO tbd_address_components (address_ID, value, component_type)
VALUES
    (@address_ID, 'Calle Principal 400', 'street'),
    (@address_ID, 'Colonia Centro', 'neighborhood'),
    (@address_ID, 'Puebla', 'city'),
    (@address_ID, 'Puebla', 'state'),
    (@address_ID, '72000', 'postal_code'),
    (@address_ID, 'MX', 'country');

INSERT INTO tbd_user_payment_methods
    (user_ID, payment_method_type_ID, provider, provider_method_ref,
     label, last_four, is_default, status)
SELECT @buyer_ID, ID, 'P04_SIM', CONCAT('spei-', @token),
       'SPEI simulado', '0001', 1, b'1'
FROM tbc_payment_methods_types
WHERE code = 'SPEI';
SET @user_payment_method_ID = LAST_INSERT_ID();
CALL sp_p04_assert_count(@user_payment_method_ID, 1,
    'Caso 4: falta el tipo SPEI en tbc_payment_methods_types.');

INSERT INTO tb_payments
    (order_ID, user_payment_method_ID, amount, payment_method, provider,
     provider_reference, payment_status)
VALUES (@order_ID, @user_payment_method_ID, @total, 'Cash', 'P04_SIM',
        CONCAT('P04-C4-', @token), 'Pending');
SET @payment_ID = LAST_INSERT_ID();
UPDATE tb_payments SET payment_status = 'Authorized'
WHERE ID = @payment_ID;
UPDATE tb_payments SET payment_status = 'Paid', paid_date = NOW()
WHERE ID = @payment_ID;

UPDATE tb_products p
JOIN p04_items i ON i.product_ID = p.ID
SET p.current_stock = p.current_stock - i.quantity;

INSERT INTO tb_shipments
    (buyer_order_ID, address_ID, carrier, tracking_number,
     shipping_cost, shipment_status, delivery_mode, pickup_point)
VALUES (@order_ID, @address_ID, 'P04_SIM',
        CONCAT('P04-C4-', @token), 0, 'Pending', 'Home', NULL);
SET @shipment_ID = LAST_INSERT_ID();

/* Primer intento fallido en el domicilio; después queda para recolección. */
UPDATE tb_shipments
SET shipment_status = 'Failed'
WHERE ID = @shipment_ID;
UPDATE tb_shipments
SET delivery_mode = 'Pickup',
    pickup_point = 'Centro de recolección de prueba - Sucursal 01',
    shipment_status = 'Delivered',
    delivered_date = NOW()
WHERE ID = @shipment_ID;
UPDATE tb_buyer_orders SET fulfillment_status = 'Delivered'
WHERE ID = @order_ID;

INSERT INTO p04_case_runs
    (case_code, run_token, buyer_ID, seller_ID, cart_ID, buyer_order_ID, address_ID)
VALUES ('C4', @token, @buyer_ID, @seller_ID, @cart_ID, @order_ID, @address_ID);

SELECT 'Caso 4 completado: SPEI guardado, cobro en efectivo' AS resultado,
       @order_ID AS buyer_order_ID, @payment_ID AS payment_ID,
       @shipment_ID AS shipment_ID;
SELECT delivery_mode, pickup_point, shipment_status
FROM tb_shipments
WHERE ID = @shipment_ID;

COMMIT;
