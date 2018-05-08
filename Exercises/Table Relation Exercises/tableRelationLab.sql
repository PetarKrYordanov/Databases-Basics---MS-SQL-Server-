--one to many example

CREATE  TABLE Mountains (
	Id INT IDENTITY,
	Name VARCHAR(50) NOT NULL,
	CONSTRAINT PK_Mountains	PRIMARY KEY (Id)
)

CREATE TABLE Peaks(
	Id INT IDENTITY,
    Name VARCHAR(50) NOT NULL,
    MountainId INT not null,

	CONSTRAINT PK_Peaks 
	PRIMARY KEY (Id),

	CONSTRAINT FK_Peaks_Mountains 
	FOREIGN KEY (MountainId) 
	REFERENCES Mountains(Id)
)

INSERT INTO Mountains (Name) VALUES
('Rila'),
('Pirin')

SELECT * FROM Mountains

INSERT INTO Peaks(Name,MountainId) VALUES
 ('Musala', 1),
('Malyovitsa',1),
('Vihren', 2),
('Kutelo', 2)

select * from Peaks

--many to many example

CREATE TABLE Employees (
	Id INT PRIMARY KEY IDENTITY,
	Name VARCHAR(50) NOT NULL
)

CREATE TABLE Projects(
	Id INT PRIMARY KEY IDENTITY,
	Name VARCHAR(50) NOT NULL
)

CREATE TABLE EmployeesProjects(
	EmployeeId INT,
	ProjectId INT,
	 
	CONSTRAINT PK_EmployeesProjects
	PRIMARY KEY (EmployeeId, ProjectId),

	CONSTRAINT FK_EmployeesProjects_Employees
	FOREIGN KEY (EmployeeId)
	REFERENCES Employees(Id),

	CONSTRAINT FK_EmployeesProjects_Projects
	FOREIGN KEY	(ProjectId)
	REFERENCES Projects(Id)
)

SELECT * FROM EmployeesProjects		

INSERT INTO Employees (Name)
VALUES ('BAY IVAN'),
('gOSHO GOSHOV'),
('Ivan Ivanov')

INSERT INTO Projects(Name) Values
('My SQL Project'),
('Super Javar Project'),
('Microsoft Hell')	

INSERT INTO EmployeesProjects (EmployeeId, ProjectId) VALUES
	(1, 2),
	(1, 1),
	(3, 3),
	(2,1)	
	
SELECT e.Name, p.Name FROM Employees AS e
JOIN EmployeesProjects AS ep ON ep.EmployeeId = E.Id
JOIN Projects AS p ON P.Id =ep.ProjectId	

DROP TABLE EmployeesProjects
DROP TABLE Employees
DROP TABLE Projects

-- Ome to One example 

  CREATE TABLE Drivers (
	Id INT PRIMARY KEY IDENTITY,
	Name VARCHAR(50) NOT NULL 
 )	

 CREATE TABLE Cars (
	Id INT PRIMARY KEY IDENTITY,
	Name VARCHAR(50) NOT NULL,
	DriverId INT FOREIGN KEY REFERENCES Drivers(Id) UNIQUE
 )

 INSERT INTO Drivers(Name)
 VALUES ('Ivan Ivanov'),
 ('tOSHKO')

INSERT INTO Cars (Name, DriverId) VALUES
('Trebant', 1),
('Ford', 2)

 SELECT C.Id, C.Name, D.Name FROM Cars	AS c
 JOIN Drivers AS D ON D.Id = C.DriverId
	
USE Geography

-- JOIN CONDITIONS
SELECT M.MountainRange, P.PeakName, p.Elevation 
	FROM Mountains AS m
JOIN Peaks AS p  ON P.MountainId = m.Id
WHERE M.MountainRange = 'Rila'
order by p.Elevation desc



			 