

Create database RentACar
go
use RentACar ;
go

CREATE TABLE Clients
(Id           INT
 PRIMARY KEY IDENTITY,
 FirstName    NVARCHAR(30) NOT NULL,
 LastName     NVARCHAR(30) NOT NULL,
 Gender       CHAR(1) NOT NULL,
 BirthDate    DATETIME ,
 CreditCard   NVARCHAR(30) NOT NULL,
 CardValidity DATETIME NOT NULL,
 Email        NVARCHAR(50) NOT NULL,
 CONSTRAINT CHK_Gender CHECK(Gender IN('F', 'M'))
);
CREATE TABLE Towns
(Id   INT
 PRIMARY KEY IDENTITY,
 Name NVARCHAR(50) NOT NULL
);
CREATE TABLE Offices
(Id            INT
 PRIMARY KEY IDENTITY,
 Name          NVARCHAR(50),
 ParkingPlaces INT,
 TownId        INT NOT NULL
                 foreign key  REFERENCES Towns(Id)
);
CREATE TABLE Models
(Id             INT
 PRIMARY KEY IDENTITY,
 Manufacturer   NVARCHAR(50) NOT NULL,
 Model          NVARCHAR(50) NOT NULL,
 ProductionYear datetime ,
 Seats          INT NOT NULL,
 Class          NVARCHAR(10),
 Consumption    DECIMAL(14, 2),
 
);
CREATE TABLE Vehicles
(Id       INT
 PRIMARY KEY IDENTITY,
 ModelId  INT NOT NULL
             foreign key  REFERENCES Models(Id),
 OfficeId INT NOT NULL
             foreign key  REFERENCES Offices(Id),
 Mileage  INT NOT NULL
              DEFAULT(0)
);
CREATE TABLE Orders
(Id                 INT
 PRIMARY KEY IDENTITY,
 ClientId           INT NOT NULL
                      foreign key   REFERENCES Clients(Id),
 TownId             INT NOT NULL
                       foreign key  REFERENCES Towns(Id),
 VehicleId          INT NOT NULL
                       foreign key  REFERENCES Vehicles(Id),
 CollectionDate     DATETIME NOT NULL,
 CollectionOfficeId INT NOT NULL
                       foreign key  REFERENCES Offices(Id),
 ReturnDate         DATETIME NULL,
 ReturnOfficeId     INT NULL
                       foreign key  REFERENCES Offices(Id),
 Bill               DECIMAL(14, 2) DEFAULT(0),
 TotalMileage       INT DEFAULT(0)
);

