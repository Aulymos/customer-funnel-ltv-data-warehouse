-- =========================================================
-- File: 24_load_dim_channel.sql
-- Purpose: Populate dw.dim_channel from staging.events
-- Source: staging.events.channel
-- Notes:
--   - Loads distinct channel values only
--   - Safe for repeated execution via ON CONFLICT
-- =========================================================

INSERT INTO dw.dim_channel (
    channel
)
SELECT DISTINCT
    e.channel
FROM staging.events e
WHERE e.channel IS NOT NULL
ON CONFLICT (channel) DO NOTHING;