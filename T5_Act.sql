SELECT APELLIDO, OFICIO FROM EMPLE WHERE OFICIO = (SELECT OFICIO FROM EMPLE WHERE UPPER(APELLIDO) = 'JIMENEZ')

SELECT APELLIDO, OFICIO, SALARIO FROM EMPLE WHERE (DEPT_NO, SALARIO) = (SELECT DEPT_NO, SALARIO FROM EMPLE WHERE APELLIDO = 'FERNANDEZ')