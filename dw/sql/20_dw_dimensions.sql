-- Create dimensions used by the event and order facts.

BEGIN;

CREATE TABLE IF NOT EXISTS dw.dim_users (
    user_key         SERIAL PRIMARY KEY,
    user_id          BIGINT NOT NULL,
    registration_date DATE,
    region             VARCHAR(50),
    age_group          VARCHAR(20),
    CONSTRAINT uq_dim_users_user_id UNIQUE (user_id)
);

CREATE TABLE IF NOT EXISTS dw.dim_date (
    date_key     INT PRIMARY KEY,
    full_date    DATE NOT NULL,
    year         INT,
    quarter      INT,
    month        INT,
    day          INT,
    day_name     VARCHAR(10),
    week_of_year INT,
    CONSTRAINT uq_dim_date_full_date UNIQUE (full_date)
);

CREATE TABLE IF NOT EXISTS dw.dim_device (
    device_key SERIAL PRIMARY KEY,
    device     VARCHAR(50) NOT NULL,
    CONSTRAINT uq_dim_device_device UNIQUE (device)
);

CREATE TABLE IF NOT EXISTS dw.dim_channel (
    channel_key SERIAL PRIMARY KEY,
    channel     VARCHAR(50) NOT NULL,
    CONSTRAINT uq_dim_channel_channel UNIQUE (channel)
);

COMMIT;
