CREATE DATABASE ecommerce;
USE ecommerce;
-- 1. Bảng customers (Khách hàng)
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Bảng orders (Đơn hàng)
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) DEFAULT 0,
    status ENUM('Pending', 'Completed', 'Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);

-- 3. Bảng products (Sản phẩm)
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Bảng order_items (Chi tiết đơn hàng)
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 5. Bảng inventory (Kho hàng)
CREATE TABLE inventory (
    product_id INT PRIMARY KEY,
    stock_quantity INT NOT NULL CHECK (stock_quantity >= 0),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- 6. Bảng payments (Thanh toán)
CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10,2) NOT NULL,
    payment_method ENUM('Credit Card', 'PayPal', 'Bank Transfer', 'Cash') NOT NULL,
    status ENUM('Pending', 'Completed', 'Failed') DEFAULT 'Pending',
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
);

INSERT INTO customers
(name, email, phone, address)
VALUES
('Nguyen Van A', 'a@gmail.com', '0900000001', 'Ha Noi'),
('Tran Thi B', 'b@gmail.com', '0900000002', 'Bac Ninh'),
('Le Van C', 'c@gmail.com', '0900000003', 'Bac Giang'),
('Pham Thi D', 'd@gmail.com', '0900000004', 'Hai Phong');

INSERT INTO products
(name, price, description)
VALUES
('Laptop Dell', 25000000, 'Laptop Dell'),
('Laptop HP', 18000000, 'Laptop HP'),
('iPhone 17', 30000000, 'iPhone 17'),
('Samsung S25', 28000000, 'Samsung S25'),
('Tai nghe Sony', 5000000, 'Tai nghe Sony');

INSERT INTO inventory
(product_id, stock_quantity)
VALUES
(1, 10),
(2, 20),
(3, 15),
(4, 25),
(5, 30);

INSERT INTO orders
(customer_id, total_amount, status)
VALUES
(1, 0, 'Pending'),
(2, 0, 'Pending'),
(3, 0, 'Completed'),
(4, 0, 'Cancelled');

INSERT INTO payments
(order_id, amount, payment_method, status)
VALUES
(3, 30000000, 'Credit Card', 'Completed');

-- Kiểm tra tồn kho trước khi thêm order_items
DELIMITER $$
CREATE TRIGGER before_order_item_insert
BEFORE INSERT ON order_items
FOR EACH ROW
BEGIN
    DECLARE v_stock INT;

    SELECT stock_quantity
    INTO v_stock
    FROM inventory
    WHERE product_id = NEW.product_id;

    IF v_stock IS NULL THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'San pham khong ton tai trong kho';

    ELSEIF v_stock < NEW.quantity THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'So luong ton kho khong du';

    END IF;
END $$
DELIMITER ;

-- Cập nhật total_amount của order
DELIMITER $$
CREATE TRIGGER after_order_item_insert
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    UPDATE orders
    SET total_amount = (
        SELECT SUM(quantity * price)
        FROM order_items
        WHERE order_id = NEW.order_id
    )
    WHERE order_id = NEW.order_id;
END $$
DELIMITER ;

-- Kiểm tra tồn kho trước khi thay đổi quantity
DELIMITER $$
CREATE TRIGGER before_order_item_update
BEFORE UPDATE ON order_items
FOR EACH ROW
BEGIN
    DECLARE v_stock INT;

    SELECT stock_quantity
    INTO v_stock
    FROM inventory
    WHERE product_id = NEW.product_id;

    IF v_stock IS NULL THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'San pham khong ton tai trong kho';

    ELSEIF v_stock < NEW.quantity THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'So luong ton kho khong du';

    END IF;
END $$
DELIMITER ;

-- Cập nhật lại total_amount khi quantity hoặc price thay đổi
DELIMITER $$
CREATE TRIGGER after_order_item_update
AFTER UPDATE ON order_items
FOR EACH ROW
BEGIN

    IF OLD.quantity <> NEW.quantity
       OR OLD.price <> NEW.price THEN

        UPDATE orders
        SET total_amount = (
            SELECT SUM(quantity * price)
            FROM order_items
            WHERE order_id = NEW.order_id
        )
        WHERE order_id = NEW.order_id;

    END IF;

END $$
DELIMITER ;

-- Không cho xóa đơn hàng Completed
DELIMITER $$
CREATE TRIGGER before_order_delete
BEFORE DELETE ON orders
FOR EACH ROW
BEGIN

    IF OLD.status = 'Completed' THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Khong the xoa don hang da Completed';

    END IF;

END $$
DELIMITER ;

-- Trả lại số lượng vào kho
DELIMITER $$
CREATE TRIGGER after_order_item_delete
AFTER DELETE ON order_items
FOR EACH ROW
BEGIN

    UPDATE inventory
    SET stock_quantity = stock_quantity + OLD.quantity
    WHERE product_id = OLD.product_id;

END $$
DELIMITER ;

ALTER TABLE orders
MODIFY total_amount DECIMAL(15,2) DEFAULT 0;
-- Thêm sản phẩm vào đơn hàng 1
INSERT INTO order_items
(order_id, product_id, quantity, price)
VALUES
(1, 1, 5, 25000000);

-- Kiểm tra order
SELECT *
FROM orders
WHERE order_id = 1;

-- Kiểm tra order_items
SELECT *
FROM order_items;

-- Kiểm tra inventory
SELECT *
FROM inventory;

-- Số lượng 50 > tồn kho 10 => báo lỗi
INSERT INTO order_items
(order_id, product_id, quantity, price)
VALUES
(1, 1, 50, 25000000);

-- TEST BEFORE UPDATE
UPDATE order_items
SET quantity = 8
WHERE order_item_id = 1;

SELECT *
FROM order_items;

SELECT *
FROM orders
WHERE order_id = 1;

-- TEST BEFORE DELETE ORDER
-- order_id = 3 có status Completed
-- => không được xóa
DELETE FROM orders
WHERE order_id = 3;

-- TEST AFTER DELETE ORDER_ITEMS
-- Xóa order_item => trả hàng về kho

SELECT *
FROM inventory
WHERE product_id = 1;

DELETE FROM order_items
WHERE order_item_id = 1;

SELECT *
FROM inventory
WHERE product_id = 1;

-- 24. XEM TẤT CẢ TRIGGER
SHOW TRIGGERS;

-- XÓA TẤT CẢ TRIGGER
DROP TRIGGER IF EXISTS before_order_item_insert;
DROP TRIGGER IF EXISTS after_order_item_insert;
DROP TRIGGER IF EXISTS before_order_item_update;
DROP TRIGGER IF EXISTS after_order_item_update;
DROP TRIGGER IF EXISTS before_order_delete;
DROP TRIGGER IF EXISTS after_order_item_delete;

