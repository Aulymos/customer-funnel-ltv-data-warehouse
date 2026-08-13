-- =========================================================
-- File: 23_load_dim_device.sql
-- Purpose: Populate dw.dim_device from staging.events
-- Source: staging.events.device
-- Notes:
--   - Loads distinct device values only
--   - Safe for repeated execution via ON CONFLICT
-- =========================================================

INSERT INTO dw.dim_device (
    device
)
SELECT DISTINCT
    e.device
FROM staging.events e 
WHERE e.device IS NOT NULL
ON CONFLICT (device) DO NOTHING;