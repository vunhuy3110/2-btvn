USE Bank;

UPDATE accounts
SET balance = 2000000
WHERE account_id = 4;

UPDATE accounts
SET balance = 0
WHERE account_id = 5;

SELECT * FROM accounts
WHERE account_id IN (4, 5);

DELIMITER //
CREATE PROCEDURE transfer_money(
    IN p_sender_id INT,
    IN p_receiver_id INT,
    IN p_amount DECIMAL(10,2)
)
BEGIN
    DECLARE v_sender_balance DECIMAL(10,2);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Giao dich that bai, da ROLLBACK' AS message;
    END;

    START TRANSACTION;

    SELECT balance
    INTO v_sender_balance
    FROM accounts
    WHERE account_id = p_sender_id;

    IF v_sender_balance < p_amount THEN

        ROLLBACK;

        SELECT 'So du khong du' AS message;

    ELSE

        UPDATE accounts
        SET balance = balance - p_amount
        WHERE account_id = p_sender_id;
        
        UPDATE accounts
        SET balance = balance + p_amount
        WHERE account_id = p_receiver_id;

        COMMIT;

        SELECT 'Chuyen tien thanh cong' AS message;

    END IF;

END //
DELIMITER ;

CALL transfer_money(4, 5, 300000);

SELECT *
FROM accounts
WHERE account_id IN (4, 5);

CALL transfer_money(4, 5, 2000000);

SELECT *
FROM accounts
WHERE account_id IN (4, 5);

