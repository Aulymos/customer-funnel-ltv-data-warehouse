BEGIN;

CREATE SCHEMA IF NOT EXISTS staging;

DROP TABLE IF EXISTS staging.orders;
DROP TABLE IF EXISTS staging.events;
DROP TABLE IF EXISTS staging.users;

CREATE TABLE staging.users (
    user_id             BIGINT PRIMARY KEY,
    registration_date   DATE,
    region              TEXT,
    age_group           TEXT,
    source_file         TEXT,
    loaded_at           TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE staging.events (
    event_id            BIGINT PRIMARY KEY,
    user_id             BIGINT,
    event_type          TEXT,
    event_timestamp     TIMESTAMPTZ,
    event_date          DATE,
    device              TEXT,
    channel             TEXT,
    session_id          TEXT,
    source_file         TEXT,
    loaded_at           TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE staging.orders (
    order_id            BIGINT PRIMARY KEY,
    user_id             BIGINT,
    order_timestamp     TIMESTAMPTZ,
    order_date          DATE,
    amount              NUMERIC(12,2),
    currency            TEXT,
    payment_method      TEXT,
    status              TEXT,
    source_file         TEXT,
    loaded_at           TIMESTAMPTZ DEFAULT NOW()
);

COMMIT;