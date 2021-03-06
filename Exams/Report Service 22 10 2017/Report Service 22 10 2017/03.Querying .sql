/*Section 3. Querying (40 pts)
You need to start with a fresh dataset, so recreate your DB and import the sample data again (DataSet_ReportService.sql). 
If not specified the ordering will be ascending.
5.	Users by Age
Select all Usernames with their age ordered by age (ascending) then by username (descending). 
Required columns:
?	Username
?	Age
*/

SELECT Username,
       Age
FROM Users
ORDER BY age,
         Username DESC;

/*6.	Unassigned Reports
Find all reports that don�t have an assigned employee. Order the results by open date in ascending order, then by description (ascending).
Required columns:
?	Description
?	OpenDate
*/

SELECT Description,
       OpenDate
FROM Reports
WHERE EmployeeId IS NULL
ORDER BY OpenDate,
         Description;

/*7.	Employees & Reports
Select only employees who have an assigned report and show all reports of each found employee. 
Show the open date column in the format �yyyy-MM-dd�. Order them by employee id (ascending) then by open date (ascending) and then by report Id (again ascending).
Required columns:
?	FirstName
?	LastName
?	Description
?	OpenDate
*/

SELECT e.FirstName,
       e.LastName,
       r.Description,
       FORMAT(r.OpenDate, 'yyyy-MM-dd')
-- CONCAT(datepart(year,r.OpenDate),'-',DATEPART(month,r.OpenDate),'-',DATEPART(day,r.OpenDate))
FROM Reports AS r
     JOIN Employees AS e ON e.id = r.EmployeeId
ORDER BY e.id,
         r.OpenDate,
         r.Id;

/*8.	Most reported Category
Select ALL categories and order them by the number of reports per category in descending order and then alphabetically by name.
Required columns:
?	CategoryName
?	ReportsNumber
*/

SELECT c.Name AS CategoryName,
       COUNT(*) AS ReportsNumber
FROM Categories AS c
     JOIN Reports AS r ON r.CategoryId = c.Id
GROUP BY c.Name
ORDER BY ReportsNumber desc, c.Name;

/*9.	Employees in Category
Select ALL categories and the number of employees in each category and order them alphabetically by category name.
Required columns:
?	CategoryName
?	Employees Number
*/

SELECT c.Name AS CategoryName,
       COUNT(*) AS [Employees Number]
FROM Categories AS c
     JOIN Employees AS e ON e.DepartmentId = c.DepartmentId
GROUP BY c.Name
ORDER BY c.Name;

/*10.	Users per Employee 
Select all employees and show how many unique users each of them have served to.
Required columns:
?	Employee�s name - Full name consisting of FirstName and LastName and a space between them 
?	User�s number
Order by Users Number descending and then by Name ascending.
*/

SELECT distinct e.FirstName+' '+e.LastName AS [Employee�s name],
       COUNT(r.UserId) AS [User�s number]
FROM Reports AS r
    right JOIN Employees AS e ON r.EmployeeId = e.Id
GROUP BY e.FirstName+' '+e.LastName
ORDER BY [User�s number] DESC,
         [Employee�s name];

 /*11.	Emergency Patrol
Select all reports which satisfy all the following criteria:
?	are not closed yet (they don�t have a CloseDate)
?	the description is longer than 20 symbols and the word �str� is mentioned anywhere
?	are assigned to one of the following departments: �Infrastructure�, �Emergency�, �Roads Maintenance�
Order the results by OpenDate (ascending), then by Reporter�s Email (ascending) and then by Report Id (ascending).
Required columns:
?	OpenDate
?	Description
?	Reporter Email
*/

SELECT r.OpenDate,
       r.Description,
       u.Email
FROM Reports AS r
     JOIN Users AS u ON u.Id = r.UserId
     JOIN Categories AS c ON c.Id = r.CategoryId
     JOIN Departments AS d ON d.Id = c.DepartmentId
WHERE r.CloseDate IS NULL
      AND LEN(r.description) > 20
      AND r.Description LIKE '%str%'
      AND c.DepartmentId IN(1, 4, 5)
ORDER BY r.OpenDate,
         u.Email,
         r.Id;

 /*12.	Birthday Report
Select all categories in which users have submitted a report on their birthday. Order them by name alphabetically.
Required columns:
?	Category Name
*/

SELECT DISTINCT
       c.Name
FROM Reports AS r
     JOIN Users AS u ON r.UserId = u.Id
                        AND DATEPART(DAY, OpenDate) = DATEPART(day, u.BirthDate)
                        AND DATEPART(MONTH, OpenDate) = DATEPART(MONTH, u.BirthDate)
     JOIN Categories AS c ON c.Id = r.CategoryId
ORDER BY c.Name;

/*13.	Numbers Coincidence
Select all unique usernames which:
?	starts with a digit and have reported in a category with id equal to the digit
OR
?	ends with a digit and have reported in a category with id equal to the digit
Required columns:
?	Username
Order them alphabetically.
*/
 SELECT DISTINCT
       Username
FROM
(
    SELECT u.Id AS userId,
           c.Id AS catId,
           u.Username
    FROM Users AS u
         JOIN Reports AS r ON r.UserId = u.Id
         JOIN Categories AS c ON c.Id = r.CategoryId
    WHERE Username LIKE '[0-9]%'
          AND CAST(LEFT(u.Username, 1) AS INT) = c.Id
    UNION ALL
    SELECT u.Id AS userId,
           c.Id AS catId,
           u.Username
    FROM Users AS u
         JOIN Reports AS r ON r.UserId = u.Id
         JOIN Categories AS c ON c.Id = r.CategoryId
    WHERE Username LIKE '%[0-9]'
          AND CAST(RIGHT(u.Username, 1) AS INT) = c.Id
) aall
ORDER BY Username;

/*14.	Open/Closed Statistics
Select all employees who have at least one assigned closed or open report through year 2016 and their total sum.
 Open reports don�t have a CloseDate. Reports that have been opened before 2016 but were closed in 2016 are counted as closed only!
Order by Name (ascending), and then by employee Id
Required columns:
?	Name - name - Full name consisting of FirstName and LastName and a space between them
?	Closed /Open reports number
  */
SELECT ISNULL(openReport.Name, ClosedReport.Name) AS [Name1],
       CONCAT(ISNULL(ClosedReport.ClosedReportCount, 0), '/', ISNULL(openReport.OpenReportCount, 0) + ISNULL(ClosedReport.ClosedReportCount, 0))
FROM
(
    SELECT e.Id AS eId,
           CONCAT(e.firstname, ' ', e.lastname) AS [Name],
           COUNT(*) AS OpenReportCount
    FROM Reports AS r
         JOIN Employees AS e ON e.Id = r.EmployeeId
                                AND r.CloseDate IS NULL
                                AND r.OpenDate > '20160101'
                                AND YEAR(r.opendate) < 2017
    GROUP BY CONCAT(e.firstname, ' ', e.lastname),
             e.Id
) openReport
FULL JOIN
(
    SELECT e.Id AS eId,
           CONCAT(e.firstname, ' ', e.lastname) AS [Name],
           isnull(COUNT(r.Id), 0) AS ClosedReportCount
    FROM Reports AS r
         JOIN Employees AS e ON e.Id = r.EmployeeId
                                AND r.CloseDate IS NOT NULL
                                AND r.OpenDate > '20160101'
                                AND YEAR(r.opendate) < 2017
    GROUP BY CONCAT(e.firstname, ' ', e.lastname),
             e.Id
) AS ClosedReport ON openReport.Name = ClosedReport.Name
ORDER BY Name1 ASC,
         ISNULL(ClosedReport.eId, openReport.eId);

/*15.	Average Closing Time
Select all departments that have been reported in and the average time for closing a report for each department rounded to the closest integer part. 
If there is no information (e.g. none closed reports) about any department fill in the Average Duration column �no info�.
Required columns:
?	Department Name 
?	Average Duration - in days
*/

SELECT d.Name,
       isnull(CAST(AVG(DATEDIFF(day, r.OpenDate, CloseDate)) AS VARCHAR(10)), 'no info') AS [Aevrage Duration]
FROM Departments AS d
     JOIN Categories AS c ON c.DepartmentId = d.Id
     LEFT JOIN Reports AS r ON r.CategoryId = c.Id
                               AND r.CloseDate IS NOT NULL
GROUP BY d.Name
ORDER BY d.Name;

/*16.	Favorite Categories
Select all departments with their categories where users have submitted a report. 
Show the distribution of reports among the categories of each department in percentages without decimal part.
Required columns:
?	Department Name 
?	Category Name
?	Percentage
Order them by department name, then by category name and then by percentage (all in ascending order).
*/
