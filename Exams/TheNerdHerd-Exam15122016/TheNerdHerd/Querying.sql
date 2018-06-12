
/*	Section 3. Querying							40 pts
For this section put your queries in judge and use SQL Server prepare DB and run queries.
5.	Age Range
Select all users that are aged between 22 and 37 inclusively. 
Required columns:
•	Nickname
•	Gender
•	Age
*/

SELECT Nickname,
       Gender,
       Age
FROM Users
WHERE Age BETWEEN 22 AND 37;

/*6.	Messages
Select all messages that are sent after 12.05.2014 and contain the word “just”. Sort the results by the message id in descending order.
Required columns:
•	Content
•	SentOn
*/

SELECT Content,
       SentOn
FROM Messages
WHERE SentOn > '20140512'
      AND Content LIKE '%just%'
ORDER BY Id DESC;

/*	7.	Chats
Select all chats that that are active and their title length is less than 5 or 3rd and 4th letters are equal to “tl”. Sort the results by title in descending order.
Required columns:
•	Title
•	IsActive
	*/

SELECT Title,
       IsActive
FROM Chats
WHERE(LEN(title) < 5
      AND IsActive = 0)
     OR Title LIKE '__tl%'
ORDER BY Title DESC;

/*	8.	Chat Messages
Select all chats with messages sent before 26.03.2012 and chat title with last letter equal to “x”. Sort by chat Id and message Id in ascending order.
Required columns:
•	Id(Chats)
•	Tittle
•	Id(Messages)
*/

select c.Id, c.Title, m.Id from Chats as c 
join Messages as m on m.ChatId = c.Id
where m.SentOn < '20120326' and RIGHT(c.Title,1)='x' 
--where m.SentOn < '20120326' and c.Title like '%x' 
order by c.id,m.id

/*	9.	Message Count
Select all chats and the amount of messages they have. Some messages may 
not have a chat. Filter messages with id less than 90. Select only the first 5 results sorted by TotalMessages in descending order and chat id in ascending order.
Required columns:
•	Id(Chats)
•	TotalMessages
*/

SELECT TOP 5 c.id,
             COUNT(*) AS TotalMessages
FROM Chats AS c
     JOIN Messages AS m ON m.ChatId = c.Id
                           AND m.id < 90
GROUP BY c.Id
ORDER BY TotalMessages DESC,
         c.Id;

/*	10.	Credentials
Select all users with emails ending with “co.uk”. Sort by email in ascending order.
Required columns:
•	Nickname
•	Email
•	Password
*/

SELECT u.Nickname,
       c.Email,
       c.Password
FROM Users AS u
     JOIN Credentials AS c ON c.Id = u.CredentialId
WHERE c.Email LIKE '%co.uk'
ORDER BY c.Email;

/* 11.	Locations
Select all users who don’t have a location.
Required columns:
•	Id(Users)
•	Nickname
•	Age
*/

SELECT id,
       Nickname,
       Age
FROM Users
WHERE users.LocationId IS NULL;

/*	12. Select all messages sent from users who have left the chat (they are not in the chat anymore).
 Filter data only for chat with id 17. Sort by message Id in descending order.
Required columns:
•	Id(Messages)
•	ChatId
•	UserId
*/

SELECT m.id,
       m.ChatId,
       m.UserId
FROM Messages AS m
WHERE m.ChatId = 17
      AND (m.UserId NOT IN
(
    SELECT userId
    FROM UsersChats
    WHERE ChatId = 17
)
           OR m.UserId IS NULL)
ORDER BY m.Id DESC;

/*	13.	Users in Bulgaria
Select all users that are located in Bulgaria. Consider the latitude is in range [41.14;44.13] and longitude in range [22.21; 28.36]. 
Sort the results by title in ascending order.
Required columns:
•	Nickname
•	Title
•	Latitude
•	Longitude
*/

SELECT DISTINCT
       u.Nickname,
       c.Title,
       l.Latitude,
       l.Longitude
FROM users AS u
     JOIN Locations AS l ON l.Id = u.LocationId
                            AND l.Latitude BETWEEN 41.13999 AND 44.12999999
                            AND l.Longitude BETWEEN 22.20999 AND 28.359999
     JOIN UsersChats AS uc ON uc.UserId = u.Id
     JOIN Chats AS c ON uc.ChatId = c.Id
ORDER BY c.Title;

/*	14.	Last Chat
Select the first message (if there is any) of the last chat.
Required columns:
•	Title
•	Content
*/

select C.Title,M.Content from Messages AS M 
RIGHT JOIN(
 select top 1 id, Title from Chats order by StartDate desc
)AS C ON C.Id = M.ChatId




