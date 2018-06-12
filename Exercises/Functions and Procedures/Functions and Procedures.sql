use SoftUni
go
--Problem 1
CREATE PROCEDURE usp_GetEmployeesSalaryAbove35000
AS
     BEGIN
         SELECT FirstName,
                LastName
         FROM Employees
         WHERE Salary > 35000;
     END;
GO
EXEC usp_GetEmployeesSalaryAbove35000;
--Problem 2
GO
CREATE PROCEDURE usp_GetEmployeesSalaryAboveNumber(@InputNumber DECIMAL(18, 4)  = 35000)
AS
     BEGIN
         SELECT FirstName,
                LastName
         FROM Employees
         WHERE Salary >= @InputNumber;
     END;
GO
EXEC usp_GetEmployeesSalaryAboveNumber
     48100;
USE SoftUni;
GO
--Problem 3
CREATE PROCEDURE usp_GetTownsStartingWith @StartString VARCHAR(6)
AS
     BEGIN
         SELECT [name] AS Town
         FROM Towns
         WHERE [Name] LIKE @StartString+'%';
     END;
GO
EXEC usp_GetTownsStartingWith
     b;
GO
--Problem 4
CREATE PROCEDURE usp_GetEmployeesFromTown @TownName VARCHAR(50)
AS
     BEGIN
         SELECT e.FirstName,
                e.LastName
         FROM Towns AS t
              INNER JOIN Addresses AS a ON a.TownID = t.TownID
              INNER JOIN Employees AS e ON e.AddressID = a.AddressID
         WHERE t.Name = @TownName;
     END;
GO
EXEC usp_GetEmployeesFromTown
     'Sofia';
GO
--Problem 5
CREATE FUNCTION ufn_GetSalaryLevel
(@salary INT
)
RETURNS VARCHAR(7)
AS
     BEGIN
         DECLARE @SalaryLevel VARCHAR(7);
         SET @SalaryLevel = CASE
                                WHEN @salary < 30000
                                THEN 'Low'
                                WHEN @salary BETWEEN 30000 AND 50000
                                THEN 'Average'
                                ELSE 'High'
                            END;
         RETURN @SalaryLevel;
     END;
GO
SELECT 13500 AS Salary,
       dbo.ufn_GetSalaryLevel(13500);
GO
--Problem 6
CREATE PROCEDURE usp_EmployeesBySalaryLevel @SalaryLevel VARCHAR(7)
AS
     BEGIN
         SELECT FirstName,
                LastName
         FROM Employees
         WHERE dbo.ufn_GetSalaryLevel(Salary) = @SalaryLevel;
     END;
GO

--Problem 7
CREATE FUNCTION ufn_IsWordComprised
(@setOfLetters VARCHAR(MAX),
 @word         VARCHAR(MAX)
)
RETURNS BIT
AS
     BEGIN
         DECLARE @Count INT= 1;
         DECLARE @CurrentLetter CHAR;
         WHILE(LEN(@word) >= @Count)
             BEGIN
                 SET @CurrentLetter = SUBSTRING(@word, @Count, 1);
                 DECLARE @MatchIndex INT= CHARINDEX(@CurrentLetter, @SetOfLetters);
                 IF(@MatchIndex = 0)
                     BEGIN
                         RETURN 0;
                     END;
                 SET @Count = @Count + 1;
             END;
         RETURN 1;
     END;
GO
SELECT dbo.ufn_IsWordComprised('let', 'tell');
SELECT dbo.ufn_IsWordComprised('sdasgg', 'Sofia');

-- Problem 8
GO
CREATE PROCEDURE usp_DeleteEmployeesFromDepartment @departmentId INT
AS
     BEGIN
         DELETE FROM EmployeesProjects
         WHERE EmployeeID IN(SELECT EmployeeID
                             FROM Employees
                             WHERE DepartmentID = @departmentId);
         ALTER TABLE departments ALTER COLUMN ManagerID INT NULL;
         UPDATE Departments
           SET
               ManagerID = NULL
         WHERE ManagerID IN(SELECT EmployeeID
                            FROM Employees
                            WHERE DepartmentID = @departmentId);
         UPDATE Employees
           SET
               ManagerID = NULL
         WHERE ManagerID IN(SELECT EmployeeID
                            FROM Employees
                            WHERE DepartmentID = @departmentId);
         DELETE Employees
         FROM Employees
         WHERE DepartmentID = @departmentId;
         DELETE FROM Departments
         WHERE DepartmentID = @departmentId;
         SELECT COUNT(*)
         FROM Employees
         WHERE DepartmentID = @departmentId;
     END;
GO

--Problem 9
USE Bank;
GO
CREATE PROCEDURE usp_GetHoldersFullName
AS
     BEGIN
         SELECT ah.FirstName+' '+ah.LastName AS [Full Name]
         FROM AccountHolders AS ah;
     END;
GO
EXEC usp_GetHoldersFullName;

--Problem 10
GO
CREATE PROC usp_GetHoldersWithBalanceHigherThan(@minBalance MONEY)
AS
     BEGIN
         WITH CTE_MinBalanceAccountHolders(HolderId)
              AS (
              SELECT AccountHolderId
              FROM Accounts
              GROUP BY AccountHolderId
              HAVING SUM(Balance) > @minBalance)
              SELECT ah.FirstName AS [First Name],
                     ah.LastName AS [Last Name]
              FROM CTE_MinBalanceAccountHolders AS minBalanceHolders
                   JOIN AccountHolders AS ah ON ah.Id = minBalanceHolders.HolderId
              ORDER BY ah.LastName,
                       ah.FirstName;
     END;
		  go

 --11. 
USE Bank -- DO NOT SUBMIT IN JUDGE the USE Bank statement or you will get compile time error.
go
CREATE FUNCTION ufn_CalculateFutureValue (@sum money, @annualIntRate float, @years int)
RETURNS money
AS
BEGIN

  RETURN @sum * POWER(1 + @annualIntRate, @years);  

END;

--12. Calculating Interest
GO -- DO NOT SUBMIT IN JUDGE "Go"
CREATE PROC usp_CalculateFutureValueForAccount
(@accountId    INT,
 @interestRate FLOAT
)
AS
     BEGIN
         DECLARE @years INT= 5;
         SELECT a.Id AS [Account Id],
                ah.FirstName AS [First Name],
                ah.LastName AS [Last Name],
                a.Balance AS [Current Balance],
                dbo.ufn_CalculateFutureValue(a.Balance, @interestRate, @years) AS [Balance in 5 years]
         FROM AccountHolders AS ah
              JOIN Accounts AS a ON ah.Id = a.AccountHolderId
         WHERE a.Id = @accountId;
     END;

go
 --13. *Cash in User Games Odd Rows
USE Diablo --DO NOT SUBMIT IN JUDGE 
GO --DO NOT SUBMIT IN JUDGE "Go"
CREATE FUNCTION ufn_CashInUsersGames
(@gameName NVARCHAR(50)
)
RETURNS TABLE
AS
     RETURN(
     WITH CTE_CashInRows(Cash,
                         RowNumber)
          AS (
          SELECT ug.Cash,
                 ROW_NUMBER() OVER(ORDER BY ug.Cash DESC)
          FROM UsersGames AS ug
               JOIN Games AS g ON ug.GameId = g.Id
          WHERE g.Name = @gameName)
          SELECT SUM(Cash) AS SumCash
          FROM CTE_CashInRows
          WHERE RowNumber % 2 = 1 -- odd row numbers only
     );
 go
-- testing
SELECT * FROM dbo.ufn_CashInUsersGames ('Lily Stargazer');
SELECT * FROM dbo.ufn_CashInUsersGames ('Love in a mist');

/*Section II. Triggers and Transactions
Part 1. Queries for Bank Database
Problem 14. Create Table Logs
Create a table – Logs (LogId, AccountId, OldSum, NewSum). 
Add a trigger to the Accounts table that enters a new entry into the Logs table every time the sum on an account changes.
 Submit only the query that creates the trigger.
Example
*/
use Bank

 Create table Logs 
 (LogId int primary key identity,
 AccountId int,
 OldBalance money,
 NewSum money)

 go
 select * from Accounts
 
 begin tran

  update Accounts 
  set Balance = 100 where id =1
   go
 Create Trigger tr_CrateAccountLogs on Accounts after
update 
as 
insert into Logs 
select id,AccountHolderId, Balance,Balance from inserted


 rollback
 select * from Accounts
 select * from Logs
