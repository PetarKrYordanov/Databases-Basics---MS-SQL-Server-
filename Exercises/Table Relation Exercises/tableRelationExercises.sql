--Problem One
USE TableRelationDemo;
CREATE TABLE Passports
(PassportId     INT IDENTITY(101, 1) NOT NULL,
 PassportNumber CHAR(8) NOT NULL,
 CONSTRAINT PK_Passports PRIMARY KEY(PassportID)
);
CREATE TABLE Persons
(PersonId   INT IDENTITY NOT NULL,
 FirstName  NVARCHAR(50) NOT NULL,
 Salary     DECIMAL(10, 2),
 PassportId INT
 UNIQUE NOT NULL,
 CONSTRAINT PK_Persons PRIMARY KEY(PersonId),
 CONSTRAINT FK_Persons_Passports FOREIGN KEY(PassportId) REFERENCES Passports(PassportId) ON DELETE CASCADE
);
INSERT INTO Passports
VALUES('N34FG21B'), ('K65LO4R7'), ('ZE657QP2');
INSERT INTO Persons
VALUES
('Roberto',
 43300.00,
 102
),
('Tom',
 56100.00,
 103
),
('Yana',
 60200.00,
 101
);

-- Problem 2 

CREATE TABLE Manufacturers
(ManufacturerId INT
 PRIMARY KEY IDENTITY,
 Name           NVARCHAR(20) NOT NULL,
 EstablishedOn  DATE DEFAULT GETDATE()
);
CREATE TABLE Models
(ModelID        INT IDENTITY(101, 1) PRIMARY KEY,
 Name           VARCHAR(20),
 ManufacturerID INT NOT NULL,
 CONSTRAINT FK_Models_Manufacturer FOREIGN KEY(ManufacturerID) REFERENCES Manufacturers(ManufacturerId)
);
INSERT INTO Manufacturers
VALUES
('BMW',
 '07/03/1916'
),
('Tesla',
 '01/01/2003'
),
('Lada',
 '01/05/1966'
);
INSERT INTO Models
VALUES
('X1',
 1
),
('i6',
 1
),
('Model S',
 2
),
('Model X',
 2
),
('Model 3',
 2
),
('Nova',
 3
);
DROP TABLE Models;
DROP TABLE Manufacturers;

--Problem 3  Many to many
CREATE TABLE Students
(StudentID INT
 PRIMARY KEY IDENTITY,
 Name      VARCHAR(50) NOT NULL
);
CREATE TABLE Exams
(ExamID INT
 PRIMARY KEY IDENTITY(101, 1),
 Name   VARCHAR(50) NOT NULL
);
CREATE TABLE StudentsExams
(StudentID INT NOT NULL,
 ExamID    INT NOT NULL,
 CONSTRAINT PK_StudentsExams PRIMARY KEY(StudentID, ExamID),
 CONSTRAINT FK_StudentsExams_Students FOREIGN KEY(StudentID) REFERENCES Students(StudentID),
 CONSTRAINT FK_StudentsExams_Exams FOREIGN KEY(ExamID) REFERENCES Exams(ExamID)
);
INSERT INTO Students
VALUES('Mila'), ('Toni'), ('Ron');
INSERT INTO Exams
VALUES('SpringMVC'), ('Neo4j'), ('Oracle 11g');
INSERT INTO StudentsExams
VALUES
(1,
 101
),
(1,
 102
),
(2,
 101
),
(3,
 103
),
(2,
 102
),
(2,
 103
);
SELECT s.Name,
       e.Name
FROM Students AS S
     JOIN StudentsExams AS se ON se.StudentID = s.StudentID
     JOIN Exams AS e ON se.ExamID = e.ExamID;

--Problem 4
CREATE TABLE Teachers
(TeacherID INT
 PRIMARY KEY IDENTITY(101, 1),
 [Name]    VARCHAR(30) NOT NULL,
 ManagerID INT FOREIGN KEY REFERENCES Teachers(TeacherID)
);
SET IDENTITY_INSERT Teacher ON;

--Problem 5
CREATE DATABASE OnlineStore;
GO
CREATE TABLE ItemTypes
(ItemTypeID INT
 PRIMARY KEY IDENTITY,
 Name       VARCHAR(50)
);
CREATE TABLE Items
(ItemID     INT
 PRIMARY KEY IDENTITY,
 Name       VARCHAR(50) NOT NULL,
 ItemTypeID INT NOT NULL,
 CONSTRAINT FK_Items_ItemTypes FOREIGN KEY(ItemTypeID) REFERENCES ItemTypes(ItemTypeID)
);
CREATE TABLE Cities
(CityID INT
 PRIMARY KEY IDENTITY,
 Name   VARCHAR(50) NOT NULL
);
CREATE TABLE Customers
(CustomerID INT
 PRIMARY KEY IDENTITY,
 Name       VARCHAR(50) NOT NULL,
 Birthdate  DATE DEFAULT GETDATE(),
 CityID     INT NOT NULL,
 CONSTRAINT FK_Customers_Cities FOREIGN KEY(CityID) REFERENCES Cities(CityID)
);
CREATE TABLE Orders
(OrderID    INT
 PRIMARY KEY IDENTITY,
 CustomerID INT NOT NULL,
 CONSTRAINT FK_Orders_Customers FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID)
);
CREATE TABLE OrderItems
(OrderID INT,
 ItemID  INT,
 CONSTRAINT PK_OrderItems PRIMARY KEY(OrderID, ItemID),
 CONSTRAINT FK_OrderItems_Orders FOREIGN KEY(OrderID) REFERENCES Orders(OrderID),
 CONSTRAINT FK_OrderItems_Items FOREIGN KEY(ItemID) REFERENCES Items(ItemID)
);

--Problem 6	University Databases
CREATE DATABASE University;
GO
USE university;
CREATE TABLE Majors
(MajorID INT
 PRIMARY KEY IDENTITY,
 [Name]  VARCHAR(50) NOT NULL
);
CREATE TABLE Students
(StudentID     INT
 PRIMARY KEY IDENTITY,
 StudentNumber INT NOT NULL,
 StudentName   VARCHAR(50) NOT NULL,
 MajorID       INT,
 CONSTRAINT FK_Students_Majors FOREIGN KEY(MajorID) REFERENCES Majors(MajorID)
);
CREATE TABLE Payments
(PaymentID     INT
 PRIMARY KEY IDENTITY,
 PaymentDate   DATE DEFAULT GETDATE(),
 PaymentAmount DECIMAL(13, 2) NOT NULL,
 StudentID     INT NOT NULL,
 CONSTRAINT FK_Payments_Students FOREIGN KEY(StudentId) REFERENCES Students(StudentID)
);
CREATE TABLE Subjects
(SubjectID   INT
 PRIMARY KEY IDENTITY,
 SubjectName VARCHAR(30) NOT NULL
);
CREATE TABLE Agenda
(StudentID INT NOT NULL,
 SubjectID INT NOT NULL,
 CONSTRAINT PK_Agende PRIMARY KEY(StudentID, SubjectID),
 CONSTRAINT FK_Agenda_Students FOREIGN KEY(StudentID) REFERENCES Students(StudentID),
 CONSTRAINT FK_Agenda_Subjects FOREIGN KEY(SubjectID) REFERENCES Subjects(SubjectID)
);

--Problem 9 
USE Geography;
SELECT m.MountainRange AS MountainRange,
       p.PeakName,
       p.Elevation
FROM Mountains AS m
     JOIN Peaks AS p ON p.MountainId = m.Id
WHERE m.MountainRange = 'Rila'
ORDER BY p.Elevation DESC;
