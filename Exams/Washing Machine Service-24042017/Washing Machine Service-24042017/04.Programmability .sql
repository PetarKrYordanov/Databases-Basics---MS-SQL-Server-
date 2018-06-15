/*	Section 4. Programmability (15 pts)
17.	Cost of Order
Create a user defined function (udf_GetCost) that receives a job’s ID and returns the total cost of all parts that were ordered for it. Return 0 if there are no orders.
Parameters:
•	JobId
 */

CREATE FUNCTION udf_GetCost
(@JobId INT
)
RETURNS DECIMAL(6, 2)
AS
     BEGIN
         DECLARE @result DECIMAL(6, 2);
         SET @result =
(
    SELECT isnull(SUM(op.Quantity * p.Price), 0)
    FROM Jobs AS j
         JOIN Orders AS o ON o.JobId = j.JobId
         JOIN OrderParts AS op ON op.OrderId = o.OrderId
         JOIN Parts AS p ON p.PartId = op.PartId
    WHERE j.JobId = @JobId
    GROUP BY j.JobId
);
         IF @result IS NULL
             RETURN 0;
         RETURN @result;
     END;
go
select dbo.udf_GetCost(2)

/*	18.	Place Order
Your task is to create a user defined procedure (usp_PlaceOrder) which accepts job ID, part serial number and 
  quantity and creates an order with the specified parameters. 
  If an order already exists for the given job that and the order is not issued (order’s issue date is NULL), add the new product to it.
   If the part is already listed in the order, add the quantity to the existing one.
When a new order is created, set it’s IssueDate to NULL.
Limitations:
•	An order cannot be placed for a job that is Finished; error message ID 50011 "This job is not active!"
•	The quantity cannot be zero or negative; error message ID 50012 "Part quantity must be more than zero!"
•	The job with given ID must exist in the database; error message ID 50013 "Job not found!"
•	The part with given serial number must exist in the database ID 50014 "Part not found!"
If any of the requirements aren’t met, rollback any changes to the database you’ve made and throw an exception with the appropriate message and state 1. 
Parameters:
•	JobId
•	Part Serial Number
•	Quantity
*/
		go
CREATE PROCEDURE usp_PlaceOrder @JobId        INT,
                                @SerialNumber VARCHAR(50),
                                @Quantity     INT
AS
     BEGIN
         BEGIN TRAN;
         DECLARE @Status VARCHAR(11)=
(
    SELECT status
    FROM Jobs
    WHERE JobId = @JobId
);
         IF(@Status = 'Finished')
             BEGIN;
                 THROW 50011, 'This job is not active!', 1;
                 ROLLBACK;
             END;
         IF(@Quantity <= 0)
             BEGIN ;
                 THROW 50012, 'Part quantity must be more than zero!', 1;
                 ROLLBACK;
             END;
         DECLARE @id INT;
         SET @id =
(
    SELECT JobId
    FROM Jobs
    WHERE JobId = @JobId
);
         IF(@id IS NULL)
             BEGIN;
                 THROW 50013, 'Job not found!', 1;
                 ROLLBACK;
             END;
         DECLARE @partId INT;
         SET @partId =
(
    SELECT PartId
    FROM Parts
    WHERE SerialNumber = @SerialNumber
);
         IF(@partId IS NULL)
             BEGIN;
                 THROW 50014, 'Part not found!', 1;
                 ROLLBACK;
             END;
         DECLARE @orderId INT;
         SET @orderId =
(
    SELECT o.OrderId
    FROM Parts AS p
         JOIN OrderParts AS op ON p.PartId = op.PartId
         JOIN Orders AS o ON o.OrderId = op.OrderId
         JOIN Jobs AS j ON j.JobId = o.JobId
    WHERE j.JobId = @JobId
          AND p.PartId = @partId
          AND o.IssueDate IS NULL
);
         IF(@orderId IS NULL)
             BEGIN
                 INSERT INTO Orders
(JobId,
 IssueDate
)
                 VALUES
(@JobId,
 NULL
);
                 INSERT INTO OrderParts
(OrderId,
 PartId,
 Quantity
)
                 VALUES
(IDENT_CURRENT('Orders'),
 @partId,
 @Quantity
);
             END;
             ELSE
             BEGIN
                 DECLARE @orderPartExist INT;
                 SET @orderPartExist =
(
    SELECT COUNT(*)
    FROM OrderParts
    WHERE OrderId = @orderId
          AND PartId = @partId
);
                 IF(@orderPartExist IS NULL)
                     BEGIN
                         INSERT INTO OrderParts
(OrderId,
 PartId,
 Quantity
)
                         VALUES
(@orderId,
 @partId,
 @Quantity
);
                     END;
                     ELSE
                     BEGIN
                         UPDATE OrderParts
                           SET
                               Quantity+=@Quantity
                         WHERE OrderId = @orderId
                               AND PartId = @partId;
                     END;
             END;
         COMMIT;
     END;

	  DECLARE @err_msg AS NVARCHAR(MAX);
BEGIN TRY
  EXEC usp_PlaceOrder 1, 'ZeroQuantity', 0
END TRY

BEGIN CATCH
  SET @err_msg = ERROR_MESSAGE();
  SELECT @err_msg
END CATCH

 /*19.	Detect Delivery
Create a trigger that detects when an order’s delivery status is changed from False to True which adds the quantities of all ordered parts to their stock quantity value (Qty).
*/
go
CREATE TRIGGER TR_DetectDelivery ON Orders
AFTER UPDATE
AS
     BEGIN
         DECLARE @oldStatus INT=
(
    SELECT Delivered
    FROM deleted
);
         DECLARE @newStatus INT=
(
    SELECT Delivered
    FROM inserted
);
         IF(@oldStatus = 0
            AND @newStatus = 1)
             BEGIN
                 UPDATE Parts
                   SET
                       StockQty+=op.Quantity
                 FROM Parts AS p
                      JOIN OrderParts AS op ON op.PartId = p.PartId
                      JOIN Orders AS o ON o.OrderId = op.OrderId
                      JOIN inserted AS i ON i.OrderId = o.OrderId
                      JOIN deleted AS d ON d.OrderId = o.OrderId;
             END;
     END;

	go
	begin tran
	UPDATE Orders
SET Delivered = 1
WHERE OrderId = 21
SELECT StockQty FROM Parts
WHERE PartId = 11

	rollback

/*20.	Vendor Preference
List all mechanics and their preference for each vendor as a percentage of parts’ quantities they ordered for their jobs.
 Express the percentage as an integer value. Order them by mechanic’s full name (ascending), number of parts from each vendor (descending) and by vendor name (ascending).
Required columns:
•	Mechanic Full Name
•	Vendor Name
•	Parts ordered from vendor
•	Preference for Vendor (percantage of parts out of all parts count ordered by the mechanic)
*/

WITH CTE_Parts
     AS (
     SELECT m.MechanicId,
            v.VendorId,
            SUM(op.Quantity) AS VendorItems
     FROM Mechanics AS m
          JOIN Jobs AS j ON j.MechanicId = m.MechanicId
          JOIN Orders AS o ON o.JobId = j.JobId
          JOIN OrderParts AS op ON op.OrderId = o.OrderId
          JOIN Parts AS p ON p.PartId = op.PartId
          JOIN Vendors AS v ON v.VendorId = P.VendorId
     GROUP BY m.MechanicId,
              v.VendorId)
     SELECT CONCAT(m.FirstName, ' ', m.LastName) AS [Mechanic],
            v.Name AS [Vendor],
            c.VendorItems AS [Parts],
            CAST(CAST(CAST(VendorItems AS DECIMAL(6, 2)) /
(
    SELECT SUM(VendorItems)
    FROM CTE_Parts
    WHERE MechanicId = c.MechanicId
) * 100 AS INT) AS VARCHAR(MAX))+'%' AS Preference
     FROM CTE_Parts AS c
          JOIN Mechanics AS m ON m.MechanicId = c.MechanicId
          JOIN Vendors AS v ON v.VendorId = c.VendorId
     ORDER BY Mechanic,
              Parts DESC,
              Vendor;
