INSERT INTO EMPLE 
SELECT 2000, 'SAAVEDRA', OFICIO, DIR, SYSDATE, SALARIO*20/100 + SALARIO, COMISION, DEPT_NO
FROM EMPLE
WHERE UPPER(APELLIDO)='SALA'