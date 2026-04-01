USE FoodOrderingSystem;
GO

IF COL_LENGTH('dbo.FoodItem', 'Position') IS NULL
BEGIN
    ALTER TABLE dbo.FoodItem
    ADD Position INT NOT NULL DEFAULT 0;

    PRINT 'Position column added to FoodItem';
END
ELSE
BEGIN
    PRINT 'Position column already exists in FoodItem';
END
GO

