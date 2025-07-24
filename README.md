# 🛠️ ETL Simulation with Audit Logging using MySQL

This project demonstrates a simple **ETL (Extract, Transform, Load)** simulation using employee data. It involves importing data from a CSV file, storing it in a MySQL database, auditing `INSERT` operations with a trigger, and exporting results to CSV files.

---

## 📁 Project Structure
etl_simulation_project/
├── employees_raw_500.csv  # Raw employee data
├── employees.csv          # Exported employee table
├── audit_log.csv          # Exported audit log table
├── README.md              # Project documentation

text

Collapse

Wrap

Copy
---

## ⚙️ Technologies Used

- **OS:** Linux (Ubuntu/Debian or similar)
- **Database:** MySQL 8+
- **Languages:** SQL, Bash
- **Tools:** MySQL CLI, Terminal, Spreadsheet software (optional)

---

## 🧩 Step-by-Step Workflow

### ✅ Step 1: Create the Database

Log in to MySQL and run:

```sql
CREATE DATABASE ETL_Simulation;
USE ETL_Simulation;
✅ Step 2: Create Tables
2.1 employees Table
sql

Collapse

Wrap

Copy
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    department VARCHAR(100),
    join_date DATE
);
2.2 audit_log Table
sql

Collapse

Wrap

Copy
CREATE TABLE audit_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(50),
    action VARCHAR(20),
    record_id INT,
    action_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
✅ Step 3: Create Trigger for Audit Logging
This trigger logs each INSERT into the employees table.

sql

Collapse

Wrap

Copy
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
⚠️ Note: Triggers do not fire for LOAD DATA INFILE operations.

✅ Step 4: Clean the CSV File
Ensure employees_raw_500.csv is clean:

Headers: employee_id,name,age,department,join_date
Dates in YYYY-MM-DD format
Age fields are numeric
No blank or malformed rows
Use Excel, LibreOffice, or a Python script (e.g., pandas) for cleaning.

✅ Step 5: Load CSV into MySQL (Optional for Bulk Insert)
sql

Collapse

Wrap

Copy
LOAD DATA LOCAL INFILE '/full/path/to/employees_raw_500.csv'
INTO TABLE employees
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
🔔 Note: LOAD DATA INFILE does not trigger the AFTER INSERT trigger.

✅ Step 6: Manually Insert Records to Test Trigger
sql

Collapse

Wrap

Copy
INSERT INTO employees (employee_id, name, age, department, join_date)
VALUES 
(501, 'Sarthak Desai', 24, 'Data Analyst', '2021-06-15'),
(502, 'Saharsh Patil', 20, 'Software Developer', '2022-01-01'),
(503, 'Riya Sharma', 27, 'QA Engineer', '2020-11-22');
✅ Step 7: View Audit Logs
Verify the trigger by checking the audit log:

sql

Collapse

Wrap

Copy
SELECT * FROM audit_log;
This displays a record for each manual insert into employees.

✅ Step 8: Export Tables to CSV
Run these commands in your terminal:

bash

Collapse

Wrap

Run

Copy
# Export employees table
mysql -u subodh -p -D ETL_Simulation -e "SELECT * FROM employees" > employees.csv

# Export audit_log table
mysql -u subodh -p -D ETL_Simulation -e "SELECT * FROM audit_log" > audit_log.csv
📍 Output files (employees.csv, audit_log.csv) are saved in your current directory.

📦 Outputs
✅ employees.csv: All employee records.
✅ audit_log.csv: Logs of manual inserts into employees.
View files with cat, less, or spreadsheet software (Excel, LibreOffice).

🧠 Learning Outcomes
Simulate an ETL pipeline with MySQL.
Clean and transform CSV data.
Use AFTER INSERT triggers for audit logging.
Export MySQL tables to CSV.
📌 Notes
Use manual INSERT statements to test the audit trigger.
LOAD DATA INFILE is efficient but bypasses triggers.
Validate CSV data before importing to avoid errors.
Replace subodh with your MySQL username and ensure proper permissions.
