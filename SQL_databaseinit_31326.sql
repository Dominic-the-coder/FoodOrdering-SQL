IF DB_ID('FoodOrdering') IS NOT NULL
BEGIN
    PRINT 'FoodOrdering database already exists';
END
ELSE
BEGIN
    CREATE DATABASE FoodOrdering;
    PRINT 'FoodOrdering database created';
END
GO

PRINT '=== DATABASE SETUP START ===';
GO

-- =========================
-- Customer Table
-- =========================
IF OBJECT_ID('FoodOrdering.dbo.Customer', 'U') IS NOT NULL
BEGIN
    PRINT 'Customer table already exists';
END
ELSE
BEGIN
    CREATE TABLE FoodOrdering.dbo.Customer (
        CustomerId INT IDENTITY(1,1) PRIMARY KEY,
        CustomerName NVARCHAR(100) NOT NULL,
        PhoneNumber NVARCHAR(20) NOT NULL,
        Address NVARCHAR(255) NOT NULL,
        CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE()
    );

    PRINT 'Customer table created';
END
GO

-- =========================
-- Customer_Credential Table
-- =========================
IF OBJECT_ID('FoodOrdering.dbo.Customer_Credential', 'U') IS NOT NULL
BEGIN
    PRINT 'Customer_Credential table already exists';
END
ELSE
BEGIN
    CREATE TABLE FoodOrdering.dbo.Customer_Credential (
        CredentialId INT IDENTITY(1,1) PRIMARY KEY,
        CustomerId INT NOT NULL UNIQUE,
        Username NVARCHAR(50) NOT NULL UNIQUE,
        CustomerPassword VARBINARY(255) NOT NULL,
        CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),

        CONSTRAINT FK_CustomerCredential_Customer
        FOREIGN KEY (CustomerId) REFERENCES FoodOrdering.dbo.Customer(CustomerId)
    );

    PRINT 'Customer_Credential table created';
END
GO

PRINT '=== DATABASE SETUP END ===';
GO