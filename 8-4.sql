CREATE DATABASE qly_don_hang_b8;
USE qly_don_hang_b8;

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    total DOUBLE NOT NULL
);

INSERT INTO orders
(order_id, total)
VALUES
(1, 6000000),
(2, 3000000),
(3, 5000000),
(4, 4500000),
(5, 8000000);

SELECT * FROM orders;

DELIMITER //
CREATE PROCEDURE sp_check_order_value(
    IN p_total_amount DOUBLE
)
BEGIN
    IF p_total_amount >= 5000000 THEN
        SELECT 'Đơn hàng giá trị cao' AS message;
    ELSE
        SELECT 'Đơn hàng bình thường' AS message;
    END IF;
END //
DELIMITER ;

CALL sp_check_order_value(8000000);
CALL sp_check_order_value(3000000);