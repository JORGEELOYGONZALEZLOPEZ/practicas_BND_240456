USE db_test_7b;

SELECT
    r.case_code,
    r.run_token,
    r.buyer_ID,
    u.nick AS buyer_nick,
    r.seller_ID,
    r.buyer_order_ID,
    o.subtotal,
    o.fulfillment_status,
    r.cart_ID,
    r.address_ID,
    r.creation_date
FROM p04_case_runs r
JOIN tb_users u ON u.ID = r.buyer_ID
JOIN tb_buyer_orders o ON o.ID = r.buyer_order_ID
ORDER BY r.ID;

SELECT
    r.case_code,
    p.installment_number,
    p.installment_count,
    p.amount,
    p.payment_method,
    p.payment_status,
    p.failure_reason
FROM p04_case_runs r
JOIN tb_payments p ON p.order_ID = r.buyer_order_ID
ORDER BY r.ID, p.installment_number;

SELECT
    r.case_code,
    s.shipment_status,
    s.delivery_mode,
    s.pickup_point,
    s.tracking_number
FROM p04_case_runs r
JOIN tb_shipments s ON s.buyer_order_ID = r.buyer_order_ID
ORDER BY r.ID, s.ID;

SELECT
    r.case_code,
    c.cancellation_status,
    ci.quantity AS canceled_quantity,
    ci.unit_amount,
    rf.amount AS refund_amount,
    rf.refund_status
FROM p04_case_runs r
JOIN tb_cancellations c ON c.buyer_order_ID = r.buyer_order_ID
LEFT JOIN tbd_cancellation_items ci ON ci.cancellation_ID = c.ID
LEFT JOIN tb_refunds rf ON rf.cancellation_ID = c.ID
ORDER BY r.ID, c.ID;

SELECT
    r.case_code,
    gc.code,
    gc.coupon_status,
    gc.balance,
    cr.redemption_status,
    cr.amount
FROM p04_case_runs r
JOIN tb_buyer_orders o ON o.ID = r.buyer_order_ID
JOIN tbd_gift_coupon_redemptions cr ON cr.buyer_order_ID = o.ID
JOIN tbc_gift_coupons gc ON gc.ID = cr.coupon_ID
ORDER BY r.ID;

SELECT table_name, table_operation, db_user, operation_date, operation_description
FROM tb_logs
WHERE operation_date >= (
    SELECT MIN(creation_date) FROM p04_case_runs
)
ORDER BY operation_date DESC
LIMIT 100;
