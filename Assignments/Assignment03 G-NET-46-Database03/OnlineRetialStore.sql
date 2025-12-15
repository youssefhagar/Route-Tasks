CREATE DATABASE OnlineRetailDB;
GO
USE OnlineRetailDB;
GO

-- ============================

CREATE TABLE Categories (
    CategoryID INT IDENTITY PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL,
    Description VARCHAR(255),
    ParentCategoryID INT NULL,
    CONSTRAINT FK_Category_Parent
        FOREIGN KEY (ParentCategoryID) REFERENCES Categories(CategoryID)
);


CREATE TABLE Products (
    ProductID INT IDENTITY PRIMARY KEY,
    ProductName VARCHAR(150) NOT NULL,
    Description VARCHAR(255),
    UnitPrice DECIMAL(10,2) NOT NULL,
    StockQuantity INT NOT NULL,
    DateAdded DATE DEFAULT GETDATE(),
    CategoryID INT NOT NULL,
    CONSTRAINT FK_Product_Category
        FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);


CREATE TABLE Suppliers (
    SupplierID INT IDENTITY PRIMARY KEY,
    SupplierName VARCHAR(150) NOT NULL,
    ContactNumber VARCHAR(30),
    Email VARCHAR(100),
    Address VARCHAR(255),
    Country VARCHAR(100)
);


CREATE TABLE Product_Suppliers (
    ProductID INT,
    SupplierID INT,
    PRIMARY KEY (ProductID, SupplierID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

CREATE TABLE Customers (
    CustomerID INT IDENTITY PRIMARY KEY,
    FullName VARCHAR(150) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    PhoneNumber VARCHAR(30),
    ShippingAddress VARCHAR(255),
    RegistrationDate DATE DEFAULT GETDATE()
);


CREATE TABLE Orders (
    OrderID INT IDENTITY PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATE DEFAULT GETDATE(),
    TotalAmount DECIMAL(12,2),
    Status VARCHAR(20) CHECK (Status IN ('Pending','Shipped','Delivered','Canceled')),
    PaymentMethod VARCHAR(30),
    CONSTRAINT FK_Order_Customer
        FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);


CREATE TABLE OrderItems (
    OrderID INT,
    ProductID INT,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);


CREATE TABLE Shipments (
    ShipmentID INT IDENTITY PRIMARY KEY,
    OrderID INT NOT NULL,
    ShipmentDate DATE,
    DeliveryDate DATE,
    CarrierName VARCHAR(100),
    TrackingNumber VARCHAR(100),
    Status VARCHAR(30),
    CONSTRAINT FK_Shipment_Order
        FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);


CREATE TABLE Payments (
    PaymentID INT IDENTITY PRIMARY KEY,
    PaymentDate DATE,
    Amount DECIMAL(12,2),
    Method VARCHAR(30) CHECK (Method IN ('Credit Card','Wallet','Bank Transfer')),
    Status VARCHAR(30)
);



CREATE TABLE Order_Payments (
    OrderID INT,
    PaymentID INT,
    PRIMARY KEY (OrderID, PaymentID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (PaymentID) REFERENCES Payments(PaymentID)
);



CREATE TABLE StockTransactions (
    TransactionID INT IDENTITY PRIMARY KEY,
    ProductID INT NOT NULL,
    TransactionDate DATE DEFAULT GETDATE(),
    QuantityChange INT NOT NULL,
    TransactionType VARCHAR(10) CHECK (TransactionType IN ('IN','OUT')),
    Reference VARCHAR(100),
    CONSTRAINT FK_Stock_Product
        FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);



CREATE TABLE Reviews (
    ReviewID INT IDENTITY PRIMARY KEY,
    ProductID INT NOT NULL,
    CustomerID INT NOT NULL,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Comment VARCHAR(255),
    ReviewDate DATE DEFAULT GETDATE(),
    CONSTRAINT FK_Review_Product
        FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    CONSTRAINT FK_Review_Customer
        FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
















