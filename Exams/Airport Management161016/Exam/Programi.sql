use Airport
/*Task 1: Review Registering Procedure
Write a procedure – “usp_SubmitReview”, which registers a review in the CustomerReviews table. The procedure should accept the following parameters as input:
•	CustomerID
•	ReviewContent
•	ReviewGrade
•	AirlineName
You can assume that the CustomerID , will always be valid, and existent in the database.
If there is no airline with the given name, raise an error – ‘Airline does not exist.’
If no error has been raised, insert the review into the table, with the Airline’s ID. 
*/
go
CREATE PROCEDURE usp_SubmitReview @CustomerID    INT,
                                  @ReviewContent VARCHAR(255),
                                  @ReviewGrade   INT,
                                  @AirlineName   VARCHAR(30)
AS
    BEGIN TRANSACTION;
        DECLARE @AirlineId INT=
(
    SELECT AirlineID
    FROM Airlines
    WHERE AirlineName = @AirlineName
);
        IF(@AirlineId IS NULL)
            BEGIN;
                THROW 50001, 'Airline does not exist.', 1;
                ROLLBACK;
            END;
        IF(@ReviewGrade <= 0
           OR @ReviewGrade >= 10)
            BEGIN
                ROLLBACK;
            END;
            ELSE
            BEGIN
                INSERT INTO CustomerReviews
(ReviewContent,
 ReviewGrade,
 AirlineID,
 CustomerID
)
                VALUES
(@ReviewContent,
 @ReviewGrade,
 @AirlineId,
 @CustomerID
);
                COMMIT;
            END;

 go

/*Task 2: Ticket Purchase Procedure
Write a procedure – “usp_PurchaseTicket”, which registers a ticket in the Tickets table, to a customer that has purchased it, taking from his balance in the CustomerBankAccounts table, 
the provided ticket price. The procedure should accept the following parameters as input:
•	CustomerID
•	FlightID
•	TicketPrice
•	Class
•	Seat
You can assume that the CustomerID , FlightID, Class and Seat will always be valid, and existent in the database.
If the ticket price is greater than the customer’s bank account balance, raise an error ‘Insufficient bank account balance for ticket purchase.’
If no error has been raised, insert the ticket into the table Tickets, and reduce the customer’s bank account balance with the ticket price’s value.
All input parameters will be given in a valid format. Numeric data will be given as numbers, text as text etc.
  */

  go

Create proc usp_PurchaseTicket @CustomerID int,
		@FlightID int,
		@TicketPrice numeric(8,2),
		@Class varchar(6),
		@Seat varchar(5)
		as 
		begin transaction
 update [CustomerBankAccounts]
		 set Balance -=@TicketPrice
		 where CustomerID = @CustomerID

		Declare @Balance numeric(10,2) =(Select Balance from 
		CustomerBankAccounts where CustomerID =@CustomerID)

		if(@Balance<0 or @Balance is null)
		begin 
		rollback;
		throw 50001,'Insufficient bank account balance for ticket purchase.',1;
		return; 
		end

		declare @TicketId int = isnull((Select max(TicketID) from Tickets ),0)+1

		insert into Tickets	Values(@TicketId,@TicketPrice,@Class,@Seat,@CustomerID,@FlightID)
		commit

/*Section 5 (BONUS): Update Trigger
AMS has given you one final task because you are really good. They have already given you full control over their database.
 You have been tasked to create a table ArrivedFlights, and a trigger, which comes in action every time a flight’s status, is updated to ‘Arrived’, and only in that case…
  In all other cases the update should function normally.
The table should hold basic data about the flight, but also the amount of passengers.
The table should have the following columns:
*/

CREATE TABLE ArrivedFlights
(FlightID    INT
 PRIMARY KEY IDENTITY,
 ArrivalTime DATETIME NOT NULL,
 Origin      VARCHAR(50) NOT NULL,
 Destination VARCHAR(50) NOT NULL,
 Passengers  INT NOT NULL,
 CONSTRAINT CHK_Passengers CHECK(Passengers > 0)
);
	   go
CREATE TRIGGER TR_ArrivedFlights ON Flights
FOR UPDATE
AS
     INSERT INTO ArrivedFlights
(FlightId,
 ArrivalTime,
 Origin,
 Destination,
 Passengers
)
            SELECT FlightID,
                   ArrivalTime,
                   orig.AirportName,
                   dest.AirportName,
(
    SELECT COUNT(*)
    FROM Tickets
    WHERE FlightID = i.FlightID
) AS Passangers
            FROM inserted AS i
                 JOIN Airports AS orig ON orig.AirportID = i.OriginAirportID
                 JOIN Airports AS dest ON dest.AirportID = i.DestinationAirportID
            WHERE Status = 'Arrived';
		