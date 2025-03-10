-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create a sample table
CREATE TABLE items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Insert 1 million rows with random data
INSERT INTO items (name)
SELECT 'Item ' || g
FROM generate_series(1, 1000000) g;

-- Create a stored procedure to insert rows every few seconds for 2 minutes
CREATE OR REPLACE PROCEDURE insert_items_workload()
LANGUAGE plpgsql
AS $$
DECLARE
    start_time TIMESTAMPTZ := now();
    duration INTERVAL := INTERVAL '2 minutes';
BEGIN
    WHILE now() - start_time < duration LOOP
        INSERT INTO items (name)
        SELECT 'Item ' || uuid_generate_v4();

        -- Commit after each insert
        COMMIT;
        
        -- Debugging notice
        RAISE NOTICE 'Inserted a row at %', now();

        -- Sleep for a few seconds to simulate real-world inserts
        PERFORM pg_sleep(.5);
    END LOOP;
END;
$$;
