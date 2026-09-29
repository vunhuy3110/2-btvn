CREATE DATABASE CustomerIndex;
USE CustomerIndex;

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    address VARCHAR(255) NOT NULL
);

INSERT INTO customers
(customer_name, email, phone, address)
VALUES
('Nguyen Van A', 'a@gmail.com', '0900000001', 'Ha Noi'),
('Tran Thi B', 'b@gmail.com', '0900000002', 'Bac Ninh'),
('Le Van C', 'c@gmail.com', '0900000003', 'Bac Giang'),
('Pham Thi D', 'd@gmail.com', '0900000004', 'Hai Phong'),
('Hoang Van E', 'e@gmail.com', '0900000005', 'Ha Noi');

SELECT * FROM customers;

CREATE UNIQUE INDEX idx_email ON customers(email);

SELECT * FROM customers WHERE email = 'a@gmail.com';

CREATE INDEX idx_phone ON customers (phone);

SELECT *FROM customers WHERE phone = '0900000001';