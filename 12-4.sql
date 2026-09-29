CREATE DATABASE employee_management;
USE employee_management;

-- 1. Bảng phòng ban
CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(255) NOT NULL
);

-- 2. Bảng nhân viên
CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    hire_date DATE NOT NULL,
    department_id INT NOT NULL,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE CASCADE
);

-- 3. Bảng chấm công
CREATE TABLE attendance (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    check_in_time DATETIME NOT NULL,
    check_out_time DATETIME,
    total_hours DECIMAL(5,2),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE
);

-- 4. Bảng lương
CREATE TABLE salaries (
    employee_id INT PRIMARY KEY,
    base_salary DECIMAL(10,2) NOT NULL,
    bonus DECIMAL(10,2) DEFAULT 0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE
);

-- 5. Lịch sử lương
CREATE TABLE salary_history (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    old_salary DECIMAL(10,2),
    new_salary DECIMAL(10,2),
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reason TEXT,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE
);

INSERT INTO departments (department_name)
VALUES
('IT'),
('KT'),
('HR');

SELECT * FROM departments;

DELIMITER $$
-- Tự động thêm @company.com vào email
CREATE TRIGGER before_employee_insert
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.email NOT LIKE '%@company.com' THEN
        SET NEW.email = CONCAT(NEW.email, '@company.com');
    END IF;
END $$

-- Tự tạo lương mặc định
CREATE TRIGGER after_employee_insert
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
    INSERT INTO salaries
    (employee_id, base_salary, bonus)
    VALUES
    (NEW.employee_id, 10000.00, 0);
END $$

-- Tự tính tổng số giờ làm
CREATE TRIGGER before_attendance_update
BEFORE UPDATE ON attendance
FOR EACH ROW
BEGIN
    IF NEW.check_out_time IS NOT NULL
       AND NEW.check_out_time <> OLD.check_out_time THEN
        SET NEW.total_hours =
            TIMESTAMPDIFF(MINUTE, NEW.check_in_time, NEW.check_out_time) / 60;
    END IF;
END $$
DELIMITER ;

-- Thêm nhân viên để test
INSERT INTO employees
(name, email, phone, hire_date, department_id)
VALUES
('Nguyen Van A', 'nguyenvana', '0900000001', '2026-09-29', 1);

-- Kiểm tra email và lương
SELECT * FROM employees;
SELECT * FROM salaries;

-- Thêm dữ liệu chấm công
INSERT INTO attendance
(employee_id, check_in_time)
VALUES
(1, '2026-09-29 08:00:00');

-- Checkout lúc 17:00
UPDATE attendance
SET check_out_time = '2026-09-29 17:00:00'
WHERE attendance_id = 1;

-- Kiểm tra giờ làm
SELECT * FROM attendance;
