use Airport
 /*Task 2: Ticket Purchase Procedure
Write a procedure – “usp_PurchaseTicket”, which registers a ticket in the Tickets table, to a customer that has purchased it, taking from his balance in the CustomerBankAccounts table, the provided ticket price. The procedure should accept the following parameters as input:
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








/*Task 2: Ticket Purchase Procedure
Write a procedure – “usp_PurchaseTicket”, which registers a ticket in the Tickets table, to a customer that has purchased it, taking from his balance in the CustomerBankAccounts table, the provided ticket price. The procedure should accept the following parameters as input:
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
		begin tran
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
go