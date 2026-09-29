USE CustomerIndex;

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL CHECK (price > 0),
    stock INT NOT NULL CHECK (stock > 0)
);

INSERT INTO products (product_name, price, stock) 
VALUES
('Laptop Dell', 25000000, 10),
('Laptop HP', 18000000, 15),
('MacBook Air', 27000000, 8),
('MacBook Pro', 45000000, 5),
('iPhone 17', 30000000, 20),
('iPhone 16', 22000000, 12),
('Samsung S25', 28000000, 18),
('Samsung A56', 12000000, 25),
('Xiaomi 15', 16000000, 20),
('Oppo Reno 13', 11000000, 15),
('Tai nghe Sony', 5000000, 30),
('AirPods Pro', 6500000, 25),
('Ban phim Logitech', 3000000, 40),
('Chuot Logitech', 2000000, 35),
('Man hinh Dell', 8000000, 10),
('Man hinh LG', 7000000, 12),
('iPad Air', 18000000, 10),
('iPad Pro', 32000000, 7),
('Apple Watch', 9000000, 15),
('Sony Camera', 35000000, 6);

DELIMITER $$
CREATE PROCEDURE get_high_value_products()
BEGIN
    SELECT * FROM products WHERE price > 1000000.00;
END $$
DELIMITER ;

CALL get_high_value_products();

SELECT * FROM products