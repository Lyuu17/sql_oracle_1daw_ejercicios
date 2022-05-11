--ej1
CREATE OR REPLACE FUNCTION BUSCAR_CLIENTE(p_nombre CLIENTES.NOMBRE%TYPE)
RETURN VARCHAR2
AS
    v_nif CLIENTES.NIF%TYPE;
BEGIN
    SELECT NIF INTO v_nif FROM CLIENTES WHERE UPPER(NOMBRE) LIKE '%' || UPPER(p_nombre) || '%';
    RETURN v_nif;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;
/

CREATE OR REPLACE FUNCTION BUSCAR_SUCURSAL(p_numSucursal SUCURSALES.NUM_SUCURSAL%TYPE, p_nif CUENTAS.NIF_TITULAR%TYPE)
RETURN NUMBER
AS
    v_numSucursal SUCURSALES.NUM_SUCURSAL%TYPE;
    v_nif CUENTAS.NIF_TITULAR%TYPE;
    
    v_numSucursalDirector SUCURSALES.NUM_SUCURSAL%TYPE;
BEGIN
    SELECT NUM_SUCURSAL INTO v_numSucursalDirector FROM SUCURSALES
    WHERE UPPER(DIRECTOR) LIKE '%ANTONIO%';

    SELECT NUM_SUCURSAL INTO v_numSucursal FROM SUCURSALES WHERE NUM_SUCURSAL = p_numSucursal;
    RETURN v_numSucursal;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        BEGIN
            SELECT CUENTAS.NUM_SUCURSAL INTO v_numSucursal FROM SUCURSALES
            JOIN CUENTAS ON CUENTAS.NUM_SUCURSAL = SUCURSALES.NUM_SUCURSAL
            WHERE CUENTAS.FECHA_ABIERTA = (SELECT MAX(CUENTAS.FECHA_ABIERTA) FROM CUENTAS WHERE NIF_TITULAR = p_nif);
            
            EXCEPTION WHEN NO_DATA_FOUND THEN
                BEGIN
                    SELECT CUENTAS.NIF_TITULAR INTO v_nif FROM CUENTAS WHERE NIF_TITULAR = p_nif;
                    RETURN v_nif;
                EXCEPTION WHEN NO_DATA_FOUND THEN
                    RETURN v_numSucursalDirector;
                END;    
        END;
        RETURN v_numSucursal;
END;
/

CREATE OR REPLACE PROCEDURE ALTA_CUENTA(p_nombreTitular CLIENTES.NOMBRE%TYPE, p_nombreCoTitular CLIENTES.NOMBRE%TYPE,
                                        p_tipoCuenta CUENTAS.TIPO%TYPE, p_saldo CUENTAS.SALDO%TYPE, 
                                        p_numSucursal CUENTAS.NUM_SUCURSAL%TYPE)
AS
    e_error EXCEPTION;
    
    v_nifTitular CLIENTES.NIF%TYPE;
    v_nifCoTitular CLIENTES.NIF%TYPE;
    
    v_numSucursal CUENTAS.NUM_SUCURSAL%TYPE;
    v_numCuenta CUENTAS.NUM_CUENTA%TYPE;
    v_tipoCuenta CUENTAS.TIPO%TYPE;
    v_saldo CUENTAS.SALDO%TYPE;
BEGIN
    IF p_nombreTitular = NULL THEN
        dbms_output.put_line('ERROR: El NOMBRE TITULAR introducido es NULO');
        RAISE e_error;
    END IF;
    
    IF p_tipoCuenta = NULL THEN
        dbms_output.put_line('ERROR: El TIPO CUENTA introducido es NULO');
        RAISE e_error;
    END IF;
    
    
    IF p_saldo IS NULL THEN
        dbms_output.put_line('ERROR: El SALDO introducido es NULO');
        RAISE e_error;
    END IF;
    
    v_saldo := p_saldo;
    v_tipoCuenta := UPPER(p_tipoCuenta);
    CASE p_tipoCuenta
        WHEN 'C' THEN
            IF p_saldo < 50 THEN
                dbms_output.put_line('ERROR: El SALDO introducido para CUENTA C es MENOR a 50'); 
                RAISE e_error;
            END IF;
        WHEN 'P' THEN
            IF p_saldo < 1000 THEN
                dbms_output.put_line('ERROR: El SALDO introducido para CUENTA P es MENOR a 1000');
                RAISE e_error;
            END IF;
            
            v_saldo := v_saldo * -1;
        WHEN 'F' THEN
            IF p_saldo < 1000 THEN
                dbms_output.put_line('ERROR: El SALDO introducido para CUENTA F es MENOR a 1000');
                RAISE e_error;
            END IF;
        ELSE
            dbms_output.put_line('ERROR: El TIPO CUENTA introducido es debe ser "C", "P" o "F"');
            
            RAISE e_error;
    END CASE;
    
    v_nifTitular := BUSCAR_CLIENTE(p_nombreTitular);
    IF v_nifTitular IS NULL THEN
        dbms_output.put_line('ERROR: El NOMBRE TITULAR introducido NO EXISTE en la TABLA CUENTAS');
        RAISE e_error;
    END IF;
    
    IF p_nombreCoTitular IS NOT NULL THEN
        v_nifCoTitular := BUSCAR_CLIENTE(p_nombreCoTitular);
    END IF;
    
    v_numSucursal := BUSCAR_SUCURSAL(p_numSucursal, v_nifTitular);
    
    SELECT (NUM_CUENTA + 100) INTO v_numCuenta FROM CUENTAS
    WHERE NUM_CUENTA = (SELECT MAX(NUM_CUENTA) FROM CUENTAS);
    
    INSERT INTO CUENTAS VALUES (v_numCuenta, v_nifTitular, v_nifCoTitular, SYSDATE, v_numSucursal, v_tipoCuenta, p_saldo, 'A');
    
    IF v_tipoCuenta = 'C' OR v_tipoCuenta = 'F' THEN
        INSERT INTO MOVIMIENTOS VALUES (v_numCuenta, SYSDATE, 50, 'PROMOCION PRIMAVERA');
        UPDATE CUENTAS SET SALDO = SALDO + 50 WHERE NUM_CUENTA = v_numCuenta;
    END IF;
    
    dbms_output.put_line('OK');
EXCEPTION
    WHEN e_error THEN
        dbms_output.put_line('');
END;
/

EXECUTE ALTA_CUENTA('ALBA REYES', 'aaaaaa', 'F', 1000, NULL);

--ej2
CREATE OR REPLACE VIEW Ej2_Nombre_Apellidos AS 
    SELECT CUENTAS.NUM_CUENTA, NOMBRE, DECODE(COUNT(MOVIMIENTOS.NUM_CUENTA), 0, 'No tiene movimientos', TO_CHAR(COUNT(MOVIMIENTOS.NUM_CUENTA))) "NUMERO_MOVIMIENTOS", NVL(SUM(MOVIMIENTOS.IMPORTE), 0) "IMPORTE_TOTAL"  FROM CUENTAS
    JOIN CLIENTES ON CLIENTES.NIF = CUENTAS.NIF_TITULAR
    LEFT JOIN MOVIMIENTOS ON MOVIMIENTOS.NUM_CUENTA = CUENTAS.NUM_CUENTA
    GROUP BY CUENTAS.NUM_CUENTA, NOMBRE
    HAVING COUNT(MOVIMIENTOS.NUM_CUENTA) <= 5;

--EJ3
CREATE USER EXAMEN IDENTIFIED BY EXAMEN
DEFAULT TABLESPACE USERS
QUOTA 2M ON USERS;

CREATE ROLE ROL_EXAMEN;
GRANT INSERT, SELECT ON CUENTAS TO ROL_EXAMEN;
GRANT INSERT, SELECT ON SUCURSALES TO ROL_EXAMEN;
GRANT CREATE TABLE, CREATE VIEW, CONNECT TO ROL_EXAMEN;
GRANT ROL_EXAMEN TO EXAMEN;

CREATE PROFILE PERFIL_EXAMEN LIMIT SESSIONS_PER_USER 3 IDLE_TIME 5 CONNECT_TIME 180;

ALTER USER EXAMEN PROFILE PERFIL_EXAMEN;