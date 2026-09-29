USE InventoryManagement;

SELECT * FROM Products;

DELIMITER //
CREATE TRIGGER BeforeInsertProduct
BEFORE INSERT ON Products
FOR EACH ROW
BEGIN
    IF NEW.quantity < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'So luong san pham khong duoc nho hon 0';
    END IF;
END //
DELIMITER ;

INSERT INTO Products
(productID, productName, quantity)
VALUES
(5, 'MacBook Air', -5);
SELECT * FROM Products;

INSERT INTO Products
(productID, productName, quantity)
VALUES
(5, 'MacBook Air', 10);
SELECT * FROM Products;
