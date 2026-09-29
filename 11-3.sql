USE Bank;

SELECT * FROM accounts;

CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    log_message VARCHAR(255),
    transaction_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
    );
    
    SELECT * FROM transactions;
    
DELIMITER //
CREATE PROCEDURE deposit_with_logging(
    IN p_account_id INT,
    IN p_amount DECIMAL(10,2)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Giao dịch thất bại, đã ROLLBACK' AS message;
    END;

    START TRANSACTION;

    UPDATE accounts
    SET balance = balance + p_amount
    WHERE account_id = p_account_id;

    INSERT INTO transactions
    (account_id, amount, log_message)
    VALUES
    (
        p_account_id,
        p_amount,
        'Nạp tiền vào tài khoản'
    );

    COMMIT;

    SELECT 'Nạp tiền thành công' AS message;
END //
DELIMITER ;

SELECT *
FROM accounts
WHERE account_id = 3;

CALL deposit_with_logging(3, 1000000);

SELECT *
FROM accounts
WHERE account_id = 3;

SELECT * FROM transactions;