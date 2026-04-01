/* =========================================
   1. CREATE DATABASE
========================================= */
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

/* =========================================
   2. SELLER
   餐厅 / 商家资料
========================================= */
IF OBJECT_ID('dbo.Seller', 'U') IS NOT NULL
BEGIN
    PRINT 'Seller table already exists';
END
ELSE
BEGIN
    CREATE TABLE dbo.Seller
    (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        RestaurantName NVARCHAR(100) NOT NULL,
        OwnerName NVARCHAR(100) NOT NULL,
        Phone NVARCHAR(20) NOT NULL,
        Email NVARCHAR(100) NOT NULL UNIQUE,
        Address NVARCHAR(255) NULL
    );

    PRINT 'Seller table created';
END
GO

/* =========================================
   3. SELLER CREDENTIALS
   商家登录账号
========================================= */
IF OBJECT_ID('dbo.SellerCredentials', 'U') IS NOT NULL
BEGIN
    PRINT 'SellerCredentials table already exists';
END
ELSE
BEGIN
    CREATE TABLE dbo.SellerCredentials
    (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        SellerId INT NOT NULL UNIQUE,
        Username NVARCHAR(50) NOT NULL UNIQUE,
        PasswordHash NVARCHAR(255) NOT NULL,

        CONSTRAINT FK_SellerCredentials_Seller
            FOREIGN KEY (SellerId) REFERENCES dbo.Seller(Id)
    );

    PRINT 'SellerCredentials table created';
END
GO

/* =========================================
   4. CATEGORY
   食物分类
========================================= */
IF OBJECT_ID('dbo.Category', 'U') IS NOT NULL
BEGIN
    PRINT 'Category table already exists';
END
ELSE
BEGIN
    CREATE TABLE dbo.Category
    (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        Name NVARCHAR(50) NOT NULL UNIQUE
    );

    PRINT 'Category table created';
END
GO

/* =========================================
   5. SIDEDISH CATEGORY
   配菜分类，属于 Category
========================================= */
IF OBJECT_ID('dbo.SideDishCategory', 'U') IS NOT NULL
BEGIN
    PRINT 'SideDishCategory table already exists';
END
ELSE
BEGIN
    CREATE TABLE dbo.SideDishCategory
    (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        CategoryId INT NOT NULL,
        Name NVARCHAR(50) NOT NULL UNIQUE,

        CONSTRAINT FK_SideDishCategory_Category
            FOREIGN KEY (CategoryId) REFERENCES dbo.Category(Id)
    );

    PRINT 'SideDishCategory table created';
END
GO

/* =========================================
   6. SIDEDISH
   配菜，属于 SideDishCategory
========================================= */
IF OBJECT_ID('dbo.SideDish', 'U') IS NOT NULL
BEGIN
    PRINT 'SideDish table already exists';
END
ELSE
BEGIN
    CREATE TABLE dbo.SideDish
    (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        SideDishCategoryId INT NOT NULL,
        Name NVARCHAR(50) NOT NULL UNIQUE,

        CONSTRAINT FK_SideDish_SideDishCategory
            FOREIGN KEY (SideDishCategoryId) REFERENCES dbo.SideDishCategory(Id)
    );

    PRINT 'SideDish table created';
END
GO

/* =========================================
   7. RESTAURANT TABLE
   餐桌资料，顾客扫码就是进这张桌
========================================= */
IF OBJECT_ID('dbo.RestaurantTable', 'U') IS NOT NULL
BEGIN
    PRINT 'RestaurantTable table already exists';
END
ELSE
BEGIN
    CREATE TABLE dbo.RestaurantTable
    (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        SellerId INT NOT NULL,
        TableNumber NVARCHAR(20) NOT NULL,
        QrCodeValue NVARCHAR(255) NULL,
        IsActive BIT NOT NULL DEFAULT 1,

        CONSTRAINT FK_RestaurantTable_Seller
            FOREIGN KEY (SellerId) REFERENCES dbo.Seller(Id)
    );

    PRINT 'RestaurantTable table created';
END
GO

/* =========================================
   8. FOOD ITEM
   菜单项目
========================================= */
IF OBJECT_ID('dbo.FoodItem', 'U') IS NOT NULL
BEGIN
    PRINT 'FoodItem table already exists';
END
ELSE
BEGIN
    CREATE TABLE dbo.FoodItem
    (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        SellerId INT NOT NULL,
        Name NVARCHAR(100) NOT NULL,
        CategoryId INT NOT NULL,
        Price DECIMAL(10,2) NOT NULL,
        IsAvailable BIT NOT NULL DEFAULT 1,

        CONSTRAINT FK_FoodItem_Seller
            FOREIGN KEY (SellerId) REFERENCES dbo.Seller(Id),

        CONSTRAINT FK_FoodItem_Category
            FOREIGN KEY (CategoryId) REFERENCES dbo.Category(Id)
    );

    PRINT 'FoodItem table created';
END
GO

/* =========================================
   9. ORDERS
   订单直接连 TableId
========================================= */
IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL
BEGIN
    PRINT 'Orders table already exists';
END
ELSE
BEGIN
    CREATE TABLE dbo.Orders
    (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        SellerId INT NOT NULL,
        TableId INT NOT NULL,
        OrderDate DATETIME NOT NULL DEFAULT GETDATE(),
        TotalAmount DECIMAL(10,2) NOT NULL DEFAULT 0,
        OrderStatus NVARCHAR(30) NOT NULL DEFAULT 'Pending',

        CONSTRAINT CK_Orders_Status
            CHECK (OrderStatus IN ('Pending', 'Preparing', 'Completed', 'Cancelled')),

        CONSTRAINT FK_Orders_Seller
            FOREIGN KEY (SellerId) REFERENCES dbo.Seller(Id),

        CONSTRAINT FK_Orders_RestaurantTable
            FOREIGN KEY (TableId) REFERENCES dbo.RestaurantTable(Id)
    );

    PRINT 'Orders table created';
END
GO

/* =========================================
   10. ORDER ITEMS
   订单明细
========================================= */
IF OBJECT_ID('dbo.OrderItems', 'U') IS NOT NULL
BEGIN
    PRINT 'OrderItems table already exists';
END
ELSE
BEGIN
    CREATE TABLE dbo.OrderItems
    (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        OrderId INT NOT NULL,
        FoodItemId INT NOT NULL,
        Quantity INT NOT NULL,
        UnitPrice DECIMAL(10,2) NOT NULL,

        CONSTRAINT CK_OrderItems_Quantity
            CHECK (Quantity > 0),

        CONSTRAINT CK_OrderItems_UnitPrice
            CHECK (UnitPrice >= 0),

        CONSTRAINT FK_OrderItems_Orders
            FOREIGN KEY (OrderId) REFERENCES dbo.Orders(Id),

        CONSTRAINT FK_OrderItems_FoodItem
            FOREIGN KEY (FoodItemId) REFERENCES dbo.FoodItem(Id)
    );

    PRINT 'OrderItems table created';
END
GO