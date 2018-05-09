USE Gringotts;
SELECT *
FROM WizzardDeposits;

--1
SELECT COUNT(id)
FROM WizzardDeposits;

--2
SELECT MAX(MagicWandSize) AS LongestMagicWand
FROM WizzardDeposits;

--3
SELECT DepositGroup,
       MAX(MagicWandSize) AS LongestMagicWand
FROM WizzardDeposits
GROUP BY DepositGroup;

 --4
SELECT e.depositGroup
FROM
(
    SELECT TOP (2) DepositGroup AS [depositGroup],
                   AVG(MagicWandSize) AS [minsum]
    FROM WizzardDeposits
    GROUP BY DepositGroup
    ORDER BY AVG(MagicWandSize)
) AS e;

 --5
SELECT DepositGroup,
       SUM(DepositAmount) AS [TotalSum]
FROM WizzardDeposits
GROUP BY DepositGroup;

--6
SELECT DepositGroup,
       SUM(DepositAmount) AS [TotalSum]
FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup;

--7
SELECT DepositGroup,
       SUM(DepositAmount) AS [TotalSum]
FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup
HAVING SUM(DepositAmount) < 150000
ORDER BY TotalSum DESC;

--8
SELECT DepositGroup,
       MagicWandCreator,
       MIN(DepositCharge) AS MinDepositCharge
FROM WizzardDeposits
GROUP BY DepositGroup,
         MagicWandCreator
ORDER BY MagicWandCreator,
         DepositGroup;

--9
SELECT CASE
           WHEN AGE BETWEEN 0 AND 10
           THEN '[0-10]'
           WHEN AGE BETWEEN 11 AND 20
           THEN '[11-20]'
           WHEN AGE BETWEEN 21 AND 30
           THEN '[21-30]'
           WHEN AGE BETWEEN 31 AND 40
           THEN '[31-40]'
           WHEN AGE BETWEEN 41 AND 50
           THEN '[41-50]'
           WHEN AGE BETWEEN 51 AND 60
           THEN '[51-60]'
           WHEN AGE >= 61
           THEN '[61+]'
       END AS AgeGroups,
       COUNT(*) AS WizzardCount
FROM WizzardDeposits
GROUP BY CASE
             WHEN AGE BETWEEN 0 AND 10
             THEN '[0-10]'
             WHEN AGE BETWEEN 11 AND 20
             THEN '[11-20]'
             WHEN AGE BETWEEN 21 AND 30
             THEN '[21-30]'
             WHEN AGE BETWEEN 31 AND 40
             THEN '[31-40]'
             WHEN AGE BETWEEN 41 AND 50
             THEN '[41-50]'
             WHEN AGE BETWEEN 51 AND 60
             THEN '[51-60]'
             WHEN AGE >= 61
             THEN '[61+]'
         END;
--10
SELECT DISTINCT
       LEFT(firstName, 1) AS FirstLetter
FROM WizzardDeposits
WHERE DepositGroup = 'Troll Chest'
ORDER BY FirstLetter;
--11
SELECT DepositGroup,
       IsDepositExpired,
       AVG(DepositInterest) AS AverageInterest
FROM WizzardDeposits
WHERE DepositStartDate > '01/01/1985'
GROUP BY DepositGroup,
         IsDepositExpired
ORDER BY DepositGroup DESC,
         IsDepositExpired;

--12
USE Gringotts;
SELECT FirstName,
       DepositAmount AS HostAmount,
       LEAD(firstName) OVER(ORDER BY id ASC) AS GuestName,
       LEAD(DepositAmount, 1) OVER(ORDER BY id ASC) AS GuestAmount,
       (depositAmount - LEAD(DepositAmount, 1) OVER(ORDER BY id ASC)) AS [Difference]
FROM WizzardDeposits;
SELECT SUM(Difference)
FROM
(
    SELECT(depositAmount - LEAD(DepositAmount) OVER(ORDER BY id ASC)) AS [Difference]
    FROM WizzardDeposits
) AS Diffs;

--13
USE SoftUni;
SELECT DepartmentID,
       SUM(salary) AS TotalSalary
FROM Employees
GROUP BY DepartmentID
ORDER BY DepartmentID;

--14
SELECT DepartmentId,
       MIN(salary) AS MinimumSalary
FROM Employees
WHERE DepartmentID IN(2, 5, 7)
AND HireDate > '01/01/2000'
GROUP BY DepartmentID;

--15
SELECT *
INTO NewTable
FROM Employees
WHERE Salary > 30000;
DELETE FROM NewTable
WHERE ManagerID = 42;
UPDATE NewTable
  SET
      Salary+=5000
WHERE DepartmentID = 1;
SELECT departmentid,
       AVG(salary)
FROM NewTable
GROUP BY DepartmentID;

--16
USE SoftUni;
SELECT DepartmentID,
       MAX(SALARY) AS MaxSalary
FROM Employees
GROUP BY DepartmentID
HAVING NOT MAX(Salary) BETWEEN 30000 AND 70000;

--17
SELECT COUNT(*)
FROM Employees
WHERE ManagerID IS NULL;

--18
SELECT DepartmentId,
       salary
FROM
(
    SELECT DepartmentID,
           Salary,
           DENSE_RANK() OVER(PARTITION BY departmentID ORDER BY Salary DESC) AS [Rank]
    FROM Employees
    GROUP BY DepartmentID,
             Salary
) AS RankedSalaries
WHERE rank = 3;

	
