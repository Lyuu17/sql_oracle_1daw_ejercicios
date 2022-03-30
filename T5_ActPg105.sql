--Hoja 105
--EJ1
SELECT departments.department_id,departments.department_name, count(employee_id) FROM DEPARTMENTS 
JOIN EMPLOYEES ON departments.department_id = employees.department_id
group by departments.department_id,departments.department_name
having count(employee_id)>4
--EJ2
SELECT EMPLE.DEPT_NO, DNOMBRE, COUNT(*) FROM EMPLE
JOIN DEPART ON DEPART.DEPT_NO = EMPLE.DEPT_NO
GROUP BY EMPLE.DEPT_NO, DNOMBRE
HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM EMPLE GROUP BY DEPT_NO)