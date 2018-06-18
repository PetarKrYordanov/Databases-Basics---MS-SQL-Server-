use RentACar
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

WITH NotReturned
     AS (
     SELECT VehicleId
     FROM Orders
     WHERE ReturnDate IS NULL)
     SELECT m.Model,
            m.Seats,
            v.Mileage
     FROM Vehicles AS v
          JOIN Models AS m ON m.Id = v.ModelId
     WHERE v.Id != ALL
(
    SELECT *
    FROM NotReturned
)
     ORDER BY v.Mileage ASC,
              m.Seats DESC,
              v.ModelId ASC;

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
SELECT AgeGroup,
       SUM(bill),
       AVG(TotalMileage)
FROM
(
    SELECT CASE
               WHEN DATEPART(YEAR, c.BirthDate) BETWEEN 1970 AND 1979
               THEN '70''s'
               WHEN DATEPART(YEAR, c.BirthDate) BETWEEN 1980 AND 1989
               THEN '80''s'
               WHEN DATEPART(YEAR, c.BirthDate) BETWEEN 1990 AND 1999
               THEN '90''s'
               ELSE 'Others'
           END AS [AgeGroup],
           SUM(o.bill) AS bill,
           o.TotalMileage
    FROM Clients AS c
         LEFT JOIN Orders AS o ON o.ClientId = c.Id
    GROUP BY BirthDate,
             TotalMileage
) AS tab
GROUP BY tab.AgeGroup
ORDER BY AgeGroup;

/*		13.	Consumption in Mind
Select the seven most ordered vehicle models. Group them by manufacturers and show only these who have average fuel consumption between 5 and 15.
Required columns:
?	Manufacturer 
?	AverageConsumption 
Order them by Manufacturer alphabetically and then by AverageConsumption ascending.
*/


SELECT Manufacturer,
       AVG(Consumption) AS AverageConsumption
FROM Models
WHERE Consumption BETWEEN 5 AND 15
      AND Id IN
(
    SELECT TOP 7 m.Id
    FROM orders AS o
         JOIN Vehicles AS v ON v.Id = o.VehicleId
         JOIN Models AS m ON m.Id = v.ModelId
    GROUP BY m.Id
    ORDER BY COUNT(o.VehicleId) DESC
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

SELECT ttt.Name,
       CASE
           WHEN MalePercent = '0'
           THEN NULL
           ELSE MalePercent
       END AS MalePercent,
       CASE
           WHEN ttt.FemalePercent = '0'
           THEN NULL
           ELSE FemalePercent
       END AS FemalePercent
FROM
(
    SELECT t.name,
           CAST((100*SUM(CASE
                             WHEN c.gender = 'M'
                             THEN 1
                             ELSE 0
                         END)/COUNT(*)) AS INT) AS MalePercent,
           CAST((100*SUM(CASE
                             WHEN c.gender = 'F'
                             THEN 1
                             ELSE 0
                         END)/COUNT(*)) AS VARCHAR(3)) AS FemalePercent
    FROM Orders AS o
         JOIN Towns AS t ON o.TownId = t.Id
         JOIN Clients AS c ON c.Id = o.ClientId
    GROUP BY t.name
) AS ttt;


/*16.	Home Sweet Home
Select all vehicles and show their current location:
•	If a vehicle has never been on a rent, it’s location should be labeled as “home”
?	If a vehicle has been turned back from rent to an office different from it’s home one - print the name of the town and the name of the office, 
it was turned back to in the following format - “TownName - OfficeName”
?	If a vehicle is rented and still not turned back, it’s location should be labeled as “on a rent”
Required columns:
?	Vehicle - print the manufacturer’s name and the model’s name in the following format - “Manufacturer - Model”
?	Location
Order them by vehicle alphabetically and then by vehicle Id (ascending).
*/
  WITH CTE_C (ReturnOfficeId, OfficeId, VehicleId, Manufacturer, Model)
AS
(
   SELECT W.ReturnOfficeId, W.OfficeId, W.Id, W.Manufacturer, W.Model
   FROM
    (SELECT DENSE_RANK() OVER(PARTITION BY V.Id ORDER BY O.CollectionDate DESC) AS [RANK], O.ReturnOfficeId, V.OfficeId, V.Id, M.Manufacturer, M.Model
    FROM Models AS M
    JOIN Vehicles AS V ON M.Id = V.ModelId
    LEFT JOIN Orders AS O ON O.VehicleId = V.Id) AS W
    WHERE W.RANK = 1
)
 
SELECT CONCAT(C.Manufacturer, ' - ', C.Model) AS [Vehicle],
       CASE
       WHEN (SELECT COUNT(*) FROM Orders WHERE VehicleId = C.VehicleId) = 0  OR C.OfficeId = C.ReturnOfficeId THEN 'home'
       WHEN  C.ReturnOfficeId IS NULL THEN 'on a rent'
       WHEN C.OfficeId <>  C.ReturnOfficeId  THEN (SELECT CONCAT([To].Name, ' - ', [Of].Name)
                                                                 FROM Offices AS [Of]
                                                                 JOIN Towns AS [To] ON [To].Id = [Of].TownId
                                                                 WHERE C.ReturnOfficeId = [Of].Id)
       END AS [Location]
FROM CTE_C AS C
ORDER BY Vehicle, C.VehicleId