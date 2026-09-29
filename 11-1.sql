CREATE DATABASE BankMn;
USE BankMn;

CREATE TABLE accounts (
    accountID INT PRIMARY KEY,
    balance DECIMAL(10,2) NOT NULL
);

CREATE TABLE transactions (
    transactionID INT PRIMARY KEY,
    fromAccountID INT NOT NULL,
    toAccountID INT NOT NULL,
    amount DECIMAL(10,2),
    transactionDate DATETIME,
    FOREIGN KEY (fromAccountID) REFERENCES accounts(accountID),
    FOREIGN KEY (toAccountID) REFERENCES accounts(accountID)
);

INSERT INTO accounts
(accountID, balance)
VALUES
(1, 5000000),
(2, 7000000),
(3, 10000000),
(4, 8000000),
(5, 12000000),
(6, 6000000),
(7, 9000000),
(8, 15000000),
(9, 11000000),
(10, 13000000);

SELECT *
FROM accounts
WHERE accountID = 1;

START TRANSACTION;
UPDATE accounts
SET balance = balance + 1000000
WHERE accountID = 1;
COMMIT;

SELECT *
FROM accounts
WHERE accountID = 1;