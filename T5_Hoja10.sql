--ej1
SELECT SUM(COUNT(COMMISSION_PCT)) FROM EMPLOYEES
GROUP BY COMMISSION_PCT
--EJ2
SELECT TRUNC(AVG(LENGTH(COUNTRY_NAME))) FROM COUNTRIES
--EJ3
SELECT DEPARTMENT_ID, AVG(SALARY) FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
HAVING DEPARTMENT_ID IN (60)
--EJ4
SELECT MAX(SALARY), MIN(SALARY), MAX(SALARY) - MIN(SALARY) FROM EMPLOYEES
--EJ5
SELECT DEPARTMENT_ID, MAX(SALARY), MIN(SALARY), MAX(SALARY) - MIN(SALARY) FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
ORDER BY DEPARTMENT_ID
--EJ6
SELECT COUNT(*) FROM EMPLOYEES
WHERE SUBSTR(FIRST_NAME, 1, 1) IN ('A', 'E', 'I', 'O', 'U')
--EJ7
SELECT COUNT(*) FROM EMPLOYEES
WHERE SUBSTR(FIRST_NAME, 1, 1) NOT IN ('A', 'E', 'I', 'O', 'U')
--EJ9
SELECT COMMISSION_PCT, COUNT(*) FROM EMPLOYEES
GROUP BY COMMISSION_PCT
ORDER BY COMMISSION_PCT
--EJ10
SELECT REGION_ID FROM COUNTRIES
GROUP BY REGION_ID
--EJ11
SELECT REGION_ID, COUNT(*) FROM COUNTRIES
GROUP BY REGION_ID
HAVING COUNT(*) > 5
--EJ12
SELECT REGION_ID, COUNT(*) FROM COUNTRIES
GROUP BY REGION_ID
HAVING COUNT(*) = (
    SELECT MAX(COUNT(*)) FROM COUNTRIES
    GROUP BY REGION_ID)
--EJ13
SELECT COUNT(*) FROM EMPLOYEES WHERE 'CLERK' = SUBSTR(JOB_ID, -LENGTH('CLERK'), LENGTH('CLERK'))
--EJ14
SELECT JOB_ID, COUNT(*) FROM EMPLOYEES
GROUP BY JOB_ID
HAVING SUBSTR(JOB_ID, 4, LENGTH('CLERK')) = 'CLERK'
--EJ15
SELECT DEPARTMENT_ID, AVG(SALARY) FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
ORDER BY DEPARTMENT_ID
--EJ16
SELECT DEPARTMENT_ID, AVG(SALARY) FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
HAVING AVG(SALARY) > 7000
ORDER BY DEPARTMENT_ID
--EJ17
SELECT COUNT(COUNT(*))
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID 
HAVING AVG(SALARY) >7000
--
SELECT SUM(COUNT(DISTINCT(DEPARTMENT_ID)))
FROM EMPLOYEES 
GROUP BY DEPARTMENT_ID
HAVING AVG(SALARY)>7000
--EJ18
SELECT TRUNC(MIN(AVG(SALARY)))"SALARIO MEDIO +ALTO" FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
HAVING AVG(SALARY)>7000 