USE ecommerce;

-- Tạo đơn hàng mới
DELIMITER $$
CREATE PROCEDURE sp_create_order(
    IN p_customer_id INT,
    IN p_product_id INT,
    IN p_quantity INT,
    IN p_price DECIMAL(10,2)
)
BEGIN
    DECLARE v_stock INT;
    DECLARE v_order_id INT;

    START TRANSACTION;

    -- Kiểm tra tồn kho
    SELECT stock_quantity
    INTO v_stock
    FROM inventory
    WHERE product_id = p_product_id;

    -- Không đủ hàng
    IF v_stock IS NULL OR v_stock < p_quantity THEN

        ROLLBACK;

        SELECT 'So luong ton kho khong du' AS message;

    ELSE

        -- Tạo đơn hàng
        INSERT INTO orders
        (customer_id, total_amount, status)
        VALUES
        (p_customer_id, p_quantity * p_price, 'Pending');

        -- Lấy order_id vừa tạo
        SET v_order_id = LAST_INSERT_ID();

        -- Thêm sản phẩm vào order_items
        INSERT INTO order_items
        (order_id, product_id, quantity, price)
        VALUES
        (v_order_id, p_product_id, p_quantity, p_price);

        -- Giảm tồn kho
        UPDATE inventory
        SET stock_quantity = stock_quantity - p_quantity
        WHERE product_id = p_product_id;

        COMMIT;

        SELECT
            'Tao don hang thanh cong' AS message,
            v_order_id AS order_id;

    END IF;

END $$
DELIMITER ;

-- Thanh toán đơn hàng
DELIMITER $$
CREATE PROCEDURE sp_pay_order(
    IN p_order_id INT,
    IN p_payment_method VARCHAR(50)
)
BEGIN
    DECLARE v_status VARCHAR(20);
    DECLARE v_amount DECIMAL(10,2);

    START TRANSACTION;

    -- Lấy trạng thái và tổng tiền đơn hàng
    SELECT status, total_amount
    INTO v_status, v_amount
    FROM orders
    WHERE order_id = p_order_id;

    -- Đơn hàng không tồn tại
    IF v_status IS NULL THEN

        ROLLBACK;

        SELECT 'Don hang khong ton tai' AS message;

    -- Đơn hàng không ở trạng thái Pending
    ELSEIF v_status <> 'Pending' THEN

        ROLLBACK;

        SELECT 'Don hang khong o trang thai Pending' AS message;

    ELSE

        -- Thêm thanh toán
        INSERT INTO payments
        (order_id, amount, payment_method, status)
        VALUES
        (
            p_order_id,
            v_amount,
            p_payment_method,
            'Completed'
        );

        -- Cập nhật trạng thái đơn hàng
        UPDATE orders
        SET status = 'Completed'
        WHERE order_id = p_order_id;

        COMMIT;

        SELECT 'Thanh toan thanh cong' AS message;

    END IF;

END $$
DELIMITER ;

-- Hủy đơn hàng
DELIMITER $$
CREATE PROCEDURE sp_cancel_order(
    IN p_order_id INT
)
BEGIN
    DECLARE v_status VARCHAR(20);
    START TRANSACTION;
    -- Kiểm tra trạng thái đơn hàng
    SELECT status
    INTO v_status
    FROM orders
    WHERE order_id = p_order_id;

    -- Đơn hàng không tồn tại
    IF v_status IS NULL THEN

        ROLLBACK;

        SELECT 'Don hang khong ton tai' AS message;

    -- Chỉ được hủy đơn Pending
    ELSEIF v_status <> 'Pending' THEN

        ROLLBACK;

        SELECT 'Chi co the huy don hang Pending' AS message;

    ELSE

        -- Hoàn trả hàng vào kho
        UPDATE inventory i
        JOIN order_items oi
            ON i.product_id = oi.product_id
        SET i.stock_quantity =
            i.stock_quantity + oi.quantity
        WHERE oi.order_id = p_order_id;

        -- Xóa sản phẩm trong order_items
        DELETE FROM order_items
        WHERE order_id = p_order_id;

        -- Cập nhật trạng thái đơn hàng
        UPDATE orders
        SET status = 'Cancelled'
        WHERE order_id = p_order_id;

        COMMIT;

        SELECT 'Huy don hang thanh cong' AS message;

    END IF;

END $$
DELIMITER ;

-- KIỂM TRA PROCEDURE sp_create_order
SELECT *
FROM inventory
WHERE product_id = 1;

CALL sp_create_order(1,1,2,25000000);

SELECT *
FROM orders
ORDER BY order_id DESC;

SELECT *
FROM order_items
ORDER BY order_item_id DESC;

SELECT *
FROM inventory
WHERE product_id = 1;

-- KIỂM TRA sp_create_order KHI KHÔNG ĐỦ KHO
CALL sp_create_order(1,1,100,25000000);

-- KIỂM TRA sp_pay_order
SELECT *
FROM orders
ORDER BY order_id DESC;

CALL sp_pay_order(LAST_INSERT_ID(),'Credit Card');

-- KIỂM TRA THANH TOÁN
SELECT *
FROM orders;

SELECT *
FROM payments;

-- TẠO MỘT ĐƠN HÀNG MỚI ĐỂ TEST HỦY
CALL sp_create_order(2,2,3,18000000);

-- XEM ĐƠN HÀNG
SELECT *
FROM orders
ORDER BY order_id DESC;

SELECT *
FROM order_items
ORDER BY order_item_id DESC;

-- HỦY ĐƠN HÀNG
-- Thay 5 bằng order_id thực tế vừa tạo 
CALL sp_cancel_order(5);

-- KIỂM TRA SAU KHI HỦY
SELECT *
FROM orders;

SELECT *
FROM order_items;

SELECT *
FROM inventory;

-- XÓA TẤT CẢ STORED PROCEDURE
DROP PROCEDURE IF EXISTS sp_create_order;
DROP PROCEDURE IF EXISTS sp_pay_order;
DROP PROCEDURE IF EXISTS sp_cancel_order;