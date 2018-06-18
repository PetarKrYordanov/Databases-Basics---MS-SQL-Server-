use RentACar

/*17.	Find My Ride
Create a user defined function with the name udf_CheckForVehicle(@townName, @seatsNumber) that
 receives a town’s name and a seats number and checks if there is any vehicle with the given seats at an office of the given town.
•	If there is a vehicle print the output in the following format: “OfficeName - Model”.
•	If there is no vehicle found print the following message: “NO SUCH VEHICLE FOUND”
•	If there is more than one vehicle available order the results by office name ascending and return the first one
Parameters:
?	Town’s name
?	Seats number
*/
GO
 
CREATE FUNCTION udf_CheckForVehicle
(@townName    VARCHAR(50),
 @seatsNumber INT
)
RETURNS VARCHAR(MAX)
AS
     BEGIN
         DECLARE @result VARCHAR(MAX)=
(
    SELECT TOP 1 CONCAT(o.Name, ' - ', m.Model)
    FROM Towns AS t
         JOIN Offices AS o ON t.Id = o.TownId
         JOIN Vehicles AS v ON v.OfficeId = o.Id
         JOIN models AS m ON m.Id = v.ModelId
    WHERE t.Id IN
(
    SELECT Id
    FROM Towns
    WHERE Name = @townName
)
          AND m.Seats = @seatsNumber
    ORDER BY o.Name
);
         IF(@result IS NULL)
             BEGIN
                 SET @result = 'NO SUCH VEHICLE FOUND';
             END;
         RETURN @result;
     END;

	GO
	SELECT dbo.udf_CheckForVehicle ('La Escondida', 9) 
	GO

/*	18.	Move a Vehicle
Create a user defined stored procedure with the name usp_MoveVehicle(@vehicleId, @officeId)
 that receives a vehicle’s Id and an office’s Id and changes the vehicle’s OfficeId 
 to the given value only if there are free ParkingPlaces in the given office.
  If the move is not successful rollback any changes and throw an exception with message:
   “Not enough room in this office!”.
Parameters:
?	Vehicle’s Id
?	Office’s Id
*/

CREATE PROCEDURE usp_MoveVehicle
(@vehicleId INT,
 @officeId  INT
)
AS
     BEGIN
         BEGIN TRANSACTION;
         DECLARE @curentVehicleCount INT=
(
    SELECT COUNT(*)
    FROM Offices AS O
         JOIN Vehicles AS V ON V.OfficeId = O.Id
    WHERE O.Id = @officeId
);
         IF(@curentVehicleCount >=
(
    SELECT ParkingPlaces
    FROM Offices
    WHERE id = @officeId
))
             BEGIN
                 RAISERROR('Not enough room in this office!', 16, 1);
                 ROLLBACK;
             END;
         UPDATE Vehicles
           SET
               OfficeId = @officeId
         WHERE id = @vehicleId;
         COMMIT;
     END;
	 go

BEGIN TRAN;
EXEC usp_MoveVehicle  7, 32;
SELECT OfficeId
FROM Vehicles WHERE Id = 7;
ROLLBACK;
 go

 /*19.	Move the Tally
Create a trigger which adds the Total Mileage from an order to the Mileage of the vehicle
 from that order. 
IMPORTANT: Total Mileage should be added to the Mileage of the vehicle 
only when it is given a value for the first time i.e. 
the trigger should not get fired if the Total Mileage in an order is edited after it is already
 having a value.
   */

create Trigger TR_AddMileage on orders after update
 as
	declare @startMileage int = (select TotalMileage from deleted)
	 if (@startMileage is not null)
	  begin
		declare @vehicleId int = (Select VehicleId from inserted)
		declare @mileage int = (Select TotalMileage from inserted)

		update Vehicles 
		set Mileage +=@mileage
		where id = @vehicleId
	  end


go

begin 
tran
		 UPDATE Orders
SET
TotalMileage = 100
WHERE Id = 16;

SELECT Mileage FROM Vehicles
WHERE Id = 25


rollback
