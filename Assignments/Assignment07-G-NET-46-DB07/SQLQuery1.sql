
/*
Question 01 : 
Write a query to display all user display names in uppercase  
along with the length of their display name
*/

select UPPER(DisplayName) , LEN(DisplayName)
from users;

/*
Question 02 : 
Write a query to show all posts with their titles and calculate  
how many days have passed since each post was created. 
Use DATEDIFF to calculate the difference from CreationDate to today.
*/

select Title , DATEDIFF(DAY,CreationDate,GETDATE())
from posts


/*
Question 03 : 
Write a query to count the total number of posts for each user. 
Display the OwnerUserId and the count of their posts. 
Only include users who have created posts. 
*/

select OwnerUserId , COUNT(*) As TOtalPosts
from Posts
where OwnerUserId Is Not Null
group by OwnerUserId

/*Question 04: 
Write a query to find users whose reputation is greater than  
the average reputation of all users. Display their DisplayName  
and Reputation. Use a subquery in the where clause. 
*/
select  DisplayName, Reputation
from Users
where Reputation > (select AVG(Reputation) from Users);



/*
Question 05 : 
Write a query to display each post title along with the first  
50 characters of the title. If the title is NULL, replace it  
with 'No Title'. Use SUBSTRING and ISNULL functions. 
*/
select IIF( Title IS NULL,'No Title',SUBSTRING(Title, 1, 50)) AS ShortTitle
from Posts;

/*
Question 06 : 
Write a query to calculate the total score and average score  
for each PostTypeId. Also show the count of posts for each type. 
Only include post types that have more than 100 posts. 
*/
select PostTypeId , SUM(Score),AVG(Score) ,COUNT(*)
from Posts
Group by PostTypeId
Having COUNT(*) > 100


/*
Question 07 : 
Write a query to show each user's DisplayName along with  
the total number of badges they have earned. Use a subquery  
in the select clause to count badges for each user. 
*/

select U.DisplayName,
    (select COUNT(*) 
     from Badges B 
     where B.UserId = U.Id) AS TotalBadges
from Users U;


/*
Question 08 : 
Write a query to find all posts where the title contains the word 
'SQL'. Display the title, score, and format the CreationDate as 
'Mon DD, YYYY'. Use CHARINDEX and FORMAT functions. 
*/
select Title,Score,FORMAT(CreationDate, 'MMM dd, yyyy') AS FormattedDate
from Posts
where CHARINDEX('SQL', Title) > 0;


/*
Question 09 : 
Write a query to group comments by PostId and calculate: 
Total number of comments 
Sum of comment scores 
Average comment score 
Only show posts that have more than 5 comments. 
*/
select PostId,COUNT(*) AS TotalComments,SUM(Score) AS TotalScore, AVG(Score) AS AvgScore
from Comments
Group by PostId
Having COUNT(*) > 5;


/*
Question 10 : 
Write a query to find all users whose location is not NULL. 
Display their DisplayName, Location, and calculate their  
reputation level using IIF: 'High' if reputation > 5000,  
otherwise 'Normal'.
*/

select DisplayName,Location,IIF(Reputation > 5000, 'High', 'Normal') AS ReputationLevel
from Users
where Location IS NOT NULL;


/*
Question 11 : 
Write a query using a derived table (subquery in from) to: 
. First, calculate total posts and average score per user 
. Then, join with Users table to show DisplayName 
. Only include users with more than 3 posts 
The derived table must have an alias. 
*/

select U.DisplayName,DT.TotalPosts,DT.AvgScore
from (
    select OwnerUserId, COUNT(*) AS TotalPosts,AVG(Score) AS AvgScore
    from Posts
    Group by OwnerUserId
    Having COUNT(*) > 3 )as DT
JOIN Users U
 on U.Id = DT.OwnerUserId;


/*
Question 12 : 
Write a query to group badges by UserId and badge Name. -Count how many times each user earned each specific badge. 
Display UserId, badge Name, and the count. 
Only show combinations where a user earned the same badge  
more than once 
*/
select UserId,Name,COUNT(*) AS BadgeCount
from Badges
Group by UserId, Name
Having COUNT(*) > 1;

/*
Question 13 : 
Write a query to display user information along with their  
account age in years. Use DATEDIFF to calculate years between  
CreationDate and current date. Round the result to 2 decimal 
places. 
Also show the absolute value of their DownVotes. 
*/

select DisplayName,ABS(DownVotes) AS DownVotesAbs,
    ROUND(DATEDIFF(DAY, CreationDate, GETDATE()) / 365.0, 2) AS AgeYears
from Users;


/*
Question 14 : 
Write a complex query that: 
. Uses a derived table to calculate comment statistics per post 
. Joins with Posts and Users tables 
. Shows: Post Title, Author Name, Author Reputation,  
Comment Count, and Total Comment Score 
. Filters to only show posts with more than 3 comments  
and post score greater than 10 
. Uses COALESCE to replace NULL author names with 'Anonymous' 
*/


-- I Can't Solve this
