use SoftUni
go
SELECT * FROM Departments

SELECT Name FROM Departments

SELECT * FROM Employees

SELECT FirstName, LastName, Salary FROM Employees

SELECT FirstName,MiddleName, LastName FROM Employees

SELECT (FirstName + '.' + LastName + '@softuni.bg') AS [Full Email Address] FROM Employees

SELECT DISTINCT Salary FROM Employees;

SELECT * FROM Employees 
WHERE [JobTitle] = 'Sales Representative'

SELECT FirstName, LastName, JobTitle FROM Employees
WHERE Salary BETWEEN 20000 AND 30000

SELECT (FirstName + ' ' + COALESCE( MiddleName, ' ')+ ' ' + LastName)
--(FirstName + ' ' + ISNULL( MiddleName, ' ')+ ' ' + LastName)
--(CONCAT(FirstName, ' ', MiddleName, ' ', LastName))
--FirstName + ' ' + MiddleName + ' ' + LastName
AS [Full Name] 
FROM Employees
WHERE Salary IN (25000,14000,12500, 23600)

SELECT FirstName, LastName from Employees 
WHERE ManagerID IS NULL

SELECT TOP 5 FirstName, LastName FROM Employees
ORDER BY Salary DESC

SELECT FirstName, LastName FROM Employees 
WHERE (Salary IN (SELECT TOP (5) Salary
FROM Employees
GROUP BY Salary
ORDER BY Salary DESC))
ORDER BY Salary DESC

SELECT FirstName, LastName FROM Employees
WHERE NOT DepartmentID =4 

SELECT * FROM Employees
	ORDER BY Salary DESC,
	FirstName,
	LastName DESC,
	MiddleName

CREATE VIEW V_EmployeesSalaries AS
SELECT FirstName, LastName, Salary
 FROM Employees
	
SELECT * FROM V_EmployeesSalaries

CREATE VIEW V_EmployeeNameJobTitle AS
SELECT CONCAT(FirstName, ' ', MiddleName, ' ', LastName) AS [Full Name],
 JobTitle as [Job Title]
FROM Employees
go
SELECT * FROM v_EmployeeNameJobTitle

SELECT DISTINCT JobTitle FROM Employees

SELECT TOP 10 * FROM Projects
ORDER BY StartDate, [Name] 

SELECT TOP 7 FirstName, LastName, HireDate FROM Employees
ORDER BY HireDate DESC

SELECT * FROM Departments
WHERE [NAME] IN 
('Engineering', 'Tool Design', 'Marketing', 'Information Services' )

UPDATE Employees
SET Salary *= 1.12
WHERE DepartmentID IN (1, 2, 4, 11)

use Geography
go

SELECT PeakName
FROM Peaks
ORDER BY PeakName

SELECT * FROM Countries

SELECT TOP 30 CountryName, [Population] 
FROM Countries
WHERE ContinentCode = 'EU'
ORDER BY [Population] DESC, CountryName

SELECT CountryName, CountryCode, 
CASE CurrencyCode
WHEN  'EUR' then 'Euro'
else 'Not Euro'
end as Currency
FROM Countries
ORDER BY CountryName

USE Diablo

SELECT [NAME]
FROM Characters
ORDER BY [NAME]
