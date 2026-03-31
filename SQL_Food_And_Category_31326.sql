IF DB_ID('FoodOrderingSystem') IS NULL
BEGIN
    CREATE DATABASE FoodOrderingSystem;
    PRINT 'Database created';
END
ELSE
BEGIN
    PRINT 'Database already exists';
END
GO

USE FoodOrderingSystem;
GO

IF OBJECT_ID('dbo.Category', 'U') IS NOT NULL
BEGIN
    PRINT 'Category table already exists';
END
ELSE
BEGIN
    CREATE TABLE dbo.Category
    (
        id INT IDENTITY(1,1) PRIMARY KEY,
        name NVARCHAR(50) NOT NULL
    );

    PRINT 'Category table created';
END
GO

IF OBJECT_ID('dbo.SideDish', 'U') IS NOT NULL
BEGIN
    PRINT 'SideDish table already exists';
END
ELSE
BEGIN
    CREATE TABLE dbo.SideDish
    (
        id INT IDENTITY(1,1) PRIMARY KEY,
        name NVARCHAR(50) NOT NULL
    );

    PRINT 'SideDish table created';
END
GO

IF OBJECT_ID('dbo.FoodItem', 'U') IS NOT NULL
BEGIN
    PRINT 'FoodItem table already exists';
END
ELSE
BEGIN
    CREATE TABLE dbo.FoodItem
    (
        id INT IDENTITY(1,1) PRIMARY KEY,
        name NVARCHAR(100) NOT NULL,
        category_id INT NOT NULL,

        CONSTRAINT FK_FoodItem_Category
            FOREIGN KEY (category_id) REFERENCES dbo.Category(id)
    );

    PRINT 'FoodItem table created';
END
GO

IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL
BEGIN
    PRINT 'Customers table already exists';
END
ELSE
BEGIN
    CREATE TABLE dbo.Customers
    (
        id INT IDENTITY(1,1) PRIMARY KEY,
        name NVARCHAR(100) NOT NULL,
        phone NVARCHAR(20) NOT NULL,
        email NVARCHAR(100) NOT NULL UNIQUE,
        address NVARCHAR(255) NOT NULL
    );

    PRINT 'Customers table created';
END
GO

IF OBJECT_ID('dbo.Customers_Credentials', 'U') IS NOT NULL
BEGIN
    PRINT 'Customers_Credentials table already exists';
END
ELSE
BEGIN
    CREATE TABLE dbo.Customers_Credentials
    (
        id INT IDENTITY(1,1) PRIMARY KEY,
        customer_id INT NOT NULL UNIQUE,
        username NVARCHAR(50) NOT NULL UNIQUE,
        password NVARCHAR(100) NOT NULL,

        CONSTRAINT FK_CustomersCredentials_Customers
            FOREIGN KEY (customer_id) REFERENCES dbo.Customers(id)
    );

    PRINT 'Customers_Credentials table created';
END
GO

CREATE TABLE dbo.Orders
(
    id INT IDENTITY(1,1) PRIMARY KEY,
    CustomerId INT NOT NULL,
    OrderDate DATETIME NOT NULL DEFAULT GETDATE(),
    TotalAmount DECIMAL(10,2) NOT NULL DEFAULT 0,
    OrderStatus NVARCHAR(30) NOT NULL DEFAULT 'Pending',

    CONSTRAINT FK_Orders_Customers
        FOREIGN KEY (CustomerId) REFERENCES dbo.Customers(id)
);
GO

CREATE TABLE dbo.OrderItems
(
    OrderItemId INT IDENTITY(1,1) PRIMARY KEY,
    OrderId INT NOT NULL,
    FoodItemId INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,

    CONSTRAINT FK_OrderItems_Orders
        FOREIGN KEY (OrderId) REFERENCES dbo.Orders(id),

    CONSTRAINT FK_OrderItems_FoodItems
        FOREIGN KEY (FoodItemId) REFERENCES dbo.FoodItem(id)
);
GO