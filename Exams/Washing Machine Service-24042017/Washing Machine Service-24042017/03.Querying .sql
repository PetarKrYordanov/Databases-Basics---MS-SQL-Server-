use wms
/*	Section 3. Querying (45 pts)
You need to start with a fresh dataset, so run the Data.sql script again. 
It includes a section that will delete all records and replace them with the starting set, so you don’t need to drop your database.
5.	Clients by Name
Select all clients ordered by last name (ascending) then by client ID (ascending). 
Required columns:
•	First Name
•	Last Name
•	Phone
*/

SELECT firstname,
       lastname,
       phone
FROM clients
ORDER BY lastname,
         clientid;

 /*6.	Job Status
Find all active jobs (that aren’t Finished) and display their status and issue date. 
Order by issue date and by job ID (both ascending).
Required columns:
•	Status
•	Issue Date
*/	  

  select Status,IssueDate  from Jobs
  where status in ('Pending', 'In Progress')
  order by IssueDate,JobId

 /*7.	Mechanic Assignments
Select all mechanics with their jobs. Include job status and issue date.
 Order by mechanic Id, issue date, job Id (all ascending).
Required columns:
•	Mechanic Full Name
•	Job Status
•	Job Issue Date
*/

SELECT CONCAT(m.firstname, ' ', m.lastname) AS [Mechanic Full Name],
       j.Status,
       j.IssueDate
FROM Mechanics AS m
     JOIN Jobs AS j ON j.MechanicId = m.MechanicId
ORDER BY m.MechanicId,
         j.IssueDate,
         j.JobId;

 /*8.	Current Clients
Select the names of all clients with active jobs (not Finished).
 Include the status of the job and how many days it’s been since it was submitted. Assume the current date is 24 April 2017.
  Order results by time length (descending) and by client ID (ascending).
Required columns:
•	Client Full Name
•	Days going – how many days have passed since the issuing
•	Status
*/															  
SELECT Concat(c.firstname, ' ', c.lastname) AS [Client Full Name],
       DATEDIFF(DAY, IssueDate, '20170424') AS [Days going],
       Status
FROM Clients AS c
     JOIN Jobs AS j ON j.ClientId = c.ClientId
                       AND j.Status IN('Pending', 'In Progress')
ORDER BY [Days going] DESC,
         c.ClientId;

/*9.	Mechanic Performance
Select all mechanics and the average time they take to finish their assigned jobs.
 Calculate the average as an integer. Order results by mechanic ID (ascending).
Required columns:
•	Mechanic Full Name
•	Average Days – average number of days the machanic took to finish the job
*/
SELECT CONCAT(m.FirstName, ' ', m.LastName) AS [Mechanic Full Name],
       av.avga AS [Average Days]
FROM
(
    SELECT m.MechanicId,
           AVG(DATEDIFF(day, j.issuedate, j.finishdate)) AS avga
    FROM Mechanics AS m
         JOIN Jobs AS j ON j.MechanicId = m.MechanicId
                           AND j.Status = 'Finished'
    GROUP BY m.MechanicId
) AS av
JOIN Mechanics AS m ON av.MechanicId = m.MechanicId
ORDER BY m.MechanicId;

/*10.	Hard Earners
Select the first 3 mechanics who have more than 1 active job (not Finished). Order them by number of jobs (descending) and by mechanic ID (ascending).
Required columns:
•	Mechanic Full Name
•	Number of Jobs
*/
SELECT cONCAT(m.FirstName, ' ', m.LastName) AS [Mechanic Full Name],
       aggJobs.jobCount AS [Number of Jobs]
FROM
(
    SELECT TOP 3 MechanicId,
                 COUNT(jobid) AS jobCount
    FROM Jobs
    WHERE status IN('Pending', 'In Progress')
    AND MechanicId IS NOT NULL
    GROUP BY MechanicId
    ORDER BY jobCount DESC
) AS aggJobs
JOIN Mechanics AS m ON m.MechanicId = aggJobs.MechanicId
WHERE aggJobs.jobCount > 1
ORDER BY aggJobs.jobCount DESC,
         m.MechanicId;

/*11.	Available Mechanics
Select all mechanics without active jobs (include mechanics which don’t have any job assigned or all of their jobs are finished).
 Order by ID (ascending).
Required columns:
•	Mechanic Full Name
*/

SELECT cONCAT(m.FirstName, ' ', m.LastName) AS [Mechanic Full Name]
FROM Mechanics AS m
     LEFT JOIN Jobs AS j ON j.MechanicId = m.MechanicId
                            AND j.Status = 'In Progress'
WHERE JobId IS NULL;  

/*12.	Parts Cost
Display the total cost of all parts ordered during the last three weeks. Assume the current date is 24 April 2017.
Required columns:
•	Parts Total Cost
*/

SELECT ISNULL(SUM(p.Price * op.Quantity), 0) AS [Parts Total]
FROM Parts AS P
     JOIN OrderParts AS op ON op.PartId = p.PartId
     JOIN Orders AS o ON o.OrderId = op.OrderId
WHERE o.IssueDate > (DATEADD(WEEK, -3, '2017/04/24'));


/*13.	Past Expenses
Select all finished jobs and the total cost of all parts that were ordered for them. Sort by total cost of parts ordered (descending)
 and by job ID (ascending).
Required columns:
•	Job ID
•	Total Parts Cost
*/

SELECT j.JobId,
       ISNULL(SUM(op.Quantity * p.Price), 0) AS Total
FROM Parts AS p
     FULL JOIN OrderParts AS op ON op.PartId = p.PartId
     FULL JOIN Orders AS o ON o.OrderId = op.OrderId
     FULL JOIN Jobs AS j ON j.JobId = o.JobId
WHERE Status = 'Finished'
GROUP BY j.JobId
ORDER BY Total DESC,
         j.JobId;

/*14.	Model Repair Time
Select all models with the average time it took to service, out of all the times it was repaired. 
Calculate the average as an integer value. Order the results by average service time ascending.
Required columns:
•	Model ID
•	Name
•	Average Service Time – average number of days it took to finish the job; note the word 'days' attached at the end!
*/

SELECT m.ModelId,
       m.Name,
       CAST(AVG(DATEDIFF(day, j.IssueDate, j.FinishDate)) AS VARCHAR(10))+' '+'days' AS [Average Service Time]
FROM models AS m
     JOIN Jobs AS j ON j.ModelId = m.ModelId
GROUP BY m.ModelId,
         m.Name
ORDER BY AVG(DATEDIFF(DAY, j.IssueDate, j.FinishDate));

 /*15.	Faultiest Model
Find the model that breaks the most (has the highest number of jobs associated with it).
 Include the cost of parts ordered for it. If there are more than one models that were serviced the same number of times, list them all.
Required columns:
•	Name
•	Times Serviced – number of assiciated jobs
•	Parts Total – cost of all parts ordered for the jobs
*/

SELECT TOP 1 WITH TIES m.Name,
                       COUNT(*) AS [Times Serviced],
(
    SELECT ISNULL(SUM(p.Price * op.Quantity), 0)
    FROM Jobs AS j
         JOIN Orders AS o ON O.JobId = j.JobId
         JOIN OrderParts AS op ON op.OrderId = o.OrderId
         JOIN Parts AS p ON p.[PartId] = op.PartId
    WHERE j.ModelId = m.ModelId
) AS [Parts Total]
FROM Models AS m
     JOIN Jobs AS j ON j.ModelId = m.ModelId
GROUP BY m.ModelId,
         m.Name
ORDER BY [Times Serviced] DESC;

/*	16.	Missing Parts
List all parts that are needed for active jobs (not Finished) without sufficient quantity in stock and in pending orders 
(the sum of parts in stock and parts ordered is less than the required quantity). Order them by part ID (ascending).
Required columns:
•	Part ID
•	Description
•	Required – number of parts required for active jobs
•	In Stock – how many of the part are currently in stock
•	Ordered – how many of the parts are expected to be delivered
 (associated with order that is not Delivered)
*/

SELECT p.PartId,
       p.Description,
       SUM(pn.quantity) AS Required,
       AVG(p.stockQty) AS [In Stock],
       ISNULL(SUM(op.quantity), 0) AS Ordered
FROM Parts AS p
     JOIN PartsNeeded AS pn ON p.PartId = pn.PartId
     JOIN Jobs AS j ON j.JobId = pn.JobId
     LEFT JOIN Orders AS o ON o.OrderId = j.JobId
     LEFT JOIN OrderParts AS op ON op.OrderId = o.OrderId
WHERE j.Status <> 'Finished'
GROUP BY p.PartId,
         p.Description
HAVING SUM(pn.Quantity) > AVG(p.StockQty)
ORDER BY p.PartId;




