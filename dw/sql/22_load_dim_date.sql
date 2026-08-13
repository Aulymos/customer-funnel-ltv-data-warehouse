-- Populate the date dimension from staging event and order dates.

INSERT INTO dw.dim_date (
    date_key,
    full_date,
    year,
    quarter,
    month,
    day,
    day_name,
    week_of_year
)
SELECT DISTINCT
    TO_CHAR(d.full_date, 'YYYYMMDD')::int AS date_key,
    d.full_date,
    EXTRACT(YEAR FROM d.full_date)::int AS year,
    EXTRACT(QUARTER FROM d.full_date)::int AS quarter,
    EXTRACT(MONTH FROM d.full_date)::int AS month,
    EXTRACT(DAY FROM d.full_date)::int AS day,
    TRIM(TO_CHAR(d.full_date, 'Day')) AS day_name,
    EXTRACT(WEEK FROM d.full_date)::int AS week_of_year
FROM (
    SELECT event_date AS full_date
    FROM staging.events
    UNION
    SELECT order_date AS full_date
    FROM staging.orders
) AS d
WHERE d.full_date IS NOT NULL
ON CONFLICT (full_date) DO NOTHING;
