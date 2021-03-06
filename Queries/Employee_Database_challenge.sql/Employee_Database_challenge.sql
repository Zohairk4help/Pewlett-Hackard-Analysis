SELECT from_date, to_date, emp_no
FROM salaries
WHERE salary BETWEEN '30000' AND '40000';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1970-01-01' AND '1970-12-31';

-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;
-- section module 7 [7.3.2]
DROP TABLE retirement_info;
-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

-- Joining departments and dept_manager tables section 7.3.3 inner join
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

-- Joining retirement_info and dept_emp tables from [7.3.3]
SELECT retirement_info.emp_no,
    retirement_info.first_name,
retirement_info.last_name,
    dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;


-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
    retirement_info.first_name,
retirement_info.last_name,
    dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

-- droped the dept_emp as there were no values in the previos one.
DROP TABLE dept_emp CASCADE; 
-- created the new dept_emp as there were no values in the previos one.
CREATE TABLE dept_emp (
emp_no INT NOT NULL,
dept_no VARCHAR NOT NULL,
from_date DATE NOT NULL,
to_date DATE NOT NULL, 
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no), 
PRIMARY KEY (emp_no, dept_no)
);
-- using short form of the sme code of joining:
SELECT ri.emp_no,
    ri.first_name,
ri.last_name,
    de.to_date
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;

-- Joining departments and dept_manager tables in short hand notaton:
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

-- creating the table 'current_emp' after the creation of joined list from the 2 tables;
SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- sec 7.3.4 count, orderby and groupby for joined table separate the employees into their departments;
-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

-- Employee count by department number in a new table; current_emp_dept-numbers
SELECT COUNT(ce.emp_no), de.dept_no
INTO current_emp_deptnumbers
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM salaries
ORDER BY to_date DESC;

-- sec 7.3.5 [creation of new temp table]
SELECT emp_no,
    first_name,
last_name,
    gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

DROP TABLE emp_info;

-- using shorthand notations that's why it was dropped: sth wrong with salary column
SELECT e.emp_no,
    e.first_name,
e.last_name,
    e.gender,
    s.salary,
    de.to_date
-- INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	 AND (de.to_date = '9999-01-01');
	 
-- sect 7.3.5 list 2 table creation
-- List of managers per department reveals only 5 results! why? table hasnot created.
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
-- INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);
		
-- creation or filtering of the tables using mulitple tables in List 3: Department Retirees
-- sth wrong with :a few folks are are appearing twice.
SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name
-- INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

-- sect 7.3.6  going to create tailored lists b/c of the problems in 7.3.5:
-- Create a query that will return only the information relevant to the Sales team
d007
SELECT ri.emp_no,
ri.first_name,
ri.last_name,
d.dept_name  gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');









--  challenge work: DELIVERABLE 1:The Number of Retiring Employees by Title
-- steps 1-2:
SELECT emp_no, first_name, last_name FROM employees;
SELECT titles, from_date, to_date FROM titles;

-- Create a new table using the INTO clause. Join both tables on the primary key.
SELECT employees.emp_no,
	 employees.first_name,
     employees.last_name,
	 titles.titles,
     titles.to_date,
     titles.from_date
INTO retirement_titles
FROM employees
INNER JOIN titles
ON employees.emp_no = titles.emp_no
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY employees.emp_no;

-- step 8 to 14: Use Dictinct with Orderby to remove duplicate rows
SELECT emp_no, first_name, last_name, titles FROM retirement_titles;


SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
titles
INTO unique_titles
FROM retirement_titles
ORDER BY emp_no, to_date DESC;

-- step 15:Number of employees retiring by their most recent titles
SELECT COUNT(titles)
FROM unique_titles;
-- step 16 to 21: grouping the titles
SELECT COUNT(ut.titles), ut.titles
INTO retiring_titles
FROM unique_titles as ut
GROUP BY ut.titles
ORDER BY COUNT(ut.titles) desc;


-- DELIVERABLE 2: The Employees Eligible for the Mentorship Program
-- steps 1-3:
SELECT emp_no, first_name, last_name, birth_date FROM employees;
SELECT from_date, to_date FROM dept_emp;
SELECT titles FROM titles;

-- steps 4-11 Create a new table using the INTO clause. Join both tables on the primary key.

SELECT em.emp_no,
	 em.first_name,
     em.last_name,
	 em.birth_date,
	 t.titles,
     de.from_date,
	 de.to_date
INTO BLABLAtbles
FROM employees AS em
INNER JOIN titles AS t
ON em.emp_no = t.emp_no
INNER JOIN dept_emp AS de
ON em.emp_no = de.emp_no;


SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
birth_date,
titles,
from_date,
to_date
INTO mentorship_eligibilty
FROM blablatbles
WHERE (birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY emp_no;

-- :Number of eligiuble employees retiring by their most recent titles
SELECT COUNT(titles)
FROM mentorship_eligibilty;
-- step 16 to 21: grouping the titles
SELECT COUNT(me.titles), me.titles
INTO mentoretiring_eligtitles
FROM mentorship_eligibilty as me
GROUP BY me.titles
ORDER BY COUNT(me.titles) desc;





