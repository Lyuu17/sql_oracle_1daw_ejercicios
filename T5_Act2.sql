--EJ TEMA 5 PÁGINA 52
SELECT APENOM FROM ALUMNOS 
JOIN NOTAS ON ALUMNOS.DNI = NOTAS.DNI 
JOIN ASIGNATURAS ON ASIGNATURAS.COD = NOTAS.COD 
WHERE UPPER(ASIGNATURAS.NOMBRE) = 'BBDD' AND NOTAS.NOTA BETWEEN 7 AND 8