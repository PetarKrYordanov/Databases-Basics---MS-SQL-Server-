 create database WMS
 go

use WMS
 go
--Create database

CREATE TABLE Clients
(ClientId  INT
 PRIMARY KEY IDENTITY,
 FirstName VARCHAR(50) NOT NULL,
 LastName  VARCHAR(50) NOT NULL,
 Phone     VARCHAR(12) NOT NULL,
 CONSTRAINT CHK_Phone CHECK(LEN(phone) = 12)
);
CREATE TABLE Mechanics
(MechanicId INT
 PRIMARY KEY IDENTITY,
 FirstName  VARCHAR(50) NOT NULL,
 LastName   VARCHAR(50) NOT NULL,
 Address    VARCHAR(255) NOT NULL
);
CREATE TABLE Models
(ModelId INT
 PRIMARY KEY IDENTITY,
 Name    VARCHAR(50)
 UNIQUE NOT NULL
);
CREATE TABLE Jobs
(JobId      INT
 PRIMARY KEY IDENTITY,
 ModelId    INT NOT NULL,
 Status     VARCHAR(11) NOT NULL
                        DEFAULT 'Pending',
 ClientId   INT NOT NULL,
 MechanicId INT NULL,
 IssueDate  DATETIME NOT NULL,
 FinishDate DATETIME NULL,
 CONSTRAINT FK_Jobs_Model FOREIGN KEY(ModelId) REFERENCES Models(ModelId),
 CONSTRAINT FK_Jobs_Clients FOREIGN KEY(ClientId) REFERENCES Clients(ClientId),
 CONSTRAINT FK_Jobs_Mechanick FOREIGN KEY(MechanicId) REFERENCES Mechanics(MechanicId),
 CONSTRAINT CHK_Status CHECK(Status = 'Pending'
                             OR Status = 'In Progress'
                             OR Status = 'Finished')
);
CREATE TABLE Vendors
(VendorId INT
 PRIMARY KEY IDENTITY,
 Name     VARCHAR(50) NOT NULL UNIQUE
);
CREATE TABLE Orders
(OrderId   INT
 PRIMARY KEY IDENTITY,
 JobId     INT NOT NULL,
 IssueDate DATETIME NULL,
 Delivered BIT DEFAULT 0,
 CONSTRAINT FK_Orders_Jobs FOREIGN KEY(JobId) REFERENCES Jobs(JobId)
);
CREATE TABLE Parts
(PartId       INT
 PRIMARY KEY IDENTITY,
 SerialNumber VARCHAR(50)
 UNIQUE NOT NULL,
 Description  VARCHAR(255) NULL,
 Price        DECIMAL(6, 2) NOT NULL,
 VendorId     INT NOT NULL,
 StockQty     INT DEFAULT 0,
 CONSTRAINT CHK_Price CHECK(Price > 0),
 CONSTRAINT FK_Parts_Vendors FOREIGN KEY(VendorId) REFERENCES Vendors(VendorId),
 CONSTRAINT CHK_Stock CHECK(StockQty >= 0)
);
CREATE TABLE PartsNeeded
(JobId    INT NOT NULL,
 PartId   INT NOT NULL,
 Quantity INT DEFAULT 1,
 CONSTRAINT CHK_Quantity1 CHECK(Quantity > 0),
 CONSTRAINT PK_PartsNeeded PRIMARY KEY(JobId, PartId),
 CONSTRAINT FK_PartsNeeded_Jobs FOREIGN KEY(JobId) REFERENCES Jobs(JobId),
 CONSTRAINT FK_PartsNeeded_Parts FOREIGN KEY(PartId) REFERENCES Parts(PartId),
);
CREATE TABLE OrderParts
(OrderId  INT NOT NULL,
 PartId   INT NOT NULL,
 Quantity INT DEFAULT 1,
 CONSTRAINT CHK_Quantity2 CHECK(Quantity > 0),
 CONSTRAINT PK_OrderParts PRIMARY KEY(OrderId, PartId),
 CONSTRAINT FK_OrderParts_Orders FOREIGN KEY(OrderId) REFERENCES Orders(OrderId),
 CONSTRAINT FK_OrderParts_Parts FOREIGN KEY(PartId) REFERENCES Parts(PartId)
);




