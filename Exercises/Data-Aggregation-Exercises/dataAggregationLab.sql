 select * from Employees

SELECT e.DepartmentID,
SUM(e.Salary) as TotalSalary
from Employees as e
group by e.DepartmentID
order by e.DepartmentID

select e.DepartmentID,
MIN(e.Salary) as MinSalary
from Employees as e
group by e.DepartmentID 

select e.DepartmentID,
COUNT(e.Salary) as SalaryCount
from Employees as e
group by DepartmentID

 select e.DepartmentID,
 Max(e.Salary) as MaxSalary
 from Employees as e
 group by DepartmentID

  select e.DepartmentID,
 Min(e.Salary) as MinSalary
 from Employees as e
 group by DepartmentID

 select e.DepartmentID,
 Avg(e.salary) as AvgSalary
 from Employees as e 
 group by e.DepartmentID

select e.DepartmentID,
sum(e.Salary) as TotalSalary
from Employees as e 
group by DepartmentID
HAVING sum(e.salary)<100000
