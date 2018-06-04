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
go
exec usp_GetEmployeesSalaryAbove35000
--Problem 2
go
CREATE PROCEDURE usp_GetEmployeesSalaryAboveNumber @InputNumber DECIMAL(18, 4)  = 35000
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
(@salary int
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
select  13500 as Salary, dbo.ufn_GetSalaryLevel(13500) 
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

	go
 select dbo.ufn_IsWordComprised('let','tell')
 select dbo.ufn_IsWordComprised('sdasgg','Sofia')

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
CREATE PROCEDURE usp_GetHoldersWithBalanceHigherThan @minSalary INT = 0
AS
     BEGIN
         SELECT ah.FirstName AS [First Name],
                ah.LastName AS [Last Name]
         FROM
(
    SELECT AccountHolderId AS AccountHolderId,
           SUM(Balance) AS SumBalance
    FROM Accounts
    GROUP BY AccountHolderId
) AS a
INNER JOIN AccountHolders AS ah ON ah.Id = a.AccountHolderId
                                   AND a.sumbalance > @minSalary;
     END;
GO
EXEC usp_GetHoldersWithBalanceHigherThan 5
SELECT AccountHolderId as AccountHolderId, SUM(Balance) as SumBalance
FROM Accounts 
group by AccountHolderId
select * from Accounts



  select * from AccountHolders

