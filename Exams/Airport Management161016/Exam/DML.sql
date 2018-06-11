  use Airport
-- Insert  Task 1
begin tran
INSERT INTO Flights
VALUES
(
  1, '2016-10-13 06:00 AM', '2016-10-13 10:00 AM', 'Delayed', 1, 4, 1),
(
  2, '2016-10-12 12:00 PM', '2016-10-12 12:01 PM', 'Departing', 1, 3, 2),
(
  3, '2016-10-14 03:00 PM', '2016-10-20 04:00 AM', 'Delayed', 4, 2, 4),
(
  4, '2016-10-12 01:24 PM', '2016-10-12 4:31 PM', 'Departing', 3, 1, 3),
(
  5, '2016-10-12 08:11 AM', '2016-10-12 11:22 PM', 'Departing', 4, 1, 1),
(
  6, '1995-06-21 12:30 PM', '1995-06-22 08:30 PM', 'Arrived', 2, 3, 5),
(
  7, '2016-10-12 11:34 PM', '2016-10-13 03:00 AM', 'Departing', 2, 4, 2),
(
  8, '2016-11-11 01:00 PM', '2016-11-12 10:00 PM', 'Delayed', 4, 3, 1),
(
  9, '2015-10-01 12:00 PM', '2015-12-01 01:00 AM', 'Arrived', 1, 2, 1),
(
  10, '2016-10-12 07:30 PM', '2016-10-13 12:30 PM', 'Departing', 2, 1, 7);  


  insert into Tickets Values
  (1,3000.00,'First','233-A',3,8),
(2,1799.90,'Second','123-D',1,1),
(3,1200.50,'Second','12-Z',2,5),
(4,410.68,'Third','45-Q',2,8),
(5,560.00,'Third','201-R',4,6),
(6,2100.00,'Second','13-T',1,9),
(7,5500.00,'First','98-O',2,7)

  select * from flights
rollback
-- Task 2
UPDATE flights
  SET
      AirlineID = 1
WHERE status = 'Arrived';

--Task 3

update tickets 
set Price *=1.5
where FlightID in (1,5,8,9)


update Tickets 
set Price *=1.5
where FlightID in (
select FlightID from Flights where AirlineID = 
(select top 1 AirlineID from Airlines  order by Rating desc))

--Task 4: Table Creation
 begin transaction
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

rollback

--Task 5: Fill the new Tables with Data

insert into	CustomerReviews Values
(1,' Me is very happy. Me likey this airline. Me good.', 10, 1, 1),
(2,' Ja, Ja, Ja... Ja, Gut, Gut, Ja Gut! Sehr Gut!', 10, 1, 4),
(3,' Meh...', 5, 4, 3),
(4,' Well Ive seen better, but Ive certainly seen a lot worse...', 7, 3, 5)

insert into	CustomerBankAccounts Values
( 1, '123456790', 2569.23, 1),
( 2, '18ABC23672', 14004568.23, 2),
( 3, 'F0RG0100N3', 19345.20, 5)