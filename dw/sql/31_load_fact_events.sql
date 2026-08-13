-- Load event facts by mapping source values to warehouse surrogate keys.

INSERT INTO dw.fact_events (
    event_id,
    user_key,
    date_key,
    device_key,
    channel_key,
    event_type,
    event_timestamp,
    session_id
)
SELECT
    e.event_id,
    u.user_key,
    d.date_key,
    dv.device_key,
    c.channel_key,
    e.event_type,
    e.event_timestamp,
    e.session_id
FROM staging.events AS e
JOIN dw.dim_users AS u
    ON e.user_id = u.user_id
JOIN dw.dim_date AS d
    ON e.event_date = d.full_date
JOIN dw.dim_device AS dv
    ON e.device = dv.device
JOIN dw.dim_channel AS c
    ON e.channel = c.channel
ON CONFLICT (event_id) DO NOTHING;
