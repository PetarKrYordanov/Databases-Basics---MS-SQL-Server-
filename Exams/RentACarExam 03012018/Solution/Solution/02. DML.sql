 select * from models
	 --insert
 Insert into Models (Manufacturer,Model,ProductionYear,Seats,Class,Consumption)
 Values ('Chevrolet', 'Astro', '2005-07-27 00:00:00.000', 4, 'Economy', 12.60),
('Toyota', 'Solara', '2009-10-15 00:00:00.000', 7, 'Family', 13.80),
('Volvo', 'S40', '2010-10-12 00:00:00.000', 3, 'Average', 11.30),
('Suzuki', 'Swift', '2000-02-03 00:00:00.000', 7, 'Economy', 16.20)

 /*03.	Update
Set all Model’s class to “Luxury” where the consumption is over 20.	  
*/

update Models
set Class = 'Luxury'
where Consumption>20

/* 04.	Delete
Delete all orders which don’t have a Return Date.
*/
delete Orders
where ReturnDate is null

