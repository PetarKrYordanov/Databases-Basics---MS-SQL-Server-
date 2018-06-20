/*Section 2. DML (10 pts)
Before you start you have to import “DataSet-ReportService.sql”. If you have created the structure correctly the data should be successfully inserted.
In this section, you have to do some data manipulations:
2.	Insert
Let’s insert some sample data into the database. Write a query to add the following records into the corresponding tables. All Id’s should be auto-generated. Replace names that relate to other tables with the appropriate ID (look them up manually, there is no need to perform table joins).
*/

INSERT INTO Employees
(FirstName,
 LastName,
 Gender,
 BirthDate,
 DepartmentId
)
VALUES
('Marlo',
 'O’Malley',
 'M',
 '9/21/1958',
 1
),
('Niki',
 'Stanaghan',
 'F',
 '11/26/1969',
 4
),
('Ayrton',
 'Senna',
 'M',
 '03/21/1960',
 9
),
('Ronnie',
 'Peterson',
 'M',
 '02/14/1944',
 9
),
('Giovanna',
 'Amati',
 'F',
 '07/20/1959',
 5
);
INSERT INTO Reports
(CategoryId,
 StatusId,
 OpenDate,
 CloseDate,
 Description,
 UserId,
 EmployeeId
)
VALUES
(1,
 1,
 '04/13/2017',
 NULL,
 'Stuck Road on Str.133',
 6,
 2
),
(6,
 3,
 '09/05/2015',
 '12/06/2015',
 'Charity trail running',
 3,
 5
),
(14,
 2,
 '09/07/2015',
 NULL,
 'Falling bricks on Str.58',
 5,
 2
),
(4,
 3,
 '07/03/2017',
 '07/06/2017',
 'Cut off streetlight on Str.11',
 1,
 1
);

/*3.	Update
Switch all report’s status to “in progress” where it is currently “waiting” for the “Streetlight” category (look up the category ID and status ID’s manually, there is no need to use table joins).
*/

Update Reports
Set StatusId = 2
where StatusId =1 and CategoryId =4

 /*4.	Delete
Delete all reports who have a status “blocked”.
*/

delete Reports
where StatusId = 4