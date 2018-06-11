

CREATE TABLE Flights
(FlightID             INT,
 DepartureTime        DATETIME NOT NULL,
 ArrivalTime          DATETIME NOT NULL,
 Status               VARCHAR(9) DEFAULT 'Cancelled'
                                 CHECK(Status = 'Departing'
                                       OR Status = 'Delayed'
                                       OR Status = 'Arrived'
                                       OR Status = 'Cancelled'),
 OriginAirportID      INT,
 DestinationAirportID INT,
 AirlineID            INT NOT NULL,
 CONSTRAINT PK_Flights PRIMARY KEY(FlightID),
 CONSTRAINT FK_Flights_Airports_Origin FOREIGN KEY(OriginAirportID) REFERENCES Airports(AirportID),
 CONSTRAINT FK_Flights_Airports_Destination FOREIGN KEY(DestinationAirportID) REFERENCES Airports(AirportID),
 CONSTRAINT FK_Flights_Airlines FOREIGN KEY(AirlineID) REFERENCES Airlines(AirlineID)
);
CREATE TABLE Tickets
(TicketID   INT,
 Price      DECIMAL(8, 2) NOT NULL,
 Class      VARCHAR(6) NOT NULL
                       CHECK(Class = 'First'
                             OR Class = 'Second'
                             OR Class = 'Third'),
 Seat       VARCHAR(5) NOT NULL,
 CustomerID INT NOT NULL,
 FlightID   INT NOT NULL,
 CONSTRAINT PK_Tickets PRIMARY KEY(TicketID),
 CONSTRAINT FK_Tickets_Customers FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID),
 CONSTRAINT FK_Tickets_Flights FOREIGN KEY(FlightID) REFERENCES Flights(FlightID)
);
GO


 Create table CustomerReviews (
 ReviewID int primary key ,
 ReviewContent varchar(255) not null,
  ReviewGrade int check(ReviewGrade between 0 and 10),
 AirlineID int check(AirlineID>0) ,
 CustomerID int check(CustomerID>0),
 CONSTRAINT FK_CustomerReviews_AIRLINES 
 fOREIGN KEY(AirlineID) References Airlines(AirlineID),
 CONStraint FK_CustomerReviews_Customers 
 Foreign key(CustomerID) References Customers(customerID)
)

create table CustomerBankAccounts (
 AccountID int primary key,
 AccountNumber varchar(10) not null unique,
 Balance decimal(10,2) not null,
 CustomerID int,
 Constraint FK_CustomerBankAccounts_Customers Foreign key(CustomerID) References Customers(CustomerID)
)


 insert into	CustomerReviews Values
(1,' Me is very happy. Me likey this airline. Me good.', 10, 1, 1),
(2,' Ja, Ja, Ja... Ja, Gut, Gut, Ja Gut! Sehr Gut!', 10, 1, 4),
(3,' Meh...', 5, 4, 3),
(4,' Well Ive seen better, but Ive certainly seen a lot worse...', 7, 3, 5)

insert into	CustomerBankAccounts Values
( 1, '123456790', 2569.23, 1),
( 2, '18ABC23672', 14004568.23, 2),
( 3, 'F0RG0100N3', 19345.20, 5)