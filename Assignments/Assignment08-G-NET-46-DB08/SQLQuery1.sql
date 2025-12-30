/*
Question 01
Retrieve users with:
Reputation > 8000 OR
Created more than 15 posts
Ensure no duplicate users
*/

SELECT DISTINCT u.Id AS UserId,u.DisplayName,u.Reputation
FROM Users u LEFT JOIN Posts p
ON u.Id = p.OwnerUserId
GROUP BY u.Id, u.DisplayName, u.Reputation
HAVING u.Reputation > 8000 OR COUNT(p.Id) > 15;



/*
Question 02
Users with:
Reputation > 3000
At least 5 badges
*/

SELECT u.Id AS UserId,u.DisplayName,u.Reputation
FROM Users u JOIN Badges b
ON u.Id = b.UserId
GROUP BY u.Id, u.DisplayName, u.Reputation
HAVING u.Reputation > 3000 AND COUNT(b.Id) >= 5;



/*
Question 03
Posts with score > 20 and no comments
*/

SELECT p.Id AS PostId,p.Title,p.Score
FROM Posts p LEFT JOIN Comments c 
ON p.Id = c.PostId
WHERE p.Score > 20 AND c.Id IS NULL;



/*
Question 04
Create Posts_Backup table (Score > 10)
*/

CREATE TABLE Posts_Backup AS
SELECT Id,Title,Score,ViewCount,CreationDate,OwnerUserId
FROM Posts
WHERE Score > 10;



/*
Question 05
Create ActiveUsers table
*/

CREATE TABLE ActiveUsers AS
SELECT u.Id AS UserId,u.DisplayName,u.Reputation,u.Location,COUNT(p.Id) AS PostCount
FROM Users u JOIN Posts p
ON u.Id = p.OwnerUserId
WHERE u.Reputation > 1000
GROUP BY u.Id, u.DisplayName, u.Reputation, u.Location;



/*
Question 06
Create empty table with same structure as Comments
*/

CREATE TABLE Comments_Template AS
SELECT *
FROM Comments
WHERE 1 = 0;



/*
   Question 07
   Post Engagement Summary
*/

CREATE TABLE PostEngagementSummary AS
SELECT p.Id AS PostId,p.Title,u.DisplayName AS AuthorName,p.Score,p.ViewCount,COUNT(c.Id) AS CommentCount,
    COALESCE(SUM(c.Score), 0) AS TotalCommentScore
FROM Posts p JOIN Users u 
ON p.OwnerUserId = u.Id
JOIN Comments c ON p.Id = c.PostId
GROUP BY p.Id, p.Title, u.DisplayName, p.Score, p.ViewCount
HAVING COUNT(c.Id) >= 3;



/* =====================================================
   Question 08
   Reusable calculation: Post age in days
===================================================== */

SELECT Id AS PostId,Title,DATEDIFF(DAY, CreationDate, GETDATE()) AS PostAgeInDays
FROM Posts;


/* =====================================================
   Question 09
   Badge level calculation
===================================================== */

SELECT u.Id AS UserId,u.DisplayName,u.Reputation,COUNT(p.Id) AS PostCount,
    CASE
        WHEN u.Reputation > 10000 AND COUNT(p.Id) > 50 THEN 'Gold'
        WHEN u.Reputation > 5000  AND COUNT(p.Id) > 20 THEN 'Silver'
        WHEN u.Reputation > 1000  AND COUNT(p.Id) > 5  THEN 'Bronze'
        ELSE 'None'
    END AS BadgeLevel
FROM Users u LEFT JOIN Posts p 
ON u.Id = p.OwnerUserId
GROUP BY u.Id, u.DisplayName, u.Reputation;



/* =====================================================
   Question 10
   Posts within X days from today
===================================================== */

DECLARE @DaysBack INT = 30;

SELECT Id AS PostId,Title,Score,ViewCount,CreationDate
FROM Posts
WHERE CreationDate >= DATEADD(DAY, -@DaysBack, GETDATE());



/* =====================================================
   Question 11
   Top users by reputation and optional location
===================================================== */

DECLARE @MinReputation INT = 5000;
DECLARE @Location VARCHAR(100) = NULL;

SELECT Id AS UserId,DisplayName,Reputation,Location,CreationDate
FROM Users
WHERE Reputation >= @MinReputation AND (@Location IS NULL OR Location = @Location);



/* =====================================================
   Question 12
   Top 3 posts per PostTypeId
===================================================== */

WITH RankedPosts AS (
    SELECT PostTypeId,Title,Score,
        ROW_NUMBER() OVER (
            PARTITION BY PostTypeId
            ORDER BY Score DESC
        ) AS rn
    FROM Posts
)
SELECT PostTypeId,Title,Score,rn AS Rank
FROM RankedPosts
WHERE rn <= 3;



/* =====================================================
   Question 13
   Users with reputation above average
===================================================== */

WITH AvgReputation AS (
    SELECT AVG(Reputation) AS AvgRep
    FROM Users
)
SELECT u.DisplayName,u.Reputation,a.AvgRep
FROM Users u CROSS JOIN AvgReputation a
WHERE u.Reputation > a.AvgRep;



/* =====================================================
   Question 14
   User post stats using CTE
===================================================== */

WITH UserPostStats AS (
    SELECT OwnerUserId,COUNT(Id) AS TotalPosts,AVG(Score) AS AvgScore
    FROM Posts
    GROUP BY OwnerUserId
)
SELECT u.DisplayName,u.Reputation,s.TotalPosts,s.AvgScore
FROM UserPostStats s JOIN Users u ON s.OwnerUserId = u.Id
WHERE s.TotalPosts > 5;



/* =====================================================
   Question 15
   Multiple CTEs (Posts + Badges)
===================================================== */

WITH PostCountCTE AS (
    SELECT OwnerUserId,COUNT(Id) AS PostCount
    FROM Posts
    GROUP BY OwnerUserId
),
BadgeCountCTE AS (
    SELECT UserId,COUNT(Id) AS BadgeCount
    FROM Badges
    GROUP BY UserId
)
SELECT u.DisplayName,u.Reputation,
    COALESCE(p.PostCount, 0) AS PostCount,
    COALESCE(b.BadgeCount, 0) AS BadgeCount
FROM Users u
LEFT JOIN PostCountCTE p ON u.Id = p.OwnerUserId
LEFT JOIN BadgeCountCTE b ON u.Id = b.UserId;



/* =====================================================
   Question 16
   Recursive CTE: numbers from 1 to 20
===================================================== */

WITH Numbers AS (
    SELECT 1 AS Num
    UNION ALL
    SELECT Num + 1
    FROM Numbers
    WHERE Num < 20
)
SELECT Num
FROM Numbers;
