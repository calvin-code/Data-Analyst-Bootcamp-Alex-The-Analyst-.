-- This tutorial uses MYSQL Workbench . Adjust the codes to suit the version of SQL database your are using.

CREATE TABLE EmployeeDemographics
(EmployeeID int,
FirstName varchar(50),
LastName varchar(50),
Age int,
Gender varchar(50)
);

CREATE TABLE EmployeeSalary
(EmployeeID INT,
JobTitle varchar(50),
Salary int);

INSERT INTO EmployeeDemographics (EmployeeID, FirstName, LastName, Age, Gender)
VALUES
(1001, 'Michael', 'Scott', 41, 'Male'),
(1002, 'Pam', 'Beesly', 32, 'Female'),
(1003, 'Jim', 'Halpert', 34, 'Male'),
(1004, 'Dwight', 'Schrute', 38, 'Male'),
(1005, 'Kelly', 'Kapoor', 30, 'Female'),
(1006, 'Ryan', 'Howard', 31, 'Male'),
(1007, 'Erin', 'Hannon', 29, 'Female'),
(1008, 'Andy', 'Bernard', 37, 'Male'),
(1009, 'Kevin', 'Malone', 40, 'Male'),
(1010, 'Angela', 'Martin', 33, 'Female'),
(1011, 'Meredith', 'Palmer', 36, 'Female'),
(1012, 'Oscar', 'Martinez', 39, 'Male'),
(1013, 'Creed', 'Bratton', 52, 'Male'),
(1014, 'Phyllis', 'Vance', 50, 'Female'),
(1015, 'Toby', 'Flenderson', 45, 'Male');

select * from EmployeeDemographics;

INSERT INTO EmployeeSalary (EmployeeID, JobTitle, Salary)
VALUES
(1001, 'Regional Manager', 75000),
(1002, 'Receptionist', 35000),
(1003, 'Sales Representative', 55000),
(1004, 'Assistant Regional Manager', 60000),
(1005, 'Customer Service Representative', 42000),
(1006, 'Temp', 32000),
(1007, 'Receptionist', 34000),
(1008, 'Sales Manager', 65000),
(1009, 'Accountant', 48000),
(1010, 'Head of Accounting', 52000),
(1011, 'Supplier Relations Representative', 40000),
(1012, 'Accountant', 47000),
(1013, 'Quality Assurance', 45000),
(1014, 'Sales Representative', 53000),
(1015, 'HR Manager', 57000);

SELECT * 
FROM EmployeeDemographics
LIMIT 5;

SELECT * 
FROM EmployeeDemographics
WHERE FirstName IN ('Jim', 'Michael');

CREATE TABLE WarehouseEmployeeDemographics
(
    EmployeeID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Age INT,
    Gender VARCHAR(50),
    JobTitle VARCHAR(50)
);

INSERT INTO WarehouseEmployeeDemographics (EmployeeID, FirstName, LastName, Age, Gender, JobTitle)
VALUES
(2001, 'Darryl', 'Philbin', 40, 'Male', 'Warehouse Manager'),
(2002, 'Roy', 'Anderson', 35, 'Male', 'Warehouse Associate'),
(2003, 'Lonny', 'Collins', 28, 'Male', 'Warehouse Worker'),
(2004, 'Val', 'Johnson', 30, 'Female', 'Warehouse Worker'),
(2005, 'Nate', 'Nickerson', 27, 'Male', 'Warehouse Worker'),
(2006, 'Glenn', '', 32, 'Male', 'Warehouse Worker'),
(2007, 'Hidetoshi', 'Hasagawa', 29, 'Male', 'Warehouse Worker'),
(2008, 'Matt', '', 31, 'Male', 'Warehouse Worker')
;

SELECT 
    FirstName, 
    LastName, 
    Age,  
    CASE
        WHEN Age > 30 THEN 'OLD'
        WHEN Age BETWEEN 27 AND 30 THEN 'YOUNG'
        ELSE 'BABY'   
    END AS GROUPIE
FROM EmployeeDemographics
WHERE Age IS NOT NULL
ORDER BY Age;

/*

Today's Topic: String Functions - TRIM, LTRIM, RTRIM, Replace, Substring, Upper, Lower

*/
use sqltutorials;

--Drop Table EmployeeErrors;


CREATE TABLE EmployeeErrors (
EmployeeID varchar(50)
,FirstName varchar(50)
,LastName varchar(50)
)

Insert into EmployeeErrors Values 
('1001  ', 'Jimbo', 'Halbert')
,('  1002', 'Pamela', 'Beasely')
,('1005', 'TOby', 'Flenderson - Fired');

Select *
From EmployeeErrors;

-- Using Trim, LTRIM, RTRIM

Select EmployeeID, TRIM(employeeID) AS IDTRIM
FROM EmployeeErrors ;

Select EmployeeID, RTRIM(employeeID) as IDRTRIM
FROM EmployeeErrors ;

Select EmployeeID, LTRIM(employeeID) as IDLTRIM
FROM EmployeeErrors ;



-- Using Replace

Select LastName, REPLACE(LastName, '- Fired', '') as LastNameFixed
FROM EmployeeErrors;


-- Using Substring

Select Substring(err.FirstName,1,3), Substring(dem.FirstName,1,3), Substring(err.LastName,1,3), Substring(dem.LastName,1,3)
FROM EmployeeErrors err
JOIN EmployeeDemographics dem
	on Substring(err.FirstName,1,3) = Substring(dem.FirstName,1,3)
	and Substring(err.LastName,1,3) = Substring(dem.LastName,1,3);



-- Using UPPER and lower

Select firstname, LOWER(firstname)
from EmployeeErrors;

Select Firstname, UPPER(FirstName)
from EmployeeErrors;

/*

Today's Topic: Stored Procedures

*/


DELIMITER $$

CREATE PROCEDURE Temp_Employee()
BEGIN
    -- Drop the temp table if it already exists
    DROP TEMPORARY TABLE IF EXISTS temp_employee;

    -- Create the temp table
    CREATE TEMPORARY TABLE temp_employee (
        JobTitle VARCHAR(100),
        EmployeesPerJob INT,
        AvgAge INT,
        AvgSalary INT
    );
END$$

DELIMITER ;


-- Insert data into the temporary table
CREATE TEMPORARY TABLE temp_employee (
        JobTitle VARCHAR(100),
        EmployeesPerJob INT,
        AvgAge INT,
        AvgSalary INT
    );
INSERT INTO temp_employee (JobTitle, EmployeesPerJob, AvgAge, AvgSalary)
SELECT 
    sal.JobTitle, 
    COUNT(sal.JobTitle), 
    AVG(emp.Age), 
    AVG(sal.Salary)
FROM EmployeeDemographics emp
JOIN EmployeeSalary sal
    ON emp.EmployeeID = sal.EmployeeID
GROUP BY sal.JobTitle;

-- Select from the temporary table
SELECT * 
FROM temp_employee;



DELIMITER $$
CREATE PROCEDURE Temp_Employee2 (IN JobTitle NVARCHAR(100))
BEGIN
    -- Drop the temporary table if it exists
    DROP TEMPORARY TABLE IF EXISTS temp_employee3;

    -- Create the temporary table
    CREATE TEMPORARY TABLE temp_employee3 (
        JobTitle VARCHAR(100),
        EmployeesPerJob INT,
        AvgAge INT,
        AvgSalary INT
    );

    -- Insert data into the temporary table
    INSERT INTO temp_employee3 (JobTitle, EmployeesPerJob, AvgAge, AvgSalary)
    SELECT 
        sal.JobTitle, 
        COUNT(sal.JobTitle), 
        AVG(emp.Age), 
        AVG(sal.Salary)
    FROM EmployeeDemographics emp
    JOIN EmployeeSalary sal
        ON emp.EmployeeID = sal.EmployeeID
    WHERE sal.JobTitle = JobTitle  -- Use the JobTitle parameter
    GROUP BY sal.JobTitle;

    -- Select the results
    SELECT * 
    FROM temp_employee3;
END $$

DELIMITER ;




CALL Temp_Employee2('Salesman');
CALL Temp_Employee2('Accountant');
