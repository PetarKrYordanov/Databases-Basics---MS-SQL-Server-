 /*	Section 2. DML (15 pts)
For this section put your queries in judge and use: “SQL Server run skeleton,
 run queries and check DB”.
Before you start you have to import “??????”.
 If you have created the structure correctly the data should be successfully inserted.
In this section, you have to do some data manipulations:
2.	Insert
Let’s insert some sample data into the database. Write a query to add the following records into the corresponding tables. All Id’s should be auto-generated.
*/
   begin tran
insert into Distributors (name, CountryId,AddressText,Summary)values 
(N'Deloitte & Touche', 2, N'6 Arch St #9757', N'Customizable neutral traveling'),
(N'Congress Title', 13, N'58 Hancock St', N'Customer loyalty'),
(N'Kitchen People', 1, N'3 E 31st St #77', N'Triple-buffered stable delivery'),
(N'General Color Co Inc', 21, N'6185 Bohn St #72', N'Focus group'),
(N'Beck Corporation', 23, N'21 E 64th Ave', N'Quality-focused 4th generation hardware')

insert into Customers (FirstName,LastName,Age,Gender,PhoneNumber,CountryId) values
  ('Francoise', 'Rautenstrauch', 15, 'M', '0195698399', 5),
('Kendra', 'Loud', 22, 'F', '0063631526', 11),
('Lourdes', 'Bauswell', 50, 'M', '0139037043', 8),
('Hannah', 'Edmison', 18, 'F', '0043343686', 1),
('Tom', 'Loeza', 31, 'M', '0144876096', 23),
('Queenie', 'Kramarczyk', 30, 'F', '0064215793', 29),
('Hiu', 'Portaro', 25, 'M', '0068277755', 16),
('Josefa', 'Opitz', 43, 'F', '0197887645', 17)

rollback

/*3.	Update
We’ve decided to switch some of our ingredients to a local distributor.
 Update the table Ingredients and change the DistributorId of "Bay Leaf",
  "Paprika" and "Poppy" to 35. 
  Change the OriginCountryId to 14 of all ingredients with OriginCountryId equal to 8.
*/
begin tran

UPDATE Ingredients
  SET
      DistributorId = 35
WHERE Name IN('Bay Leaf', 'Paprika', 'Poppy');
UPDATE Ingredients
  SET
      OriginCountryId = 14
WHERE OriginCountryId = 8;

rollback

/*4.	Delete
Delete all Feedbacks which relate to Customer with Id 14 or 
to Product with Id 5.
*/

DELETE FROM Feedbacks
WHERE CustomerId = 14
      OR ProductId = 5;