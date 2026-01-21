-- ###################################
--➢ Part 02  Trigger 
-- ###################################
CREATE TABLE ChangeLog
(
    LogId INT IDENTITY PRIMARY KEY,
    TableName NVARCHAR(100),
    ActionType NVARCHAR(50),
    UserId INT NULL,
    OldData NVARCHAR(MAX) NULL,
    NewData NVARCHAR(MAX) NULL,
    ActionDate DATETIME DEFAULT GETDATE(),
    SqlCommand NVARCHAR(MAX) NULL
);

/*
QUESTION 1 
Create an AFTER INSERT trigger on the Posts table that logs every new post creation into a 
ChangeLog table. 
The log should include: 
● Table name 
● Action type 
● User ID of the post owner 
● Post title stored as new data 
*/
CREATE TRIGGER trg_AfterInsert_Posts
ON Posts
AFTER INSERT
AS
BEGIN
    INSERT INTO ChangeLog (TableName, ActionType, UserId, NewData)
    SELECT 'Posts','INSERT', OwnerUserId,Title
    FROM inserted;
END;


/*
QUESTION 2 
Create an AFTER UPDATE trigger on the Users table that tracks changes to the Reputation 
column. 
The trigger should: 
● Log changes only when the reputation value actually changes 
● Store both the old and new reputation values in the ChangeLog table 
*/
CREATE TRIGGER trg_AfterUpdate_Users_Reputation
ON Users
AFTER UPDATE
AS
BEGIN
    INSERT INTO ChangeLog (TableName, ActionType, UserId, OldData, NewData)
    SELECT 'Users', 'UPDATE Reputation', i.Id,
        CAST(d.Reputation AS NVARCHAR),
        CAST(i.Reputation AS NVARCHAR)
    FROM inserted i JOIN deleted d
	ON i.Id = d.Id
    WHERE i.Reputation <> d.Reputation;
END;

/*
-- QUESTION 3
Create an AFTER DELETE trigger on the Posts table that archives deleted posts into a 
DeletedPosts table. 
All relevant post information should be stored before the post is removed.
*/

CREATE TRIGGER trg_AfterDelete_Posts
ON Posts
AFTER DELETE
AS
BEGIN
    INSERT INTO DeletedPosts
    SELECT * FROM deleted;
END;

/*
QUESTION 4 
Create an INSTEAD OF INSERT trigger on a view named vw_NewUsers (based on the Users 
table). 
The trigger should: 
● Validate incoming data 
● Prevent insertion if the DisplayName is NULL or empty 
*/

CREATE VIEW vw_NewUsers
AS
SELECT Id, DisplayName, Reputation
FROM Users;


CREATE TRIGGER trg_InsteadOfInsert_vw_NewUsers
ON vw_NewUsers
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE DisplayName IS NULL OR LTRIM(RTRIM(DisplayName)) = ''
    )
    BEGIN
        RAISERROR ('DisplayName cannot be NULL or empty', 16, 1);
        RETURN;
    END;

    INSERT INTO Users (DisplayName, Reputation)
    SELECT DisplayName, Reputation
    FROM inserted;
END;


/*
QUESTION 5 
Create an INSTEAD OF UPDATE trigger on the Posts table that prevents updates to the Id 
column. 
Any attempt to update the Id column should be: 
● Blocked 
● Logged in the ChangeLog table 
*/
CREATE TRIGGER trg_Block_PostId_Update
ON Posts
INSTEAD OF UPDATE
AS
BEGIN
    IF UPDATE(Id)
    BEGIN
        INSERT INTO ChangeLog (TableName, ActionType)
        VALUES ('Posts', 'UPDATE Id BLOCKED');

        RAISERROR ('Updating Id is not allowed', 16, 1);
        RETURN;
    END;

    UPDATE p
    SET 
        Title = i.Title,
        Body  = i.Body,
        Score = i.Score
    FROM Posts p JOIN inserted i
	ON p.Id = i.Id;
END;


/*
QUESTION 6 
● Add an IsDeleted flag 
Create an INSTEAD OF DELETE trigger on the Comments table that implements a soft 
delete mechanism. 
Instead of deleting records: 
● Mark records as deleted 
● Log the soft delete operation 
*/
ALTER TABLE Comments ADD IsDeleted BIT DEFAULT 0;


CREATE TRIGGER trg_SoftDelete_Comments
ON Comments
INSTEAD OF DELETE
AS
BEGIN
    UPDATE c
    SET IsDeleted = 1
    FROM Comments c JOIN deleted d 
	ON c.Id = d.Id;

    INSERT INTO ChangeLog (TableName, ActionType)
    VALUES ('Comments', 'SOFT DELETE');
END;



/*
QUESTION 7 
Create a DDL trigger at the database level that prevents any table from being dropped. 
All drop table attempts should be logged in the ChangeLog table. 
*/
CREATE TRIGGER trg_Prevent_DropTable
ON DATABASE
FOR DROP_TABLE
AS
BEGIN
    INSERT INTO ChangeLog (ActionType, SqlCommand)
    VALUES (
        'DROP TABLE BLOCKED',
        EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'NVARCHAR(MAX)')
    );

    ROLLBACK;
END;


/*
QUESTION 8 
Create a DDL trigger that logs all CREATE TABLE operations. 
The trigger should record: 
● The action type 
● The full SQL command used to create the table
*/
CREATE TRIGGER trg_Log_CreateTable
ON DATABASE
FOR CREATE_TABLE
AS
BEGIN
    INSERT INTO ChangeLog (ActionType, SqlCommand)
    VALUES (
        'CREATE TABLE',
        EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'NVARCHAR(MAX)')
    );
END;


/*
QUESTION 9 
Create a DDL trigger that prevents any ALTER TABLE statement that attempts to drop a 
column. 
All blocked attempts should be logged. 
*/

CREATE TRIGGER trg_Block_DropColumn
ON DATABASE
FOR ALTER_TABLE
AS
BEGIN
    IF EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'NVARCHAR(MAX)')
       LIKE '%DROP COLUMN%'
    BEGIN
        INSERT INTO ChangeLog (ActionType, SqlCommand)
        VALUES (
            'DROP COLUMN BLOCKED',
            EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'NVARCHAR(MAX)')
        );

        ROLLBACK;
    END;
END;

/*
QUESTION 10 
Create a single trigger on the Badges table that tracks INSERT, UPDATE, and DELETE 
operations. 
The trigger should: 
● Detect the operation type using INSERTED and DELETED tables 
● Log the action appropriately in the ChangeLog table 
*/
CREATE TRIGGER trg_Badges_AllActions
ON Badges
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
        INSERT INTO ChangeLog (TableName, ActionType)
        VALUES ('Badges', 'UPDATE');
    ELSE IF EXISTS (SELECT 1 FROM inserted)
        INSERT INTO ChangeLog (TableName, ActionType)
        VALUES ('Badges', 'INSERT');
    ELSE
        INSERT INTO ChangeLog (TableName, ActionType)
        VALUES ('Badges', 'DELETE');
END;


/*
QUESTION 11 
Create a trigger that maintains summary statistics in a PostStatistics table whenever posts are 
inserted, updated, or deleted. 
The trigger should update: 
● Total number of posts 
● Total score 
● Average score 
for the affected users.
*/
CREATE TABLE PostStatistics
(
    UserId INT PRIMARY KEY,
    TotalPosts INT,
    TotalScore INT,
    AvgScore FLOAT
);
CREATE TRIGGER trg_Update_PostStatistics
ON Posts
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    MERGE PostStatistics ps
    USING (
        SELECT 
            OwnerUserId,
            COUNT(*) TotalPosts,
            SUM(Score) TotalScore,
            AVG(CAST(Score AS FLOAT)) AvgScore
        FROM Posts
        GROUP BY OwnerUserId
    ) s
    ON ps.UserId = s.OwnerUserId
    WHEN MATCHED THEN
        UPDATE SET
            TotalPosts = s.TotalPosts,
            TotalScore = s.TotalScore,
            AvgScore   = s.AvgScore
    WHEN NOT MATCHED THEN
        INSERT VALUES (s.OwnerUserId, s.TotalPosts, s.TotalScore, s.AvgScore);
END;


/*
QUESTION 12 
Create an INSTEAD OF DELETE trigger on the Posts table that prevents deletion of posts with 
a score greater than 100. 
Any prevented deletion should be logged. 
*/
CREATE TRIGGER trg_Block_HighScore_Posts
ON Posts
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM deleted WHERE Score > 100)
    BEGIN
        INSERT INTO ChangeLog (TableName, ActionType)
        VALUES ('Posts', 'DELETE BLOCKED (Score > 100)');

        RAISERROR ('Cannot delete post with score > 100', 16, 1);
        RETURN;
    END;

    DELETE FROM Posts
    WHERE Id IN (SELECT Id FROM deleted);
END;


/*
QUESTION 13 
Write the SQL commands required to: 
1. Disable a specific trigger on the Posts table 
2. Enable the same trigger again 
3. Check whether the trigger is currently enabled or disabled 
*/
-- Disable trigger
DISABLE TRIGGER trg_AfterInsert_Posts ON Posts;

-- Enable trigger
ENABLE TRIGGER trg_AfterInsert_Posts ON Posts;

-- Check trigger status
SELECT name, is_disabled
FROM sys.triggers
WHERE name = 'trg_AfterInsert_Posts';




-- Note : I used AI to help me with some things.
