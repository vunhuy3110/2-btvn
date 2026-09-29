USE CustomerIndex;

SELECT * FROM customers;

CREATE VIEW  view_customer_contact AS
SELECT customer_id,customer_name,email,phone FROM customers ;


SELECT * FROM view_customer_contact ;