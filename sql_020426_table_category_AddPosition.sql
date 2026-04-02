USE FoodOrderingSystem;
GO

IF COL_LENGTH('dbo.Category', 'Position') IS NULL
BEGIN
    ALTER TABLE dbo.Category
    ADD Position INT NOT NULL DEFAULT 0;

    PRINT 'Position column added to Category';
END
ELSE
BEGIN
    PRINT 'Position column already exists in Category';
END
GO