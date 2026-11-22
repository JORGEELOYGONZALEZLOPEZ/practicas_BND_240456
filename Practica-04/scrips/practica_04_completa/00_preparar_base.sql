/*
  Ejecutar una sola vez, después de restaurar Respaldo20261113.sql.
  Agrega únicamente los datos que faltan para representar los cinco casos.
  Requiere MySQL 8 y una cuenta administradora de db_test_7b.
*/
USE db_test_7b;

ALTER TABLE tb_buyer_orders
    ADD COLUMN buyer_ID INT NULL AFTER ID,
    ADD CONSTRAINT fk_p04_order_buyer
        FOREIGN KEY (buyer_ID) REFERENCES tb_users (ID);

ALTER TABLE tb_payments
    MODIFY COLUMN payment_method
        ENUM('Card', 'SPEI', 'Transfer', 'Cash', 'GiftCoupon') NOT NULL,
    ADD COLUMN user_payment_method_ID BIGINT UNSIGNED NULL AFTER order_ID,
    ADD COLUMN installment_number SMALLINT UNSIGNED NOT NULL DEFAULT 1,
    ADD COLUMN installment_count SMALLINT UNSIGNED NOT NULL DEFAULT 1,
    ADD COLUMN failure_reason VARCHAR(250) NULL,
    ADD COLUMN refunded_amount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    ADD CONSTRAINT fk_p04_payment_method
        FOREIGN KEY (user_payment_method_ID)
        REFERENCES tbd_user_payment_methods (ID),
    ADD CONSTRAINT chk_p04_refunded_amount
        CHECK (refunded_amount >= 0 AND refunded_amount <= amount);

ALTER TABLE tb_payment_transactions
    MODIFY COLUMN event_type
        ENUM('Created', 'Authorized', 'Captured', 'Failed', 'Refunded',
             'PartiallyRefunded', 'Voided') NOT NULL;

ALTER TABLE tb_shipments
    ADD COLUMN delivery_mode ENUM('Home', 'Pickup') NOT NULL DEFAULT 'Home',
    ADD COLUMN pickup_point VARCHAR(200) NULL;

CREATE TABLE tbc_gift_coupons (
    ID INT UNSIGNED NOT NULL AUTO_INCREMENT,
    code VARCHAR(50) NOT NULL,
    assigned_user_ID INT NULL,
    original_amount DECIMAL(12,2) NOT NULL,
    balance DECIMAL(12,2) NOT NULL,
    coupon_status ENUM('Available', 'Redeemed', 'Blocked') NOT NULL DEFAULT 'Available',
    creation_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_update DATETIME NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (ID),
    UNIQUE KEY uk_p04_coupon_code (code),
    CONSTRAINT fk_p04_coupon_user
        FOREIGN KEY (assigned_user_ID) REFERENCES tb_users (ID),
    CONSTRAINT chk_p04_coupon_amounts
        CHECK (original_amount >= 0 AND balance >= 0 AND balance <= original_amount)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tbd_gift_coupon_redemptions (
    ID BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    coupon_ID INT UNSIGNED NOT NULL,
    buyer_order_ID INT UNSIGNED NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    redemption_status ENUM('Reserved', 'Redeemed', 'Released') NOT NULL DEFAULT 'Reserved',
    creation_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_update DATETIME NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (ID),
    KEY idx_p04_redemption_order (buyer_order_ID),
    CONSTRAINT fk_p04_redemption_coupon
        FOREIGN KEY (coupon_ID) REFERENCES tbc_gift_coupons (ID),
    CONSTRAINT fk_p04_redemption_order
        FOREIGN KEY (buyer_order_ID) REFERENCES tb_buyer_orders (ID),
    CONSTRAINT chk_p04_redemption_amount CHECK (amount > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE p04_case_runs (
    ID BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    case_code VARCHAR(10) NOT NULL,
    run_token CHAR(32) NOT NULL,
    buyer_ID INT NOT NULL,
    seller_ID INT NOT NULL,
    cart_ID INT NOT NULL,
    buyer_order_ID INT UNSIGNED NOT NULL,
    address_ID INT NOT NULL,
    creation_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (ID),
    UNIQUE KEY uk_p04_case_token (case_code, run_token),
    KEY idx_p04_case_buyer (buyer_ID),
    KEY idx_p04_case_order (buyer_order_ID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO tbc_payment_methods_types (code, description)
VALUES
    ('DEBIT_CARD', 'Tarjeta de débito simulada'),
    ('CREDIT_CARD', 'Tarjeta de crédito simulada'),
    ('SPIN', 'Billetera digital Spin simulada'),
    ('SPEI', 'Cuenta SPEI simulada'),
    ('GIFT_COUPON', 'Cupón de regalo simulado')
ON DUPLICATE KEY UPDATE description = VALUES(description), status = b'1';

DROP PROCEDURE IF EXISTS sp_p04_assert_count;
DROP PROCEDURE IF EXISTS sp_p04_create_user;

DELIMITER $$

CREATE PROCEDURE sp_p04_assert_count(
    IN p_actual INT,
    IN p_expected INT,
    IN p_message VARCHAR(250)
)
BEGIN
    IF p_actual IS NULL OR p_actual < p_expected THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = p_message;
    END IF;
END$$

CREATE PROCEDURE sp_p04_create_user(
    IN p_case_code VARCHAR(10),
    IN p_kind VARCHAR(10),
    OUT p_user_id INT
)
BEGIN
    DECLARE v_token CHAR(32);
    DECLARE v_email VARCHAR(100);
    DECLARE v_nick VARCHAR(50);

    SET v_token = REPLACE(UUID(), '-', '');
    SET v_email = CONCAT('p04_', LOWER(p_case_code), '_', LOWER(p_kind),
                         '_', v_token, '@example.test');
    SET v_nick = CONCAT('p04_', LOWER(p_case_code), '_', LOWER(p_kind),
                        '_', v_token);

    CALL sp_register_new_user(
        v_email,
        v_nick,
        'P04_Simulacion_2026!',
        NULL,
        CONCAT('Usuario de prueba ', p_case_code),
        p_kind,
        '1995-05-15',
        'Prefiero no decirlo',
        'MX',
        '5550000000'
    );

    SELECT ID INTO p_user_id
    FROM tb_users
    WHERE email = v_email;
END$$

DROP TRIGGER IF EXISTS trg_payments_after_update$$

CREATE TRIGGER trg_payments_after_update
AFTER UPDATE ON tb_payments
FOR EACH ROW
BEGIN
    IF OLD.payment_status <> NEW.payment_status THEN
        INSERT INTO tb_payment_transactions
            (payment_ID, event_type, amount, event_reference, remarks)
        VALUES (
            NEW.ID,
            CASE NEW.payment_status
                WHEN 'Pending' THEN 'Created'
                WHEN 'Authorized' THEN 'Authorized'
                WHEN 'Paid' THEN 'Captured'
                WHEN 'Failed' THEN 'Failed'
                WHEN 'Cancelled' THEN 'Voided'
                WHEN 'Refunded' THEN 'Refunded'
                WHEN 'PartiallyRefunded' THEN 'PartiallyRefunded'
                ELSE 'Failed'
            END,
            CASE
                WHEN NEW.payment_status IN ('Refunded', 'PartiallyRefunded')
                    THEN NEW.refunded_amount
                ELSE NEW.amount
            END,
            NEW.provider_reference,
            CASE
                WHEN NEW.payment_status = 'Failed'
                    THEN COALESCE(NEW.failure_reason, 'Pago rechazado')
                WHEN NEW.payment_status IN ('Refunded', 'PartiallyRefunded')
                    THEN CONCAT('Importe reembolsado: ', NEW.refunded_amount)
                ELSE CONCAT('Cambio de estado: ', OLD.payment_status, ' -> ', NEW.payment_status)
            END
        );
    END IF;

    INSERT INTO tb_logs
        (table_name, table_operation, db_user, operation_date,
         operation_description, operation_status)
    VALUES ('tb_payments', 'update', USER(), NOW(),
            CONCAT('ID: ', NEW.ID, ', order_ID: ', NEW.order_ID,
                   ', status: ', OLD.payment_status, ' -> ', NEW.payment_status),
            b'1');
END$$

DELIMITER ;

SELECT 'Preparación de Práctica 04 completada' AS resultado;
