CREATE DATABASE ETL_Simulation;
USE ETL_Simulation;

CREATE TABLE staging_employees (
    id INTEGER,
    full_name TEXT,
    age TEXT,
    department TEXT,
    join_date TEXT
);
LOAD DATA LOCAL INFILE '/home/subodh/Documents/employees_raw_500.csv'
INTO TABLE staging_employees
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) FROM staging_employees;
SELECT * FROM staging_employees LIMIT 5;

CREATE TABLE employees (
    employee_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    age INTEGER,
    department TEXT,
    join_date TEXT
);



CREATE TABLE cleaned_employees AS
SELECT
    id,
    TRIM(full_name) AS full_name,
    CAST(age AS UNSIGNED) AS age,
    LOWER(department) AS department,

    -- Parse various date formats using CASE
    CASE
        WHEN join_date REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$' THEN STR_TO_DATE(join_date, '%d/%m/%Y')
        WHEN join_date REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' THEN STR_TO_DATE(join_date, '%Y-%m-%d')
        WHEN join_date REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$' THEN STR_TO_DATE(join_date, '%m-%d-%Y')
        ELSE NULL
    END AS join_date

FROM staging_employees
WHERE age REGEXP '^[0-9]+$'
  AND (
      join_date REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
      OR join_date REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
      OR join_date REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$'
  );





INSERT INTO employees (employee_id, name, age, department, join_date)
SELECT id, full_name, age, department, join_date
FROM cleaned_employees
WHERE age IS NOT NULL AND join_date IS NOT NULL;

CREATE TABLE audit_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    table_name TEXT,
    action TEXT,
    action_timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    record_id INT
);

DELIMITER //

CREATE TRIGGER trg_after_insert_employees
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (table_name, action, record_id)
    VALUES ('employees', 'INSERT', NEW.employee_id);
END;
//

DELIMITER ;

INSERT INTO employees (employee_id,name, age, department, join_date) VALUES (501, 'John Doe', '35', 'hr', '2020-01-01');

SELECT * FROM audit_log ORDER BY action_timestamp DESC;

 INSERT INTO employees (employee_id,name, age, department, join_date) VALUES (502, 'Saharsh Patil', '20', 'software developer', '2022-01-01');

 SELECT * FROM audit_log ORDER BY action_timestamp DESC;

INSERT INTO employees (employee_id, name, age, department, join_date)
VALUES
  (503, 'Riya Sharma', '27', 'data analyst', '2021-09-15'),
  (504, 'Amit Verma', '31', 'network admin', '2020-05-10'),
  (505, 'Neha Joshi', '29', 'hr', '2019-12-20'),
  (506, 'Karan Mehta', '25', 'backend developer', '2023-03-05');

SELECT * FROM audit_log ORDER BY action_timestamp DESC;

SELECT * FROM audit_log;

EXIT

mysql -u subodh -p -D ETL_Simulation -e "SELECT * FROM employees" > employees.csv

cat employees.csv

mysql -u subodh -p -D ETL_Simulation -e "SELECT * FROM audit_log" > audit_log.csv

cat audit_log.csv


