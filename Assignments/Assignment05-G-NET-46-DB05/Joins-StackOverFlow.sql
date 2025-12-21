/*
#########################################
## Joining Tables 
## Note : Use StackOverflow Database 
#########################################
*/

/*
Question 01 : 
●  Write a query to display all users along with all post types  
*/
-- Tables : Users - Posts - Posttypes
select U.DisplayName ,PT.Type
from Users U inner join Posts P
on u.id = P.OwnerUserid
inner join PostTypes PT
on P.PostTypeID = PT.id;

-- ======================================
/*
Question 02 : 
●  Write a query to retrieve all posts along with their owner's  
display name and reputation. Only include posts that have an owner. 
*/

select U.DisplayName ,U.Reputation,P.Title
from Users U inner join Posts P
on u.id = P.OwnerUserid;


-- ======================================
/*
Question 03 : 
Write a query to show all comments with their associated post 
titles. Display the comment text, comment score, and post title. 
*/

select P.Title , C.Text , C.Score 
from comments C inner join Posts P
on C.PostId = P.Id;

-- ======================================
/*
Question 04 : 
Write a query to list all users and their badges (if any). 
Include users even if they don't have badges. 
Show display name, badge name, and badge date. 
*/

select U.DisplayName , B.name , B.Date
from Users U left join Badges B
on U.id = B.UserId;

-- ======================================
/*
Question 05 : 
Write a query to display all posts along with their comments (if any).
Include posts that have no comments.
Show post title, post score, comment text, and comment score.
*/

select P.Title , P.Score , C.Text , C.Score 
from comments C Right join Posts P
on C.PostId = P.Id;
-- ======================================

/*
Question 06 : 
Write a query to show all votes along with their corresponding posts.
Include all votes even if the post information is missing. 
Display vote type ID, creation date, and post title. 
*/

select v.VoteTypeId , v.CreationData , p.Title
from Votes v left join Posts p
on v.postId = p.id;
-- ======================================

/*
Question 07 : 
Write a query to find all answers (posts with ParentId) along with 
their parent question. Show the answer title, answer score, 
question title, and question score. 
*/

select Asr.Title ,Asr.score , Qu.Tilte , Qu.Score
from Posts Asr join Posts Qu
on Asr.ParentId = Qu.id;
-- ======================================

/*
Question 08 :
Write a query to display all related posts using the PostLinks table. 
Show the original post title, related post title, and link type ID.
*/
-- I don't Know
--select p.title , l
--from PostLinks l left join Posts p
--on l.relatePostId = p.id


/*
Question 09 : 
Write a query to show posts with their authors and the post type 
name. Display post title, author display name, author reputation,  
and post type. 
*/

select P.Title ,U.DisplayName,U.Reputation,PT.Name            
from Posts P join Users U
on P.OwnerUserId = U.Id
join PostTypes PT
on P.PostTypeId = PT.Id;

/*
Question 10 : 
Write a query to retrieve all comments along with the post title, 
post author, and the commenter's display name. 
*/

select P.Title,PU.DisplayName,CU.DisplayName
from Comments C join Posts P
on C.PostId = P.Id
join Users PU          
on P.OwnerUserId = PU.Id
join Users CU        
on C.UserId = CU.Id;

/*
Question 11 :
Write a query to display all votes with post information and vote type name.
Show post title, vote type name, creation date, and bounty amount.
*/

select P.Title,VT.Name,V.CreationDate, V.BountyAmount
from Votes V join Posts P
on V.PostId = P.Id
join VoteTypes VT
no V.VoteTypeId = VT.Id;

/*
Question 12 :
Write a query to show all users along with their posts and 
comments on those posts. Include users even if they have no 
posts or comments. Display user name, post title, and comment 
text. 
*/

-- i don't Know


/*
Question 13:
Write a query to retrieve posts with their authors, post types, and
any badges the author has earned. Show post title, author name,
post type, and badge name.
*/

select P.Title,U.DisplayName,PT.Name,B.Name
from Posts P join Users U
on P.OwnerUserId = U.Id
join PostTypes PT
on P.PostTypeId = PT.Id
LEFT JOIN Badges B
on U.Id = B.UserId;


/*
Question 14 : 
Write a query to create a comprehensive report showing:  
post title, post author name, author reputation, comment text, 
commenter name, vote type, and vote creation date. Include 
posts even if they don't have comments or votes. Filter to only 
show posts with a score greater than 5. 
*/

-- i can't Solve this