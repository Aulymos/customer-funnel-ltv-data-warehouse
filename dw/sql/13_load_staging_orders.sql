DO $$
DECLARE
    tbl RECORD;
BEGIN

FOR tbl IN
    SELECT table_name
    FROM information_schema.tables
    WHERE table_schema = 'raw'
    AND table_name LIKE 'orders_%_raw'
    ORDER BY table_name
LOOP

    EXECUTE format(
        '
        INSERT INTO staging.orders
        (
            order_id,
            user_id,
            order_timestamp,
            order_date,
            amount,
            currency,
            payment_method,
            status,
            source_file
        )
        SELECT
            order_id,
            user_id,
            order_timestamp,
            order_timestamp::date,
            amount,
            currency,
            payment_method,
            status,
            source_file
        FROM raw.%I
        ',
        tbl.table_name
    );

END LOOP;

END $$;