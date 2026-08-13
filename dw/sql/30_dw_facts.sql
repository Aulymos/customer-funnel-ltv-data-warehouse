-- Create event-level and order-level fact tables.
-- Business identifiers are unique so repeated loads remain safe.

BEGIN;

CREATE TABLE IF NOT EXISTS dw.fact_events (
    event_key       BIGSERIAL PRIMARY KEY,
    event_id        BIGINT NOT NULL,
    user_key        INT NOT NULL,
    date_key        INT NOT NULL,
    device_key      INT NOT NULL,
    channel_key     INT NOT NULL,
    event_type      VARCHAR(50) NOT NULL,
    event_timestamp TIMESTAMPTZ NOT NULL,
    session_id      VARCHAR(100),

    CONSTRAINT uq_fact_events_event_id UNIQUE (event_id),
    CONSTRAINT fk_fact_events_user
        FOREIGN KEY (user_key) REFERENCES dw.dim_users (user_key),
    CONSTRAINT fk_fact_events_date
        FOREIGN KEY (date_key) REFERENCES dw.dim_date (date_key),
    CONSTRAINT fk_fact_events_device
        FOREIGN KEY (device_key) REFERENCES dw.dim_device (device_key),
    CONSTRAINT fk_fact_events_channel
        FOREIGN KEY (channel_key) REFERENCES dw.dim_channel (channel_key)
);

CREATE TABLE IF NOT EXISTS dw.fact_orders (
    order_key       BIGSERIAL PRIMARY KEY,
    order_id        BIGINT NOT NULL,
    user_key        INT NOT NULL,
    date_key        INT NOT NULL,
    order_timestamp TIMESTAMPTZ NOT NULL,
    amount           NUMERIC(12,2) NOT NULL,
    currency         VARCHAR(10) NOT NULL,
    payment_method   VARCHAR(50),
    status           VARCHAR(50),

    CONSTRAINT uq_fact_orders_order_id UNIQUE (order_id),
    CONSTRAINT fk_fact_orders_user
        FOREIGN KEY (user_key) REFERENCES dw.dim_users (user_key),
    CONSTRAINT fk_fact_orders_date
        FOREIGN KEY (date_key) REFERENCES dw.dim_date (date_key)
);

CREATE INDEX IF NOT EXISTS idx_fact_events_user_key
    ON dw.fact_events (user_key);
CREATE INDEX IF NOT EXISTS idx_fact_events_date_key
    ON dw.fact_events (date_key);
CREATE INDEX IF NOT EXISTS idx_fact_events_device_key
    ON dw.fact_events (device_key);
CREATE INDEX IF NOT EXISTS idx_fact_events_channel_key
    ON dw.fact_events (channel_key);
CREATE INDEX IF NOT EXISTS idx_fact_events_event_type
    ON dw.fact_events (event_type);
CREATE INDEX IF NOT EXISTS idx_fact_events_event_timestamp
    ON dw.fact_events (event_timestamp);

CREATE INDEX IF NOT EXISTS idx_fact_orders_user_key
    ON dw.fact_orders (user_key);
CREATE INDEX IF NOT EXISTS idx_fact_orders_date_key
    ON dw.fact_orders (date_key);
CREATE INDEX IF NOT EXISTS idx_fact_orders_order_timestamp
    ON dw.fact_orders (order_timestamp);
CREATE INDEX IF NOT EXISTS idx_fact_orders_status
    ON dw.fact_orders (status);

COMMIT;
