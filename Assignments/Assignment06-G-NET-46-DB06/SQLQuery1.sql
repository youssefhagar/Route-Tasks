/*
Question 01 : 
Write a query to retrieve the top 15 users with the highest reputation. 
Display their DisplayName, Reputation, and Location. 
Order the results by Reputation in descending order
*/

SELECT TOP (15) DisplayName,Reputation,Location
FROM Users
ORDER BY Reputation DESC;





/*
Question 02 : 
Write a query to get the top 10 posts by score, but include  
all posts that have the same score as the 10th post. 
Use TOP WITH TIES. Display Title, Score, and ViewCount. 
*/

SELECT TOP (10) WITH TIES Title,Score,ViewCount
FROM Posts
WHERE Title IS NOT NULL
ORDER BY Score DESC;




/*
Question 03 : 
Write a query to implement pagination: skip the first 20 users  
and retrieve the next 10 users when ordered by reputation. 
Use OFFSET and FETCH. Display DisplayName and Reputation. 
*/


SELECT DisplayName,Reputation
FROM Users
ORDER BY Reputation DESC
OFFSET 20 ROWS
FETCH NEXT 10 ROWS ONLY;



/*
Question 04: 
Write a query to assign a unique row number to each post  
ordered by Score in descending order. 
Use ROW_NUMBER(). Display the row number, Title, and Score. 
Only include posts with non-null titles. 
*/

SELECT ROW_NUMBER() OVER (ORDER BY Score DESC) AS RowNum,
       Title,
       Score
FROM Posts
WHERE Title IS NOT NULL;


/*
Question 05 : 
Write a query to rank users by their reputation using RANK(). 
Display the rank, DisplayName, and Reputation. 
Explain what happens when two users have the same reputation. 
*/


SELECT RANK() OVER (ORDER BY Reputation DESC) AS RankNum,
       DisplayName,
       Reputation
FROM Users;

-- Explain what happens when two users have the same reputation.
-- Answer : There will be a gap  



/*
Question 06 : 
Write a query to rank posts by score using DENSE_RANK(). 
Display the dense rank, Title, and Score. 
Explain how DENSE_RANK differs from RANK. 
*/

SELECT DENSE_RANK() OVER (ORDER BY Score DESC) AS DenseRankNum,
       Title,
       Score
FROM Posts
WHERE Title IS NOT NULL;


-- Explain how DENSE_RANK differs from RANK.
--     DENSE_RANK          |      RANK
--  There is no gap            there is a gap
--  ex: 1,1,1,2              ex: 1,1,1,4



/*
Question 07 : 
Write a query to divide all users into 5 equal groups (quintiles) 
based on their reputation. Use NTILE(5). 
Display the quintile number, DisplayName, and Reputation. 
*/

SELECT NTILE(5) OVER (ORDER BY Reputation DESC) AS Quintile,
       DisplayName,
       Reputation
FROM Users;


/*
Question 08 : 
Write a query to rank posts within each PostTypeId separately. 
Use ROW_NUMBER() with PARTITION BY. 
Display PostTypeId, rank within type, Title, and Score. 
Order by Score descending within each partition. 
*/

SELECT PostTypeId,ROW_NUMBER() OVER (PARTITION BY PostTypeId ORDER BY Score DESC) AS RankWithinType,
       Title,
       Score
FROM Posts
WHERE Title IS NOT NULL;