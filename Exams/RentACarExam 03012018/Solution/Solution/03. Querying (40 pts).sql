/*	  Section 3. Querying (40 pts)
You need to start with a fresh dataset, so recreate your DB and import the sample data again (DataSet_RentACar.sql). 
05.	Showroom
*/
SELECT Manufacturer,
       Model
FROM models
ORDER BY Manufacturer,
         Id DESC;

/*	06.	Y Generation
Find all clients who are born between 1977 and 1994. Order the clients by First Name and then by Last Name in ascending order, and finally by Id (ascending).
Required columns:
?	First Name
?	Last Name
*/

SELECT FirstName,
       LastName
FROM Clients
WHERE DATEPART(YEAR, BirthDate) BETWEEN 1977 AND 1994
ORDER BY FirstName,
         LastName,
         Id;

/*	07.	Spacious Office
Select all offices which have a parking lot with more than 25 places. Order them by their Town’s name (ascending) and then by Office Id (ascending).
Required columns:
?	TownName
?	OfficeName
?	ParkingPlaces
*/

SELECT t.Name AS TownName,
       o.Name AS OfficeName,
       o.ParkingPlaces
FROM Offices AS o
     JOIN Towns AS t ON t.Id = o.TownId
WHERE o.ParkingPlaces > 25
ORDER BY t.Name,
         o.Id;

 /*08.	Available Vehicles
Show all available vehicles. (A vehicle is not available if it is reserved for an order and is not turned back yet)
Required columns:
?	Model
?	Seats
?	Mileage
Order the results by Mileage (ascending), then by the Model’s number of seats (descending) and finally by Model Id (ascending).
*/

SELECT m.Model,
       m.Seats,
       v.Mileage
FROM Vehicles AS v
     LEFT JOIN Orders AS o ON o.VehicleId = v.Id
     JOIN Models AS m ON m.Id = v.ModelId
WHERE o.ReturnDate IS NULL
ORDER BY v.Mileage,
         m.Seats DESC,
         v.ModelId;
SELECT *
FROM Orders
WHERE Vehicles = 34;

select VehicleId from orders  

/*	09.	Offices per Town
Select all towns and show the total number of offices per each town.
Required columns:
?	TownName
?	OfficesNumber
Order the results by OfficesNumber descending and then by TownName ascending.
*/


SELECT t.Name AS TownName,
       COUNT(*)
FROM Offices AS o
     JOIN Towns AS t ON t.Id = o.TownId
GROUP BY t.Id,
         t.name
ORDER BY COUNT(*) DESC,
         TownName;

/*	010.	Buyers Best Choice 
Select all vehicle models and show how many times each of them have been ordered.
Required columns:
?	Manufacturer
?	Model
?	TimesOrdered
Order by total TimesOrdered descending, then by Manufacturer descending and then by Model (ascending).
*/


SELECT m.Manufacturer,
       m.Model,
       isnull(COUNT(o.VehicleId), 0) AS TimesOrdered
FROM Vehicles AS v
     FULL JOIN Orders AS o ON v.Id = o.VehicleId
     JOIN Models AS m ON m.id = v.ModelId
GROUP BY m.id,
         m.Model,
         m.Manufacturer
ORDER BY TimesOrdered DESC,
         m.Manufacturer DESC,
         m.Model;

/*11.	Kinda Person
Select the clients who have placed an order and print their most frequent choice of vehicle’s class. If a client’s most frequent choice is equally spread over different vehicle classes show all the choices on separate lines.
Required columns:
?	Names - Clients first and last name separated by space
?	Class - Most frequent class choice
Order them by client’s Names, then by Class and then by Client Id (all in ascending order).
*/

SELECT Names,
       Class
FROM
(
    SELECT c.Id,
           c.firstName+' '+c.lastName AS Names,
           m.class,
           DENSE_RANK() OVER(PARTITION BY c.id ORDER BY COUNT(m.class) DESC) AS [Rank]
    FROM Clients AS c
         JOIN Orders AS o ON o.ClientId = c.Id
         JOIN Vehicles AS v ON v.Id = o.VehicleId
         JOIN Models AS m ON m.id = v.ModelId
    GROUP BY c.id,
             c.FirstName,
             c.LastName,
             m.Class
) AS sorted
WHERE sorted.Rank = 1
ORDER BY Names;

 /*		12.	Age Groups Revenue
Show the clients who have placed an order distributed in age groups according to the year they are born in:
?	from 1970 until 1979 - labeled “70’s”
?	from 1980 until 1989 - labeled “80’s”
?	from 1990 until 1999 - labeled “90’s”
?	all clients who doesn’t fall in none of the above groups should be put in the group “Others”
For each group show the Revenue (sum of bills paid) and the average driven mileage.
Order the results by Age Group (ascending).
Required columns:
?	Age Group
?	Revenue
?	AverageMileage
*/
  select AgeGroup, sum(bill), avg(TotalMileage) from (
SELECT case 
when DATEPART(YEAR,c.BirthDate) between 1970 and 1979
then '70''s'
when DATEPART(YEAR,c.BirthDate) between 1980 and 1989
then '80''s'
when DATEPART(YEAR,c.BirthDate) between 1990 and 1999
then '90''s'
else 'Others'
end as [AgeGroup],
sum(o.bill) as bill, o.TotalMileage
FROM Clients AS c
    left JOIN Orders AS o ON o.ClientId = c.Id
group by  BirthDate,TotalMileage	
) as tab 
group by tab.AgeGroup
order by AgeGroup

/*		13.	Consumption in Mind
Select the seven most ordered vehicle models. Group them by manufacturers and show only these who have average fuel consumption between 5 and 15.
Required columns:
?	Manufacturer 
?	AverageConsumption 
Order them by Manufacturer alphabetically and then by AverageConsumption ascending.
*/


SELECT  Manufacturer,
             AVG(Consumption) AS AverageConsumption
FROM Models
WHERE Consumption BETWEEN 5 AND 15 and Id  in(
	 select top 7 m.Id from orders as o 
 join Vehicles as v on v.Id = o.VehicleId
 join Models as m on m.Id = v.ModelId
 group by m.Id
 order by COUNT(o.VehicleId)  desc
) 
GROUP BY Manufacturer
ORDER BY Manufacturer,
         AverageConsumption; 

/*		14.	Debt Hunter
Select the clients who have placed an order with invalid credit card. Show only the first two clients per town with the biggest Bill. An order is invalid when the card’s validity date is before the collection date.
Order them by Town’s Name alphabetically, then by Bill Amount (descending) and then by Client Id (ascending).
Required columns:
?	Names
?	Email
?	Bill
?	Town
*/

SELECT tab.FirstName+' '+tab.LastName AS CategoryName,
       tab.Email AS Email,
       tab.Bill AS Bill,
       tab.Name AS Town
FROM
(
    SELECT c.Id,
           c.FirstName,
           c.LastName,
           c.Email,
           o.Bill,
           t.Name,
           DENSE_RANK() OVER(PARTITION BY t.name ORDER BY(o.bill) DESC) AS [Rank]
    FROM Clients AS c
         JOIN Orders AS o ON o.ClientId = c.Id
         JOIN Towns AS t ON t.id = o.TownId
    WHERE c.CardValidity < o.CollectionDate
          AND bill IS NOT NULL
    GROUP BY t.Name,
             o.Bill,
             c.Id,
             c.Email,
             c.FirstName,
             c.LastName
) AS tab
WHERE Rank <= 2
ORDER BY Town,
         bill,
         tab.id;

/*		15.	Town Statistics
Select all towns and show the distribution of the placed orders between male and female clients in percentages.
Required columns:
?	TownName
?	MalePercent
?	FemalePercent
Order them by TownName alphabetically and then by Town Id ascending.
*/
  go
CREATE FUNCTION dbo.ufn_GetMalePercents
(@townId INT
)
RETURNS INT
AS
     BEGIN
         DECLARE @countPersons INT=
(
    SELECT COUNT(*)
    FROM Towns AS t
         JOIN Orders AS o ON o.TownId = t.Id
         JOIN Clients AS c ON c.id = o.ClientId
    WHERE t.Id = @townId
);
         DECLARE @sexCount INT;
         SET @sexCount =
(
    SELECT COUNT(*)
    FROM Towns AS t
         JOIN Orders AS o ON o.TownId = t.Id
         JOIN Clients AS c ON c.id = o.ClientId
    WHERE t.Id = @townId
          AND c.Gender = 'M'
);
         IF(@sexCount = 0)
             BEGIN
                 RETURN 0;
             END;
         DECLARE @percent INT;
         SET @percent = FLOOR((@sexCount * 100) / @countPersons);
         RETURN @percent;
     END;

CREATE  FUNCTION dbo.ufn_GetFemalePercents
(@townId INT
)
RETURNS INT
AS
     BEGIN
         DECLARE @countPersons INT=
(
    SELECT COUNT(*)
    FROM Towns AS t
         JOIN Orders AS o ON o.TownId = t.Id
         JOIN Clients AS c ON c.id = o.ClientId
    WHERE t.Id = @townId
);
         DECLARE @sexCount INT;
         SET @sexCount =
(
    SELECT COUNT(*)
    FROM Towns AS t
         JOIN Orders AS o ON o.TownId = t.Id
         JOIN Clients AS c ON c.id = o.ClientId
    WHERE t.Id = @townId
          AND c.Gender = 'F'
);
         IF(@sexCount = 0)
             BEGIN
                 RETURN 0;
             END;
         DECLARE @percent INT;
         SET @percent = FLOOR((@sexCount * 100) / @countPersons);
         RETURN @percent;
     END;
SELECT 
       t.Name,
      case 
	  when dbo.ufn_GetMalePercents(t.Id) =0
	  then null 
	  else dbo.ufn_GetMalePercents(t.Id)end as MalePercent,
      case 
	  when dbo.ufn_GetFemalePercents(t.Id) =0
	  then null
	  else  dbo.ufn_GetFemalePercents(t.Id) 
	  end as FemalePercent
FROM Towns AS t
ORDER BY t.Name,
         t.Id;


 /*		17.	Find My Ride
Create a user defined function with the name udf_CheckForVehicle(@townName, @seatsNumber) that receives a town’s name and a seats number and checks if there is any vehicle with the given seats at an office of the given town.
•	If there is a vehicle print the output in the following format: “OfficeName - Model”.
•	If there is no vehicle found print the following message: “NO SUCH VEHICLE FOUND”
•	If there is more than one vehicle available order the results by office name ascending and return the first one
Parameters:
?	Town’s name
?	Seats number
*/

create function udf_CheckForVehicle(@townName, @seatsNumber) 


		
		 