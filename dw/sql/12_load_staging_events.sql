DO $$
DECLARE
    tbl RECORD;
BEGIN

FOR tbl IN
    SELECT table_name
    FROM information_schema.tables
    WHERE table_schema = 'raw'
    AND table_name LIKE 'events_%_raw'
    ORDER BY table_name
LOOP

    EXECUTE format(
        '
        INSERT INTO staging.events
        (
            event_id,
            user_id,
            event_type,
            event_timestamp,
            event_date,
            device,
            channel,
            session_id,
            source_file
        )
        SELECT
            event_id,
            user_id,
            event_type,
            event_timestamp,
            event_timestamp::date,
            device,
            channel,
            session_id,
            source_file
        FROM raw.%I
        ',
        tbl.table_name
    );

END LOOP;

END $$;