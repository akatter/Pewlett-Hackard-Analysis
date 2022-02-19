-- Creating initial retirement table

SELECT  e.emp_no,
		e.first_name,
		e.last_name,
		t.title,
		t.from_date,
		t.to_date
INTO retirement_titles
FROM employees AS e
    INNER JOIN titles AS t
        ON (e.emp_no = t.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;

-- Use Distinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title
INTO unique_titles
FROM retirement_titles
WHERE to_date = '9999-01-01'
ORDER BY emp_no, to_date DESC;

-- Retiring Titles Count
SELECT COUNT(title), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY COUNT(title) DESC;

--Task 2 mentorship program eligibility
SELECT DISTINCT ON(emp_no) e.emp_no,
		e.first_name,
		e.last_name,
		e.birth_date,
		de.from_date,
		de.to_date,
		t.title
INTO mentorship_eligibilty
FROM employees AS e
    INNER JOIN dept_emp AS de
        ON (e.emp_no = de.emp_no)
    INNER JOIN titles AS t
        ON e.emp_no = t.emp_no 
WHERE de.to_date = '9999-01-01'
	AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
--sort by employee number, to_date to get current position with distinct on
ORDER BY e.emp_no, de.to_date DESC;



-- Task 3 additional table 1 Mentorship Eligibility by Current Title
SELECT COUNT(title), title
INTO mentorship_title_count
FROM mentorship_eligibilty
GROUP BY title
ORDER BY COUNT(title) DESC;

--Task 3 additional table 1 mentorship retire comparison
SELECT rt.title, rt.count as "retiring count", mtc.count as "mentor count"
INTO mentorship_needs
FROM retiring_titles as rt
	LEFT JOIN mentorship_title_count as mtc
		ON rt.title = mtc.title
ORDER BY title

-- Task 3 additional table 2 - issues with managers in database
SELECT  d.dept_no,
		d.dept_name,
		e.emp_no,
		e.first_name,
		e.last_name,
		e.birth_date,
		m.from_date,
		m.to_date
INTO manager_issues
FROM departments AS d
    LEFT JOIN manager_info AS m
        ON (d.dept_no = m.dept_no)
	LEFT JOIN employees as e
		ON (m.emp_no = e.emp_no)
ORDER BY d.dept_no;
