/*	5.	Products by Price
Select all products ordered by price (descending) then by name (ascending). 
Required columns:
•	Name
•	Price
•	Description
	*/
use Bakery

SELECT Name,
       Price,
       Description
FROM Products
ORDER BY price DESC,
         name;

 /*6.	Ingredients
Find all ingredients coming from the countries with Id’s of 1, 10, 20.
 Order them by ingredient Id (ascending).
Required columns:
•	Name
•	Description
•	OriginCountryId
*/

select Name,Description,OriginCountryId from Ingredients
where OriginCountryId in(1,10,20)
order by id

/*7.	Ingredients from Bulgaria and Greece
Select top 15 ingredients coming from Bulgaria and Greece. Order them by ingredient name then by country name (both ascending).
Required columns:
•	Name
•	Description
•	CountryName
*/

SELECT TOP 15 i.Name 'Name',
              i.Description,
              c.Name AS CountryName
FROM Ingredients AS i
     JOIN Countries AS c ON c.Id = i.OriginCountryId
                            AND c.Name IN('Bulgaria', 'Greece')
ORDER BY i.Name,
         c.Name;

/*8.	Best Rated Products
Select top 10 best rated products ordered by average rate (descending) then by amount of feedbacks (descending).
Required columns:
•	Name
•	Description
•	AverageRate – average Rate for each product
•	FeedbacksAmount – number of feedbacks for each product
*/
SELECT cfeedback.Name,
       cfeedback.Description,
       av.AverageRate,
       cfeedback.count
FROM
(
    SELECT p.Name,
           p.id AS prodId,
           COUNT(*) AS count,
           p.Description
    FROM Products AS p
         JOIN Feedbacks AS f ON p.Id = f.ProductId
    GROUP BY p.Id,
             p.Description,
             Name
) AS cfeedback
JOIN
(
    SELECT TOP 10 ProductID,
                  AVG(rate) AS AverageRate
    FROM Feedbacks
    GROUP BY ProductId
    ORDER BY AVG(rate) DESC
) AS av ON av.ProductId = cfeedback.prodId
ORDER BY av.AverageRate DESC,
         count DESC;

/*9.	Negative Feedback
Select all feedbacks alongside with the customers which gave them.
Filter only feedbacks which have rate below 5.0. 
Order results by ProductId (descending) then by Rate (ascending).
Required columns:
•	ProductId
•	Rate
•	Description
•	CustomerId
•	Age
•	Gender
*/

SELECT f.ProductId,
       f.Rate,
       f.Description,
       f.CustomerId,
       c.Age,
       c.Gender
FROM Customers AS c
     JOIN Feedbacks AS f ON f.CustomerId = c.Id
                            AND f.Rate < 5
ORDER BY f.ProductId DESC,
         f.Rate ASC;

/*10.	Customers without Feedback
Select all customers without feedbacks. Order them by customer id (ascending).
Required columns:
•	CustomerName – customer’s first and last name, concatenated with space
•	PhoneNumber
•	Gender
*/


SELECT CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
       c.PhoneNumber,
       c.Gender
FROM Customers AS c
     LEFT JOIN Feedbacks AS f ON f.CustomerId = c.Id
WHERE f.id IS NULL
order by c.Id asc

/*11.	Honorable Mentions
Select all feedbacks given by customers which have at least 3 feedbacks. 
Order them by product Id then by customer name and lastly by feedback id – all ascending.
Required columns:
•	ProductId
•	CustomerName – customer’s first and last name, concatenated with space
•	FeedbackDescription
*/


SELECT f.ProductId,
       CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
       f.Description
FROM Feedbacks AS f
     JOIN
(
    SELECT c.Id AS id,
           COUNT(*) AS counts
    FROM Customers AS c
         JOIN Feedbacks AS f ON f.CustomerId = c.Id
    GROUP BY c.id
) AS feedCount ON f.CustomerId = feedCount.id
     JOIN Customers AS c ON c.Id = f.CustomerId
WHERE feedCount.counts >= 3
ORDER BY f.ProductId,
         CustomerName,
         f.Id;

/*	12.	Customers by Criteria
Select customers that are either at least 21 old and contain “an” in their first name or their phone number ends 
with “38” and are not from Greece. Order by first name (ascending), then by age(descending).
Required columns:
•	FirstName
•	Age
•	PhoneNumber
*/

SELECT c.FirstName,
       c.Age,
       c.PhoneNumber
FROM Customers AS c
WHERE(FirstName LIKE '%an%'
      AND c.Age >= 21)
     OR (RIGHT(PhoneNumber, 2) = '38'
         AND c.CountryId <>(
    SELECT id
    FROM Countries
    WHERE Name = 'Greece'
))
ORDER BY c.FirstName,
         c.Age DESC;


/*13.	Middle Range Distributors
Select all distributors which distribute ingredients used in the
 making process of all products having average rate between 5 and 8 (inclusive).
  Order by distributor name, ingredient name and product name all ascending.
Required columns:
•	DistributorName
•	IngredientName
•	ProductName
•	AverageRate
*/

SELECT d.Name AS DistributorName,
       i.Name AS IngredientName,
       p.Name AS ProductName,
       avRate.AverageRate
FROM Products AS p
     JOIN ProductsIngredients AS pi ON pi.ProductId = p.Id
     JOIN Ingredients AS i ON pi.IngredientId = i.Id
     JOIN Distributors AS d ON d.Id = i.DistributorId
     JOIN
(
    SELECT AVG(F.Rate) AS AverageRate,
           P.Id
    FROM Feedbacks AS f
         JOIN Products AS p ON p.Id = f.ProductId
    GROUP BY P.Id
) AS avRate ON avRate.Id = p.Id
WHERE AverageRate BETWEEN 5 AND 8
ORDER BY DistributorName,
         IngredientName,
         ProductName;

/*	14.	The Most Positive Country
Select the country which gave the most positive feedbacks. 
If there are several – print them all. Required columns:
•	CountryName
•	FeedbackRate – average feedback rate for each country
*/
SELECT Name,
       FeedbackRate
FROM
(
    SELECT avgt.Name,
           avgT.FeedbackRate,
           RANK() OVER(ORDER BY avgT.FeedbackRate DESC) AS avRank
    FROM
(
    SELECT co.Name,
           AVG(f.Rate) AS FeedbackRate
    FROM Feedbacks AS f
         JOIN Customers AS c ON c.Id = f.CustomerId
         JOIN Countries AS co ON co.Id = c.CountryId
    GROUP BY co.Name
) AS avgT
) AS av
WHERE avRank = 1;

/*		15.	Country Representative
Select all countries with their most active distributor 
(the one with the greatest number of ingredients).
 If there are several distributors with most ingredients delivered,
  list them all. Order by country name then by distributor name.
Required columns:
•	CountryName
•	DistributorName
*/
SELECT CountryName,
       DistributorName
FROM
(
    SELECT c.Name AS CountryName,
           d.Name AS DistributorName,
           DENSE_RANK() OVER(PARTITION BY c.name ORDER BY discount.distributorcount DESC) AS r
    FROM
(
    SELECT COUNT(c.id) AS distributorCount,
           d.Id AS dId
    FROM Countries AS c
         JOIN Distributors AS d ON d.CountryId = c.Id
         JOIN Ingredients AS i ON i.DistributorId = d.Id
    GROUP BY d.Id
) AS disCount
RIGHT JOIN Distributors AS d ON disCount.dId = d.Id
JOIN Countries AS c ON c.Id = d.CountryId
) AS ranke
WHERE ranke.r = 1
ORDER BY CountryName,
         DistributorName;







