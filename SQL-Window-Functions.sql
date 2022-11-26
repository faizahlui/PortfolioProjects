###############################################################
###############################################################
--  SQL Window Functions
###############################################################
###############################################################


-- Retrieve all the data in the project-db database
SELECT * FROM PortfolioProjects.dbo.employees
SELECT * FROM PortfolioProjects.dbo.departments;
SELECT * FROM PortfolioProjects.dbo.regions;
SELECT * FROM PortfolioProjects.dbo.customers;
SELECT * FROM PortfolioProjects.dbo.sales;

#############################
--ROW_NUMBER() and OVER() to assign numbers to each row
#############################

-- Assign numbers to each row of the departments table
SELECT *,
ROW_NUMBER() OVER(ORDER BY division) AS Row_Num
FROM PortfolioProjects.dbo.departments
ORDER BY Row_Num ASC


-- Assign numbers to each row of 
-- the department for the Entertainment division
SELECT *,
ROW_NUMBER() OVER(ORDER BY department ) AS Row_N
FROM PortfolioProjects.dbo.departments
WHERE division = 'Entertainment'
ORDER BY Row_N ASC;

#############################
--  ROW_NUMBER() - Part Two
-- assign numbers to each row using ROW_NUMBER() and OVER()
#############################

--  Retrieve all the data from the employees table
SELECT * FROM PortfolioProjects.dbo.employees;

--  Retrieve a list of employee_id, first_name, 
-- hire_date, and department of all employees in the sports
-- department ordered by the hire date
SELECT employee_id,first_name,hire_date,department,
ROW_NUMBER() OVER (ORDER BY hire_date) AS Row_num
FROM PortfolioProjects.dbo.employees
WHERE department='Sports'
ORDER BY Row_num ASC


--  Order by multiple columns
SELECT employee_id, first_name, hire_date, salary, department,
ROW_NUMBER() OVER (ORDER BY hire_date ASC , salary ASC) AS Row_num
FROM PortfolioProjects.dbo.employees 


-- Ordering in- and outside the OVER() clause
SELECT employee_id, first_name, hire_date, salary, department,
ROW_NUMBER() OVER(ORDER BY hire_date ASC, salary DESC) AS Row_N
FROM PortfolioProjects.dbo.employees 
WHERE department = 'Sports'
ORDER BY employee_id;


#############################
--  PARTITION BY
-- the PARTITION BY clause inside OVER()
#############################

--Retrieve the employee_id, first_name, 
-- hire_date of employees for different departments
SELECT employee_id, first_name,hire_date,department, 
ROW_NUMBER() OVER (PARTITION BY department ORDER BY department) AS Row_N
FROM PortfolioProjects.dbo.employees 
ORDER BY department ASC


-- Order by the hire_date
SELECT employee_id, first_name, department, hire_date,
ROW_NUMBER() OVER(PARTITION BY department ORDER BY hire_date) AS Row_N
FROM PortfolioProjects.dbo.employees 
ORDER BY department ASC;

#############################
--PARTITION BY with CTE
-- write a conditional statement using a single CASE clause
#############################

-- Retrieve all data from the sales and customers tables
SELECT * FROM PortfolioProjects.dbo.customers;
SELECT * FROM PortfolioProjects.dbo.sales;

-- Create a common table expression to retrieve the
-- customer_id, customer_name, segment and how many 
-- times the customer has purchased from the mall 
--Number each customer by how many purchases they've made
WITH customer_purchase AS (
	SELECT s.[Customer ID], c.[Customer Name], c.Segment,
	COUNT(*) AS purchase_count
	FROM PortfolioProjects.dbo.sales s
	JOIN PortfolioProjects.dbo.customers c
	ON s.[Customer ID] = c.[Customer ID]
	GROUP BY s.[Customer ID], c.[Customer Name], c.Segment)
SELECT *, 
ROW_NUMBER() OVER (PARTITION BY segment ORDER BY segment ASC,purchase_count) AS Row_N
FROM customer_purchase




#############################
-- Fetching: LEAD() & LAG()
-- fetch data using the LEAD() and LAG() clauses
#############################

-- Retrieve all employees first name, department, salary
-- and the salary after that employee
----LEAD allows to fetch data abover or below the current row
SELECT first_name,department,salary,
LEAD(salary) OVER (ORDER BY salary) next_salary
FROM PortfolioProjects.dbo.employees
 

-- Retrieve all employees first name, department, salary
-- and the salary before that employee
SELECT first_name,department,salary,
LAG(salary) OVER (ORDER BY salary) next_salary
FROM PortfolioProjects.dbo.employees
 

--Retrieve all employees first name, department, salary
-- and the salary after that employee in order of their salaries
SELECT first_name,department,salary,
LAG(salary) OVER (ORDER BY salary) next_salary
FROM PortfolioProjects.dbo.employees

-- What is the difference of the salaries? 
SELECT first_name,department,salary,
LEAD(salary) OVER (ORDER BY salary) AS next_salary, 
salary - LEAD(salary) OVER (ORDER BY salary DESC) AS salary_difference
FROM PortfolioProjects.dbo.employees

--  Retrieve all employees first name, department, salary
-- and the salary before that employee in order of their salaries in
-- descending order. Call the new column closest_higher_salary
SELECT first_name, department, salary,
LAG(salary) OVER (ORDER BY salary DESC) AS closest_higher_salary
FROM PortfolioProjects.dbo.employees

-- Retrieve all employees first name, department, salary
-- and the salary after that employee for each department in descending order
-- of their salaries. Call the new column closest_lowest_salary 
SELECT first_name, department, salary,
LEAD(salary) OVER (PARTITION BY department ORDER BY salary DESC) AS closest_lowest_salary
FROM PortfolioProjects.dbo.employees;

-- Return the first closest, second closest and third closest salary of the 'Clothing' department
SELECT first_name, department, salary,
LEAD(salary, 1) OVER (ORDER BY salary DESC) closest_salary,
LEAD(salary, 2) OVER (ORDER BY salary DESC) next_closest_salary,
LEAD(salary, 3) OVER (ORDER BY salary DESC) third_closest_salary
FROM PortfolioProjects.dbo.employees
WHERE department = 'Clothing';

#############################
-- FIRST_VALUE() - Part One
--  use the FIRST_VALUE() clause with the OVER() clause
#############################

-- Retrieve the first_name, last_name, department, and 
-- hire_date of all employees. Add a new column called first_emp_date 
-- that returns the hire date of the first hired employee
SELECT first_name, last_name, department, hire_date,
FIRST_VALUE(hire_date) OVER (ORDER BY department) AS first_emp_date
FROM PortfolioProjects.dbo.employees

-- Find the difference between the hire date of the first employee
-- hired and every other employees
SELECT *, DATEDIFF(DAY,first_emp_date , hire_date) AS hiredate_diff
FROM (
SELECT first_name, last_name, department, hire_date,
FIRST_VALUE(hire_date) OVER (ORDER BY hire_date) AS first_emp_date
FROM PortfolioProjects.dbo.employees)  AS a
ORDER BY hire_date

--  Partition by department
SELECT first_name, last_name, department, hire_date,
FIRST_VALUE(hire_date) OVER (PARTITION BY department
					 ORDER BY hire_date) AS first_emp_date
FROM PortfolioProjects.dbo.employees;

--  Find the difference between the hire date of the 
-- first employee hired and every other employees partitioned by department
SELECT *, DATEDIFF(day,first_emp_date,hire_date) AS hiredate_diff
FROM (
SELECT first_name, last_name, department, hire_date,
FIRST_VALUE(hire_date) OVER (PARTITION BY department
							 ORDER BY hire_date) AS first_emp_date
FROM PortfolioProjects.dbo.employees) a
ORDER BY department;

#############################
-- FIRST_VALUE() - Part Two
-- use the FIRST_VALUE() clause with the OVER() clause
#############################

--  Return the first salary for different departments
-- Order by the salary in descending order
SELECT first_name, email, department, salary,
FIRST_VALUE(salary) OVER(PARTITION BY department
						 ORDER BY salary DESC) first_salary
FROM PortfolioProjects.dbo.employees;

-- OR
SELECT first_name, email, department, salary,
MAX(salary) OVER(PARTITION BY department
				 ORDER BY salary DESC) first_salary
FROM PortfolioProjects.dbo.employees;

--  Return the first salary for different departments
-- Order by the first_name in ascending order
SELECT first_name, email, department, salary, 
FIRST_VALUE(salary) OVER (PARTITION BY department 
							ORDER BY first_name ASC)
FROM PortfolioProjects.dbo.employees;



-- Return the fifth salary for different departments
-- Order by the first_name in ascending order
SELECT first_name, email, department, salary, 
lead(salary,4) OVER (PARTITION BY department 
							ORDER BY first_name ASC) AS fifth_salary
FROM PortfolioProjects.dbo.employees




