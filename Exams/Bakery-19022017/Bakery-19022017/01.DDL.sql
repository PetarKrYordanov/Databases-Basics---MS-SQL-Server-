CREATE DATABASE Bakery
go
USE Bakery

-- TASK 1
CREATE TABLE Products(
Id INT IDENTITY NOT NULL,
Name NVARCHAR(25) UNIQUE,
Description NVARCHAR(250),
Recipe NVARCHAR(MAX),
Price money,
CONSTRAINT PK_ProductId PRIMARY KEY (Id),
CONSTRAINT CHK_ProductPrice CHECK (Price > 0)
)

CREATE TABLE Countries(
Id INT IDENTITY NOT NULL,
Name NVARCHAR(50) unique,
CONSTRAINT PK_CountryId PRIMARY KEY (Id)
)

CREATE TABLE Distributors(
Id INT NOT NULL IDENTITY (0,1),
[Name] NVARCHAR(25) UNIQUE,
AddressText NVARCHAR(30), 
Summary NVARCHAR(200), 
CountryId INT,
CONSTRAINT PK_DistributorId PRIMARY KEY (Id),
CONSTRAINT FK_DistributorId FOREIGN KEY (CountryId) REFERENCES Countries(Id)
)

CREATE TABLE Ingredients(
Id INT IDENTITY ,
[Name] NVARCHAR(30),
Description NVARCHAR(200),
OriginCountryId INT ,
DistributorId INT,
CONSTRAINT PK_IngredientId PRIMARY KEY (Id),
CONSTRAINT FK_DistributorIngredientId FOREIGN KEY (DistributorId) REFERENCES Distributors(Id),
CONSTRAINT FK_OriginCountry FOREIGN KEY (OriginCountryId) REFERENCES Countries(Id)
)

CREATE TABLE ProductsIngredients(
ProductId INT NOT NULL,
IngredientId INT NOT NULL,
CONSTRAINT PK_ProductsIngredients PRIMARY KEY (ProductId,IngredientId),
CONSTRAINT FK_ProductId FOREIGN KEY (ProductId) REFERENCES Products(Id),
CONSTRAINT FK_IngredientId FOREIGN KEY (IngredientId) REFERENCES Ingredients(Id)
)

CREATE TABLE Customers(
Id INT NOT NULL IDENTITY, 
FirstName NVARCHAR(25),
LastName NVARCHAR(25), 
Gender CHAR NOT NULL,
Age INT, 
PhoneNumber VARCHAR(10),
CountryId INT NOT NULL ,
CONSTRAINT PK_CustomerId PRIMARY KEY (Id),
CONSTRAINT FK_CountryId FOREIGN KEY (CountryId) REFERENCES Countries(Id),
CONSTRAINT CHK_Gender CHECK (Gender IN ('M', 'F')),
CONSTRAINT CHK_PhoneNumber CHECK (LEN(PhoneNumber) = 10)
)

CREATE TABLE Feedbacks(
Id INT NOT NULL IDENTITY,
Description NVARCHAR(255),
Rate DECIMAL(4,2),
ProductId INT,
CustomerId INT ,
CONSTRAINT PK_FeedbackId PRIMARY KEY (Id),
CONSTRAINT FK_FeedbackProductId FOREIGN KEY (ProductId) REFERENCES Products(Id),
CONSTRAINT FK_FeedbackCustomerId FOREIGN KEY (CustomerId) REFERENCES Customers(Id),
CONSTRAINT CHK_Rate CHECK  (Rate BETWEEN 0.001 AND 9.99999)
)

-- TASK 5

