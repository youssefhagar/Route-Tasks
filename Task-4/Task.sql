-- ===============================================================================
-- 1) Insert a new Manager (Best Practice: Always specify column list)
-- ===============================================================================

INSERT INTO Managers (FullName, Email)
VALUES ('Ahmed Khaled', 'AhmedKhaled@Bank.com');

-- ===============================================================================
-- 2) Archive customers born before 1990 
--    Best Practices:
--      ✔ Specify column list
--      ✔ Use INSERT...SELECT for bulk operations
--      ✔ Test SELECT before INSERT
-- ===============================================================================

-- Test first (recommended but optional)
SELECT Number, FullName, DateOfBirth, Email, PhoneNumber
FROM Customers
WHERE DateOfBirth < '1990-01-01';

-- Create table
CREATE TABLE ArchivedCustomers (
    Number INT PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Email NVARCHAR(150),
    PhoneNumber NVARCHAR(20)
);

-- Insert using INSERT...SELECT
INSERT INTO ArchivedCustomers (Number, FullName, DateOfBirth, Email, PhoneNumber)
SELECT Number, FullName, DateOfBirth, Email, PhoneNumber
FROM Customers
WHERE DateOfBirth < '1990-01-01';


-- ===============================================================================
-- 3) Delete all transactions where Amount > 50,000
--    Best Practices:
--      ✔ Always test DELETE with SELECT first
-- ===============================================================================

-- Test first (recommended but optional)
SELECT *
FROM Transactions
WHERE Amount > 50000;

DELETE FROM Transactions
WHERE Amount > 50000;
