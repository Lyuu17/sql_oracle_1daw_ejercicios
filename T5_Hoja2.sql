--Tablas Depart y Emple
--Ej1
SELECT * FROM EMPLE WHERE DEPT_NO = (SELECT DEPT_NO FROM EMPLE WHERE APELLIDO ='GIL');
--EJ2
SELECT * FROM EMPLE WHERE SALARIO >  (SELECT SALARIO FROM EMPLE WHERE APELLIDO='TOVAR');
--EJ3
SELECT * FROM EMPLE WHERE OFICIO = (SELECT OFICIO FROM EMPLE WHERE APELLIDO = 'MARTIN') OR SALARIO < (SELECT SALARIO FROM EMPLE WHERE APELLIDO = 'ALONSO');
--EJ4
SELECT APELLIDO,SALARIO FROM EMPLE WHERE DIR = (SELECT DIR FROM EMPLE WHERE APELLIDO='NEGRO');
--EJ5
SELECT * FROM EMPLE WHERE (OFICIO,SALARIO) = (SELECT OFICIO, SALARIO FROM EMPLE WHERE APELLIDO='GIL');
--Tablas Alumnos,Asignaturas,Notas
--EJ6
SELECT * FROM ALUMNOS WHERE POBLA = (SELECT POBLA FROM ALUMNOS WHERE UPPER(APENOM) LIKE '%LUIS');
--EJ7
SELECT NOMBRE FROM ASIGNATURAS WHERE COD IN (SELECT COD FROM NOTAS WHERE NOTA != 6 )
--EJ8
SELECT NOMBRE FROM ASIGNATURAS WHERE COD IN (SELECT COD FROM NOTAS WHERE NOTA>5)
--EJ9
SELECT APENOM FROM ALUMNOS WHERE POBLA='MADRID' AND DNI IN (SELECT DNI FROM NOTAS WHERE NOTA < 5)
--EJ10
SELECT APENOM FROM ALUMNOS WHERE DNI IN (SELECT DISTINCT DNI FROM NOTAS WHERE NOTA = (SELECT NOTA FROM NOTAS WHERE DNI = (SELECT DNI FROM ALUMNOS WHERE UPPER(APENOM) LIKE '%MARÍA') AND COD = (SELECT COD FROM ASIGNATURAS WHERE UPPER(NOMBRE) = 'MARCAS')))
--EJ11
SELECT APENOM FROM ALUMNOS WHERE DNI IN (SELECT DISTINCT DNI FROM NOTAS WHERE NOTA  = (SELECT NOTA FROM NOTAS WHERE DNI = (SELECT DNI FROM ALUMNOS WHERE UPPER(APENOM) LIKE '%LUIS') AND COD = (SELECT COD FROM ASIGNATURAS WHERE UPPER(NOMBRE) = 'PROGRAMACIÓN')) AND COD = (SELECT COD FROM ASIGNATURAS WHERE UPPER(NOMBRE) = 'PROGRAMACIÓN'))
--Tablas Zonas,Emple_Parque,Atracciones,Averias_Parque
--EJ12
SELECT NOM_ATRACCION FROM ATRACCIONES WHERE NOM_ZONA IN (SELECT NOM_ZONA FROM ATRACCIONES WHERE NOM_ZONA IN (SELECT NOM_ZONA FROM ZONAS WHERE UPPER(NOM_ATRACCION)='LEJANO OESTE'))
--EJ13
SELECT NOM_ATRACCION "ATRACCIONES NUNCA AVERIAS" FROM ATRACCIONES WHERE COD_ATRACCION NOT IN (SELECT COD_ATRACCION FROM AVERIAS_PARQUE);
--EJ14
SELECT NOM_ATRACCION "ATRACCIONES NO AVERIADAS" FROM ATRACCIONES WHERE COD_ATRACCION IN (SELECT COD_ATRACCION FROM AVERIAS_PARQUE WHERE Fecha_Arreglo IS NOT NULL)
--EJ15
SELECT * FROM EMPLE_PARQUE WHERE DNI_EMPLE IN(SELECT DNI_EMPLE FROM AVERIAS_PARQUE WHERE TO_CHAR(FECHA_ARREGLO, 'YYYY')!=2013)