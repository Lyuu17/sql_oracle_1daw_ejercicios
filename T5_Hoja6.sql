--EJ10 IDK--
SELECT APENOM,NOTA,NOMBRE FROM ALUMNOS
JOIN NOTAS ON NOTAS.DNI = ALUMNOS.DNI
JOIN ASIGNATURAS ON NOTAS.COD = ASIGNATURAS.COD
WHERE UPPER(asignaturas.nombre) ='BBDD' AND NOTA = (SELECT MIN(NOTA) FROM NOTAS WHERE UPPER(asignaturas.nombre)='BBDD')
--EJ11
SELECT DISTINCT NOTA FROM NOTAS 
JOIN ASIGNATURAS ON NOTAS.COD=ASIGNATURAS.COD
WHERE UPPER(NOMBRE)='MARCAS'
--TABLAS ZONAS,EMPLE,PARQUE_ATRACCIONES,AVERIAS_PARQUE
--EJ12 FALTA EL FUCKING COUNT SUS MUERTOS XD
SSELECT NOM_EMPLEADO,FECHA_ARREGLO,COD_ATRACCION FROM EMPLE_PARQUE
JOIN AVERIAS_PARQUE ON EMPLE_PARQUE.DNI_EMPLE = AVERIAS_PARQUE.DNI_EMPLE
WHERE UPPER(NOM_EMPLEADO)='IGNACIO PEÑA' AND FECHA_ARREGLO IN (SELECT (FECHA_ARREGLO) FROM AVERIAS_PARQUE WHERE UPPER(NOM_EMPLEADO)='IGNACIO PEÑA' AND FECHA_ARREGLO IS NOT NULL)
--EJ13
SELECT COUNT(COD_ATRACCION) FROM ATRACCIONES
JOIN ZONAS ON ATRACCIONES.NOM_ZONA = ZONAS.NOM_ZONA
WHERE UPPER(ZONAS.NOM_ZONA)='GRAN MAQUINARIA'
SELECT COUNT(COD_ATRACCION) "AVERIAS" FROM AVERIAS_PARQUE
JOIN ZONAS ON ATRACCIONES.NOM_ZONA = ZONAS.NOM_ZONA
WHERE UPPER(ZONAS.NOM_ZONA)='GRAN MAQUINARIA'
--EJ14
SELECT COUNT(COD_ATRACCION) "AVERIAS" FROM AVERIAS_PARQUE
JOIN ZONAS ON ATRACCIONES.NOM_ZONA = ZONAS.NOM_ZONA
JOIN ATRACCIONES ON AVERIAS_PARQUE.COD_ATRACCION = ATRACCIONES.COD_ATRACCION
WHERE UPPER(ZONAS.NOM_ZONA)='GRAN MAQUINARIA'
--EJ15
SELECT AVERIAS_PARQUE.COD_ATRACCION,NOM_ATRACCION,FECHA_FALLA "ULTIMA_AVERIA" FROM AVERIAS_PARQUE 
JOIN ATRACCIONES ON ATRACCIONES.COD_ATRACCION = AVERIAS_PARQUE.COD_ATRACCION
WHERE FECHA_FALLA = (SELECT MAX(FECHA_FALLA) FROM AVERIAS_PARQUE)
--EJ16
SELECT AVERIAS_PARQUE.COD_ATRACCION,NOM_ATRACCION,COSTE_AVERIA "MÁXIMO COSTE" FROM AVERIAS_PARQUE
JOIN ATRACCIONES ON ATRACCIONES.COD_ATRACCION = AVERIAS_PARQUE.COD_ATRACCION
WHERE COSTE_AVERIA = (SELECT MAX(COSTE_AVERIA) FROM AVERIAS_PARQUE)