--ej1
CREATE OR REPLACE PROCEDURE Muestra_Zona_Nombre_Apellidos
AS
    CURSOR c_c1 IS
        SELECT NOM_ZONA, DNI_ENCARGADO FROM ZONAS ORDER BY NOM_ZONA ASC;
    CURSOR c_c2(nomZona ATRACCIONES.NOM_ZONA%TYPE) IS
        SELECT NOM_ATRACCION, FEC_INAUGURACION FROM ATRACCIONES WHERE NOM_ZONA = nomZona AND ROWNUM <= 3 ORDER BY FEC_INAUGURACION DESC;
        
    v_nombreEmple EMPLE_PARQUE.NOM_EMPLEADO%TYPE;
BEGIN
    FOR curZona IN c_c1 LOOP
        dbms_output.put_line('ZONA: ' || curZona.NOM_ZONA);
        
        SELECT NOM_EMPLEADO INTO v_nombreEmple 
        FROM EMPLE_PARQUE 
        WHERE DNI_EMPLE = curZona.DNI_ENCARGADO;
        
        dbms_output.put_line('NOMBRE DEL EMPLEADO ENCARGADO: ' || v_nombreEmple);
        
        dbms_output.put_line('ATRACCIONES: ');
        FOR curAtraccion IN c_c2(curZona.NOM_ZONA) LOOP
            dbms_output.put_line('  NOMBRE: ' || curAtraccion.NOM_ATRACCION);
            dbms_output.put_line('  FECHA INAUGURACIÓN: ' || TO_CHAR(curAtraccion.FEC_INAUGURACION, 'MM/YYYY'));
        END LOOP;
    END LOOP;
END;
/

EXECUTE Muestra_Zona_Nombre_Apellidos();

--ej2
CREATE OR REPLACE PROCEDURE proc_ej2
IS
    CURSOR c_precios IS
        SELECT PRODUCT_ID, MIN_PRICE FROM PRICE WHERE MIN_PRICE < 5 FOR UPDATE;
    v_productosActualizados NUMBER := 0;
BEGIN
    FOR curProductoPrecio IN c_precios LOOP
        UPDATE PRICE SET MIN_PRICE = MIN_PRICE + MIN_PRICE * 0.10 WHERE CURRENT OF c_precios;
            
        v_productosActualizados := v_productosActualizados + 1;
    END LOOP;
    
    dbms_output.put_line('Nº de productos actualizados: ' || v_productosActualizados);
END;
/

EXECUTE proc_ej2();

--ej3
CREATE OR REPLACE TRIGGER tgr_ej3
BEFORE INSERT OR UPDATE OF SALARY
ON EMPLOYEE
FOR EACH ROW
DECLARE
    v_salarioMaximo SALARY_GRADE.UPPER_BOUND%TYPE;
    v_salarioMinimo SALARY_GRADE.LOWER_BOUND%TYPE;
BEGIN
    SELECT UPPER_BOUND, LOWER_BOUND INTO v_salarioMaximo, v_salarioMinimo
    FROM SALARY_GRADE
    JOIN JOB ON JOB.GRADE_ID = SALARY_GRADE.GRADE_ID
    WHERE JOB_ID = :new.JOB_ID;
    
    IF :new.SALARY < v_salarioMinimo OR :new.SALARY > v_salarioMaximo THEN
        RAISE_APPLICATION_ERROR(-20000, 'No se puede asignar un salario por encima o por debajo del salario en función de su trabajo');
    END IF;
END;

--ej4
CREATE OR REPLACE TRIGGER tgr_ej4
INSTEAD OF INSERT OR DELETE OR UPDATE
ON VISTA_EXAMEN
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO DEPART VALUES (:new.NUMERO_DPT, :new.NOMBRE, :new.LOCALIDAD);
    ELSIF DELETING THEN
        DELETE FROM DEPART WHERE DEPT_NO = :old.NUMERO_DPT;
    ELSIF UPDATING('LOCALIDAD') THEN
        UPDATE DEPART SET LOC = :new.LOCALIDAD WHERE DEPT_NO = :new.NUMERO_DPT;
    ELSE
        RAISE_APPLICATION_ERROR(-20000, 'No está permitido');
    END IF;
END;