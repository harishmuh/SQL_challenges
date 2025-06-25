-- Accessing the world database 
USE world;
SELECT * FROM country;

-- PROBLEM: Display country names and their populations for countries with populations 
-- greater than the average global population.

-- INVALID: WHERE clause cannot use aggregate functions directly
SELECT Name, Population
FROM country
WHERE Population > AVG(Population); -- ERROR

-- Step 1: Find the global average population
SELECT AVG(Population) AS Average_Population FROM Country;

-- Step 2: Display countries with population greater than average
SELECT Name, Population
FROM country
WHERE Population > 25434098.1172
ORDER BY Population;

-- Better with Subquery
SELECT Name, Population
FROM country
WHERE Population > (SELECT AVG(Population) FROM Country)
ORDER BY Population;

-- ------------------------------------------------------
-- Subqueries
-- -------------------------------------------------------
-- A subquery is a query within another query.

-- Basic Example:
-- SELECT column1, column2, ...
-- FROM table_name
-- WHERE column2 > (SELECT AGG_FUNCTION(column2) FROM table_name)

USE employees;
SHOW TABLES;
SELECT * FROM employees;

-- PROBLEM: Show all employees with the most recent birth date (youngest)

-- Step 1: Get latest birth_date
SELECT MAX(birth_date) FROM employees;

-- Step 2: Get employees born on that date
SELECT first_name, birth_date
FROM employees
WHERE birth_date = (SELECT MAX(birth_date) FROM employees);

-- PROBLEM: Show employees earning above average salary

-- Step 1: Get average salary
SELECT AVG(salary) FROM salaries;

-- Step 2: Get employees with salary above average
SELECT emp_no, salary 
FROM salaries
WHERE salary > (SELECT AVG(salary) FROM salaries);

-- ------------------------------------------------------
-- Subqueries as a list

-- PROBLEM: Show salary of employees whose first name starts with 'N'

-- Using Implicit Join
SELECT e.emp_no, s.salary 
FROM employees e, salaries s
WHERE e.emp_no = s.emp_no
AND e.first_name LIKE 'N%';

-- Using Subquery
SELECT emp_no, salary 
FROM salaries
WHERE emp_no IN (
    SELECT emp_no FROM employees
    WHERE first_name LIKE 'N%'
);

-- ------------------------------------------------------
-- Subquery in SELECT Clause

-- PROBLEM: Show emp_no, salary, avg_salary, min_salary, max_salary from the salaries table

SELECT 
    emp_no, 
    salary, 
    (SELECT AVG(salary) FROM salaries) AS avg_salary, 
    (SELECT MIN(salary) FROM salaries) AS min_salary, 
    (SELECT MAX(salary) FROM salaries) AS max_salary
FROM salaries;

-- ------------------------------------------------------
-- WORKING WITH MULTIPLE TABLES

-- PROBLEM: Show names of employees with the title "Senior Engineer"

-- Step 1: Get list of emp_no
SELECT emp_no FROM titles WHERE title='Senior Engineer';

-- Step 2: Get employee names
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM employees
WHERE emp_no IN (
    SELECT emp_no FROM titles WHERE title='Senior Engineer'
);

-- ------------------------------------------------------
-- RELATIONSHIP MODELS
-- PRIMARY KEY: Unique identifier of a table (e.g., emp_no in employees)
-- FOREIGN KEY: References a primary key in another table (e.g., emp_no in titles)
-- PARENT TABLE: The table with the primary key
-- DEPENDENT TABLE: The table with the foreign key

-- Relationship TYPES
-- One-to-One: One record in Table A = One in Table B
-- One-to-Many: One record in Table A = Many in Table B
-- Many-to-Many: Many records in Table A = Many in Table B (via junction table)


-- ------------------------------------------------------
-- JOIN TYPES
-- ------------------------------------------------------

---------------------------------------------------------
-- INNER JOIN
-- Merge employees and salaries using INNER JOIN and show all columns
SELECT *
FROM employees
JOIN salaries ON employees.emp_no = salaries.emp_no;

-- Show selected columns
SELECT employees.emp_no, employees.first_name, employees.last_name, salaries.salary
FROM employees
JOIN salaries ON employees.emp_no = salaries.emp_no;

-- With alias
SELECT e.emp_no, e.first_name, e.last_name, s.salary
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no;

-- PROBLEM: Show emp_no, name, salary for employees with salary > 150000
SELECT e.emp_no, first_name, last_name, salary, from_date
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
WHERE salary > 150000;

-- Show names of employees with title Senior Engineer
SELECT e.emp_no, e.first_name, e.last_name, t.title 
FROM employees e 
JOIN titles t ON e.emp_no = t.emp_no
WHERE title='Senior Engineer';

-- Join more than 2 tables: Show employee names and current department
SELECT e.emp_no, e.first_name, d.dept_no, d.dept_name 
FROM employees e
JOIN current_dept_emp cde ON e.emp_no = cde.emp_no
JOIN departments d ON cde.dept_no = d.dept_no;

------------------------------------------------------
-- IMPLICIT JOIN

-- Merge employees and salaries using WHERE clause
SELECT *
FROM employees e, salaries s
WHERE e.emp_no = s.emp_no;

-- PROBLEM: Show employees with salary > 150000 using implicit join
SELECT e.emp_no, first_name, last_name, salary, from_date
FROM employees e, salaries s
WHERE e.emp_no = s.emp_no AND salary > 150000;

-- Show employee names and current departments using implicit join
SELECT e.emp_no, e.first_name, d.dept_no, d.dept_name 
FROM employees e, current_dept_emp c, departments d
WHERE e.emp_no = c.emp_no AND c.dept_no = d.dept_no;


----------------------------------------------------------
-- Accessing Purwadhika

-- Sample tables for join types
USE purwadhika;

CREATE TABLE nama (
    ID INT,
    Nama VARCHAR(10)
);

INSERT INTO nama VALUES
(1, 'Rossi'), (2, 'Schumacher'), (3, 'Halland'), (4, 'Jordan'), (5, 'Leonardo');

CREATE TABLE profesi (
    ID INT,
    Profesi VARCHAR(20)
);

INSERT INTO profesi VALUES
(1, 'Racer'), (1, 'Entrepreneur'), (3, 'Footballer'), (4, 'Basketball Player'), (6, 'Singer');

------------------------------------------------------
-- LEFT JOIN

-- Show all names and their professions (if any)
SELECT *
FROM nama n
LEFT JOIN profesi p ON n.ID = p.ID;

-------------------------------------------------------
-- RIGHT JOIN
-- Show all professions and their associated names (if any)
SELECT *
FROM nama n
RIGHT JOIN profesi p ON n.ID = p.ID;

-------------------------------------------------------
-- FULL OUTER JOIN
-- Combine results of LEFT and RIGHT joins
SELECT *
FROM nama n
LEFT JOIN profesi p ON n.ID = p.ID
UNION
SELECT *
FROM nama n
RIGHT JOIN profesi p ON n.ID = p.ID;

-------------------------------------------------------
-- FULL OUTER JOIN
-- Combine results of LEFT and RIGHT joins
SELECT *
FROM nama n
LEFT JOIN profesi p ON n.ID = p.ID
UNION
SELECT *
FROM nama n
RIGHT JOIN profesi p ON n.ID = p.ID;

-------------------------------------------------------
-- SELF JOIN

-- Show employees who share the same birth date but are different people
USE employees;

SELECT 
    e1.first_name, e1.last_name, e1.birth_date,
    e2.first_name, e2.last_name, e2.birth_date
FROM employees e1, employees e2
WHERE e1.birth_date = e2.birth_date
AND e1.emp_no != e2.emp_no;
