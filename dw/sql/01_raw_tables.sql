-- Create source-aligned raw landing tables for the supplied CSV files.

BEGIN;

CREATE SCHEMA IF NOT EXISTS raw;

CREATE TABLE IF NOT EXISTS raw.users_raw (
    user_id           BIGINT,
    registration_date DATE,
    region             TEXT,
    age_group          TEXT,
    source_file        TEXT,
    ingested_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_raw_users_user_id
    ON raw.users_raw (user_id);

DO $$
DECLARE
    d DATE;
    table_name TEXT;
BEGIN
    FOR d IN
        SELECT generate_series(
            '2025-10-01'::date,
            '2025-10-07'::date,
            interval '1 day'
        )::date
    LOOP
        table_name := 'events_' || TO_CHAR(d, 'YYYYMMDD') || '_raw';

        EXECUTE FORMAT(
            'CREATE TABLE IF NOT EXISTS raw.%I (
                event_id        BIGINT,
                user_id         BIGINT,
                event_type      TEXT,
                event_timestamp TIMESTAMPTZ,
                device          TEXT,
                channel         TEXT,
                session_id      TEXT,
                source_file     TEXT,
                ingested_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
            )',
            table_name
        );

        EXECUTE FORMAT(
            'CREATE INDEX IF NOT EXISTS %I ON raw.%I (user_id)',
            'idx_' || table_name || '_user_id',
            table_name
        );
    END LOOP;
END $$;

DO $$
DECLARE
    d DATE;
    table_name TEXT;
BEGIN
    FOR d IN
        SELECT generate_series(
            '2025-10-01'::date,
            '2025-10-07'::date,
            interval '1 day'
        )::date
    LOOP
        table_name := 'orders_' || TO_CHAR(d, 'YYYYMMDD') || '_raw';

        EXECUTE FORMAT(
            'CREATE TABLE IF NOT EXISTS raw.%I (
                order_id        BIGINT,
                user_id         BIGINT,
                order_timestamp TIMESTAMPTZ,
                amount          NUMERIC(12,2),
                currency        TEXT,
                payment_method  TEXT,
                status          TEXT,
                source_file     TEXT,
                ingested_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
            )',
            table_name
        );

        EXECUTE FORMAT(
            'CREATE INDEX IF NOT EXISTS %I ON raw.%I (user_id)',
            'idx_' || table_name || '_user_id',
            table_name
        );
    END LOOP;
END $$;

COMMIT;
