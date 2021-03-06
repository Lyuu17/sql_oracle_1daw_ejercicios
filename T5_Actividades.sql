--act1
SELECT APELLIDO, OFICIO FROM EMPLE WHERE OFICIO = (SELECT OFICIO FROM EMPLE WHERE UPPER(APELLIDO) = 'JIMENEZ')

SELECT APELLIDO, OFICIO, SALARIO FROM EMPLE WHERE (DEPT_NO, SALARIO) = (SELECT DEPT_NO, SALARIO FROM EMPLE WHERE APELLIDO = 'FERNANDEZ')

--act2
--EJ TEMA 5 PÁGINA 52
SELECT APENOM FROM ALUMNOS 
JOIN NOTAS ON ALUMNOS.DNI = NOTAS.DNI 
JOIN ASIGNATURAS ON ASIGNATURAS.COD = NOTAS.COD 
WHERE UPPER(ASIGNATURAS.NOMBRE) = 'BBDD' AND NOTAS.NOTA BETWEEN 7 AND 8

--Act pagina 105
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