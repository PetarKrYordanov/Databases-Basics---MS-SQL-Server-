
/*	 Section 4. Programmability					20 pts
For this section put your queries in judge and use SQL Server run skeleton, run queries and check DB.
15.	Radians
Create a user defined function that transforms degrees to radians. The formula should multiply the degrees by Pi and then split by 180. The return type must be float. Call the function udf_GetRadians.
Parameters:
•	Degrees
*/

GO
CREATE FUNCTION udf_GetRadians
(@Degrees FLOAT
)
RETURNS FLOAT
AS
     BEGIN
         DECLARE @result FLOAT;
         SET @result = @Degrees * PI() / 180;
         RETURN @result;
     END;
GO
SELECT dbo.udf_GetRadians(22.12) AS Radians;

/*	16.	Change Password
Create a user defined procedure that receives an email and changes the password with the newly provided one. 
If the email doesn’t exist throw an exception with Severity = 16, State = 1
 and message “The email does't exist!”. Call the procedure udp_ChangePassword.
Parameters:
•	Email
•	NewPassword
*/

USE TheNerdHerd;
GO
CREATE PROC udp_ChangePassword @Email       VARCHAR(30),
                               @NewPassword VARCHAR(20)
AS
     BEGIN
         BEGIN TRANSACTION;
         DECLARE @mail VARCHAR(30);
         SET @mail =
(
    SELECT TOP 1 Email
    FROM Credentials
    WHERE Email = @Email
);
         IF(@mail IS NULL)
             BEGIN
                 ROLLBACK;
                 RAISERROR('The email does''t exist!', 16, 1);
             END;
         UPDATE Credentials
           SET
               Password = @NewPassword
         WHERE Email = @Email;
         COMMIT;
     END;
GO

/*	17.	Send Message
Create a user defined procedure sends a message with a current date. The procedure should receive UserId, ChatId and the Content of the message. If there is no chat with that user throw an exception with Severity = 16, State = 1 and message “There is no chat with that user!”. Call the procedure udp_SendMessage.
Parameters:
•	UserId
•	ChatId
•	Content
*/ 

CREATE PROCEDURE udp_SendMessage @UserId  INT,
                                 @ChatId  INT,
                                 @Content VARCHAR(200)
AS
     BEGIN
         BEGIN TRANSACTION;
         DECLARE @ChatCount INT;
         SET @ChatCount =
(
    SELECT COUNT(*)
    FROM UsersChats
    WHERE ChatId = @ChatId
          AND UserId = @UserId
);
         IF(@ChatCount <> 1)
             BEGIN
                 ROLLBACK;
                 RAISERROR('There is no chat with that user!', 16, 1);
             END;
         INSERT INTO Messages
(Content,
 Senton,
 chatid,
 userid
)
         VALUES
(@Content,
 '2016-12-05',
 @ChatId,
 @UserId
);
         COMMIT;
     END;

/*	18.	Log Messages
Create a trigger that logs any deleted message from table messages.
 Submit only your create trigger statement.
  The log table should be called MessageLogs and should have exactly the same structure as table Messages. 
  The name of the trigger is not important.
*/

Select * into MessageLogs from Messages
truncate table MessageLogs
go

Create trigger T_Messages_After_Del on Messages after DELETE
as
begin
 INSERT INTO MessageLogs
       SELECT *
       FROM deleted;

 delete from Messages where id =1

/*Section 5. Bonus								10 pts
For this section put your queries in judge and use SQL Server run skeleton, run queries and check DB.
19.	Delete users
Create a trigger that will help you to delete a user. Submit the create trigger statement only.
Example:

     DELETE FROM Users
      WHERE Users.Id = 1
*/
go
								   
CREATE TRIGGER T_Users_InsteadOF_Delete ON Users INSTEAD OF DELETE
AS
	UPDATE Users
	SET CredentialId = NULL
	WHERE Id IN (SELECT Id FROM deleted)
	
	DELETE FROM Credentials
	WHERE Id IN (SELECT CredentialId FROM deleted)

	DELETE FROM UsersChats
	WHERE UserId IN (SELECT Id FROM deleted)

	UPDATE Messages
	SET UserId = NULL
	WHERE UserId IN (SELECT Id FROM deleted)
	
	DELETE FROM Users
	WHERE Id IN (SELECT Id FROM deleted)
   end







