CREATE DATABASE sinh_vien;
USE sinh_vien;

CREATE TABLE students (
    student_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    class_name VARCHAR(100) NOT NULL
);

INSERT INTO students
(student_id, full_name, class_name)
VALUES
(1, 'Nguyen Van A', 'IT1'),
(2, 'Tran Thi B', 'IT1'),
(3, 'Le Van C', 'IT2'),
(4, 'Pham Thi D', 'IT2');

DELIMITER //
CREATE PROCEDURE sp_get_all_students()
BEGIN
    SELECT *
    FROM students;
END //
DELIMITER ;

CALL sp_get_all_students();
