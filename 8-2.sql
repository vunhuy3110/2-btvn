CREATE DATABASE qly_sp_b8;
USE qly_sp_b8;

CREATE TABLE products (
    id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DOUBLE NOT NULL,
    category VARCHAR(100) NOT NULL
);

INSERT INTO products
(id, name, price, category)
VALUES
(1, 'Laptop Dell', 25000000, 'Laptop'),
(2, 'Macbook Air', 18000000, 'Laptop'),
(3, 'iPhone 17', 30000000, 'Dien thoai'),
(4, 'iPhone 16', 28000000, 'Dien thoai'),
(5, 'Tai nghe', 5000000, 'Phu kien');

SELECT * FROM products;

DELIMITER //
CREATE PROCEDURE sp_get_products_by_category(
    IN p_category VARCHAR(100)
)
BEGIN
    SELECT *
    FROM products
    WHERE category = p_category;
END //
DELIMITER ;

CALL sp_get_products_by_category('Laptop');

CALL sp_get_products_by_category('Dien thoai');

CALL sp_get_products_by_category('Phu kien');