INSERT INTO staging.users (
    user_id,
    registration_date,
    region,
    age_group,
    source_file
)
SELECT
    user_id,
    registration_date,
    region,
    age_group,
    source_file
FROM raw.users_raw;