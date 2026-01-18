-- #######################################
-- ### ➢Part 01 Stored Procedure
-- #######################################
/*
QUESTION 1
Create a stored procedure named sp_GetRecentBadges that retrieves all badges earned by
users within the last N days.
The procedure should accept one input parameter @DaysBack (INT) to determine how many
days back to search.
Test the procedure using different values for the number of days.
*/
Go
CREATE PROCEDURE sp_GetRecentBadges @DaysBack INT
AS
BEGIN
    SELECT *
    FROM Badges
    WHERE Date >= DATEADD(DAY, -@DaysBack, GETDATE())
END
GO
-- Test 
EXEC sp_GetRecentBadges 7
EXEC sp_GetRecentBadges 30

/*
QUESTION 2
Create a stored procedure named sp_GetUserSummary that retrieves summary statistics for a
specific user.
The procedure should accept @UserId as an input parameter and return the following values
as output parameters:
● Total number of posts created by the user
● Total number of badges earned by the user
● Average score of the user’s posts
*/
Go
CREATE PROCEDURE sp_GetUserSummary @UserId INT,
    @TotalPosts INT OUTPUT,
    @TotalBadges INT OUTPUT,
    @AvgPostScore DECIMAL(10,2) OUTPUT
AS
BEGIN
    SELECT @TotalPosts = COUNT(*)
    FROM Posts
    WHERE OwnerUserId = @UserId

    SELECT @TotalBadges = COUNT(*)
    FROM Badges
    WHERE UserId = @UserId

    SELECT @AvgPostScore = AVG(CAST(Score AS DECIMAL(10,2)))
    FROM Posts
    WHERE OwnerUserId = @UserId
END
GO
-- Tea]st  
DECLARE @p INT, @b INT, @avg DECIMAL(10,2)
EXEC sp_GetUserSummary 5, @p OUTPUT, @b OUTPUT, @avg OUTPUT
SELECT @p AS TotalPosts, @b AS TotalBadges, @avg AS AvgScore


/*
QUESTION 3
Create a stored procedure named sp_SearchPosts that searches for posts based on:
● A keyword found in the post title
● A minimum post score
The procedure should accept @Keyword as an input parameter and @MinScore as an
optional parameter with a default value of 0.
The result should display matching posts ordered by score.
*/
Go
CREATE PROCEDURE sp_SearchPosts @Keyword NVARCHAR(100),@MinScore INT = 0
AS
BEGIN
    SELECT Id, Title, Score
    FROM Posts
    WHERE Title LIKE '%' + @Keyword + '%'
      AND Score >= @MinScore
    ORDER BY Score DESC
END
GO


/*
QUESTION 6
Create a stored procedure named sp_UpdatePostScore that updates the score of a post.
The procedure should:
● Accept a post ID and a new score as input
● Validate that the post exists
● Use transactions and TRY…CATCH to ensure safe updates
● Roll back changes if an error occurs
Then create a permanent table named TopUsersArchive and insert the results returned by the
procedure into this table.
*/
Go
CREATE PROCEDURE sp_UpdatePostScore @PostId INT,@NewScore INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION

        IF NOT EXISTS (SELECT 1 FROM Posts WHERE Id = @PostId)
        BEGIN
            RAISERROR('Post not found', 16, 1)
        END

        UPDATE Posts
        SET Score = @NewScore
        WHERE Id = @PostId

        COMMIT
    END TRY
    BEGIN CATCH
        ROLLBACK
        THROW
    END CATCH
END
GO


-- Creat Table Archive
CREATE TABLE TopUsersArchive
(
    UserId INT,
    TotalScore INT,
    ArchivedAt DATETIME DEFAULT GETDATE()
)


/*
QUESTION 8
Create a stored procedure named sp_InsertUserLog that inserts a new record into a UserLog
table.
The procedure should:
● Accept user ID, action, and details as input
● Return the newly created log ID using an output parameter
*/
Go
CREATE PROCEDURE sp_InsertUserLog@UserId INT,@Action NVARCHAR(100),@Details NVARCHAR(255),
    @LogId INT OUTPUT
AS
BEGIN
    INSERT INTO UserLog(UserId, Action, Details, CreatedAt)
    VALUES(@UserId, @Action, @Details, GETDATE())

    SET @LogId = SCOPE_IDENTITY()
END
GO


/*
QUESTION 9
Create a stored procedure named sp_UpdateUserReputation that updates a user’s reputation.
The procedure should:
● Validate that the reputation value is not negative
● Validate that the user exists
● Return the number of rows affected
● Handle errors appropriately
*/
Go
CREATE PROCEDURE sp_UpdateUserReputation @UserId INT,@NewReputation INT
AS
BEGIN
    IF @NewReputation < 0
        RAISERROR('Reputation cannot be negative', 16, 1)

    IF NOT EXISTS (SELECT 1 FROM Users WHERE Id = @UserId)
        RAISERROR('User not found', 16, 1)

    UPDATE Users
    SET Reputation = @NewReputation
    WHERE Id = @UserId

    SELECT @@ROWCOUNT AS RowsAffected
END
GO


/*
QUESTION 10
Create a stored procedure named sp_DeleteLowScorePosts that deletes all posts with a score
less than or equal to a given value.
The procedure should:
● Use transactions
● Return the number of deleted records as an output parameter
● Roll back changes if an error occurs
*/
Go
CREATE PROCEDURE sp_DeleteLowScorePosts @MaxScore INT,@DeletedCount INT OUTPUT
AS
BEGIN
-- SET NoCount OFF
    BEGIN TRY
        BEGIN TRANSACTION

        DELETE FROM Posts
        WHERE Score <= @MaxScore

        SET @DeletedCount = @@ROWCOUNT

        COMMIT
    END TRY
    BEGIN CATCH
        ROLLBACK
        THROW
    END CATCH
END
GO

/*
QUESTION 11
Create a stored procedure named sp_BulkInsertBadges that inserts multiple badge records for
a user.
The procedure should:
● Accept a user ID
● Accept a badge count indicating how many badges to insert
● Insert multiple related records in a single operation
*/


GO
GO
CREATE PROCEDURE sp_BulkInsertBadges
    @UserId INT,
    @BadgeCount INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN;

        ;WITH Numbers AS (
            SELECT TOP (@BadgeCount) 
            FROM Users
        )
        INSERT INTO Badges (UserId, Name, Date)
        SELECT @UserId, 'Auto Badge', GETDATE()
        FROM Numbers;

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;

        THROW;
    END CATCH
END
GO



/*
QUESTION 12
Create a stored procedure named sp_GenerateUserReport that generates a complete user report.
The procedure should:
➢ Call another stored procedure internally to retrieve user statistics
➢ Combine user profile data and statistics
➢ Return a formatted report including a calculated user level
*/

CREATE PROCEDURE sp_GenerateUserReport @UserId INT
AS
BEGIN

    DECLARE  @Posts INT, @Badges INT,@AvgScore DECIMAL(10,2),@UserLevel NVARCHAR(20)
    EXEC sp_GetUserSummary @UserId,@Posts OUTPUT,@Badges OUTPUT,@AvgScore OUTPUT

    SET @UserLevel =
        CASE 
            WHEN @Posts >= 100 THEN 'Expert'
            WHEN @Posts >= 20 THEN 'Intermediate'
            ELSE 'Beginner'
        END

    SELECT 
        u.DisplayName,
        u.Reputation,
        @Posts AS TotalPosts,
        @Badges AS TotalBadges,
        @AvgScore AS AvgPostScore,
        @UserLevel AS UserLevel
    FROM Users u
    WHERE u.Id = @UserId
END
GO



/*
QUESTION 3
Create a stored procedure named sp_GetUserOrError that retrieves user details by user ID.
If the specified user does not exist, the procedure should raise a meaningful error.
Use TRY…CATCH for proper error handling.
QUESTION 4
Create a stored procedure named sp_AnalyzeUserActivity that:
*/

-- This is not understood