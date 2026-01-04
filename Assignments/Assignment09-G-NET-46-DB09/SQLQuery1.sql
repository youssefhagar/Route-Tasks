-- #############################################
-- ------     TASK SOLUTION   ----------------
-- #############################################
/*
Scenario: The marketing team runs this query frequently to find popular posts
by specific users, but it is running very slow. Create the best possible Index to
optimize this specific query
Example:

            SELECT Id, Title, Score, ViewCount, CreationDate
            FROM Posts
            WHERE OwnerUserId = 22656  AND Score > 100
            ORDER BY CreationDate DESC;
*/

-- Best Index

CREATE NONCLUSTERED INDEX IX_Posts_OwnerUser_Score_CreationDate
ON Posts (OwnerUserId, Score, CreationDate DESC)
INCLUDE (Title, ViewCount);

-- Why This Index Is Efficient
-- Filters rows quickly using OwnerUserId and Score
-- Returns data already sorted by CreationDate DESC




-- #############################################
-- ------     ASSIGNMENT SOLUTION   ------------
-- #############################################






/* =========================================================
   Question 01
   Optimize queries that search posts by a specific user
   with a minimum score threshold, ordered by score DESC
   ========================================================= */

/* a) Create an appropriate covering index */
CREATE NONCLUSTERED INDEX IX_Posts_User_Score
ON Posts (OwnerUserId, Score)
GO

/* b) The index covers all columns used in SELECT */

/* c) Test query */
SELECT Id, Title, Score, ViewCount, CreationDate
FROM Posts
WHERE OwnerUserId = 5 AND Score > 50 ك
GO

/* d) Verify index creation */
EXEC sp_helpindex 'Posts';
GO



/* =========================================================
   Question 02
   Optimize queries that frequently access high-value posts
   (Score > 100 AND Title IS NOT NULL)
   ========================================================= */

/* a) Create a filtered index for high-value posts */
CREATE NONCLUSTERED INDEX IX_Posts_HighValue
ON Posts (Score)
WHERE Score > 100 AND Title IS NOT NULL;
GO

/* b) Relevant columns are included to fully cover the query */

/* c) Test query */
SELECT Id, OwnerUserId, Title, Score, ViewCount, CreationDate
FROM Posts
WHERE Score > 100 AND Title IS NOT NULL
GO


/* d) Explain why this specialized index design is beneficial

   This filtered index is beneficial because it stores only high-value posts
   that satisfy the conditions (Score > 100 and Title IS NOT NULL).
   By indexing a smaller subset of rows, SQL Server scans fewer pages,
   reduces I/O operations, and improves query performance.
   The optimizer can quickly locate the required rows using an index seek
   instead of scanning the entire Posts table.
*/





