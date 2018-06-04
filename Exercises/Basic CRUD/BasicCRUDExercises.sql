USE SoftUni;
GO

/**2.	Find All Information About Departments
Write a SQL query to find all available information about the Departments. Submit your query statements as Prepare DB & run queries.
*/

SELECT *
FROM Departments;

/**	3.	Find all Department Names
Write SQL query to find all Department names. Submit your query statements as Prepare DB & run queries.
**/

SELECT Name
FROM Departments;
SELECT *
FROM Employees;

/**		4.	Find Salary of Each Employee
Write SQL query to find the first name, last name and salary of each employee. Submit your query statements as Prepare DB & run queries.
**/

SELECT FirstName,
       LastName,
       Salary
FROM Employees;

/**		5.	Find Full Name of Each Employee
Write SQL query to find the first, middle and last name of each employee. Submit your query statements as Prepare DB & run queries.
*/

SELECT FirstName,
       MiddleName,
       LastName
FROM Employees;

/**		6.	Find Email Address of Each Employee
Write a SQL query to find the email address of each employee. (by his first and last name). Consider that the email domain is softuni.bg. Emails should look like “John.Doe@softuni.bg". The produced column should be named "Full Email Address". Submit your query statements as Prepare DB & run queries.
*/

SELECT(FirstName+'.'+LastName+'@softuni.bg') AS [Full Email Address]
FROM Employees;

/**		7.	Find All Different Employee’s Salaries
Write a SQL query to find all different employee’s salaries. Show only the salaries. Submit your query statements as Prepare DB & run queries.
*/

SELECT DISTINCT
       Salary
FROM Employees;

/**   8.	Find all Information About Employees
Write a SQL query to find all information about the employees whose job title is “Sales Representative”. Submit your query statements as Prepare DB & run queries.
**/

SELECT *
FROM Employees
WHERE [JobTitle] = 'Sales Representative';

/**		9.	Find Names of All Employees by Salary in Range
Write a SQL query to find the first name, last name and job title of all employees whose salary is in the range [20000, 30000]. Submit your query statements as Prepare DB & run queries.
*/

SELECT FirstName,
       LastName,
       JobTitle
FROM Employees
WHERE Salary BETWEEN 20000 AND 30000;

SELECT *
FROM Employees
WHERE Salary >= 20000
      AND salary <= 30000;

/**		10.	 Find Names of All Employees 
Write a SQL query to find the full name of all employees whose salary is 25000, 14000, 12500 or 23600. Full Name is combination of first, middle and last name (separated with single space) and they should be in one column called “Full Name”. Submit your query statements as Prepare DB & run queries.
*/

SELECT(FirstName+' '+COALESCE(MiddleName, ' ')+' '+LastName)
--(FirstName + ' ' + ISNULL( MiddleName, ' ')+ ' ' + LastName)
--(CONCAT(FirstName, ' ', MiddleName, ' ', LastName))
--FirstName + ' ' + MiddleName + ' ' + LastName
      AS [Full Name]
FROM Employees
WHERE Salary IN(25000, 14000, 12500, 23600);

/**		11.	 Find All Employees Without Manager
Write a SQL query to find first and last names about those employees that does not have a manager. Submit your query statements as Prepare DB & run queries.
*/

SELECT FirstName,
       LastName
FROM Employees
WHERE ManagerID IS NULL;

/**		12.	 Find All Employees with Salary More Than 50000
Write a SQL query to find first name, last name and salary of those employees who has salary more than 50000. Order them in decreasing order by salary. Submit your query statements as Prepare DB & run queries.
*/

SELECT FirstName,
       LastName,
       Salary
FROM Employees
WHERE Salary > 50000
ORDER BY Salary DESC;

/**		13.	 Find 5 Best Paid Employees.
Write SQL query to find first and last names about 5 best paid Employees ordered descending by their salary. Submit your query statements as Prepare DB & run queries.
*/

SELECT TOP 5 FirstName,
             LastName
FROM Employees
ORDER BY Salary DESC;
SELECT FirstName,
       LastName
FROM Employees
WHERE(Salary IN
(
    SELECT TOP (5) Salary
    FROM Employees
    GROUP BY Salary
    ORDER BY Salary DESC
))
ORDER BY Salary DESC;

/**		14.	Find All Employees Except Marketing
Write a SQL query to find the first and last names of all employees whose department ID is different from 4. Submit your query statements as Prepare DB & run queries.
*/

SELECT FirstName,
       LastName
FROM Employees
WHERE NOT DepartmentID = 4; 

/**		15.	Sort Employees Table
Write a SQL query to sort all records in the Employees table by the following criteria: 
•	First by salary in decreasing order
•	Then by first name alphabetically
•	Then by last name descending
•	Then by middle name alphabetically
Submit your query statements as Prepare DB & run queries.
*/

SELECT *
FROM Employees
ORDER BY Salary DESC,
         FirstName,
         LastName DESC,
         MiddleName;

/**		16.	 Create View Employees with Salaries
Write a SQL query to create a view V_EmployeesSalaries with first name, last name and salary for each employee. Submit your query statements as Run skeleton, run queries & check DB.
*/

CREATE VIEW V_EmployeesSalaries
AS
     SELECT FirstName,
            LastName,
            Salary
     FROM Employees;
SELECT *
FROM V_EmployeesSalaries;

/**		17.	Create View Employees with Job Titles
Write a SQL query to create view V_EmployeeNameJobTitle with full employee name and job title. When middle name is NULL replace it with empty string (‘’). Submit your query statements as Run skeleton, run queries & check DB.
*/

CREATE VIEW V_EmployeeNameJobTitle
AS
     SELECT CONCAT(FirstName, ' ', MiddleName, ' ', LastName) AS [Full Name],
            JobTitle AS [Job Title]
     FROM Employees;
GO
SELECT *
FROM v_EmployeeNameJobTitle;

/**		18.	 Distinct Job Titles
Write a SQL query to find all distinct job titles. Submit your query statements as Prepare DB & run queries.
*/

SELECT DISTINCT
       JobTitle
FROM Employees;

/**		19.	Find First 10 Started Projects
Write a SQL query to find first 10 started projects. Select all information about them and sort them by start date, then by name. Submit your query statements as Prepare DB & run queries.
*/

SELECT TOP 10 *
FROM Projects
ORDER BY StartDate,
         [Name]; 

/**		20.	 Last 7 Hired Employees
Write a SQL query to find last 7 hired employees. Select their first, last name and their hire date. Submit your query statements as Prepare DB & run queries.
*/

SELECT TOP 7 FirstName,
             LastName,
             HireDate
FROM Employees
ORDER BY HireDate DESC;

/**		21.	Increase Salaries
Write a SQL query to increase salaries of all employees that are in the Engineering, Tool Design, Marketing or Information Services department by 12%. Then select Salaries column from the Employees table. After that exercise restore your database to revert those changes. Submit your query statements as Prepare DB & run queries
*/

SELECT *
FROM Departments
WHERE [NAME] IN('Engineering', 'Tool Design', 'Marketing', 'Information Services');
UPDATE Employees
  SET
      Salary*=1.12
WHERE DepartmentID IN(1, 2, 4, 11);

SELECT Salary
FROM Employees;
USE Geography;
GO
 
/**		22.	 All Mountain Peaks
Display all mountain peaks in alphabetical order. Submit your query statements as Prepare DB & run queries.
*/

SELECT PeakName
FROM Peaks
ORDER BY PeakName;
SELECT *
FROM Countries;

/**		23.	 Biggest Countries by Population
Find the 30 biggest countries by population from Europe. Display the country name and population. Sort the results by population (from biggest to smallest), then by country alphabetically. Submit your query statements as Prepare DB & run queries.
*/

SELECT TOP 30 CountryName,
              [Population]
FROM Countries
WHERE ContinentCode = 'EU'
ORDER BY [Population] DESC,
         CountryName;

/**		24.	 *Countries and Currency (Euro / Not Euro)
Find all countries along with information about their currency. Display the country code, country name and information about its currency: either "Euro" or "Not Euro". Sort the results by country name alphabetically. Submit your query statements as Prepare DB & run queries.
*Hint: Use CASE … WHEN.
*/

SELECT CountryName,
       CountryCode,
       CASE CurrencyCode
           WHEN 'EUR'
           THEN 'Euro'
           ELSE 'Not Euro'
       END AS Currency
FROM Countries
ORDER BY CountryName;
USE Diablo;

/**		25.	 All Diablo Characters
Display all characters in alphabetical order. Submit your query statements as Prepare DB & run queries.
*/

SELECT [NAME]
FROM Characters
ORDER BY [NAME];
