USE db_test_7b;

CALL sp_p04_create_user('C5', 'buyer', @buyer_ID);
CALL sp_p04_create_user('C5', 'seller', @seller_ID);
SET @token = REPLACE(UUID(), '-', '');

SELECT ID, current_stock INTO @product_ID, @original_stock
FROM tb_products
WHERE status = b'1' AND current_price > 0
ORDER BY ID
LIMIT 1;
CALL sp_p04_assert_count(@product_ID, 1,
    'Caso 5: no hay productos activos para simular la falta de inventario.');

START TRANSACTION;

UPDATE tb_products SET current_stock = 0 WHERE ID = @product_ID;

INSERT INTO tbd_products_users
    (user_ID, product_ID, type_ownership, status, avalaible_date)
VALUES (@seller_ID, @product_ID, 'Reseller', b'1', NOW())
ON DUPLICATE KEY UPDATE status = b'1', avalaible_date = NOW();

INSERT INTO tb_carts (user_ID, status) VALUES (@buyer_ID, b'1');
SET @cart_ID = LAST_INSERT_ID();
INSERT INTO tbd_carts_items (cart_ID, provider_ID, product_ID, quantity)
VALUES (@cart_ID, @seller_ID, @product_ID, 1);

SELECT current_price INTO @unit_price
FROM tb_products WHERE ID = @product_ID;

INSERT INTO tb_buyer_orders
    (buyer_ID, seller_ID, subtotal, shipping_cost, fulfillment_status, status)
VALUES (@buyer_ID, @seller_ID, @unit_price, 0, 'Pending', b'1');
SET @order_ID = LAST_INSERT_ID();

INSERT INTO tbd_order_items
    (seller_order_ID, product_ID, provider_ID, product_name, quantity, unit_price)
SELECT @order_ID, ID, @seller_ID, name, 1, current_price
FROM tb_products WHERE ID = @product_ID;

INSERT INTO tb_user_addresses
    (user_ID, address_label, recipient_name, recipient_phone, is_default, status)
VALUES (@buyer_ID, 'Casa caso 5', 'Usuario de prueba C5',
        '5550000000', 1, b'1');
SET @address_ID = LAST_INSERT_ID();

INSERT INTO tbd_address_components (address_ID, value, component_type)
VALUES
    (@address_ID, 'Calle Prueba 500', 'street'),
    (@address_ID, 'Colonia Centro', 'neighborhood'),
    (@address_ID, 'Puebla', 'city'),
    (@address_ID, 'Puebla', 'state'),
    (@address_ID, '72000', 'postal_code'),
    (@address_ID, 'MX', 'country');

SET @coupon_code = CONCAT('P04-C5-', @token);
INSERT INTO tbc_gift_coupons
    (code, assigned_user_ID, original_amount, balance, coupon_status)
VALUES (@coupon_code, @buyer_ID, @unit_price, @unit_price, 'Available');
SET @coupon_ID = LAST_INSERT_ID();

INSERT INTO tbd_user_payment_methods
    (user_ID, payment_method_type_ID, provider, provider_method_ref,
     label, is_default, status)
SELECT @buyer_ID, ID, 'P04_COUPON', @coupon_code,
       'Cupón de regalo simulado', 1, b'1'
FROM tbc_payment_methods_types
WHERE code = 'GIFT_COUPON';
SET @user_payment_method_ID = LAST_INSERT_ID();
CALL sp_p04_assert_count(@user_payment_method_ID, 1,
    'Caso 5: falta el tipo GIFT_COUPON en tbc_payment_methods_types.');

INSERT INTO tbd_gift_coupon_redemptions
    (coupon_ID, buyer_order_ID, amount, redemption_status)
VALUES (@coupon_ID, @order_ID, @unit_price, 'Reserved');
SET @redemption_ID = LAST_INSERT_ID();

/* Simula que el cupón se aplicó antes de validar el stock. */
UPDATE tbc_gift_coupons
SET balance = 0, coupon_status = 'Redeemed'
WHERE ID = @coupon_ID;
UPDATE tbd_gift_coupon_redemptions
SET redemption_status = 'Redeemed'
WHERE ID = @redemption_ID;

/* Validación fallida: no se crea envío ni pago capturado. */
INSERT INTO tb_cancellations
    (buyer_order_ID, user_ID, cancellation_reason, cancellation_status,
     resolution_notes, resolved_date)
VALUES (@order_ID, @buyer_ID, 'Falta de inventario',
        'Completed', 'Pedido cancelado; cupón liberado', NOW());
SET @cancellation_ID = LAST_INSERT_ID();
UPDATE tb_buyer_orders
SET fulfillment_status = 'Canceled'
WHERE ID = @order_ID;
UPDATE tbd_gift_coupon_redemptions
SET redemption_status = 'Released'
WHERE ID = @redemption_ID;
UPDATE tbc_gift_coupons
SET assigned_user_ID = NULL, balance = original_amount, coupon_status = 'Available'
WHERE ID = @coupon_ID;
UPDATE tb_products SET current_stock = @original_stock WHERE ID = @product_ID;

INSERT INTO p04_case_runs
    (case_code, run_token, buyer_ID, seller_ID, cart_ID, buyer_order_ID, address_ID)
VALUES ('C5', @token, @buyer_ID, @seller_ID, @cart_ID, @order_ID, @address_ID);

SELECT 'Caso 5 completado: inventario insuficiente y cupón liberado' AS resultado,
       @order_ID AS buyer_order_ID, @cancellation_ID AS cancellation_ID,
       @coupon_code AS coupon_reasignado;
SELECT coupon_status, balance, assigned_user_ID
FROM tbc_gift_coupons
WHERE ID = @coupon_ID;

COMMIT;
