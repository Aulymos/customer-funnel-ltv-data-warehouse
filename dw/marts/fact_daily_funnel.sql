-- Daily funnel mart: one row per observed calendar date.

BEGIN;

DROP TABLE IF EXISTS marts.fact_daily_funnel;

CREATE TABLE marts.fact_daily_funnel AS
WITH daily_views AS (
    SELECT
        date_key,
        COUNT(DISTINCT user_key) AS view_users
    FROM dw.fact_events
    WHERE event_type = 'view'
    GROUP BY date_key
),
daily_clicks AS (
    SELECT
        date_key,
        COUNT(DISTINCT user_key) AS click_users
    FROM dw.fact_events
    WHERE event_type = 'click'
    GROUP BY date_key
),
daily_paid_orders AS (
    SELECT
        date_key,
        COUNT(DISTINCT user_key) AS purchase_users
    FROM dw.fact_orders
    WHERE status = 'paid'
    GROUP BY date_key
)
SELECT
    d.full_date AS date,
    COALESCE(v.view_users, 0) AS view_users,
    COALESCE(c.click_users, 0) AS click_users,
    COALESCE(p.purchase_users, 0) AS purchase_users,
    ROUND(
        COALESCE(c.click_users, 0)::numeric
        / NULLIF(COALESCE(v.view_users, 0), 0),
        4
    ) AS view_to_click_rate,
    ROUND(
        COALESCE(p.purchase_users, 0)::numeric
        / NULLIF(COALESCE(c.click_users, 0), 0),
        4
    ) AS click_to_purchase_rate,
    ROUND(
        COALESCE(p.purchase_users, 0)::numeric
        / NULLIF(COALESCE(v.view_users, 0), 0),
        4
    ) AS overall_conversion_rate
FROM dw.dim_date AS d
LEFT JOIN daily_views AS v
    ON d.date_key = v.date_key
LEFT JOIN daily_clicks AS c
    ON d.date_key = c.date_key
LEFT JOIN daily_paid_orders AS p
    ON d.date_key = p.date_key;

ALTER TABLE marts.fact_daily_funnel
    ADD CONSTRAINT pk_fact_daily_funnel PRIMARY KEY (date);

COMMIT;
