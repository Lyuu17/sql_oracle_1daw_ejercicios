SELECT * FROM ALUM0405

SELECT DNI, NOMBRE, APELLIDOS, CURSO, NIVEL, CLASE FROM ALUM0405

SELECT * FROM ALUM0405 WHERE UPPER(POBLACION) = 'GUADALAJARA'

SELECT NOMBRE, APELLIDOS FROM ALUM0405 WHERE UPPER(POBLACION) = 'GUADALAJARA'

SELECT DNI, NOMBRE, APELLIDOS, CURSO, NIVEL, CLASE FROM ALUM0405 ORDER BY APELLIDOS, NOMBRE
SELECT DNI, NOMBRE, APELLIDOS, CURSO, NIVEL, CLASE FROM ALUM0405 ORDER BY 3, 2