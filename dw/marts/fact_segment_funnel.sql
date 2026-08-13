-- Segment funnel mart: one row per region and age group.

BEGIN;

DROP TABLE IF EXISTS marts.fact_segment_funnel;

CREATE TABLE marts.fact_segment_funnel AS
WITH segment_spine AS (
    SELECT DISTINCT
        region,
        age_group
    FROM dw.dim_users
    WHERE region IS NOT NULL
      AND age_group IS NOT NULL
),
segment_views AS (
    SELECT
        u.region,
        u.age_group,
        COUNT(DISTINCT e.user_key) AS view_users
    FROM dw.fact_events AS e
    JOIN dw.dim_users AS u
        ON e.user_key = u.user_key
    WHERE e.event_type = 'view'
    GROUP BY u.region, u.age_group
),
segment_clicks AS (
    SELECT
        u.region,
        u.age_group,
        COUNT(DISTINCT e.user_key) AS click_users
    FROM dw.fact_events AS e
    JOIN dw.dim_users AS u
        ON e.user_key = u.user_key
    WHERE e.event_type = 'click'
    GROUP BY u.region, u.age_group
),
segment_paid_orders AS (
    SELECT
        u.region,
        u.age_group,
        COUNT(DISTINCT o.user_key) AS purchase_users
    FROM dw.fact_orders AS o
    JOIN dw.dim_users AS u
        ON o.user_key = u.user_key
    WHERE o.status = 'paid'
    GROUP BY u.region, u.age_group
)
SELECT
    s.region,
    s.age_group,
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
FROM segment_spine AS s
LEFT JOIN segment_views AS v
    USING (region, age_group)
LEFT JOIN segment_clicks AS c
    USING (region, age_group)
LEFT JOIN segment_paid_orders AS p
    USING (region, age_group);

ALTER TABLE marts.fact_segment_funnel
    ADD CONSTRAINT pk_fact_segment_funnel
    PRIMARY KEY (region, age_group);

COMMIT;
