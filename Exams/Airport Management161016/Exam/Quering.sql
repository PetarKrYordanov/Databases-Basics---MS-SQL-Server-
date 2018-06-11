USE Airport;

/*Task 1: Extract All Tickets
Extract from the database, all of the Tickets, taking only the Ticket’s ID, Price, Class and Seat. Sort the results ascending by TicketID.
*/

SELECT TicketiD,
       Price,
       Class,
       Seat
FROM tickets;

/*Task 2: Extract All Customers 
Extract from the database, all of the Customers, taking only the Customer’s ID, Full Name (First name + Last name separated by a single space) and Gender. Sort the results by alphabetical order of the full name, and as second criteria, sort them ascending by CustomerID.
*/

SELECT CustomerID,
       CONCAT(FirstName, ' ', LastName) AS FullName,
       Gender
FROM Customers
ORDER BY FullName,
         CustomerID;
		 
/*	Task 3: Extract Delayed Flights 
Extract from the database, all of the Flights, which have Status-‘Delayed’, taking only the Flight’s ID, DepartureTime and ArrivalTime. Sort the results ascending by FlightID
*/

SELECT FlightID,
       DepartureTime,
       ArrivalTime
FROM Flights
WHERE Status = 'Delayed'
ORDER BY FlightID;		

/*	Task 4: Extract Top 5 Most Highly Rated Airlines which have any Flights
Extract from the database, the top 5 airlines, in terms of highest rating, which have any flights, taking only the Airlines’ IDs and Airlines’ Names, Airlines’ Nationalities and Airlines’ Ratings. If two airlines have the same rating order them, ascending, by AIrlineID.
*/

SELECT DISTINCT TOP 5 a.AirlineId,
                      a.AirlineName,
                      a.Nationality,
                      a.Rating
FROM Airlines AS a
     JOIN Flights AS F ON f.AirlineID = a.AirlineID
ORDER BY Rating DESC,
         a.AirlineID;

/*	Task 5: Extract all Tickets with price below 5000, for First Class
Extract from the database, all tickets, which have price below 5000, and have class – ‘First´, taking the Tickets’ IDs, Flights’ Destination Airport Name, and Owning Customers’ Full Names (First name + Last name separated by a single space). Order the results, ascending, by TicketID.
*/

SELECT t.TicketID,
       a.AirportName AS Destination,
       CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName
FROM Tickets AS t
     JOIN Customers AS c ON c.CustomerID = t.CustomerID
     JOIN Flights AS f ON f.FlightID = t.FlightID
     JOIN Airports AS a ON f.DestinationAirportID = a.AirportID
WHERE t.Price < 5000
      AND t.Class = 'First'
ORDER BY t.TicketID;

/*	Task 6: Extract all Customers which are departing from their Home Town
Extract from the database, all of the Customers, which are departing from their Home Town, taking only the Customer’s ID, Full Name (First name + Last name separated by a single space) and Home Town Name. Order the results, ascending, by CustomerID.
*/

SELECT DISTINCT
       c.CustomerID,
       CONCAT(c.FirstName, ' ', c.LastName) AS FullName,
       t.TownName
FROM Flights AS f
     JOIN Airports AS a ON a.AirportID = f.OriginAirportID
     JOIN Tickets AS ti ON ti.FlightID = f.FlightID
     JOIN Customers AS c ON c.CustomerID = ti.CustomerID
     JOIN Towns AS t ON t.TownID = c.HomeTownID
WHERE c.HomeTownID = a.TownID;

/*	Task 7: Extract all Customers which will fly
Extract from the database all customers, which have bought tickets and the flights to their tickets have Status-‘Departing’, taking only the Customer’s ID, Full Name (First name + Last name separated by a single space) and Age. Order them Ascending by their Age. Assume that the current year is 2016. If two people have the same age, order them by CustomerID, ascending. 
*/

SELECT DISTINCT
       c.CustomerID,
       CONCAT(c.firstName, ' ', LastName) AS FullName,
       DATEDIFF(YEAR, c.DateOfBirth, '20160101') AS Age
FROM Customers AS c
     JOIN Tickets AS ti ON ti.CustomerID = c.CustomerID
     JOIN Flights AS f ON f.FlightID = ti.FlightID
WHERE f.Status = 'Departing'
ORDER BY Age,
         c.CustomerID;

/*	Task 8: Extract Top 3 Customers which have Delayed Flights
Extract from the database, the top 3 Customers, in terms of most expensive Ticket, which’s flights have Status- ‘Delayed’. Take the Customers’ IDs, Full Name (First name + Last name separated by a single space), Ticket Price and Flight Destination Airport Name.  If two tickets have the same price, order them, ascending, by CustomerID.
*/

SELECT TOP 3 c.CustomerID,
             CONCAT(c.firstname, ' ', c.lastname) AS FullName,
             t.Price,
             a.AirportName AS Destination
FROM Customers AS c
     JOIN Tickets AS t ON t.CustomerID = c.CustomerID
     JOIN Flights AS f ON f.FlightID = t.FlightID
                          AND f.Status = 'Delayed'
     JOIN Airports AS a ON a.AirportID = f.DestinationAirportID
ORDER BY t.Price DESC,
         c.CustomerID;

/*	Task 9: Extract the Last 5 Flights, which are departing.
Extract from the database, the last 5 Flights, in terms of departure time, which have a status of ‘Departing’, taking only the Flights’ IDs, Departure Time, Arrival Time, Origin and Destination Airport Names. 
You have to take the last 5 flights in terms of departure time, which means they must be ordered ascending by departure time in the first place. If two flights have the same departure time, order them by FlightID, ascending.
*/


SELECT f.FlightID,
       f.DepartureTime,
       f.ArrivalTime,
       ao.AirportName AS Origin,
       ad.AirportName AS Destination
FROM
(
    SELECT TOP 5 FlightID,
                 DepartureTime,
                 ArrivalTime,
                 OriginAirportID,
                 DestinationAirportID
    FROM Flights
    WHERE Status = 'Departing'
    ORDER BY DepartureTime DESC,
             FlightID
) AS f
LEFT JOIN Airports AS ao ON ao.AirportID = f.OriginAirportID
LEFT JOIN Airports AS ad ON ad.AirportID = f.DestinationAirportID
ORDER BY DepartureTime,
         FlightID;

/*	Task 10: Extract all Customers below 21 years, which have already flew at least once
Extract from the database, all customers which are below 21 years aged, and own a ticket to a flight, which has status – ‘Arrived’, taking their Customer’s ID, Full Name (First name + Last name separated by a single space), and Age. Order them by their Age in descending order.  Assume that the current year is 2016. If two persons have the same age, order them by CustomerID, ascending.
*/

SELECT DISTINCT
       c.CustomerID,
       CONCAT(c.firstName, ' ', LastName) AS FullName,
       DATEDIFF(YEAR, c.DateOfBirth, '20160101') AS Age
FROM Customers AS c
     JOIN Tickets AS t ON t.CustomerID = c.CustomerID
     JOIN Flights AS f ON f.FlightID = t.FlightID
                          AND f.Status = 'Arrived'
WHERE DATEDIFF(YEAR, c.DateOfBirth, '20160101') < 21
ORDER BY Age DESC,
         c.CustomerID;

/*
Task 11: Extract all Airports and the Count of People departing from them
Extract from the database, all airports that have any flights with Status-‘Departing’, and extract the count of people that have tickets for those flights. Take the Airports’ IDs, Airports’ Names, and Count of People as Passengers. Order the results by AirportID, ascending. The flights must have some people in them.
*/

SELECT f.OriginAirportID,
       a.AirportName,
       COUNT(*) AS Passengers
FROM Airports AS A
     JOIN Flights AS F ON F.OriginAirportID = A.AirportID
                          AND F.Status = 'Departing'
     JOIN Tickets AS t ON t.FlightID = f.FlightID
GROUP BY f.OriginAirportID,
         a.AirportName;





