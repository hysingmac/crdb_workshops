CREATE DATABASE molt;
\c molt;

CREATE TABLE employees (
    id serial PRIMARY KEY,
    unique_id UUID,
    name VARCHAR(50),
    created_at TIMESTAMPTZ,
    updated_at DATE,
    is_hired BOOLEAN,
    age SMALLINT,
    salary NUMERIC(8, 2),
    bonus REAL
);

CREATE TABLE tbl1(id INT PRIMARY KEY, t TEXT);

CREATE TABLE departments (
    id serial PRIMARY KEY,
    name VARCHAR(50),
    description VARCHAR(100),
    number_employees INTEGER
);

CREATE TABLE customers (
    id serial PRIMARY KEY,
    unique_id VARCHAR(100),
    name VARCHAR(50),
    priority VARCHAR(20)
);

CREATE TABLE contractors (
    id SERIAL PRIMARY KEY,
    unique_id VARCHAR(100),
    location VARCHAR(50),
    hourly_rate DECIMAL(8, 2)
);

CREATE TABLE orders (
    o_id INT8 NOT NULL,
    o_d_id INT8 NOT NULL,
    o_w_id INT8 NOT NULL,
    o_c_id INT8 NOT NULL,
    o_entry_d TIMESTAMP NULL,
    o_carrier_id INT8 NULL,
    o_ol_cnt INT8 NULL,
    o_all_local INT8 NULL,
    CONSTRAINT order_pkey PRIMARY KEY (o_w_id, o_c_id, o_d_id, o_id)
);

CREATE TABLE computed (
    o_id INT8 NOT NULL,
    o_d_id INT8 NOT NULL,
    o_w_id INT8 NOT NULL,
    o_c_id INT8 NOT NULL,
    o_entry_d TIMESTAMP NULL,
    o_carrier_id INT8 NULL,
    o_ol_cnt INT8 NULL,
    o_all_local INT8 NULL,
    o_computed_stored INT8 GENERATED ALWAYS AS (o_d_id * o_w_id) STORED,
    o_computed_stored2 INT8 GENERATED ALWAYS AS (o_c_id + o_id) STORED,
    CONSTRAINT computed_pkey PRIMARY KEY (o_w_id)
);

CREATE TABLE computed2 (
    o_id INT8 NOT NULL,
    o_d_id INT8 NOT NULL,
    o_w_id INT8 NOT NULL,
    o_c_id INT8 NOT NULL,
    o_entry_d TIMESTAMP NULL,
    o_carrier_id INT8 NULL,
    o_ol_cnt INT8 NULL,
    o_all_local INT8 NULL,
    o_computed_stored INT8 GENERATED ALWAYS AS (o_d_id + o_w_id) STORED,
    o_computed_stored2 INT8 GENERATED ALWAYS AS (o_c_id * o_id) STORED,
    CONSTRAINT computed2_pkey PRIMARY KEY (o_w_id)
);

DO $$ 
DECLARE 
    i INT;
BEGIN
    i := 1;
    WHILE i <= 200000 LOOP
        INSERT INTO employees (unique_id, name, created_at, updated_at, is_hired, age, salary, bonus)
        VALUES (
            ('550e8400-e29b-41d4-a716-446655440000'::uuid),
            'Employee_' || i,
            '2023-11-03 09:00:00'::timestamp,
            '2023-11-03'::date,
            true,
            24,
            5000.00,
            100.25
        );
        i := i + 1;
    END LOOP;
END $$;

INSERT INTO tbl1 VALUES (1, 'aaa'), (2, 'bb b'), (3, 'ééé'), (4, '🫡🫡🫡'), (5, '娜娜'), (6, 'Лукас'), (7, 'ルカス');

INSERT INTO departments(name, description, number_employees) VALUES ('engineering', 'building tech', 400), ('sales', 'building funnel', 200);

INSERT INTO customers (unique_id, name, priority) 
VALUES 
('ABC123', 'John Doe', 'High'),
('DEF456', 'Jane Smith', 'Medium'),
('GHI789', 'Alice Johnson', 'Low');

INSERT INTO contractors (unique_id, location, hourly_rate) 
VALUES 
('CON123', 'New York', 50.00),
('CON456', 'Los Angeles', 45.50),
('CON789', 'Chicago', 55.75);

INSERT INTO orders (o_id, o_d_id, o_w_id, o_c_id, o_entry_d, o_carrier_id, o_ol_cnt, o_all_local) 
VALUES
(1, 1, 1, 1001, '2024-05-14 10:00:00', 1, 5, 1),
(2, 2, 1, 1002, '2024-05-14 10:15:00', 2, 3, 0),
(3, 3, 1, 1003, '2024-05-14 10:30:00', 1, 4, 1),
(4, 1, 2, 1004, '2024-05-14 10:45:00', 3, 2, 0),
(5, 2, 2, 1005, '2024-05-14 11:00:00', 2, 6, 1);

INSERT INTO computed (
    o_id, o_d_id, o_w_id, o_c_id, o_entry_d, o_carrier_id, o_ol_cnt, o_all_local
) VALUES
    (1, 2, 3, 4, '2024-07-17 10:00:00', 5, 6, 7),
    (2, 3, 4, 5, '2024-07-18 11:00:00', 6, 7, 8),
    (3, 4, 5, 6, '2024-07-19 12:00:00', 7, 8, 9);

INSERT INTO computed2 (
    o_id, o_d_id, o_w_id, o_c_id, o_entry_d, o_carrier_id, o_ol_cnt, o_all_local
) VALUES
    (1, 2, 3, 4, '2024-07-17 10:00:00', 5, 6, 7),
    (2, 3, 4, 5, '2024-07-18 11:00:00', 6, 7, 8),
    (3, 4, 5, 6, '2024-07-19 12:00:00', 7, 8, 9);

