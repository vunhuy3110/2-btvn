USE ecommerce;

CREATE TABLE order_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    old_status ENUM('Pending', 'Completed', 'Cancelled'),
    new_status ENUM('Pending', 'Completed', 'Cancelled'),
    log_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
);

-- Trigger BEFORE INSERT: kiểm tra số tiền thanh toán
DELIMITER $$
CREATE TRIGGER before_insert_check_payment
BEFORE INSERT ON payments
FOR EACH ROW
BEGIN
    DECLARE v_total_amount DECIMAL(10,2);

    SELECT total_amount INTO v_total_amount
    FROM orders
    WHERE order_id = NEW.order_id;

    IF v_total_amount IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Don hang khong ton tai';
    ELSEIF NEW.amount <> v_total_amount THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'So tien thanh toan khong khop voi tong tien don hang';
    END IF;
END $$
DELIMITER ;

-- Trigger AFTER UPDATE: ghi log khi trạng thái đơn hàng thay đổi
DELIMITER $$
CREATE TRIGGER after_update_order_status
AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
    IF OLD.status <> NEW.status THEN
        INSERT INTO order_logs (order_id, old_status, new_status)
        VALUES (NEW.order_id, OLD.status, NEW.status);
    END IF;
END $$
DELIMITER ;

-- Stored Procedure cập nhật trạng thái đơn hàng và thanh toán
DELIMITER $$
CREATE PROCEDURE sp_update_order_status_with_payment(
    IN p_order_id INT,
    IN p_new_status VARCHAR(20),
    IN p_payment_amount DECIMAL(10,2),
    IN p_payment_method VARCHAR(50)
)
BEGIN
    DECLARE v_old_status VARCHAR(20);

    -- Nếu xảy ra lỗi SQL thì ROLLBACK
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Giao dich that bai, da ROLLBACK' AS message;
    END;

    -- Bắt đầu Transaction
    START TRANSACTION;

    -- Lấy trạng thái hiện tại
    SELECT status INTO v_old_status
    FROM orders
    WHERE order_id = p_order_id;

    -- Kiểm tra đơn hàng có tồn tại không
    IF v_old_status IS NULL THEN
        ROLLBACK;
        SELECT 'Don hang khong ton tai' AS message;

    -- Kiểm tra trạng thái mới có giống trạng thái hiện tại không
    ELSEIF v_old_status = p_new_status THEN
        ROLLBACK;
        SELECT 'Trang thai moi giong trang thai hien tai' AS message;
    ELSE

        -- Nếu chuyển sang Completed thì thêm payment
        IF p_new_status = 'Completed' THEN
            INSERT INTO payments (order_id, amount, payment_method, status)
            VALUES (p_order_id, p_payment_amount, p_payment_method, 'Completed');
        END IF;

        -- Cập nhật trạng thái đơn hàng
        UPDATE orders SET status = p_new_status
        WHERE order_id = p_order_id;

        -- Hoàn tất Transaction
        COMMIT;

        SELECT 'Cap nhat trang thai thanh cong' AS message;
    END IF;
END $$
DELIMITER ;

-- Kiểm tra dữ liệu
SELECT * FROM orders;
SELECT * FROM order_logs;
SELECT * FROM payments;

-- Test trường hợp thành công
CALL sp_update_order_status_with_payment(1, 'Completed', 50000000, 'Credit Card');

-- Kiểm tra sau khi thành công
SELECT * FROM orders WHERE order_id = 1;
SELECT * FROM payments;
SELECT * FROM order_logs;

-- trường hợp sai số tiền
CALL sp_update_order_status_with_payment(2, 'Completed', 999999, 'PayPal');

-- Kiểm tra sau khi ROLLBACK
SELECT * FROM orders WHERE order_id = 2;
SELECT * FROM payments;
SELECT * FROM order_logs;

-- ktra trạng thái mới giống trạng thái hiện tại
CALL sp_update_order_status_with_payment(1, 'Completed', 50000000, 'Cash');

-- Xem toàn bộ lịch sử
SELECT * FROM order_logs ORDER BY log_id;

-- Xem Trigger
SHOW TRIGGERS;

-- Xóa Trigger
DROP TRIGGER IF EXISTS before_insert_check_payment;
DROP TRIGGER IF EXISTS after_update_order_status;

-- Xóa Stored Procedure
DROP PROCEDURE IF EXISTS sp_update_order_status_with_payment;

-- Xóa bảng log
DROP TABLE IF EXISTS order_logs;