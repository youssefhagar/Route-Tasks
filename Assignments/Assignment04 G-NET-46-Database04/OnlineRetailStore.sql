-- ================================
-- 1. INSERT OPERATIONS : 
-- ================================


-- Insert a new Customer (FullName, PhoneNumber, Email, ShippingAddress, RegistrationDate) 
INSERT INTO Customers (FullName, PhoneNumber, Email, ShippingAddress, RegistrationDate)
VALUES ('Ahmed Mohamed', '01012345678', 'ahmed@gmail.com', 'Cairo, Egypt', GETDATE());

-- Insert 3 new Suppliers 
INSERT INTO Suppliers (SupplierName, ContactNumber, Email, Address, Country)
VALUES 
('Tech Supplier', '01211111111', 'tech@supplier.com', 'Nasr City', 'Egypt'),
('Fashion Supplier', '01222222222', 'fashion@supplier.com', 'Giza', 'Egypt'),
('Home Supplier', '01233333333', 'home@supplier.com', 'Alexandria', 'Egypt');


-- Insert 2 Categories 
INSERT INTO Categories (CategoryName, Description)
VALUES 
('Electronics', 'Electronic Devices'),
('Clothing', 'Men and Women Clothes');

-- Insert a Product but only (Name, UnitPrice) 
INSERT INTO Products (ProductName, UnitPrice, StockQuantity, CategoryID)
VALUES ('USB Flash', 80, 0, 1);

-- Create table ArchivedStock (TranId, ProductId, QuantityChange,TranDate) Insert into ArchivedStock all StockTransactions before 2023 
CREATE TABLE ArchivedStock (
    TranId INT,
    ProductID INT,
    QuantityChange INT,
    TranDate DATE
);

INSERT INTO ArchivedStock
SELECT TransactionID, ProductID, QuantityChange, TransactionDate
FROM StockTransactions
WHERE TransactionDate < '2023-01-01';



-- ================================
-- 2. TEMPORARY TABLES 
-- ================================

-- Create #CustomerOrders with (OrderId, CustomerId, TotalAmount) Insert customers who made orders above 5000. 
CREATE TABLE #CustomerOrders (
    OrderID INT,
    CustomerID INT,
    TotalAmount DECIMAL(12,2)
);

INSERT INTO #CustomerOrders
SELECT OrderID, CustomerID, TotalAmount
FROM Orders
WHERE TotalAmount > 5000;


-- Create ##TopRatedProducts with (ProductId, Rating) Insert products with rating ≥ 4.5
CREATE TABLE ##TopRatedProducts (
    ProductID INT,
    Rating DECIMAL(3,2)
);

INSERT INTO ##TopRatedProducts
SELECT ProductID, AVG(Rating)
FROM Reviews
GROUP BY ProductID
HAVING AVG(Rating) >= 4.5;


-- ================================
-- 3. UPDATE OPERATIONS 
-- ================================

-- Increase all UnitPrice by 10% for products under 100 EGP 
UPDATE Products
SET UnitPrice = UnitPrice * 1.10
WHERE UnitPrice < 100;


-- Update Order Status: If TotalAmount > 5000 → “Premium” Else → “Standard” 

UPDATE Orders
SET Status = 
    CASE 
        WHEN TotalAmount > 5000 THEN 'Premium'
        ELSE 'Standard'
    END;


-- ================================
-- 4. DELETE OPERATIONS 
-- ================================

-- Delete a Review by ReviewId 
DELETE FROM Reviews
WHERE ReviewID = 5;

-- Delete all Orders with Status = “Cancelled 
DELETE FROM Orders
WHERE Status = 'Canceled';

-- Delete OrderItems for a given OrderId 
DELETE FROM OrderItems
WHERE OrderID = 10;




-- ================================
-- 5. MERGE OPERATION 
-- ================================
/*
Create table #ProductsUpdate (ProductId, Name, UnitPrice, 
StockQuantity) 
MERGE logic: 
If product exists → UPDATE price & stock 
If new → INSERT 
DELETE 
*/

CREATE TABLE #ProductsUpdate (
    ProductID INT,
    Name VARCHAR(150),
    UnitPrice DECIMAL(10,2),
    StockQuantity INT
);

INSERT INTO #ProductsUpdate
VALUES
(1, 'USB Flash', 95, 200),
(50, 'Wireless Mouse', 350, 100);


MERGE Products AS Target
USING #ProductsUpdate AS Source
ON Target.ProductID = Source.ProductID

WHEN MATCHED THEN
    UPDATE SET 
        Target.ProductName = Source.Name,
        Target.UnitPrice = Source.UnitPrice,
        Target.StockQuantity = Source.StockQuantity

WHEN NOT MATCHED THEN
    INSERT (ProductName, UnitPrice, StockQuantity, CategoryID)
    VALUES (Source.Name, Source.UnitPrice, Source.StockQuantity, 1);















