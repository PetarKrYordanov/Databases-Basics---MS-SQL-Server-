use ReportService
/*Section 4. Programmability (14 pts)
17.	Employee’s Load
Create a user defined function with the name udf_GetReportsCount(@employeeId, @statusId) that receives an employee’s Id and a status Id 
returns the sum of the reports he is assigned to with the given status.
Parameters:
?	Employee’s Id
?	Status Id
  */   GO

  CREATE function udf_GetReportsCount(@employeeId int, @statusId int) 
  returns int
  as 
	begin
	  declare @result int = (select isnull(ISNULL(count(r.Id),0),0) from Reports as r
	   where r.EmployeeId = @employeeId	and r.StatusId = @statusId
	   group by r.EmployeeId )
	   IF (@result IS NULL)
	   BEGIN
		  SET @result = 0;
	   END
	   return @result;
	end

	GO
	SELECT Id, FirstName, Lastname, dbo.udf_GetReportsCount(Id, 2) AS ReportsCount
FROM Employees
ORDER BY Id

/*18.	Assign Employee
Create a user defined stored procedure with the name usp_AssignEmployeeToReport(@employeeId, @reportId)
 that receives an employee’s Id and a report’s Id and assigns the employee to the report only 
 if the department of the employee and the department of the report’s category are the same.
  If the assigning is not successful rollback any changes and throw an exception with message: “Employee doesn't belong to the appropriate department!”. 
Parameters:
?	Employee’s Id								 
?	Report’s Id
*/	GO


SELECT * FROM Reports WHERE id = 2

/*19.	Close Reports
Create a trigger which changes the StatusId to “completed” of each report after a CloseDate is entered for the report. 
*/	GO
										
Create trigger TR_CompletedReports on Reports after update
as
	declare @ReportId int= ( select i.Id from inserted	as i						
						where i.CloseDate is not null)
	declare @StatusId int= (select id from Status where Label = 'completed')
	update Reports
	set StatusId = @StatusId
	where id= @ReportId

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