USE CustomerIndex;

DELIMITER $$
CREATE PROCEDURE insert_customer(
    IN in_customer_name VARCHAR(50),
    IN in_email VARCHAR(100),
    IN in_phone VARCHAR(15),
    IN in_address VARCHAR(255)
)
BEGIN
    INSERT INTO customers
    (customer_name, email, phone, address)
    VALUES
    (in_customer_name, in_email, in_phone, in_address);

    SELECT 'Thêm mới khách hàng thành công' AS message;
END $$
DELIMITER ;

CALL insert_customer(
    'Nguyen Thi F',
    'f@gmail.com',
    '0900000006',
    'Ha Noi'
);

SELECT * FROM customers;