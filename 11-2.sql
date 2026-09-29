CREATE DATABASE Bank;
USE Bank;

CREATE TABLE accounts (
    account_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    balance DECIMAL(10,2) NOT NULL
);

INSERT INTO accounts
(account_id, customer_name, balance)
VALUES
(1, 'Nguyen Van A', 5000000),
(2, 'Tran Thi B', 300000),
(3, 'Le Van C', 1000000),
(4, 'Pham Thi D', 2000000),
(5, 'Hoang Van E', 1500000);

SELECT * FROM accounts;

DELIMITER //
CREATE PROCEDURE withdraw_money(
    IN p_account_id INT,
    IN p_amount DECIMAL(10,2)
)
BEGIN
    DECLARE v_balance DECIMAL(10,2);

    START TRANSACTION;

    UPDATE accounts
    SET balance = balance - p_amount
    WHERE account_id = p_account_id;

    SELECT balance
    INTO v_balance
    FROM accounts
    WHERE account_id = p_account_id;

    IF v_balance < 0 THEN
        ROLLBACK;
        SELECT 'Giao dịch thất bại.Số dư không đủ' AS message;
    ELSE
        COMMIT;
        SELECT 'Rút tiền thành công' AS message;
    END IF;
END //
DELIMITER ;

CALL withdraw_money(2, 500000);

SELECT *
FROM accounts
WHERE account_id = 2;

CALL withdraw_money(2, 100000);

SELECT *
FROM accounts
WHERE account_id = 2;