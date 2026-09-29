CREATE DATABASE EmployeeMn;
USE EmployeeMn;

CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    salary DECIMAL(10,2),
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(15)
);

CREATE TABLE salary_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    old_salary DECIMAL(10,2),
    new_salary DECIMAL(10,2),
    change_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(id)
);

INSERT INTO employees
(first_name, last_name, salary, email, phone_number)
VALUES
('An', 'Nguyen', 12000000, 'an@gmail.com', '0900000001'),
('Binh', 'Tran', 15000000, 'binh@gmail.com', '0900000002'),
('Chi', 'Le', 18000000, 'chi@gmail.com', '0900000003'),
('Dung', 'Pham', 14000000, 'dung@gmail.com', '0900000004'),
('Hoa', 'Hoang', 20000000, 'hoa@gmail.com', '0900000005'),
('Nam', 'Vo', 16000000, 'nam@gmail.com', '0900000006'),
('Lan', 'Do', 13000000, 'lan@gmail.com', '0900000007'),
('Minh', 'Bui', 17000000, 'minh@gmail.com', '0900000008'),
('Mai', 'Dang', 19000000, 'mai@gmail.com', '0900000009'),
('Tuan', 'Nguyen', 22000000, 'tuan@gmail.com', '0900000010');

SELECT * FROM employees;

DELIMITER //
CREATE TRIGGER AfterEmployeeSalaryUpdate
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    IF OLD.salary <> NEW.salary THEN
        INSERT INTO salary_log
        (employee_id, old_salary, new_salary)
        VALUES
        (NEW.id, OLD.salary, NEW.salary);
    END IF;
END //
DELIMITER ;

UPDATE employees
SET salary = 15000000
WHERE id = 1;

SELECT * FROM salary_log;

UPDATE employees
SET salary = 18000000
WHERE id = 1;

SELECT * FROM salary_log;
