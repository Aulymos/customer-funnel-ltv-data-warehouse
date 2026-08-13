-- Load order facts by mapping source values to warehouse surrogate keys.

INSERT INTO dw.fact_orders (
    order_id,
    user_key,
    date_key,
    order_timestamp,
    amount,
    currency,
    payment_method,
    status
)
SELECT
    o.order_id,
    u.user_key,
    d.date_key,
    o.order_timestamp,
    o.amount,
    o.currency,
    o.payment_method,
    o.status
FROM staging.orders AS o
JOIN dw.dim_users AS u
    ON o.user_id = u.user_id
JOIN dw.dim_date AS d
    ON o.order_date = d.full_date
ON CONFLICT (order_id) DO NOTHING;
