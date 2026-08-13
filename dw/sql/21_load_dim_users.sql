-- =========================================================
-- File: 21_load_dim_users.sql
-- Purpose: Load data into dw.dim_users
-- Source: staging.users
-- Notes:
--   - Uses the business key (user_id) to prevent duplicates
--   - Safe for repeated execution via ON CONFLICT
-- =========================================================

INSERT INTO dw.dim_users (
    user_id,
    registration_date,
    region,
    age_group
)

SELECT 
    s.user_id,
    s.registration_date,
    s.region,
    s.age_group
FROM staging.users s 
ON CONFLICT (user_id) DO NOTHING;