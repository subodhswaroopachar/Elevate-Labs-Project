# 🛠️ ETL Simulation with Audit Logging using MySQL

This project simulates a basic ETL (Extract, Transform, Load) process using a CSV file of employee data. It includes data cleaning, loading into a MySQL database, and setting up **audit logging** using **triggers** to monitor insert actions.

---

## 📁 Project Structure

etl_simulation_project/
├── employees_raw_500.csv # Raw employee data
├── employees.csv # Cleaned/exported employee table
├── audit_log.csv # Exported audit log table
├── README.md # Project documentation

yaml
Copy
Edit

---

## ⚙️ Technologies Used

- **OS**: Linux (Ubuntu/Debian)
- **Database**: MySQL
- **Tooling**: MySQL CLI, DB Browser for SQLite/MySQL GUI (optional)
- **Language**: SQL & Shell

---

## 🧩 Steps Performed

### ✅ Step 1: Create MySQL Database

```sql
CREATE DATABASE ETL_Simulation;
USE ETL_Simulation;
✅ Step 2: Create employees Table
sql
Copy
Edit
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    department VARCHAR(100),
    join_date DATE
);
✅ Step 3: Create audit_log Table
sql
Copy
Edit
CREATE TABLE audit_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(50),
    action VARCHAR(20),
    record_id INT,
    action_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
✅ Step 4: Import Raw CSV Data (Optional Pre-Cleaning)
Use Python, Pandas, or a spreadsheet tool to clean:

Ensure age is numeric (e.g., "35" not "thirty five")

Format join_date properly (e.g., YYYY-MM-DD)

Then bulk insert using:

sql
Copy
Edit
LOAD DATA LOCAL INFILE '/full/path/to/employees_cleaned.csv'
INTO TABLE employees
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
✅ Step 5: Create Trigger for Insert Logging
sql
Copy
Edit
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
This automatically logs new insert actions into audit_log.

✅ Step 6: Test Inserts
sql
Copy
Edit
INSERT INTO employees (employee_id, name, age, department, join_date)
VALUES (502, 'Saharsh Patil', 20, 'Software Developer', '2022-01-01');
✅ Step 7: Export Tables to CSV
From the Linux terminal:

bash
Copy
Edit
# Export employees table
mysql -u subodh -p -D ETL_Simulation -e "SELECT * FROM employees" > employees.csv

# Export audit_log table
mysql -u subodh -p -D ETL_Simulation -e "SELECT * FROM audit_log" > audit_log.csv
These files will be saved in the current directory.

🧠 What You Learned
How to simulate a basic ETL pipeline

Cleaning and inserting CSV data into MySQL

Writing MySQL triggers to log insert actions

Exporting MySQL tables to CSV from the command line

📌 Notes
Always validate and clean your CSV data before importing (e.g., invalid dates, non-numeric ages).

MySQL triggers can log to audit tables but cannot track LOAD DATA INFILE inserts unless row-by-row inserts are done.

Use DB Browser or cat/nano to inspect exported CSVs.
