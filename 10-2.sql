USE InventoryManagement;

SELECT * FROM Products;

DELIMITER //
CREATE TRIGGER BeforeProductDelete
BEFORE DELETE ON Products
FOR EACH ROW
BEGIN
    IF OLD.quantity > 10 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Khong the xoa san pham vi so luong lon hon 10';
    END IF;
END //
DELIMITER ;

DELETE FROM Products
WHERE productID = 2;
SELECT * FROM Products;

DELETE FROM Products
WHERE productID = 3;
SELECT * FROM Products;


DELETE FROM Products
WHERE productID = 1;
SELECT * FROM Products;