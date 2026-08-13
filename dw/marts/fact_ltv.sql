-- LTV-proxy mart: observed paid revenue per registered user.
-- Grain: registration month × region × age group.

BEGIN;

DROP TABLE IF EXISTS marts.fact_ltv;

CREATE TABLE marts.fact_ltv AS
WITH user_cohort AS (
    SELECT
        user_key,
        DATE_TRUNC('month', registration_date)::date AS registration_month,
        region,
        age_group
    FROM dw.dim_users
    WHERE registration_date IS NOT NULL
      AND region IS NOT NULL
      AND age_group IS NOT NULL
),
user_revenue AS (
    SELECT
        user_key,
        SUM(amount) AS total_revenue
    FROM dw.fact_orders
    WHERE status = 'paid'
    GROUP BY user_key
),
user_level AS (
    SELECT
        c.registration_month,
        c.region,
        c.age_group,
        c.user_key,
        COALESCE(r.total_revenue, 0) AS user_revenue
    FROM user_cohort AS c
    LEFT JOIN user_revenue AS r
        ON c.user_key = r.user_key
)
SELECT
    registration_month,
    region,
    age_group,
    COUNT(DISTINCT user_key) AS total_users,
    SUM(user_revenue) AS total_revenue,
    ROUND(
        SUM(user_revenue)::numeric
        / NULLIF(COUNT(DISTINCT user_key), 0),
        2
    ) AS ltv
FROM user_level
GROUP BY
    registration_month,
    region,
    age_group;

ALTER TABLE marts.fact_ltv
    ADD CONSTRAINT pk_fact_ltv
    PRIMARY KEY (registration_month, region, age_group);

COMMENT ON COLUMN marts.fact_ltv.ltv IS
    'Observed-period paid revenue per registered user; a portfolio LTV proxy.';

COMMIT;
