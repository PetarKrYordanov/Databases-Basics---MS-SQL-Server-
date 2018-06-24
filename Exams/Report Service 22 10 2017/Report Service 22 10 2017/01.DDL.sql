create database ReportService
go
use ReportService
 
 CREATE TABLE Users
(Id        INT NOT NULL IDENTITY,
 Username  NVARCHAR(30) NOT NULL UNIQUE,
 Password  NVARCHAR(50) NOT NULL,
 Name      NVARCHAR(50),
 Gender    CHAR(1),
 BirthDate DATETIME,
 Age       INT,
 Email     NVARCHAR(50) NOT NULL,
 CONSTRAINT CHK_GenderUsers CHECK(Gender IN('M', 'F')),
 CONSTRAINT PK_Users PRIMARY KEY(Id)
);
CREATE TABLE Departments
(Id   INT not null IDENTITY,
 Name NVARCHAR(50) NOT NULL,
 CONSTRAINT PK_Departments PRIMARY KEY(Id)
);
CREATE TABLE Employees
(Id           INT not null IDENTITY,
 FirstName    NVARCHAR(25),
 LastName     NVARCHAR(25),
 Gender       CHAR(1),
 BirthDate    DATETIME,
 Age          INT,
 DepartmentId INT NOT NULL,
 CONSTRAINT FK_EmployeeDepartment FOREIGN KEY(DepartmentId) REFERENCES Departments(Id),
 CONSTRAINT CHK_GenderEmployees CHECK(Gender IN('M', 'F')),
 CONSTRAINT PK_Employees PRIMARY KEY(Id)
);
CREATE TABLE Categories
(Id           INT not null IDENTITY,
 Name         NVARCHAR(50) NOT NULL,
 DepartmentId INT,
 CONSTRAINT FK_CategoriesDepartment FOREIGN KEY(DepartmentId) REFERENCES Departments(Id),
 CONSTRAINT PK_Categories PRIMARY KEY(Id)
);
CREATE TABLE Status
(Id    INT not null IDENTITY,
 Label VARCHAR(30) NOT NULL,
 CONSTRAINT PK_Status PRIMARY KEY(Id)
);
CREATE TABLE Reports
(Id          INT not null IDENTITY,
 CategoryId  INT NOT NULL,
 StatusId    INT NOT NULL,
 OpenDate    DATETIME NOT NULL,
 CloseDate   DATETIME,
 Description NVARCHAR(200),
 UserId      INT NOT NULL,
 EmployeeId  INT,
 CONSTRAINT PK_Reports PRIMARY KEY(Id),
 CONSTRAINT FK_ReportsCategory FOREIGN KEY(CategoryId) REFERENCES Categories(Id),
 CONSTRAINT FK_ReportsStatus FOREIGN KEY(StatusId) REFERENCES Status(Id),
 CONSTRAINT FK_ReportsUsers FOREIGN KEY(UserId) REFERENCES Users(Id),
 CONSTRAINT FK_ReportsEmoloyees FOREIGN KEY(EmployeeId) REFERENCES Employees(Id)
);


