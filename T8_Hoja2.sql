--ej1
CREATE OR REPLACE PROCEDURE precio_porcentaje (precio NUMBER, porcentaje NUMBER, resultado OUT NUMBER)
AS
BEGIN
    IF porcentaje < 0 AND porcentaje > 100 THEN
        dbms_output.put_line('error de porcentaje');
    ELSE
        resultado := (precio * porcentaje / 100) + precio;
    END IF;
END;

DECLARE
    resultado NUMBER(5, 2);
BEGIN
    precio_porcentaje(100, 100, resultado);
    dbms_output.Put_line(resultado);
END;
--ej2
CREATE OR REPLACE PROCEDURE numeros_pares (num1 NUMBER, num2 NUMBER)
AS
BEGIN
    FOR i IN num1 .. num2 LOOP
        IF MOD(i, 2) = 0 THEN
            dbms_output.put_line(i || ' es par');
        END IF;
    END LOOP;
END;

EXECUTE numeros_pares(1, 100);
--ej3
CREATE OR REPLACE PROCEDURE tabla_multiplicar (num NUMBER)
AS
BEGIN
    FOR i IN 0 .. 10 LOOP
        dbms_output.put_line(i || 'x' || num || '=' || (num*i));
    END LOOP;
END;

EXECUTE tabla_multiplicar(1);
--ej4
CREATE OR REPLACE FUNCTION fecha_numero(fecha DATE)
RETURN NUMBER
AS
BEGIN
    RETURN TO_NUMBER(TO_CHAR(fecha, 'YYYY'));
END;

EXECUTE dbms_output.put_line(fecha_numero('20/04/2006'));
--ej5
CREATE OR REPLACE FUNCTION numero_años(fecha1 DATE, fecha2 DATE)
RETURN NUMBER
AS
BEGIN
    RETURN TO_CHAR(fecha1, 'YYYY') - TO_CHAR(fecha2, 'YYYY');
END;

EXECUTE dbms_output.put_line(numero_años(SYSDATE, '1/1/2000'));
--ej6
CREATE OR REPLACE FUNCTION numero_años(fecha1 DATE, fecha2 DATE)
RETURN NUMBER
AS
BEGIN
    RETURN (TO_CHAR(fecha1, 'YYYY') - TO_CHAR(fecha2, 'YYYY')) / 3;
END;

EXECUTE dbms_output.put_line(numero_años(SYSDATE, '1/1/2000'));
--ej7
CREATE OR REPLACE FUNCTION funcion_ej7(cadena VARCHAR2)
RETURN VARCHAR2
AS
    tmp_cadena VARCHAR2(32) DEFAULT '';
BEGIN
    tmp_cadena := UPPER(cadena);
    tmp_cadena := REGEXP_REPLACE(tmp_cadena, '[^aA-zZ]', ' ');
    RETURN tmp_cadena;
END;

EXECUTE dbms_output.put_line(funcion_ej7('Caramelo'));
EXECUTE dbms_output.put_line(funcion_ej7('Ca%a6elo'));

--ej8
CREATE OR REPLACE FUNCTION func_ej8(p_apellido VARCHAR)
RETURN DATE
AS
    v_fecha DATE DEFAULT SYSDATE;
BEGIN
    SELECT FECHA_ALT INTO v_fecha FROM EMPLE WHERE EMPLE.APELLIDO = UPPER(p_apellido);
    RETURN v_fecha;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('No encontrado');

    RETURN NULL;
END;

EXECUTE dbms_output.put_line(func_ej8('SANCHEZ'));

--ej9
CREATE OR REPLACE PROCEDURE proc_ej9(p_apellido VARCHAR2, p_oficio VARCHAR2)
AS
    v_viejoOficio EMPLE.OFICIO%TYPE;
BEGIN

    SELECT OFICIO INTO v_viejoOficio FROM EMPLE WHERE APELLIDO = UPPER(p_apellido);
    UPDATE EMPLE SET OFICIO = UPPER(p_oficio) WHERE APELLIDO = UPPER(p_apellido);
    
    dbms_output.put_line('Empleado ' || p_apellido || ', oficio ' || v_viejoOficio || ' -> ' || p_oficio);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('No existe');
END;

EXECUTE proc_ej9('SANCHEZ', 'VENDEDOR');

--ej10
CREATE OR REPLACE PROCEDURE proc_ej10(p_deptno NUMBER)
AS
    v_salarioMaximo EMPLE.SALARIO%TYPE;
    v_salarioMinimo EMPLE.SALARIO%TYPE;
    v_salarioMedio EMPLE.SALARIO%TYPE;
    v_salidas NUMBER(1);
BEGIN
    SELECT COUNT(*), MAX(SALARIO), MIN(SALARIO), AVG(SALARIO) INTO v_salidas, v_salarioMaximo, v_salarioMinimo, v_salarioMedio FROM EMPLE
    WHERE DEPT_NO = p_deptno;
    
    IF v_salidas = 0 THEN
        RAISE NO_DATA_FOUND;
    END IF;

    dbms_output.put_line('Maximo: ' || v_salarioMaximo || '€, mínimo: ' || v_salarioMinimo || '€, medio: ' || v_salarioMedio || '€');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('No existe el depart');
END;

EXECUTE proc_ej10(-1);

--ej11
CREATE OR REPLACE PROCEDURE proc_ej11(p_titulo VARCHAR2)
AS
    v_codigo SERIE.SERIE_ID%TYPE;
BEGIN
    SELECT SERIE_ID INTO v_codigo FROM SERIE WHERE UPPER(SERIE_TITULO) LIKE '%' || UPPER(p_titulo) || '%';

    dbms_output.put_line('ID: ' || v_codigo);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('No encontrado');
    WHEN TOO_MANY_ROWS THEN
        dbms_output.put_line('Demasiados resultados');
END;

EXECUTE proc_ej11('The Killing'); -- error

EXECUTE proc_ej11('Borgen'); -- ok

--ej12
CREATE OR REPLACE PROCEDURE proc_ej12(p_serieId VARCHAR2)
AS
    v_totalCapitulos NUMBER(2) DEFAULT 0;
BEGIN
    SELECT COUNT(CAPITULO) INTO v_totalCapitulos 
    FROM CAPITULO
    WHERE SERIE_ID = p_serieId;

    dbms_output.put_line('Total capitulos: ' || v_totalCapitulos);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('La serie introducida no existe.');
END;

EXECUTE proc_ej12('MDRNF');

--ej13
CREATE OR REPLACE FUNCTION func_ej13(p_serieId VARCHAR2)
RETURN NUMBER
AS
    v_totalCapitulos NUMBER(2) DEFAULT 0;
BEGIN
    SELECT COUNT(CAPITULO) INTO v_totalCapitulos 
    FROM CAPITULO
    WHERE SERIE_ID = p_serieId;

    RETURN v_totalCapitulos;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN v_totalCapitulos;
END;

EXECUTE dbms_output.put_line(func_ej13('MDRNF'));

--ej14
CREATE OR REPLACE FUNCTION func_ej14(p_serieId VARCHAR2)
RETURN NUMBER
AS
    v_totalCapitulos NUMBER(2) DEFAULT 0;
BEGIN
    SELECT COUNT(CAPITULO) INTO v_totalCapitulos 
    FROM CAPITULO
    WHERE SERIE_ID = p_serieId;

    UPDATE SERIE SET CAPITULOS = v_totalCapitulos WHERE SERIE_ID = p_serieId;

    RETURN v_totalCapitulos;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN v_totalCapitulos;
END;

EXECUTE dbms_output.put_line(func_ej14('WWRLD'));
EXECUTE dbms_output.put_line(func_ej14('WWRLD'));

--ej15
CREATE OR REPLACE PROCEDURE proc_ej15(p_autorNombre VARCHAR2)
AS
    v_numPersonajes NUMBER(3, 0) DEFAULT 0;
BEGIN
    SELECT COUNT(*) INTO v_numPersonajes
    FROM REPARTO
    JOIN ACTOR ON ACTOR.ACTOR_ID = REPARTO.ACTOR_ID
    WHERE ACTOR.ACTOR_NOMBRE = p_autorNombre;
    
    dbms_output.put_line('Nº de personajes interpretados por ' || p_autorNombre || ': ' || v_numPersonajes);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Sin datos');
END;

EXECUTE proc_ej15('Sidse Babett Knudsen');
EXECUTE proc_ej15('Billy Campbell');

--ej16
CREATE OR REPLACE PROCEDURE proc_ej16(p_dept NUMBER, p_subidaSalarioPorcentaje NUMBER)
AS
    v_emple EMPLE.EMP_NO%TYPE;
BEGIN
    SELECT EMP_NO INTO v_emple FROM EMPLE WHERE SALARIO =
        (SELECT MIN(SALARIO) FROM EMPLE);
        
    UPDATE EMPLE SET SALARIO = SALARIO + (SALARIO * p_subidaSalarioPorcentaje / 100)
    WHERE EMP_NO = v_emple;

    -- falta: Validar
    -- que con ese porcentaje no supere la media del departamento, en cuyo caso no se
    -- modifica. 

    dbms_output.put_line('Salario actualizado al empleado ' || EMP_NO);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Departamento no encontrado');
END;

EXECUTE proc_ej16(20, 100);

--ej17
CREATE OR REPLACE PROCEDURE proc_ej17(p_numEmple NUMBER)
AS
    v_resultados NUMBER(1);
BEGIN
    SELECT COUNT(*) INTO v_resultados FROM EMPLE WHERE EMP_NO = p_numEmple;

    IF v_resultados = 0 THEN
        RAISE NO_DATA_FOUND;
    END IF;

    DELETE FROM EMPLE WHERE EMP_NO = p_numEmple;

    dbms_output.put_line('OK');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('No se encuentra con ese numero de empleado');
END;

EXECUTE proc_ej17(7369);

--ej18
CREATE OR REPLACE FUNCTION func_ej18 (p_nombreDept VARCHAR2)
RETURN NUMBER
AS
    v_numeroDept DEPART.DEPT_NO%TYPE;
BEGIN
    SELECT DEPT_NO INTO v_numeroDept FROM DEPART WHERE DNOMBRE = UPPER(p_nombreDept);
    RETURN v_numeroDept;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END;

CREATE OR REPLACE PROCEDURE proc_ej18 (p_nombreDept VARCHAR2, v_porcentaje NUMBER)
AS
    e_porcentaje_invalido EXCEPTION;
    e_numero_dept_invalido EXCEPTION;

    v_numeroDept DEPART.DEPT_NO%TYPE;
BEGIN
    IF v_porcentaje < 0 OR v_porcentaje > 100 THEN
        RAISE e_porcentaje_invalido;
    END IF;

    v_numeroDept := func_ej18(p_nombreDept);
    IF v_numeroDept = 0 THEN
        RAISE e_numero_dept_invalido;
    END IF;

    UPDATE EMPLE SET SALARIO = SALARIO + (SALARIO * v_porcentaje / 100)
    WHERE DEPT_NO = v_numeroDept AND 
        (SALARIO + (SALARIO * v_porcentaje / 100)) <= (SELECT SALARIO FROM EMPLE WHERE OFICIO = 'PRESIDENTE') AND
        OFICIO <> 'PRESIDENTE';

    dbms_output.put_line('OK');
EXCEPTION
    WHEN e_porcentaje_invalido THEN
        dbms_output.put_line('Porcentaje invalido');
    WHEN e_numero_dept_invalido THEN
        dbms_output.put_line('Numero de departamento no encontrado');
END;

--ej19

CREATE OR REPLACE FUNCTION func_BuscaMatricula(p_matricula VARCHAR2)
RETURN BOOLEAN
AS
    v_matricula COCHES_TALLER.MATRICULA%TYPE;
BEGIN
    SELECT MATRICULA INTO v_matricula FROM COCHES_TALLER WHERE 
        MATRICULA = p_matricula;

RETURN TRUE;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- 1234ABC
        IF LENGTH(p_matricula) != 8 THEN
            RETURN FALSE;
        END IF;

        FOR i IN 1 .. 4 LOOP
            IF (SUBSTR(p_matricula, i, 1) NOT BETWEEN '0' AND '9') THEN
                RETURN FALSE;
            END IF;
        END LOOP;

        FOR i IN 5 .. 8 LOOP
            IF (SUBSTR(p_matricula, i, 1) NOT BETWEEN 'A' AND 'Z') THEN
                RETURN FALSE;
            END IF;
        END LOOP;

        RETURN TRUE;
END;
/

CREATE OR REPLACE FUNCTION func_BuscaFuncion(p_funcion VARCHAR2)
RETURN NUMBER
AS
    v_nEmpleado MECANICOS.NEMPLEADO%TYPE;
    v_nEmpleadoMasAntiguo MECANICOS.NEMPLEADO%TYPE;
BEGIN
    SELECT NEMPLEADO INTO v_nEmpleadoMasAntiguo
    FROM MECANICOS
    WHERE FECHA_ING = (SELECT MIN(FECHA_ING) FROM MECANICOS);

    SELECT NEMPLEADO INTO v_nEmpleado 
    FROM MECANICOS WHERE FUNCION = p_funcion AND
    FECHA_ING = (SELECT MAX(FECHA_ING) FROM MECANICOS WHERE FUNCION = p_funcion);
    
    RETURN v_nEmpleado;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN v_nEmpleadoMasAntiguo;
    WHEN TOO_MANY_ROWS THEN
        --todo
END;
/

CREATE OR REPLACE PROCEDURE proc_ej19(p_indi CHAR, p_matricula VARCHAR2, p_funcion VARCHAR2, p_importe NUMBER)
AS
    v_matriculaExiste BOOLEAN;
    v_nEmpleado MECANICOS.NEMPLEADO%TYPE;
    v_matricula ARREGLOS.MATRICULA%TYPE;
    
    e_matriculaInvalida EXCEPTION;
BEGIN
    CASE p_indi
        WHEN 'A' THEN
            v_matriculaExiste := func_BuscaMatricula(p_matricula);
            IF v_matriculaExiste != TRUE THEN
                RAISE e_matriculaInvalida;
            END IF;
            
            v_nEmpleado := func_BuscaFuncion(p_funcion);

            INSERT INTO COCHES_TALLER VALUES (p_matricula, ' ', NULL, v_nEmpleado);
            INSERT INTO ARREGLOS VALUES (p_matricula, v_nEmpleado, SYSDATE, NULL, p_importe);
        WHEN 'T' THEN
            SELECT MATRICULA INTO v_matricula FROM ARREGLOS WHERE MATRICULA = p_matricula AND FECHA_SALIDA IS NULL;
            
            UPDATE ARREGLOS SET FECHA_SALIDA = SYSDATE, IMPORTE = p_importe WHERE MATRICULA = p_matricula;
    END CASE;
EXCEPTION
    WHEN e_matriculaInvalida THEN
        dbms_output.put_line('Matricula invalida');
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Matrícula no encontrada ');
    --todo: no case exception
END;
/

EXECUTE proc_ej19('A', '1235ABC', 'MECANICO', 100);

EXECUTE proc_ej19('T', '1234ABC', 'MECANICO', 200);

--ej20
CREATE OR REPLACE PROCEDURE PBORRA_AUTOR(p_autor NUMBER)
AS
    v_nombreAutor AUTORES.NOMBRE%TYPE;
BEGIN
    SELECT NOMBRE INTO v_nombreAutor FROM AUTORES WHERE idAutor = p_autor;

    DELETE FROM AUTORES CASCADE WHERE idAutor = p_autor;

    dbms_output.put_line('Autor borrado: ' || v_nombreAutor);
END;
/

EXECUTE PBORRA_AUTOR(3);

--ej21
DECLARE
    v_numAutor AUTORES.IDAUTOR%TYPE;
BEGIN
    PBORRA_AUTOR(&v_numAutor);
END;
/

--ej22
CREATE OR REPLACE FUNCTION FCUANTOS_LIBROS(p_numAutor NUMBER)
RETURN NUMBER
AS
    v_numLibros NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_numLibros FROM LIBROS WHERE IDAUTOR = p_numAutor;
    RETURN v_numLibros;
END;
/

--ej23
CREATE OR REPLACE FUNCTION FEXISTE_AUTOR(p_numAutor NUMBER)
RETURN BOOLEAN
AS
    v_numAutor AUTORES.IDAUTOR%TYPE;
BEGIN
    SELECT IDAUTOR INTO v_numAutor FROM AUTORES WHERE IDAUTOR = p_numAutor;
    RETURN TRUE;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN FALSE;
END;
/

--ej24
CREATE OR REPLACE PROCEDURE PINSERTA_LIBRO(p_titulo VARCHAR2, p_numPaginas NUMBER, p_idAutor NUMBER)
AS
    v_idLibro LIBROS.IDLIBRO%TYPE;

    e_noExisteAutor EXCEPTION;
BEGIN
    IF !FEXISTE_AUTOR(p_idAutor) THEN
        RAISE e_noExisteAutor;
    END IF;
    
    SELECT COUNT(*) INTO v_idLibro FROM LIBROS;

    INSERT INTO LIBROS VALUES (v_idLibro, p_titulo, p_numPaginas, SYSDATE, p_idAutor);
EXCEPTION
    WHEN e_noExisteAutor THEN
        dbms_output.put_line('No existe el autor.');
END;
/

--ej25
DECLARE
    v_titulo LIBROS.TITULO%TYPE;
    v_numPaginas LIBROS.NUMPAGINAS%TYPE;
    v_idAutor LIBROS.IDAUTOR%TYPE;
BEGIN
    PINSERTA_LIBRO('&v_titulo', &v_numPaginas, &v_idAutor);
END;
/

--ej26
CREATE OR REPLACE FUNCTION func_ej25(p_cadena VARCHAR2)
RETURN VARCHAR2
AS
    v_temp VARCHAR2(256);
BEGIN
    FOR i IN 1 .. LENGTH(p_cadena) LOOP
        v_temp := CONCAT(v_temp, SUBSTR(p_cadena, -i, 1));
    END LOOP;
    
    RETURN v_temp;
END;
/
EXECUTE dbms_output.put_line(func_ej25('123456'));

--ej27
CREATE OR REPLACE FUNCTION IS_NUMERIC(p_num VARCHAR2)
RETURN BOOLEAN
AS
    v_num NUMBER;
BEGIN
    v_num := TO_NUMBER(p_num);
    
    RETURN TRUE;
EXCEPTION
    WHEN OTHERS THEN
        RETURN FALSE;
END;
/

CREATE OR REPLACE FUNCTION BUSCA_ANIMAL(p_animal VARCHAR2)
RETURN VARCHAR2
AS
    v_idAnimal ANIMALES.IDENT%TYPE;
BEGIN
    IF IS_NUMERIC(p_animal) THEN
        --id
        SELECT IDENT INTO v_idAnimal FROM ANIMALES WHERE IDENT = p_animal;
    ELSE
        --nombre
        SELECT IDENT INTO v_idAnimal FROM ANIMALES WHERE NOMBRE = UPPER(p_animal);
    END IF;
    
    RETURN v_idAnimal;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Animal no encontrado');
    WHEN TOO_MANY_ROWS THEN
        dbms_output.put_line('Demasiados resultados');
END;
/

CREATE OR REPLACE FUNCTION BUSCA_VET(p_vet VARCHAR2)
RETURN NUMBER
AS
    v_numColegiado VETERINARIOS.NUMCOLEGIADO%TYPE;
BEGIN
    SELECT NUMCOLEGIADO INTO v_numColegiado FROM VETERINARIOS WHERE UPPER(NOMBRE) LIKE '%'||UPPER(p_vet)||'%';

    RETURN v_numColegiado;
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        SELECT MAX(NUMCOLEGIADO) INTO v_numColegiado FROM VETERINARIOS;
        RETURN v_numColegiado;
    WHEN NO_DATA_FOUND THEN
        SELECT MAX(NUMCOLEGIADO) INTO v_numColegiado FROM VETERINARIOS WHERE UPPER(NOMBRE) LIKE '%'||UPPER(p_vet)||'%';
        RETURN v_numColegiado;
END;
/

CREATE OR REPLACE PROCEDURE PEDIR_REVISION(p_animal VARCHAR2, p_veterinario VARCHAR2)
AS
    v_idAnimal ANIMALES.IDENT%TYPE;
    v_numColegiado VETERINARIOS.NUMCOLEGIADO%TYPE;
    
    e_faltanDatos EXCEPTION;
BEGIN
    IF LENGTH(p_animal) = 0 OR LENGTH(p_veterinario) = 0 THEN
        RAISE e_faltanDatos;
    END IF;

    v_idAnimal := BUSCA_ANIMAL(p_animal);
    v_numColegiado := BUSCA_VET(p_veterinario);
    
    INSERT INTO VISITAS VALUES (v_idAnimal, SYSDATE, v_numColegiado, 'REVISIÓN', NULL, NULL);

EXCEPTION
    WHEN e_faltanDatos THEN
        dbms_output.put_line('Faltan datos');
END;
/

EXECUTE PEDIR_REVISION('JUK', 'ANA GIL');