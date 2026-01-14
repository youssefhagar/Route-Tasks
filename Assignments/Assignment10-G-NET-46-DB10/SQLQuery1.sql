-- #############################################
-- #############      Task     #################
-- #############################################



/*
Scenario(1) : Management wants a simple dashboard showing "User Engagement". 
They need a view that hides the complexity of joins.
Create a view named v_UserEngagement. 
The view should return: UserDisplayName , TotalPosts (Count of their posts) , 
TotalComments (Count of their comments) and OverallScore (Sum of scores from both posts and comments) 
Condition: Only include users who have at least 1 Post.
*/
CREATE VIEW v_UserEngagement
AS
SELECT
    u.DisplayName AS UserDisplayName,
    COUNT(DISTINCT p.Id) AS TotalPosts,
    COUNT(DISTINCT c.Id) AS TotalComments,
    ISNULL(SUM(p.Score),0) + ISNULL(SUM(c.Score),0) AS OverallScore
FROM Users u
JOIN Posts p
    ON u.Id = p.OwnerUserId      
LEFT JOIN Comments c
    ON u.Id = c.UserId
GROUP BY u.DisplayName;
GO



/*
Scenario(2): We have a heavy reporting query that calculates the Total Views received by all posts for each year.
This calculation takes too long because the Posts table is huge. 
Create a view v_YearlyPostStats that calculates: PostYear (derived from CreationDate) , 
TotalViews (Sum of ViewCount) and TotalPostCount (Count of posts) 
Constraint: You must use WITH SCHEMABINDING and COUNT_BIG(*). 
Create a Unique Clustered Index on this view to materialize it.
*/
CREATE VIEW dbo.v_YearlyPostStats
WITH SCHEMABINDING
AS
SELECT
    YEAR(CreationDate) AS PostYear,
    COUNT_BIG(*) AS TotalPostCount,
    SUM(ISNULL(ViewCount,0)) AS TotalViews
FROM dbo.Posts
GROUP BY YEAR(CreationDate);
GO

CREATE UNIQUE CLUSTERED INDEX IX_v_YearlyPostStats
ON dbo.v_YearlyPostStats (PostYear);
GO



/*
Scenario: You need to give a junior moderator access to update post titles, 
but they are only allowed to touch posts that have a Score lower than 10 (Low quality posts).
They should not be able to edit high-scoring posts or accidentally upgrade a low-score post
to a high score manually. Create a view v_LowScorePosts that selects Id, Title, Score from
Posts where Score < 10. Add the necessary option to prevent the moderator from updating a 
post's score to be 20 (which would make it disappear from their view).
*/

CREATE VIEW v_LowScorePosts
AS
SELECT
    Id,
    Title,
    Score
FROM Posts
WHERE Score < 10
WITH CHECK OPTION;
GO




-- #############################################
-- ##########       Assignment     #############
-- #############################################


-- Question 01 :
-- QUESTION 1 - Create a view that displays basic user information including 
-- their display name, reputation, location, and account creation date.
-- Name the view: vw_BasicUserInfo - Test the view by selecting all records from it. 
CREATE VIEW vw_BasicUserInfo
AS
SELECT 
    Id AS UserId,
    DisplayName,
    Reputation,
    Location,
    CreationDate
FROM Users;
GO
-- Test
SELECT * FROM vw_BasicUserInfo;


-- Question 02 : 
--Create a view that shows all posts with their titles, scores,
-- view counts, and creation dates where the score is greater than 10. 
-- Name the view: vw_HighScoringPosts - Test by querying posts from this view. 
CREATE VIEW vw_HighScoringPosts
AS
SELECT 
    Id AS PostId,
    Title,
    Score,
    ViewCount,
    CreationDate
FROM Posts
WHERE Score > 10;
GO

-- Test
SELECT * FROM vw_HighScoringPosts;


-- Question 03 : 
-- Create a view that combines data from Users and Posts tables. 
-- Show the post title, post score, author name, and author reputation.
-- Name the view: vw_PostsWithAuthors - This is a complex view involving joins. 
CREATE VIEW vw_PostsWithAuthors
AS
SELECT 
    p.Title,
    p.Score,
    u.DisplayName AS AuthorName,
    u.Reputation AS AuthorReputation
FROM Posts p
JOIN Users u 
    ON p.OwnerUserId = u.Id;
GO
 
 
 
-- Question 04 : 
-- Create a view that aggregates comment statistics per post.
-- Include: PostId, total comment count, sum of comment scores,
-- and average comment score. - Name the view: vw_PostCommentStats
-- This is a complex view with aggregation.
CREATE VIEW vw_PostCommentStats
AS
SELECT 
    PostId,
    COUNT(*) AS TotalComments,
    SUM(Score) AS TotalCommentScore,
    AVG(CAST(Score AS DECIMAL(10,2))) AS AvgCommentScore
FROM Comments
GROUP BY PostId;
GO


-- Question 05 : 
-- Create an indexed view that shows user activity summaries.
-- Include: UserId, DisplayName, Reputation, total posts count.
-- Name the view: vw_UserActivityIndexed 
-- Make it an indexed view with a unique clustered index on UserId 
CREATE VIEW vw_UserActivityIndexed
WITH SCHEMABINDING
AS
SELECT 
    u.Id AS UserId,
    u.DisplayName,
    u.Reputation,
    COUNT_BIG(p.Id) AS TotalPosts
FROM dbo.Users u
LEFT JOIN dbo.Posts p
    ON u.Id = p.OwnerUserId
GROUP BY 
    u.Id, u.DisplayName, u.Reputation;
GO

CREATE UNIQUE CLUSTERED INDEX IX_vw_UserActivityIndexed
ON vw_UserActivityIndexed(UserId);
GO


-- Question 06 : 
-- Create a partitioned view that combines high reputation users 
-- (reputation > 5000) and low reputation users (reputation <= 5000) 
-- from the same Users table using UNION ALL. - Name the view: vw_UsersPartitioned 
CREATE VIEW vw_UsersPartitioned
AS
SELECT * FROM Users WHERE Reputation > 5000
UNION ALL
SELECT * FROM Users WHERE Reputation <= 5000;
GO


-- Question 07 : 
-- Create an updatable view on the Users table that shows
-- UserId, DisplayName, and Location.
-- Test the view by updating a user's location through the view.
-- Name the view: vw_EditableUsers 
CREATE VIEW vw_EditableUsers
AS
SELECT 
    Id AS UserId,
    DisplayName,
    Location
FROM Users;
GO

-- Test Update
UPDATE vw_EditableUsers
SET Location = 'Cairo'
WHERE UserId = 1;


-- Question 08 : 
-- Create a view with CHECK OPTION that only shows posts with
-- score greater than or equal to 20.
-- Name the view: vw_QualityPosts 
-- Ensure that any updates through this view maintain the score >= 20 
CREATE VIEW vw_QualityPosts
AS
SELECT 
    Id AS PostId,
    Title,
    Score
FROM Posts
WHERE Score >= 20
WITH CHECK OPTION;
GO


-- Question 09 : 
-- Create a complex view that shows comprehensive post information 
-- including post details, author information, and comment count. 
-- Include: PostId, Title, Score, AuthorName, AuthorReputation, CommentCount. 
CREATE VIEW vw_PostDetails
AS
SELECT 
    p.Id AS PostId,
    p.Title,
    p.Score,
    u.DisplayName AS AuthorName,
    u.Reputation AS AuthorReputation,
    COUNT(c.Id) AS CommentCount
FROM Posts p
JOIN Users u 
    ON p.OwnerUserId = u.Id
LEFT JOIN Comments c
    ON p.Id = c.PostId
GROUP BY 
    p.Id, p.Title, p.Score,
    u.DisplayName, u.Reputation;
GO


-- Question 10 : 
-- Create a view that shows badge statistics per user. 
-- Include: UserId, DisplayName, Reputation, total badge count, 
-- and a list of unique badge names (comma-separated if possible,
-- or just the count for simplicity). - Name the view: vw_UserBadgeStats . 
CREATE VIEW vw_UserBadgeStats
AS
SELECT 
    u.Id AS UserId,
    u.DisplayName,
    u.Reputation,
    COUNT(b.Id) AS TotalBadges
FROM Users u
LEFT JOIN Badges b
    ON u.Id = b.UserId
GROUP BY 
    u.Id, u.DisplayName, u.Reputation;
GO


-- Question 11 : 
-- Create a view that shows only active users (those who have 
-- posted in the last 365 days from today, or have a reputation > 1000). 
-- Include: UserId, DisplayName, Reputation, LastActivityDate 
-- Name the view: vw_ActiveUsers. 
CREATE VIEW vw_ActiveUsers
AS
SELECT DISTINCT
    u.Id AS UserId,
    u.DisplayName,
    u.Reputation,
    u.LastAccessDate AS LastActivityDate
FROM Users u
LEFT JOIN Posts p
    ON u.Id = p.OwnerUserId
WHERE 
    p.CreationDate >= DATEADD(DAY, -365, GETDATE())
    OR u.Reputation > 1000;
GO


-- Question 12 : 
-- Create an indexed view that calculates total views and average score per user from their posts. 
-- Include: UserId, TotalPosts, TotalViews, AvgScore
-- Name the view: vw_UserPostMetrics 
-- Create a unique clustered index on UserId. 
CREATE VIEW vw_UserPostMetrics
WITH SCHEMABINDING
AS
SELECT 
    u.Id AS UserId,
    COUNT_BIG(p.Id) AS TotalPosts,
    SUM(ISNULL(p.ViewCount,0)) AS TotalViews,
    AVG(CAST(p.Score AS DECIMAL(10,2))) AS AvgScore
FROM dbo.Users u
JOIN dbo.Posts p
    ON u.Id = p.OwnerUserId
GROUP BY u.Id;
GO

CREATE UNIQUE CLUSTERED INDEX IX_vw_UserPostMetrics
ON vw_UserPostMetrics(UserId);
GO


-- Question 13 : 
-- Create a view that categorizes posts based on their score ranges.
-- Categories: 'Excellent' (>= 100), 'Good' (50-99), 'Average' (10-49), 
-- 'Low' (< 10) - Include: PostId, Title, Score, Category - Name the view: vw_PostsByCategory
CREATE VIEW vw_PostsByCategory
AS
SELECT 
    Id AS PostId,
    Title,
    Score,
    CASE
        WHEN Score >= 100 THEN 'Excellent'
        WHEN Score BETWEEN 50 AND 99 THEN 'Good'
        WHEN Score BETWEEN 10 AND 49 THEN 'Average'
        ELSE 'Low'
    END AS Category
FROM Posts;
GO



