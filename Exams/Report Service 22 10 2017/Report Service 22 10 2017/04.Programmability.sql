use ReportService
/*Section 4. Programmability (14 pts)
17.	Employee’s Load
Create a user defined function with the name udf_GetReportsCount(@employeeId, @statusId) that receives an employee’s Id and a status Id 
returns the sum of the reports he is assigned to with the given status.
Parameters:
?	Employee’s Id
?	Status Id
  */   GO

  CREATE FUNCTION udf_GetReportsCount
(@employeeId INT,
 @statusId   INT
)
RETURNS INT
AS
     BEGIN
         DECLARE @result INT=
(
    SELECT isnull(ISNULL(COUNT(r.Id), 0), 0)
    FROM Reports AS r
    WHERE r.EmployeeId = @employeeId
          AND r.StatusId = @statusId
    GROUP BY r.EmployeeId
);
         IF(@result IS NULL)
             BEGIN
                 SET @result = 0;
             END;
         RETURN @result;
     END;
GO
SELECT Id,
       FirstName,
       Lastname,
       dbo.udf_GetReportsCount(Id, 2) AS ReportsCount
FROM Employees
ORDER BY Id;

/*18.	Assign Employee
Create a user defined stored procedure with the name usp_AssignEmployeeToReport(@employeeId, @reportId)
 that receives an employee’s Id and a report’s Id and assigns the employee to the report only 
 if the department of the employee and the department of the report’s category are the same.
  If the assigning is not successful rollback any changes and throw an exception with message: “Employee doesn't belong to the appropriate department!”. 
Parameters:
?	Employee’s Id								 
?	Report’s Id
*/	GO

CREATE PROCEDURE usp_AssignEmployeeToReport @employeeId INT,
                                            @reportId   INT
AS
     BEGIN
         BEGIN TRAN;
         DECLARE @emplDepartmentID INT;
         SET @emplDepartmentID =
(
    SELECT DepartmentId
    FROM Employees
    WHERE Id = @employeeId
);
         DECLARE @categoryId INT=
(
    SELECT CategoryId
    FROM Reports
    WHERE id = @reportId
);
         DECLARE @reportDepartMentID INT=
(
    SELECT DepartmentId
    FROM Categories
    WHERE id = @categoryId
);
         UPDATE Reports
           SET
               EmployeeId = @employeeId
         WHERE id = @reportId;
         IF(@reportDepartMentID <> @emplDepartmentID
            AND @employeeId IS NOT NULL)
             BEGIN
                 ROLLBACK;
                 THROW 50001, 'Employee doesn''t belong to the appropriate department!', 1;
             END;
         COMMIT;
     END;



/*19.	Close Reports
Create a trigger which changes the StatusId to “completed” of each report after a CloseDate is entered for the report. 
*/	GO
										
CREATE TRIGGER TR_CompletedReports ON Reports
AFTER UPDATE
AS
     DECLARE @ReportId INT=
(
    SELECT i.Id
    FROM inserted AS i
    WHERE i.CloseDate IS NOT NULL
);
     DECLARE @StatusId INT=
(
    SELECT id
    FROM Status
    WHERE Label = 'completed'
);
     UPDATE Reports
       SET
           StatusId = @StatusId
     WHERE id = @ReportId;

 /*Section 5. Bonus (10 pts)
20.	Categories Revision
Select all categories which have reports with status “waiting” or “in progress” and show their total number in the 
column “Reports Number”. In the third column fill the main status type of  reports for the category 
(e.g. 2 reports with status “waiting” and 3 reports with status “in progress” result in value “in progress”). 
If they are equal just fill in “equal”. Order by category Name, then by Reports Number and then by Main Status.
Required columns:
?	Category Name
?	Reports Number
?	Main Status
*/

SELECT [Category Name],
       (WaitingCount + ProgresCount) AS [Reports Number],
       CASE
           WHEN Waitingcount > ProgresCount
           THEN 'waiting'
           WHEN Waitingcount = ProgresCount
           THEN 'equal'
           ELSE 'in progress'
       END AS [Main Status]
FROM
(
    SELECT isnull(wait.CatName, progress.CatName) AS [Category Name],
           ISNULL(wait.waitingCount, 0) AS WaitingCount,
           isnull(progress.inprogresCount, 0) AS ProgresCount
    FROM
(
    SELECT c.Name AS CatName,
           isnull(COUNT(*), 0) AS waitingCount
    FROM Categories AS c
         JOIN Reports AS r ON c.Id = r.CategoryId
         JOIN Status AS s ON s.Id = r.StatusId
                             AND s.Label = 'waiting'
    GROUP BY c.Name
) wait
FULL JOIN
(
    SELECT c.Name AS CatName,
           isnull(COUNT(*), 0) AS inprogresCount
    FROM Categories AS c
         JOIN Reports AS r ON c.Id = r.CategoryId
         JOIN Status AS s ON s.Id = r.StatusId
                             AND s.Label = 'in progress'
    GROUP BY c.Name
) AS progress ON progress.CatName = wait.CatName
) AS tab
ORDER BY tab.[Category Name];