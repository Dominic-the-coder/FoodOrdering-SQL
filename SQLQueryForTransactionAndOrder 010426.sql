IF OBJECT_ID('dbo.CurrentTransaction', 'U') IS NOT NULL
BEGIN
    PRINT 'CurrentTransaction table already exists';
END
ELSE
BEGIN
    CREATE TABLE dbo.CurrentTransaction
    (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        OrderId INT NOT NULL UNIQUE,
        TransactionCode NVARCHAR(50) NOT NULL UNIQUE,
        PaymentMethod NVARCHAR(30) NOT NULL,
        TransactionStatus NVARCHAR(30) NOT NULL DEFAULT 'Pending',
        Amount DECIMAL(10,2) NOT NULL,
        CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
        UpdatedAt DATETIME NOT NULL DEFAULT GETDATE(),

        CONSTRAINT CK_CurrentTransaction_Method
            CHECK (PaymentMethod IN ('Cash', 'Card', 'EWallet', 'OnlineBanking')),

        CONSTRAINT CK_CurrentTransaction_Status
            CHECK (TransactionStatus IN ('Pending', 'Paid', 'Failed', 'Refunded')),

        CONSTRAINT FK_CurrentTransaction_Orders
            FOREIGN KEY (OrderId) REFERENCES dbo.Orders(Id)
    );

    PRINT 'CurrentTransaction table created';
END
GO

IF OBJECT_ID('dbo.OrderHistory', 'U') IS NOT NULL
BEGIN
    PRINT 'OrderHistory table already exists';
END
ELSE
BEGIN
    CREATE TABLE dbo.OrderHistory
    (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        OriginalOrderId INT NOT NULL,
        SellerId INT NOT NULL,
        TableId INT NOT NULL,
        OrderDate DATETIME NOT NULL,
        TotalAmount DECIMAL(10,2) NOT NULL,
        OrderStatus NVARCHAR(30) NOT NULL,
        ArchivedAt DATETIME NOT NULL DEFAULT GETDATE(),

        CONSTRAINT CK_OrderHistory_Status
            CHECK (OrderStatus IN ('Completed', 'Cancelled')),

        CONSTRAINT FK_OrderHistory_Seller
            FOREIGN KEY (SellerId) REFERENCES dbo.Seller(Id),

        CONSTRAINT FK_OrderHistory_RestaurantTable
            FOREIGN KEY (TableId) REFERENCES dbo.RestaurantTable(Id)
    );

    PRINT 'OrderHistory table created';
END
GO

IF OBJECT_ID('dbo.TransactionHistory', 'U') IS NOT NULL
BEGIN
    PRINT 'TransactionHistory table already exists';
END
ELSE
BEGIN
    CREATE TABLE dbo.TransactionHistory
    (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        CurrentTransactionId INT NOT NULL,
        OrderId INT NOT NULL,
        TransactionCode NVARCHAR(50) NOT NULL,
        PaymentMethod NVARCHAR(30) NOT NULL,
        TransactionStatus NVARCHAR(30) NOT NULL,
        Amount DECIMAL(10,2) NOT NULL,
        RecordedAt DATETIME NOT NULL DEFAULT GETDATE(),

        CONSTRAINT CK_TransactionHistory_Method
            CHECK (PaymentMethod IN ('Cash', 'Card', 'EWallet', 'OnlineBanking')),

        CONSTRAINT CK_TransactionHistory_Status
            CHECK (TransactionStatus IN ('Pending', 'Paid', 'Failed', 'Refunded')),

        CONSTRAINT FK_TransactionHistory_CurrentTransaction
            FOREIGN KEY (CurrentTransactionId) REFERENCES dbo.CurrentTransaction(Id),

        CONSTRAINT FK_TransactionHistory_Orders
            FOREIGN KEY (OrderId) REFERENCES dbo.Orders(Id)
    );

    PRINT 'TransactionHistory table created';
END
GO