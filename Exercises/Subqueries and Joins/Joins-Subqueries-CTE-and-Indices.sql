--Problem 1
use SoftUni

SELECT TOP 5 EmployeeID,
             JobTitle,
             E.AddressID,
             A.AddressText
FROM Employees AS E
     INNER JOIN Addresses AS A ON A.AddressID = E.AddressID
ORDER BY E.AddressID;

--Problem 2
SELECT TOP 50 FirstName,
              LastName,
              t.Name,
              a.AddressText
FROM Employees AS e
     INNER JOIN Addresses AS a ON a.AddressID = e.AddressID
     INNER JOIN Towns AS t ON t.TownID = a.TownID
ORDER BY FirstName,
         LastName;

--Problem 3
SELECT EmployeeID,
       FirstName,
       LastName,
       d.Name
FROM Employees AS e
     INNER JOIN Departments AS d ON d.DepartmentID = e.DepartmentID
WHERE d.Name = 'Sales';

--Problem 4
SELECT TOP 5 e.EmployeeID,
             e.FirstName,
             e.Salary,
             d.Name
FROM Employees AS e
     INNER JOIN Departments AS d ON d.DepartmentID = e.DepartmentID
WHERE e.Salary > 15000
ORDER BY d.DepartmentID;

--Problem 5			  
SELECT TOP 3 E.EmployeeID,
             E.FirstName
FROM Employees AS E
     LEFT JOIN EmployeesProjects AS EP ON EP.EmployeeID = E.EmployeeID
WHERE EP.ProjectID IS NULL
ORDER BY EmployeeID; 

--Problem 6
SELECT e.FirstName,
       e.LastName,
       e.HireDate,
       d.Name AS DeptName
FROM Employees AS e
     JOIN Departments AS d ON d.DepartmentID = e.DepartmentID
WHERE d.Name IN('Finance', 'Sales')
     AND e.HireDate > '01.01.1999'
ORDER BY HireDate;

--Problem 7
SELECT TOP 5 e.EmployeeID,
             e.FirstName,
             p.Name
FROM Employees AS e
     JOIN EmployeesProjects AS ep ON ep.EmployeeID = e.EmployeeID
     JOIN Projects AS p ON p.ProjectID = ep.ProjectID
WHERE p.StartDate > '08/13/2002'
      AND p.EndDate IS NULL
ORDER BY EmployeeID;

--Problem 8
SELECT ep.EmployeeID,
       e.FirstName,
       CASE
           WHEN p.StartDate > '2005'
           THEN NULL
           ELSE p.Name
       END AS ProjectName
FROM EmployeesProjects AS ep
     JOIN Employees AS e ON e.EmployeeID = ep.EmployeeID
     RIGHT JOIN Projects AS p ON p.ProjectID = ep.ProjectID
WHERE e.EmployeeID = 24;

--Problem 9
SELECT e.EmployeeID,
       e.FirstName,
       em.EmployeeID,
       em.FirstName
FROM Employees AS e
     INNER JOIN Employees AS em ON em.EmployeeID = e.ManagerID
WHERE e.ManagerID IN(3, 7)
ORDER BY e.EmployeeID;

--Problem 10
SELECT TOP 50 e.EmployeeID,
              e.FirstName+' '+e.LastName AS EmployeeName,
              em.FirstName+' '+em.LastName AS ManagerName,
              d.Name AS DepartmentName
FROM Employees AS e
     INNER JOIN Employees AS em ON em.EmployeeID = e.ManagerID
     INNER JOIN Departments AS d ON d.DepartmentID = e.DepartmentID
ORDER BY e.EmployeeID;

--Problem 11 Interesting different results !!!

 select top 1 * from 
(
SELECT AVG(salary)	as avgs
FROM Employees
GROUP BY Employees.DepartmentID
 ) as tab
order by avgs

--Problem 12 
use Geography

SELECT C.CountryCode,
       m.MountainRange,
       p.PeakName,
       p.Elevation
FROM Countries AS C
     JOIN MountainsCountries AS MC ON mc.CountryCode = c.CountryCode
     JOIN Mountains AS m ON m.Id = mc.MountainId
     JOIN Peaks AS p ON p.MountainId = m.Id
WHERE p.Elevation > 2835
      AND c.CountryName = 'Bulgaria'
ORDER BY p.Elevation DESC;

--Problem 13
SELECT c.CountryCode,
       COUNT(mc.MountainId)
FROM Countries AS c
     LEFT OUTER JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
GROUP BY mc.CountryCode,
         c.CountryCode,
         c.CountryName
HAVING c.CountryName IN('Bulgaria', 'Russia', 'United States');

--Problem 14 
SELECT TOP 5 c.CountryName,
             r.RiverName
FROM Countries AS c
     LEFT OUTER JOIN CountriesRivers AS cr ON cr.CountryCode = c.CountryCode
     LEFT OUTER JOIN Rivers AS r ON r.Id = cr.RiverId
WHERE c.ContinentCode =
(
    SELECT ContinentCode
    FROM Continents
    WHERE ContinentName = 'Africa'
)
ORDER BY c.CountryName;

--Problem 15
SELECT ranked.ContinentCode,
       ranked.CurrencyCode,
       ranked.CurrencyUsage
FROM
(
    SELECT gbc.ContinentCode,
           gbc.CurrencyCode,
           gbc.CurrencyUsage,
           DENSE_RANK() OVER(PARTITION BY gbc.ContinentCode ORDER BY gbc.CurrencyUsage DESC) AS UsageRank
    FROM
    (
        SELECT ContinentCode,
               CurrencyCode,
               COUNT(CurrencyCode) AS CurrencyUsage
        FROM Countries
        GROUP BY
		 ContinentCode,
                 CurrencyCode
        HAVING COUNT(CurrencyCode) > 1
    ) AS gbc
) AS ranked
WHERE ranked.UsageRank = 1
ORDER BY ranked.ContinentCode; 

--Problem 16

   select count(CountryCode) as CountryCode 
 from Countries
 where 	CountryCode  not in (select CountryCode from MountainsCountries)

 --Problem 17

SELECT SORTED.CountryName,
       SORTED.HighestPeakElevation,
       RIVERS.LongestRiverLength
FROM
(
    SELECT TOP 5 c.CountryName,
                 MAX(p.Elevation) AS HighestPeakElevation
    FROM MountainsCountries AS mc
         JOIN Countries AS c ON c.CountryCode = mc.CountryCode
         JOIN Mountains AS m ON m.Id = mc.MountainId
         JOIN Peaks AS p ON p.MountainId = m.Id
    GROUP BY c.CountryName
    ORDER BY MAX(p.Elevation) DESC
) AS SORTED
JOIN
(
    SELECT C.CountryName,
           MAX(R.Length) AS LongestRiverLength
    FROM Countries AS c
         JOIN CountriesRivers AS CR ON CR.CountryCode = C.CountryCode
         JOIN Rivers AS R ON R.Id = CR.RiverId
    GROUP BY C.CountryName
) AS RIVERS ON RIVERS.CountryName = SORTED.CountryName;

--second solution
SELECT TOP (5) peaks.CountryName,
               peaks.Elevation AS HighestPeakElevation,
               rivers.Length AS LongestRiverLength
FROM
(
    SELECT c.CountryName,
           c.CountryCode,
           DENSE_RANK() OVER(PARTITION BY c.CountryName ORDER BY p.Elevation DESC) AS DescendingElevationRank,
           p.Elevation
    FROM Countries AS c
         FULL OUTER JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
         FULL OUTER JOIN Mountains AS m ON mc.MountainId = m.Id
         FULL OUTER JOIN Peaks AS p ON m.Id = p.MountainId
) AS peaks
FULL OUTER JOIN
(
    SELECT c.CountryName,
           c.CountryCode,
           DENSE_RANK() OVER(PARTITION BY c.CountryCode ORDER BY r.Length DESC) AS DescendingRiversLenghRank,
           r.Length
    FROM Countries AS c
         FULL OUTER JOIN CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
         FULL OUTER JOIN Rivers AS r ON cr.RiverId = r.Id
) AS rivers ON peaks.CountryCode = rivers.CountryCode
WHERE peaks.DescendingElevationRank = 1
      AND rivers.DescendingRiversLenghRank = 1
      AND (peaks.Elevation IS NOT NULL
           OR rivers.Length IS NOT NULL)
ORDER BY HighestPeakElevation DESC,
         LongestRiverLength DESC,
         CountryName; 
		  

--Problem 18
	  
SELECT TOP (5) jt.CountryName AS Country,
               ISNULL(jt.PeakName, '(no highest peak)') AS HighestPeakName,
               ISNULL(jt.Elevation, 0) AS HighestPeakElevation,
               ISNULL(jt.MountainRange, '(no mountain)') AS Mountain
FROM
(
    SELECT c.CountryName,
           DENSE_RANK() OVER(PARTITION BY c.CountryName ORDER BY p.Elevation DESC) AS PeakRank,
           p.PeakName,
           p.Elevation,
           m.MountainRange
    FROM Countries AS c
         LEFT JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
         LEFT JOIN Mountains AS m ON mc.MountainId = m.Id
         LEFT JOIN Peaks AS p ON m.Id = p.MountainId
) AS jt
WHERE jt.PeakRank = 1
ORDER BY jt.CountryName,
         jt.PeakName;

-- CASE solution

SELECT TOP (5) jt.CountryName AS Country,
               CASE
                   WHEN jt.PeakName IS NULL
                   THEN '(no highest peak)'
                   ELSE jt.PeakName
               END AS HighestPeakName,
               CASE
                   WHEN jt.Elevation IS NULL
                   THEN 0
                   ELSE jt.Elevation
               END AS HighestPeakElevation,
               CASE
                   WHEN jt.MountainRange IS NULL
                   THEN '(no mountain)'
                   ELSE jt.MountainRange
               END AS Mountain
FROM
(
    SELECT c.CountryName,
           DENSE_RANK() OVER(PARTITION BY c.CountryName ORDER BY p.Elevation DESC) AS PeakRank,
           p.PeakName,
           p.Elevation,
           m.MountainRange
    FROM Countries AS c
         LEFT JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
         LEFT JOIN Mountains AS m ON mc.MountainId = m.Id
         LEFT JOIN Peaks AS p ON m.Id = p.MountainId
) AS jt
WHERE jt.PeakRank = 1
ORDER BY jt.CountryName,
         jt.PeakName;
