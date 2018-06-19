use Bakery

/*Section 4. Programmability (20 pts)
For this section put your queries in judge and use: “SQL Server run skeleton, run queries and check DB”.
16.	Customers with Countries
Create a view named v_UserWithCountries which selects all customers with their countries.
Required columns:
•	CustomerName – first name plus last name, with space between them
•	Age
•	Gender
•	CountryName
*/ go

CREATE VIEW v_UserWithCountries
AS
     SELECT CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
            c.Age,
            c.Gender,
            co.Name AS CountryName
     FROM Customers AS c
          JOIN Countries AS co ON co.Id = c.CountryId;

go
	SELECT TOP 5 *
	  FROM v_UserWithCountries
	 ORDER BY Age

/*18.	Send Feedback
Each Customer should not have more than 3 feedbacks per product. Your task is to create a user defined procedure (usp_SendFeedback) which accepts customer’s id, product’s id, rate and description.  You should insert the data but if the user already has 3 feedbacks – rollback any changes and throw an exception with message “You are limited to only 3 feedbacks per product!” with Severity = 16 and State = 1.
Parameters:
•	CustomerId
•	ProductId
•	Rate
•	Description

*/
go

CREATE FUNCTION dbo.udf_GetRating
(@Name NVARCHAR(25)
)
RETURNS VARCHAR(9)
AS
     BEGIN
         DECLARE @rating DECIMAL(4, 2);
         SET @rating =
(
    SELECT AVG(Rate)
    FROM Feedbacks AS f
         JOIN Products AS p ON p.Id = f.ProductId
                               AND p.Name = @Name
    GROUP BY p.Name
);
         DECLARE @result VARCHAR(9);
         IF(@rating IS NULL)
             BEGIN
                 SET @result = 'No rating';
                 RETURN @result;
             END;
         SET @result = CASE
                           WHEN @rating < 5
                           THEN 'Bad'
                           WHEN @rating > 8
                           THEN 'Good'
                           ELSE 'Average'
                       END;
         RETURN @result;
     END;

	go

SELECT TOP 5 Id, Name, dbo.udf_GetRating(Name)
  FROM Products
 ORDER BY Id

 /*18.	Send Feedback
Each Customer should not have more than 3 feedbacks per product. 
Your task is to create a user defined procedure (usp_SendFeedback) which accepts customer’s id, product’s id, rate and description.
  You should insert the data but if the user already has 3 feedbacks – 
  rollback any changes and throw an exception with message “You are limited to only 3 feedbacks per product!” with Severity = 16 and State = 1.
Parameters:
•	CustomerId
•	ProductId
•	Rate
•	Description
*/
go

CREATE PROCEDURE usp_SendFeedback @CustomerId  INT,
                                  @ProductId   INT,
                                  @Rate        DECIMAL(4, 2),
                                  @Description NVARCHAR(255)
AS;
	begin
	Begin transaction
	  declare @feedCounts int;
	  set @feedCounts= (Select COUNT(*) from Feedbacks where ProductId=@ProductId and CustomerId =@CustomerId
	  )
	  if (@feedCounts =3)
	  begin
		 rollback;
		 raiserror('You are limited to only 3 feedbacks per product!',16,1)
	  end
	   else 
	   begin
		  insert into Feedbacks (Description,Rate,ProductId,CustomerId)values
		  (@Description,@Rate,@ProductId,@CustomerId)
	   end
	commit
	end

go
begin tran
EXEC usp_SendFeedback 1, 5, 7.50, 'Average experience';
SELECT * FROM Feedbacks WHERE CustomerId = 1 AND ProductId = 5;
rollback

/*19.	Delete Products
Create a trigger that deletes all of the relations of a product upon 
its deletion. 
*/
go
CREATE TRIGGER T_Products_InsteadOF_Delete ON Products INSTEAD OF DELETE
AS

 delete ProductsIngredients 
 where ProductId in (select id from deleted)

delete from Feedbacks 
where ProductId in (select id from deleted)

delete Products 
 where id in (select id from deleted)

  go
  begin tran
delete from Products
 where id =7

 rollback

/*Section 5. Bonus (10 pts)
For this section put your queries in judge and use: “SQL Server prepare DB and run queries”.
20.	Products by One Distributor
Select all products which ingredients are delivered by only one distributor. Order them by product Id.
Required columns:
•	ProductName
•	ProductAverageRate
•	DistributorName
•	DistributorCountry
*/
select ProductName,ProductAverageRate,DistributorName,DistributorCountry from (		   
SELECT distinct p.Id, p.Name AS ProductName,
       AvgRate.ProductAverageRate,
       d.Name AS DistributorName,
       c.Name AS DistributorCountry
FROM
(
    SELECT distinct p.id
    FROM Products AS p
         JOIN ProductsIngredients AS pi ON pi.ProductId = p.id
         JOIN Ingredients AS i ON i.Id = pi.IngredientId 
         JOIN Distributors AS d ON d.Id = i.DistributorId
    GROUP BY p.Id
    HAVING COUNT(DISTINCT d.id) = 1
) AS OneDistributorProducts
left JOIN
(
    SELECT p.Id,
           AVG(f.rate) AS ProductAverageRate
    FROM Products AS p
       left  JOIN Feedbacks AS f ON f.ProductId = p.id
    GROUP BY p.Id
) AS AvgRate ON AvgRate.Id = OneDistributorProducts.Id
 JOIN Products AS p ON p.Id = OneDistributorProducts.Id
 JOIN ProductsIngredients AS pi ON pi.ProductId = OneDistributorProducts.Id
 JOIN Ingredients AS i ON pi.IngredientId = i.Id
 JOIN Distributors AS d ON d.Id = i.DistributorId
 JOIN Countries AS c ON c.Id = d.CountryId
 ) as DistinctP
ORDER BY DistinctP.Id;


    SELECT *
    FROM Products AS p
         JOIN ProductsIngredients AS pi ON pi.ProductId = p.id
         JOIN Ingredients AS i ON i.Id = pi.IngredientId
         JOIN Distributors AS d ON d.Id = i.DistributorId
		 where p.Id = 22




