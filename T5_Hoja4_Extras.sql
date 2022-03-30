--USER HR--
--EJ1
SELECT department_id,department_name,city FROM DEPARTMENTS
JOIN LOCATIONS on departments.location_id = locations.location_id
--EJ2
SELECT department_id,department_name,city,country_name FROM DEPARTMENTS
JOIN LOCATIONS on departments.location_id = locations.location_id
JOIN COUNTRIES on locations.country_id = countries.country_id
--EJ3
SELECT department_id,department_name,city,country_name FROM DEPARTMENTS
JOIN LOCATIONS on departments.location_id = locations.location_id
JOIN COUNTRIES on locations.country_id = countries.country_id
WHERE upper(country_name)= 'UNITED STATES OF AMERICA'
--EJ4
SELECT first_name, last_name, job_title,start_date,end_date FROM EMPLOYEES
JOIN JOBS on employees.job_id = jobs.job_id
JOIN JOB_HISTORY on jobs.job_id = job_history.job_id
--EJ5
SELECT first_name, last_name, job_title,start_date,end_date,job_history.employee_id FROM EMPLOYEES
JOIN JOBS on employees.job_id = jobs.job_id
JOIN JOB_HISTORY on jobs.job_id = job_history.job_id
WHERE job_history.EMPLOYEE_ID >=2 order by EMPLOYEE_ID
--EJ6
SELECT first_name,last_name,departments.manager_id,department_name FROM EMPLOYEES
JOIN DEPARTMENTS on employees.department_id = departments.department_id
WHERE upper(department_name) = 'SALES' and departments.manager_id is not null
--EJ7
SELECT first_name,last_name,departments.manager_id,department_name,salary,max_salary FROM EMPLOYEES
JOIN DEPARTMENTS on employees.department_id = departments.department_id
JOIN JOBS on employees.job_id = jobs.job_id
WHERE salary=max_salary
--EJ9 IDK FOR THE MOMENT XD 
SELECT first_name,last_name,job_history.employee_idfrom EMPLOYESS
JOIN JOB_HISTORY on employees.employee_id = job_history.employee_id
WHERE manager_id =>5
--EJ10
SELECT first_name,last_name,region_name FROM EMPLOYEES
JOIN DEPARTMENTS on employees.department_id = departments.department_id
JOIN LOCATIONS on departments.location_id = locations.location_id
JOIN COUNTRIES on locations.country_id = countries.country_id
JOIN REGIONS on countries.region_id = regions.region_id
WHERE upper(regions.region_name)='EUROPE'
--EJ11
SELECT first_name,last_name,region_name,department_name FROM EMPLOYEES 
JOIN DEPARTMENTS on employees.department_id = departments.department_id
JOIN LOCATIONS on departments.location_id = locations.location_id
JOIN COUNTRIES on locations.country_id = countries.country_id
JOIN REGIONS on countries.region_id = regions.region_id
WHERE upper(regions.region_name)='EUROPE' AND upper(department_name) ='HUMAN RESOURCES'
--EJ12
SELECT sum(salary)"SUMA DE SALARIOS",country_name FROM EMPLOYEES 
JOIN DEPARTMENTS on employees.department_id = departments.department_id
JOIN LOCATIONS on departments.location_id = locations.location_id
JOIN COUNTRIES on locations.country_id = countries.country_id GROUP BY countries.country_name
--EJ13 IDK
SELECT sum(employees.commission_pct)"SUMA COMISIONES" ,departments.department_name FROM EMPLOYEES FULL
JOIN  DEPARTMENTS on employees.department_id = departments.department_id GROUP BY departments.department_name
WHERE (null)='0'
