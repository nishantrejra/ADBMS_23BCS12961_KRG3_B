--easy question
/*
GENERATE AN EMPLOYEE RELATIN WITH ONLY A ONE ATTRIBUTE I.E, EMP_ID
TASK: DIND THE MAX EMP_ID, BUT EXCLUDING THE DUPLICATES
*/

-- Create new database
CREATE DATABASE exp4;
USE exp4;

---------------- EASY LEVEL ----------------
-- Employee table (with duplicate EmpIDs)
CREATE TABLE Employee (
    EmpID INT
);

INSERT INTO Employee (EmpID) VALUES
(101),
(101),
(102),
(102),
(105),
(105),
(106),
(107),
(108),
(108);

-- Find max EmpID excluding duplicates
SELECT MAX(EmpID) AS [MAX_UNIQUE] 
FROM Employee 
WHERE EmpID IN (
    SELECT EmpID FROM Employee 
    GROUP BY EmpID 
    HAVING COUNT(EmpID) = 1
);

-- Products
CREATE TABLE TBL_PRODUCTS (
    ID INT PRIMARY KEY IDENTITY,
    [NAME] NVARCHAR(50),
    [DESCRIPTION] NVARCHAR(250) 
);

CREATE TABLE TBL_PRODUCTSALES (
    ID INT PRIMARY KEY IDENTITY,
    PRODUCTID INT FOREIGN KEY REFERENCES TBL_PRODUCTS(ID),
    UNITPRICE INT,
    QUANTITYSOLD INT
);

-- Insert Products (Indian context)
INSERT INTO TBL_PRODUCTS VALUES ('Refrigerator','200L Double Door Refrigerator');
INSERT INTO TBL_PRODUCTS VALUES ('Laptop','Dell Inspiron Slim Laptop');
INSERT INTO TBL_PRODUCTS VALUES ('Mobile','Samsung Galaxy Smartphone');
INSERT INTO TBL_PRODUCTS VALUES ('Mixer','Philips Kitchen Mixer');

-- Insert Sales
INSERT INTO TBL_PRODUCTSALES VALUES (3,15000,5);
INSERT INTO TBL_PRODUCTSALES VALUES (2,35000,7);
INSERT INTO TBL_PRODUCTSALES VALUES (3,15000,4);
INSERT INTO TBL_PRODUCTSALES VALUES (3,15000,9);

-- Products not sold even once
SELECT ID,[NAME],[DESCRIPTION] 
FROM TBL_PRODUCTS 
WHERE ID NOT IN (
    SELECT DISTINCT PRODUCTID FROM TBL_PRODUCTSALES
);

-- Using LEFT JOIN
SELECT T.*,P.* 
FROM TBL_PRODUCTS AS T 
LEFT JOIN TBL_PRODUCTSALES AS P ON T.ID=P.PRODUCTID
WHERE PRODUCTID IS NULL;

-- Total quantity sold per product
SELECT T.NAME, 
       (SELECT SUM(QUANTITYSOLD) FROM TBL_PRODUCTSALES WHERE PRODUCTID=T.ID) AS QTY_SOLD 
FROM TBL_PRODUCTS AS T;


---------------- MEDIUM LEVEL ----------------
-- Department Table
CREATE TABLE department (
    id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

-- Employee Table
CREATE TABLE employee (
    id INT,
    name VARCHAR(50),
    salary INT,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES department(id)
);

-- Insert Departments
INSERT INTO department (id, dept_name) VALUES
(1, 'IT'),
(2, 'Sales');

-- Insert Employees (Indian names)
INSERT INTO employee (id, name, salary, department_id) VALUES
(1, 'Ramesh', 70000, 1),
(2, 'Suresh', 90000, 1),
(3, 'Priya', 80000, 2),
(4, 'Anita', 60000, 2),
(5, 'Vikas', 90000, 1);

-- Query: Highest salary per department
SELECT d.dept_name, e.name, e.salary 
FROM employee AS e
INNER JOIN department AS d ON d.id=e.department_id
WHERE e.salary IN (
    SELECT MAX(e2.salary) 
    FROM employee AS e2 
    WHERE e2.department_id=e.department_id
)
ORDER BY dept_name;

-- Alternative group by approach
SELECT d.dept_name, e.name, e.salary 
FROM employee AS e
INNER JOIN department AS d ON d.id=e.department_id
WHERE e.salary IN (
    SELECT MAX(e2.salary) 
    FROM employee AS e2 
    GROUP BY e2.department_id
);


---------------- HARD LEVEL ----------------
-- Table A
CREATE TABLE TableA (
    Empid INT,
    Ename VARCHAR(50),
    Salary INT
);

-- Table B
CREATE TABLE TableB (
    Empid INT,
    Ename VARCHAR(50),
    Salary INT
);

-- Insert Indian employees
INSERT INTO TableA VALUES 
(1, 'Amit', 1000), 
(2, 'Bhavesh', 300);

INSERT INTO TableB VALUES 
(2, 'Bhavesh', 400), 
(3, 'Chitra', 100);

-- Union and minimum salary
SELECT Empid, Ename, MIN(Salary) AS Salary 
FROM (
    SELECT * FROM TableA
    UNION ALL
    SELECT * FROM TableB
) AS INTERMIDIATE_RESULT
GROUP BY Empid, Ename;
