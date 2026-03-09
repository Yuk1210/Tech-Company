-- Single Table Assignments
-- 1. Find the employee number for employees named MARTIN.
SELECT employee_number
FROM employees
WHERE employee_name = 'MARTIN';

-- 2. Find the employee(s) with a salary greater than 1500.
SELECT *
FROM employees
WHERE salary > 1500;

-- 3. List the names of salesmen that earn more than 1300.
SELECT employee_name
FROM employees
WHERE job_title = 'salesman'
AND salary > 1300;

-- 4. List the names of employees that are not salesmen.
SELECT employee_name
FROM employees
WHERE job_title != 'salesman';

-- 5. List the names of all clerks together with their salary with a deduction of 10%.
SELECT employee_name, salary * 0.9 AS salary_after_deduction
FROM employees
WHERE job_title = 'clerk';

-- 6. Find the name of employees hired before May 1981.
SELECT employee_name
FROM employees
WHERE hire_date < '1981-05-01';

-- 7. List employees sorted by salary in descending order (i.e. highest salary first).
SELECT *
FROM employees
ORDER BY salary DESC;

-- 8. List departments sorted by location.
SELECT *
FROM departments
ORDER BY office_location;

-- 9. Find name of the department located in New York.
SELECT department_name
FROM departments
WHERE office_location = 'new york';

-- 10. You have proven your worth at the company. Your colleague comes to you trying to remember what's-his-name. It starts with a J and ends with S. Can you help her?
SELECT employee_name
FROM employees
Where employee_name LIKE 'J%S';

-- 11. Maybe that wasn't helpful. "Oh yeah, I remember now!" they say and tell you that he is a manager.
SELECT employee_name
FROM employees
Where employee_name LIKE 'J%S'
AND job_title = 'manager';

-- 12. How many employees are there in each department?
SELECT department_number, COUNT(*) AS number_of_employees
FROM employees
GROUP BY department_number;

-- Aggregate functions
-- 1. For the first assignment, take on the hat of a Data Analyst. You've been tasked to create a summary of interesting data.
-- ???? is it a question or information for the next part of the assignment

-- 2. List the number of employees.
SELECT COUNT(*) AS number_of_employees
FROM employees;

-- 3. List the sum of all salaries (excluding commission which are bonuses added to the base salaries).
SELECT SUM(salary) AS total_salary
FROM employees;

-- 4. List the average salary for employees in department 20.
SELECT AVG(salary) AS average_salary
FROM employees
WHERE department_number = 20;

-- 5. List the unique job titles in the company.
SELECT DISTINCT job_title
FROM employees;

-- 6. List the number of employees in each department.
SELECT department_number, COUNT(*) AS number_of_employees
FROM employees
GROUP BY department_number;

-- 7. List in decreasing order the maximum salary in each department together with the department number.
SELECT department_number, MAX(salary) AS max_salary
FROM employees
GROUP BY department_number
ORDER BY max_salary DESC;

-- 8. List total sum of salary and commission for all employees.
SELECT SUM(salary + IFNULL(commission,0)) AS total_compensation
FROM employees;

-- 9. Subquery time! Select the name and salary of employees whose salary is above average: WHERE salary > (SELECT AVG(salary) FROM employees).
SELECT employee_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- JOIN Assignments
-- 1. Create an INNER JOIN between employees and departments to get the department name for each employee. Show all columns.
SELECT *
FROM employees
INNER JOIN departments
ON employees.department_number = departments.department_number;

-- 2. Continue from the last task. Show two columns. The employee_name and their corresponding department_name. Oh, and can you sort them alphabetically (A-Z)?
SELECT employees.employee_name, departments.department_name
FROM employees
INNER JOIN departments
ON employees.department_number = departments.department_number
ORDER BY employees.employee_name ASC;

-- 3. Now is the time to make a LEFT JOIN. Let's look at employee_name and department_name only. There is one more person this time who didn't show in the previous query. Who is it and why?
SELECT employees.employee_name, departments.department_name
FROM employees
LEFT JOIN departments
ON employees.department_number = departments.department_number;
-- King Is the extra, and it's because his department_number is NULL, So he does not match a department

-- 4. Consider this query:
SELECT departments.department_name, COUNT(employees.employee_number)
FROM employees
JOIN departments
ON departments.department_number = employees.department_number
GROUP BY department_name;
-- One department is missing. Which one and why?
-- The missing department is Operations, because no employees belong to it

-- 5. To get the missing department change the previous query to use a RIGHT JOIN.
SELECT departments.department_name, COUNT(employees.employee_number)
FROM employees
RIGHT JOIN departments
ON departments.department_number = employees.department_number
GROUP BY departments.department_name;

-- 6. SCOTT sends you this query and asks you to run it. In order to assess whether it is information that SCOTT is privy to, you must first understand it. Describe in technical terms what this query does:
SELECT *
FROM employees employee
JOIN employees manager
ON employee.manager_id = manager.employee_number
ORDER BY employee.employee_name;
-- It joins the employees table with itself to match employees with their managers

-- 7. Get two columns: employees and their managers.
SELECT employee.employee_name AS employee, manager.employee_name AS manager
FROM employees employee
JOIN employees manager
ON employee.manager_id = manager.employee_number;

-- 8. Use the HAVING keyword (feel free to look it up) to show the departments with more than 3 employees. The as number_of_employees is so that you can reference the value later on in the query:
SELECT employees.department_number, COUNT(department_number) as number_of_employees
FROM employees
GROUP BY department_number
HAVING number_of_employees > 3;

-- Join Table (Many-to-many)
-- 1. Create a new table called leaders and insert rows into it.
CREATE TABLE leaders (
leader_id INT PRIMARY KEY,
leader_name VARCHAR(30)
);

INSERT INTO leaders (leader_id, leader_name) VALUES (1, 'JOHNSEN');
INSERT INTO leaders (leader_id, leader_name) VALUES (2, 'DAVIS');
INSERT INTO leaders (leader_id, leader_name) VALUES (3, 'WILSON');

-- 2. Create a new table called employees_leaders that should link the employees and leaders tables. This is called a join table. It will enable you to create a many-to-many relationship between employees and leaders (a leader can manage multiple employees and an employee can have multiple leaders). Try to figure it out yourself, otherwise here is the solution:
CREATE TABLE employees_leaders (
employee_number INT,
leader_number INT,
PRIMARY KEY (employee_number, leader_number),
FOREIGN KEY (employee_number) REFERENCES employees(employee_number),
FOREIGN KEY (leader_number) REFERENCES leaders(leader_id));

-- 3. Create rows in employees_leaders that link employees to their respective leaders.
INSERT INTO employees_leaders VALUES (7369, 1);
INSERT INTO employees_leaders VALUES (7499, 1);
INSERT INTO employees_leaders VALUES (7521, 2);
INSERT INTO employees_leaders VALUES (7566, 2);
INSERT INTO employees_leaders VALUES (7654, 3);

-- 4. Create a many-to-many query between employees and leaders. It requires two JOIN statements. First you select from employees, then you join with employees_leaders, and finally you join again with leaders.
SELECT employees.employee_name,
leaders.leader_name
FROM employees
JOIN employees_leaders
ON employees.employee_number = employees_leaders.employee_number
JOIN leaders

ON employees_leaders.leader_number = leaders.leader_id;
