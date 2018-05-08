   USE SoftUni

--Problem 1
   SELECT FirstName, LastName FROM Employees
   WHERE FirstName LIKE'SA%'

--Problem 2
   SELECT FirstName, LastName FROM Employees
   WHERE LastName LIKE'%EI%'

--Problem 3
   SELECT FirstName FROM Employees
   WHERE DepartmentID IN (3, 10) AND
   HireDate BETWEEN   '1995' AND '2006'

--Problem 4
     SELECT FirstName, LastName FROM Employees
   WHERE  CHARINDEX('engineer',JobTitle) = 0

--Problem 5
SELECT [Name] FROM Towns
 WHERE DATALENGTH([Name])=5 OR DATALENGTH([Name])=6
ORDER BY [Name]

--Problem 6
SELECT TownID, [Name] FROM Towns
WHERE [Name] LIKE '[MKBE]%'
ORDER BY [Name]

--Problem 7
SELECT TownID, [Name] FROM Towns
WHERE [Name] LIKE '[^rbd]%'
ORDER BY [Name]

--Problem 8
CREATE VIEW
V_EmployeesHiredAfter2000 AS
SELECT FirstName,LastName FROM Employees
WHERE HireDate > CONVERT(DATE, '2001-01-01')
SELECT * FROM V_EmployeesHiredAfter2000

--Problem 9
SELECT FirstName, LastName FROM Employees
WHERE LEN(LastName) = 5

USE Geography

--Problem 10
 SELECT CountryName, IsoCode FROM Countries
 WHERE ISNULL( (LEN(CountryName) - LEN(REPLACE(CountryName,'A',''))),1)>=3
ORDER BY IsoCode

--Problem 11
SELECT 
 Peaks.PeakName,
 Rivers.RiverName,
 LOWER(CONCAT(LEFT(Peaks.PeakName, LEN(Peaks.PeakName)-1), Rivers.RiverName)) AS MIX
 FROM Peaks
	JOIN Rivers ON RIGHT(Peaks.PeakName,1) = LEFT(Rivers.RiverName,1)
	ORDER BY MIX

USE Diablo
--Problem 12
SELECT TOP 50 [Name], FORMAT(CAST(Start as date),'yyyy-MM-dd') AS [Start]
 FROM Games
WHERE DATEPART(YEAR, [Start]) BETWEEN '2011' AND '2012'
ORDER BY [Start], [Name]

--Problem 13
SELECT Username, 
SUBSTRING(Email, CHARINDEX('@',Email)+1, 50) AS [Email Provider]
 FROM Users
 ORDER BY [Email Provider],
 Username

 --Problem 14
 SELECT Username, IpAddress AS [IP Address]
 FROM Users
 WHERE IpAddress LIKE '___.1%.%.___'
 ORDER BY Username

--Problem 15
 SELECT [Name] AS [Game],
	CASE
		WHEN DATEPART(HOUR, Start) BETWEEN 0 AND 11
		THEN 'Morning'
		when DATEPART(HOUR, Start) BETWEEN 12 AND 17
		THEN 'Afternoon'
		WHEN DATEPART(HOUR,Start) BETWEEN 18 AND 23
		THEN 'Evening'
		ELSE 'N\A'
		END AS [Part of the Day],
	CASE
		WHEN Duration<=3
		THEN 'Extra Short'
		WHEN Duration BETWEEN 4 AND 6
		THEN 'Short'
		WHEN Duration>6
		THEN 'Long'
		WHEN Duration IS NULL
		THEN 'Extra Long'
		ELSE 'Error - must be unreachable case'
		END AS [Duration]
	FROM Games
	ORDER BY Name,
	[Duration], [Part of the Day];

--Problem 16
	USE Orders

	SELECT ProductName,
	OrderDate,
	DATEADD(DAY,3,OrderDate) AS [Pay Due],
	DATEADD(MONTH, 1, OrderDate) AS [Deliver Due]
	FROM Orders
