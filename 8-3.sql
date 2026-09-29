CREATE DATABASE qly_nhan_vien_ct;
USE qly_nhan_vien_ct;

CREATE TABLE employees (
    id INT PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    salary DOUBLE NOT NULL
);

INSERT INTO employees
(id, full_name, salary)
VALUES
(1, 'Nguyen Van A', 15000000),
(2, 'Tran Thi B', 18000000),
(3, 'Le Van C', 12000000),
(4, 'Pham Thi D', 20000000),
(5, 'Hoang Van E', 16000000);

SELECT * FROM employees;

DELIMITER //
CREATE PROCEDURE sp_get_avg_salary()
BEGIN
    DECLARE avg_salary DOUBLE;

    SELECT AVG(salary)
    INTO avg_salary
    FROM employees;

    SELECT avg_salary AS average_salary;
END //
DELIMITER ;

CALL sp_get_avg_salary();
