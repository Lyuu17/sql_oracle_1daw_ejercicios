--ej1
CREATE OR REPLACE PROCEDURE proc_ej1(p_codDepart NUMBER)
AS
    CURSOR c_cur1 IS SELECT APELLIDO, SALARIO, OFICIO FROM EMPLE WHERE DEPT_NO = p_codDepart;
    v_curRow c_cur1%ROWTYPE;
    v_rowCount NUMBER(4) DEFAULT 0;
    v_sumaSalarios NUMBER(7, 2) DEFAULT 0;
BEGIN
    OPEN c_cur1;
    LOOP
        FETCH c_cur1 INTO v_curRow;
        EXIT WHEN c_cur1%NOTFOUND;
        
        v_sumaSalarios := v_sumaSalarios + v_curRow.SALARIO;
        v_rowCount := v_rowCount + 1;
        
        dbms_output.put_line(v_curRow.APELLIDO || ', ' || v_curRow.SALARIO || ', ' || v_curRow.OFICIO);
    END LOOP;
    
    dbms_output.put_line('Total: ' || v_rowCount || ', suma salarios ' || v_sumaSalarios || '€');
    
    CLOSE c_cur1;
END;
/

EXECUTE proc_ej1(30);

--ej2
CREATE OR REPLACE PROCEDURE proc_ej2(p_oficio VARCHAR2, p_porcentaje NUMBER)
AS
    e_sinDatos EXCEPTION;
    e_porcentajeInvalido EXCEPTION;
    
    CURSOR c_cur1 IS SELECT * FROM EMPLE WHERE OFICIO = p_oficio;
    v_datosRow c_cur1%ROWTYPE;
BEGIN
    IF LENGTH(p_oficio) = 0 THEN
        RAISE e_sinDatos;
    END IF;
    
    IF p_porcentaje < 0 OR p_porcentaje > 100 THEN
        RAISE e_porcentajeInvalido;
    END IF;
    
    OPEN c_cur1;
    LOOP 
        FETCH c_cur1 INTO v_datosRow;
        EXIT WHEN c_cur1%NOTFOUND;
    
        dbms_output.put_line(v_datosRow.APELLIDO || ', ' || v_datosRow.SALARIO || ' -> ' || 
            (v_datosRow.SALARIO + (p_porcentaje * v_datosRow.SALARIO / 100)));
    END LOOP;
    
    CLOSE c_cur1;
EXCEPTION
    WHEN e_sinDatos THEN
        dbms_output.put_line('Faltan datos');
    WHEN e_porcentajeInvalido THEN
        dbms_output.put_line('Porcentaje inválido');
END;
/

EXECUTE proc_ej2('VENDEDOR', 100);

--ej3
CREATE OR REPLACE PROCEDURE proc_ej3(p_año1 NUMBER, p_año2 NUMBER)
AS
    e_año EXCEPTION;
    
    CURSOR c_c1 IS 
        SELECT APELLIDO, SALARIO FROM EMPLE WHERE TO_CHAR(FECHA_ALT, 'YYYY') BETWEEN p_año1 AND p_año2;
    v_curRow c_c1%ROWTYPE;
BEGIN
    IF p_año1 > p_año2 THEN
        RAISE e_año;
    END IF;
    
    IF p_año2 > TO_CHAR(SYSDATE, 'YYYY') THEN
        RAISE e_año;
    END IF;
    
    OPEN c_c1;
    LOOP
        FETCH c_c1 INTO v_curRow;
        EXIT WHEN c_c1%NOTFOUND;
        
        dbms_output.put_line(v_curRow.APELLIDO || ', ' || v_curRow.SALARIO || '€');
    END LOOP;
        
    CLOSE c_c1;
EXCEPTION 
    WHEN e_año THEN
        dbms_output.put_line('Año incorrecto');
END;
/

EXECUTE proc_ej3(2007, 2008);

--ej4
CREATE OR REPLACE PROCEDURE proc_ej4(p_numEmple NUMBER)
AS
    e_nEmpleMenor EXCEPTION;
    e_nEmpleMayor EXCEPTION;

    CURSOR c_c1 IS
        SELECT APELLIDO, SALARIO FROM EMPLE ORDER BY SALARIO DESC;

    v_curRow c_c1%ROWTYPE;

    v_numEmpleados NUMBER;
BEGIN
    IF p_numEmple < 1 THEN
        RAISE e_nEmpleMenor;
    END IF;

    SELECT COUNT(*) INTO v_numEmpleados FROM EMPLE;
    
     IF p_numEmple > v_numEmpleados THEN
        RAISE e_nEmpleMayor;
    END IF;
    
    OPEN c_c1;
    
    FOR i IN 1 .. p_numEmple LOOP
        FETCH c_c1 INTO v_curRow;
    
        dbms_output.put_line(v_curRow.APELLIDO || ', ' || v_curRow.SALARIO);
    END LOOP;
    
    CLOSE c_c1;
EXCEPTION
    WHEN e_nEmpleMenor THEN
        dbms_output.put_line('El nº de empleados pasado por parametro no puede ser menor a 1');
    WHEN e_nEmpleMayor THEN
        dbms_output.put_line('El nº de empleados pasado por parametro no puede ser mayor al nº de empleados de la tabla');
END;
/

EXECUTE proc_ej4(5);

--ej5
CREATE OR REPLACE PROCEDURE proc_ej5
AS
    CURSOR c_c1 IS
        SELECT DEPT_NO, MIN(SALARIO) "MIN", MAX(SALARIO) "MAX", COUNT(DEPT_NO) "TOTAL" FROM EMPLE 
        GROUP BY DEPT_NO;
    
    v_curRow c_c1%ROWTYPE;
BEGIN
    OPEN c_c1;
    
    LOOP 
        FETCH c_c1 INTO v_curRow;
        EXIT WHEN c_c1%NOTFOUND;
        
        dbms_output.put_line('Dept: ' || v_curRow.DEPT_NO || ', min: ' || v_curRow.MIN || '€, max: ' || v_curRow.MAX || '€, nºempleados: ' || v_curRow.TOTAL);
    END LOOP;
    
    CLOSE c_c1;
END;
/

EXECUTE proc_ej5();

--ej6
CREATE OR REPLACE PROCEDURE proc_ej6
AS
    CURSOR c_c1 IS
        SELECT MOTIVO, FH_VISITA, ANIMALES.NOMBRE "NOMBRE", DUENHOS.DNI "DNI", PRECIO FROM VISITAS
        JOIN ANIMALES ON ANIMALES.IDENT = VISITAS.IDENT_ANIMAL
        JOIN DUENHOS ON DUENHOS.DNI = ANIMALES.DNI_DUENHO
        ORDER BY MOTIVO, FH_VISITA;
    
    c_curRow c_c1%ROWTYPE;
BEGIN
    OPEN c_c1;
    
    LOOP
        FETCH c_c1 INTO c_curRow;
        EXIT WHEN c_c1%NOTFOUND;
        
        dbms_output.put_line(c_curRow.MOTIVO || ', ' || c_curRow.FH_VISITA || ', ' || c_curRow.NOMBRE ||
            ', ' || c_curRow.DNI || ', ' || c_curRow.PRECIO);
    END LOOP;
    
    CLOSE c_c1;
END;
/

EXECUTE proc_ej6();

--ej7 (NO NESTED CURSOR)
CREATE OR REPLACE FUNCTION BUSCAR_DNI(p_nombreDuenho VARCHAR2)
RETURN VARCHAR2
AS
    v_dni DUENHOS.DNI%TYPE;
BEGIN
    SELECT DNI INTO v_dni FROM DUENHOS WHERE UPPER(NOMBRE) LIKE '%' || UPPER(p_nombreDuenho) || '%' AND ROWNUM = 1;
    
    RETURN v_dni;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;
/

CREATE OR REPLACE PROCEDURE proc_ej7(p_nombreDuenho VARCHAR2)
AS
    CURSOR c_c1 IS
        SELECT DUENHOS.DNI "DNI", DUENHOS.NOMBRE "NOMBRE", DUENHOS.DIRECCION "DIRECCION", ANIMALES.IDENT "IDENT", ANIMALES.NOMBRE "A_NOMBRE", ANIMALES.ESPECIE "ESPECIE" FROM DUENHOS
        JOIN ANIMALES ON ANIMALES.DNI_DUENHO = DUENHOS.DNI;
        
    CURSOR c_c2(DNI ANIMALES.DNI_DUENHO%TYPE) IS
        SELECT IDENT, ANIMALES.NOMBRE "NOMBRE", ESPECIE, RAZA, FH_VISITA, VETERINARIOS.NOMBRE "VETNOM", MOTIVO, PRECIO FROM ANIMALES
        LEFT JOIN VISITAS ON VISITAS.IDENT_ANIMAL = ANIMALES.IDENT
        LEFT JOIN VETERINARIOS ON VETERINARIOS.NUMCOLEGIADO = VISITAS.NUMCOLEGIADO
        WHERE ANIMALES.DNI_DUENHO = DNI;

    v_dni DUENHOS.DNI%TYPE;
    
    v_curNoEncontrado c_c1%ROWTYPE;
    v_curEncontrado c_c2%ROWTYPE;
    
    v_totalVisitas NUMBER DEFAULT 0;
    v_sumaPrecioVisitas NUMBER DEFAULT 0;
    v_totalAnimales NUMBER DEFAULT 0;
BEGIN
    v_dni := BUSCAR_DNI(p_nombreDuenho);
    
    --si DNI es NULL
    IF v_dni IS NULL THEN
        OPEN c_c1;
        LOOP
            FETCH c_c1 INTO v_curNoEncontrado;
            EXIT WHEN c_c1%NOTFOUND;
        
            dbms_output.put_line('DNI: ' || v_curNoEncontrado.DNI || ', NOMBRE: ' || v_curNoEncontrado.NOMBRE || ', DIRECCION: ' || v_curNoEncontrado.DIRECCION);
            dbms_output.put_line('IDENT: ' || v_curNoEncontrado.IDENT || ', NOMBRE: ' || v_curNoEncontrado.A_NOMBRE || ', ESPECIE: ' || v_curNoEncontrado.ESPECIE);
        
        END LOOP;
        CLOSE c_c1;
    ELSE
        --mostrar por DNI
        OPEN c_c2(v_dni);
        LOOP
            FETCH c_c2 INTO v_curEncontrado;
            EXIT WHEN c_c2%NOTFOUND;
        
            dbms_output.put_line('IDENT: ' || v_curEncontrado.IDENT || ', NOMBRE: ' || v_curEncontrado.NOMBRE || ', ESPECIE: ' || v_curEncontrado.ESPECIE);
            dbms_output.put_line('Fecha y Hora Visita: ' || v_curEncontrado.FH_VISITA || ', NOMBRE VET: ' || v_curEncontrado.VETNOM || ', MOTIVO: ' || v_curEncontrado.MOTIVO);
        END LOOP;
        
        SELECT COUNT(ANIMALES.IDENT), COUNT(VISITAS.IDENT_ANIMAL), SUM(PRECIO) INTO v_totalAnimales, v_totalVisitas, v_sumaPrecioVisitas FROM VISITAS 
        RIGHT JOIN ANIMALES ON ANIMALES.IDENT = VISITAS.IDENT_ANIMAL
        WHERE ANIMALES.DNI_DUENHO = v_dni;
        
        dbms_output.put_line('Total visitas: ' || v_totalVisitas || ', suma total visitas: ' || v_sumaPrecioVisitas || '€');
        dbms_output.put_line('Total animales: ' || v_totalAnimales);
        
        CLOSE c_c2;
    END IF;

END;
/

EXECUTE proc_ej7('asd');

--ej7 (NESTED CURSOR y FOREACH)
CREATE OR REPLACE FUNCTION BUSCAR_DNI(p_nombreDuenho VARCHAR2)
RETURN VARCHAR2
AS
    v_dni DUENHOS.DNI%TYPE;
BEGIN
    SELECT DNI INTO v_dni FROM DUENHOS WHERE UPPER(NOMBRE) LIKE '%' || UPPER(p_nombreDuenho) || '%' AND ROWNUM = 1;
    
    RETURN v_dni;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;
/

CREATE OR REPLACE PROCEDURE proc_ej7(p_nombreDuenho VARCHAR2)
AS
    CURSOR c_getDueños IS
        SELECT DNI, NOMBRE, DIRECCION FROM DUENHOS;
    CURSOR c_getDueño(D DUENHOS.DNI%TYPE) IS
        SELECT DNI, NOMBRE, DIRECCION FROM DUENHOS WHERE DNI = D;

    CURSOR c_getAnimal(DNI ANIMALES.DNI_DUENHO%TYPE) IS
        SELECT IDENT, NOMBRE, ESPECIE
        FROM ANIMALES WHERE DNI_DUENHO = DNI;

    CURSOR c_getVisitas(I ANIMALES.DNI_DUENHO%TYPE) IS
        SELECT FH_VISITA, NOMBRE, MOTIVO, PRECIO FROM VISITAS
        LEFT JOIN VETERINARIOS ON VETERINARIOS.NUMCOLEGIADO = VISITAS.NUMCOLEGIADO
        WHERE IDENT_ANIMAL = I;

    v_dni DUENHOS.DNI%TYPE;
    
    v_totalVisitas NUMBER DEFAULT 0;
    v_sumaPrecioVisitas NUMBER DEFAULT 0;
    v_totalAnimales NUMBER DEFAULT 0;
BEGIN
    v_dni := BUSCAR_DNI(p_nombreDuenho);
    
    --si DNI es NULL
    IF v_dni IS NULL THEN
        FOR v_curDueño IN c_getDueños LOOP
            dbms_output.put_line('DNI: ' || v_curDueño.DNI || ', NOMBRE: ' || v_curDueño.NOMBRE || ', DIRECCION: ' || v_curDueño.DIRECCION);

            FOR v_curAnimales IN c_getAnimal(v_curDueño.DNI) LOOP
                dbms_output.put_line('IDENT: ' || v_curAnimales.IDENT || ', NOMBRE: ' || v_curAnimales.NOMBRE || ', ESPECIE: ' || v_curAnimales.ESPECIE);
            END LOOP;
        END LOOP;
    ELSE
        --mostrar por DNI
        FOR v_curDueño IN c_getDueño(v_dni) LOOP
            dbms_output.put_line('DNI: ' || v_curDueño.DNI || ', NOMBRE: ' || v_curDueño.NOMBRE || ', DIRECCION: ' || v_curDueño.DIRECCION);

            FOR v_curAnimales IN c_getAnimal(v_curDueño.DNI) LOOP
                dbms_output.put_line('IDENT: ' || v_curAnimales.IDENT || ', NOMBRE: ' || v_curAnimales.NOMBRE || ', ESPECIE: ' || v_curAnimales.ESPECIE);
                
                FOR v_curVisitas IN c_getVisitas(v_curAnimales.IDENT) LOOP
                    dbms_output.put_line('Fecha y Hora Visita: ' || v_curVisitas.FH_VISITA || ', NOMBRE VET: ' || v_curVisitas.NOMBRE || ', MOTIVO: ' || v_curVisitas.MOTIVO);
                END LOOP;
            END LOOP;
        END LOOP;
        
        SELECT COUNT(ANIMALES.IDENT), COUNT(VISITAS.IDENT_ANIMAL), SUM(PRECIO) INTO v_totalAnimales, v_totalVisitas, v_sumaPrecioVisitas FROM VISITAS 
        RIGHT JOIN ANIMALES ON ANIMALES.IDENT = VISITAS.IDENT_ANIMAL
        WHERE ANIMALES.DNI_DUENHO = v_dni;
        
        dbms_output.put_line('Total visitas: ' || v_totalVisitas || ', suma total visitas: ' || v_sumaPrecioVisitas || '€');
        dbms_output.put_line('Total animales: ' || v_totalAnimales);
    END IF;

END;
/

EXECUTE proc_ej7('asd');

--ej8
CREATE OR REPLACE PROCEDURE proc_ej8
AS
    CURSOR c_getFunciones IS
        SELECT FUNCION FROM MECANICOS
        GROUP BY FUNCION;
    
    CURSOR c_getMecanicoPorFuncion(FUNC MECANICOS.FUNCION%TYPE) IS
        SELECT NEMPLEADO, NOMBRE, TELEFONO FROM MECANICOS
        WHERE FUNCION = FUNC;
    
    CURSOR c_getArreglos(NEMPLE ARREGLOS.NEMPLEADO%TYPE) IS
        SELECT ARREGLOS.MATRICULA, CLIENTES_TALLER.NOMBRE "NOMBRE", IMPORTE, FECHA_ENTRADA, NVL(SYSDATE - FECHA_SALIDA, SYSDATE - FECHA_ENTRADA) "DIAS" FROM ARREGLOS
        JOIN COCHES_TALLER ON COCHES_TALLER.MATRICULA = ARREGLOS.MATRICULA
        JOIN CLIENTES_TALLER ON CLIENTES_TALLER.NCLIENTE = COCHES_TALLER.NCLIENTE
        WHERE NEMPLEADO = NEMPLE;

    v_curFunciones c_getFunciones%ROWTYPE;
    v_curMecanico c_getMecanicoPorFuncion%ROWTYPE;
    v_curArreglo c_getArreglos%ROWTYPE;
BEGIN
    OPEN c_getFunciones;
    LOOP
        FETCH c_getFunciones INTO v_curFunciones;
        EXIT WHEN c_getFunciones%NOTFOUND;
        
        dbms_output.put_line('FUNCION ' || v_curFunciones.FUNCION);
        
        OPEN c_getMecanicoPorFuncion(v_curFunciones.FUNCION);
        LOOP
            FETCH c_getMecanicoPorFuncion INTO v_curMecanico;
            EXIT WHEN c_getMecanicoPorFuncion%NOTFOUND;
            
            dbms_output.put_line('-- NOMBRE ' || v_curMecanico.NOMBRE || ', TLF: ' || v_curMecanico.TELEFONO);
            
            OPEN c_getArreglos(v_curMecanico.NEMPLEADO);
            LOOP
                FETCH c_getArreglos INTO v_curArreglo;
                EXIT WHEN c_getArreglos%NOTFOUND;
                
                dbms_output.put_line('---- MATRÍCULA: ' || v_curArreglo.MATRICULA || ', DUEÑO: ' || v_curArreglo.NOMBRE || ', IMPORTE: ' || v_curArreglo.IMPORTE || ', FECHA ENTRADA: ' || v_curArreglo.FECHA_ENTRADA || ', DÍAS: ' || v_curArreglo.DIAS);
            END LOOP;
            CLOSE c_getArreglos;
        END LOOP;
        CLOSE c_getMecanicoPorFuncion;
    END LOOP;
    CLOSE c_getFunciones;
END;
/

EXECUTE proc_ej8();

--ej9
CREATE OR REPLACE PROCEDURE proc_ej9
AS
    CURSOR c_getCoches IS
        SELECT MATRICULA, MODELO, ANHO_MATRICULA, NCLIENTE
        FROM COCHES_TALLER;
    CURSOR c_getArreglos(MAT ARREGLOS.MATRICULA%TYPE) IS
        SELECT NEMPLEADO, FECHA_ENTRADA, FECHA_SALIDA, IMPORTE, ROWNUM
        FROM ARREGLOS
        WHERE MATRICULA = MAT
        ORDER BY FECHA_ENTRADA
        FOR UPDATE;
        
    
    v_curCoches c_getCoches%ROWTYPE;
    v_curArreglos c_getArreglos%ROWTYPE;
BEGIN
    OPEN c_getCoches;
    LOOP
        FETCH c_getCoches INTO v_curCoches;
        EXIT WHEN c_getCoches%NOTFOUND;
        
        dbms_output.put_line('Matricula: ' || v_curCoches.MATRICULA || ', MODELO: ' || v_curCoches.MODELO || ', '  
            || v_curCoches.ANHO_MATRICULA || ', NCLIENTE: ' || v_curCoches.NCLIENTE);

        OPEN c_getArreglos(v_curCoches.MATRICULA);
        LOOP
            FETCH c_getArreglos INTO v_curArreglos;
            EXIT WHEN c_getArreglos%NOTFOUND;
            
            IF c_getArreglos%ROWCOUNT = v_curArreglos.ROWNUM THEN
                UPDATE ARREGLOS SET IMPORTE = IMPORTE - (10 * IMPORTE / 100) WHERE CURRENT OF c_getArreglos;
            END IF;
            
            dbms_output.put_line(' -- ' || v_curArreglos.FECHA_ENTRADA || ', salida: ' || v_curArreglos.FECHA_SALIDA || ', importe: ' || v_curArreglos.IMPORTE);
        END LOOP;
        CLOSE c_getArreglos;
    END LOOP;
    CLOSE c_getCoches;
END;
/

EXECUTE proc_ej9();

--EJ10
CREATE OR REPLACE PROCEDURE proc_ej10
AS
    CURSOR c_c1 IS
        SELECT CLIENTES_TALLER.NCLIENTE, CLIENTES_TALLER.NOMBRE, SUM(IMPORTE) "TOTAL"
        FROM CLIENTES_TALLER
        JOIN COCHES_TALLER ON COCHES_TALLER.NCLIENTE = CLIENTES_TALLER.NCLIENTE
        JOIN ARREGLOS ON ARREGLOS.MATRICULA = COCHES_TALLER.MATRICULA
        GROUP BY CLIENTES_TALLER.NCLIENTE, CLIENTES_TALLER.NOMBRE
        ORDER BY SUM(IMPORTE) DESC;
    p_curRow c_c1%ROWTYPE;
BEGIN
    OPEN c_c1;
    FOR i IN 1 .. 3 LOOP
        FETCH c_c1 INTO p_curRow;
        
        dbms_output.put_line('NCLIENTE: ' || p_curRow.NCLIENTE || ', NOMBRE: ' || p_curRow.NOMBRE || ', DINERO GASTADO: ' || p_curRow.TOTAL || '€');
    END LOOP;
    CLOSE c_c1;
END;
/

EXECUTE proc_ej10();

--EJ11
CREATE OR REPLACE FUNCTION Busca_Emple_Parque(NOMBRE VARCHAR2)
RETURN VARCHAR2
AS
    v_dni EMPLE_PARQUE.DNI_EMPLE%TYPE;
    v_averias NUMBER;
BEGIN
    SELECT DNI_EMPLE INTO v_dni FROM EMPLE_PARQUE WHERE UPPER(NOM_EMPLEADO) LIKE '%' || UPPER(NOMBRE) || '%';
    
    SELECT COUNT(*) INTO v_averias FROM AVERIAS_PARQUE WHERE DNI_EMPLE = v_dni;
    IF v_averias = 0 THEN
        RETURN '0';
    END IF;
    
    RETURN v_dni;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;
/

CREATE OR REPLACE PROCEDURE Mostrar_Averias_Emple(NOMBRE VARCHAR2)
AS
    CURSOR c_getAverias(DNI AVERIAS_PARQUE.DNI_EMPLE%TYPE) IS
        SELECT NOM_ATRACCION, TO_CHAR(FECHA_FALLA, 'DAY') "DIASEMANA" FROM AVERIAS_PARQUE
        JOIN ATRACCIONES ON ATRACCIONES.COD_ATRACCION = AVERIAS_PARQUE.COD_ATRACCION
        WHERE DNI_EMPLE = DNI;

    v_resultado AVERIAS_PARQUE.DNI_EMPLE%TYPE;
    
    v_averiasAcabadas NUMBER;
    v_averiasSinAcabar NUMBER;
    
    e_sinAverias EXCEPTION;
    e_noExiste EXCEPTION;
BEGIN
    v_resultado := Busca_Emple_Parque(NOMBRE);

    IF v_resultado = '0' THEN
        RAISE e_sinAverias;
    END IF;
    
    IF v_resultado IS NULL THEN
        RAISE e_noExiste;
    END IF;
    
    FOR v_curAverias IN c_getAverias(v_resultado) LOOP
        dbms_output.put_line('ATRACCIÓN NOMBRE: ' || v_curAverias.NOM_ATRACCION || ', DIA DE LA SEMANA: ' || v_curAverias.DIASEMANA);
    END LOOP;
    
    SELECT SUM(DECODE(FECHA_ARREGLO, NULL, 0, 1)) "ACABADAS", SUM(DECODE(FECHA_ARREGLO, NULL, 1, 0)) "SINACABAR" INTO v_averiasAcabadas, v_averiasSinAcabar
    FROM AVERIAS_PARQUE
    JOIN ATRACCIONES ON ATRACCIONES.COD_ATRACCION = AVERIAS_PARQUE.COD_ATRACCION
    WHERE DNI_EMPLE = v_resultado;
    
    dbms_output.put_line('ARREGLOS ACABADOS: ' || v_averiasAcabadas || ', ARREGLOS SIN ACABAR: ' || v_averiasSinAcabar);
    
EXCEPTION
    WHEN e_sinAverias THEN
        dbms_output.put_line('No tiene averías');
    WHEN e_noExiste THEN
        dbms_output.put_line('No existe el empleado');
END;
/

EXECUTE Mostrar_Averias_Emple('Luis Pérez');