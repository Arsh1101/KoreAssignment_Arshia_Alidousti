-- Execute SQL Task To Remove Duplicae Data

DELETE T FROM
(SELECT [Email], [UserID], DupRank = ROW_NUMBER() OVER (PARTITION BY [Email], [UserID] ORDER BY [UserID], [Email]) FROM [KoreAssignment_Arshia_Alidousti].[stg].[Users]) AS T
WHERE DupRank > 1

-- Execute SQL Task To Isolate Error Data

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'isolated')
BEGIN
EXEC('CREATE SCHEMA isolated');
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'isolated.Users') AND type in (N'U'))
BEGIN
CREATE TABLE isolated.Users (
StgID INT IDENTITY(1,1) PRIMARY KEY,
UserID INT,
FullName NVARCHAR(255),
Age INT,
Email NVARCHAR(255),
RegistrationDate DATE,
LastLoginDate DATE,
PurchaseTotal FLOAT
);
END
GO
INSERT INTO [isolated].[Users] ([UserID],[FullName],[Age],[Email],[RegistrationDate],[LastLoginDate],[PurchaseTotal])
SELECT [UserID],[FullName],[Age],[Email],[RegistrationDate],[LastLoginDate],[PurchaseTotal] FROM [stg].[Users]
WHERE [StgID] IS NULL OR [UserID] IS NULL
					  OR [FullName] IS NULL
					  OR [Age] IS NULL
					  OR [Email] IS NULL OR [Email] = ''
					  OR [RegistrationDate] IS NULL
					  OR [LastLoginDate] IS NULL
					  OR [PurchaseTotal] IS NULL ;

DELETE FROM [KoreAssignment_Arshia_Alidousti].[stg].[Users] WHERE [StgID] IS NULL
																	OR [UserID] IS NULL 
																	OR [FullName] IS NULL 
																	OR [Age] IS NULL 
																	OR [Email] IS NULL OR [Email] = ''
																	OR [RegistrationDate] IS NULL
																	OR [LastLoginDate] IS NULL
																	OR [PurchaseTotal] IS NULL ;

-- Execute SQL Task To Check Production Table Columns

IF NOT EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS TC
    JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE KCU
        ON TC.CONSTRAINT_NAME = KCU.CONSTRAINT_NAME
    WHERE TC.TABLE_SCHEMA = 'prod'
    AND TC.TABLE_NAME = 'Users'
    AND TC.CONSTRAINT_TYPE = 'PRIMARY KEY'
    AND KCU.COLUMN_NAME = 'ID'
)
BEGIN
    THROW 50000, 'Production table does not have uniq ID.', 0;
END

GO
IF NOT EXISTS (
    SELECT 1
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'Users'
	AND TABLE_SCHEMA = 'prod'
    AND COLUMN_NAME IN ('UserID', 'FullName', 'Age', 'Email', 'RegistrationDate', 'LastLoginDate', 'PurchaseTotal')
	GROUP BY TABLE_NAME
	HAVING COUNT(*) = 7
)
BEGIN
    THROW 50001, 'Production table does not have required fields.', 1;
END
