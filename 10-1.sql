CREATE DATABASE InventoryManagement;
USE InventoryManagement;

CREATE TABLE Products (
    productID INT PRIMARY KEY,
    productName VARCHAR(100) NOT NULL,
    quantity INT NOT NULL
);

CREATE TABLE InventoryChanges (
    changeID INT PRIMARY KEY AUTO_INCREMENT,
    productID INT NOT NULL,
    oldQuantity INT,
    newQuantity INT,
    changeDate DATETIME,
    FOREIGN KEY (productID) REFERENCES Products(productID)
);

INSERT INTO Products
(productID, productName, quantity)
VALUES
(1, 'Laptop Dell', 10),
(2, 'Laptop HP', 20),
(3, 'iPhone 17', 15),
(4, 'Samsung S25', 25);

SELECT * FROM Products;
 
DELIMITER //
CREATE TRIGGER AfterUpdate
AFTER UPDATE ON Products
FOR EACH ROW
BEGIN
    IF OLD.quantity <> NEW.quantity THEN
        INSERT INTO InventoryChanges
        (productID, oldQuantity, newQuantity, changeDate)
        VALUES
        (
            NEW.productID,
            OLD.quantity,
            NEW.quantity,
            NOW()
        );
    END IF;
END //
DELIMITER ;
    
UPDATE Products
SET quantity = 15
WHERE productID = 1;

SELECT * FROM Products;

SELECT * FROM InventoryChanges;

UPDATE Products
SET quantity = 8
WHERE productID = 1;

SELECT * FROM InventoryChanges;