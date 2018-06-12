/*Section 2. DML								15 pts
For this section put your queries in judge and use SQL Server run skeleton, run queries and check DB.
Before you start you have to import Data.sql. If you have created the structure correctly the data should be successfully inserted.
In this section you have to do couple of data manipulations:
2.	Insert
*/
use TheNerdHerd
begin tran

INSERT INTO Messages (Content, ChatId, UserId, SentOn)
SELECT
CONCAT(Age, '-', Gender, '-', l.Latitude, '-', l.Longitude ),
CASE 
	WHEN Gender = 'F' THEN CEILING(SQRT(Age * 2))
	WHEN Gender = 'M' THEN CEILING(POWER(Age / 18, 3))
END,
u.Id,
'2016-12-15'
FROM Users AS u
INNER JOIN Locations AS l ON l.Id = u.LocationId
WHERE u.Id BETWEEN 10 AND 20

  select * from Messages

  rollback

  /*3.	Update
The back-end developers have slightly failed and let some chats to have messages with a date earlier than the creation date of the chat. You have to fix that. 
For all chats which have messages before the chat StartDate update the chat StartDate to be equal to the earliest message in that chat.
*/
begin tran

update Chats 
set StartDate = (
	Select min(m.SentOn) from Chats as c
	join Messages as m on m.ChatId = c.Id
	where c.Id = Chats.id
	)
	where chats.id in(
	select c.Id from Chats as c 
	join Messages as m on m.ChatId = c.Id
	group by c.Id, c.StartDate
	having c.StartDate>min(m.SentOn))


rollback


/*4.	Delete
Delete all locations which doesn’t have user located there.
*/

begin tran


DELETE FROM Locations
WHERE Locations.id IN(SELECT l.id
                      FROM Locations AS l
                           LEFT JOIN Users AS u ON u.LocationId = l.Id
                      WHERE u.id IS NULL);

rollback


