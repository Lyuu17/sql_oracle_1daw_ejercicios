--ej1
CREATE OR REPLACE VIEW DEPARTAM AS
    SELECT DEPT_NO, DNOMBRE, LOC, (SELECT COUNT(*) FROM EMPLE WHERE DEPT_NO = DEPART.DEPT_NO) "NEMPLEADOS"
    FROM DEPART;

CREATE OR REPLACE TRIGGER tgrsus_ej1
INSTEAD OF INSERT OR DELETE OR UPDATE
ON DEPARTAM
BEGIN
    IF INSERTING THEN
        INSERT INTO DEPART VALUES (:old.DEPT_NO, :old.DNOMBRE, :old.LOC);
    ELSIF DELETING THEN
        DELETE FROM DEPART WHERE DEPT_NO = :old.DEPT_NO;
    ELSIF UPDATING('LOC') THEN
        UPDATE DEPART SET LOC = :new.LOC WHERE DEPT_NO = :new.DEPT_NO;
    ELSE
        RAISE_APPLICATION_ERROR(-20000, 'ERROR');
    END IF;
END;
/

--ej2
CREATE OR REPLACE TRIGGER TRG_PAISES_EUROPA
INSTEAD OF INSERT OR DELETE OR UPDATE
ON paises_europa_vista
FOR EACH ROW
DECLARE
    v_ciudadMasPoblada CIUDAD.NOMBRE%TYPE;
    v_habCiudadMasPoblada PAIS.NUM_HAB%TYPE;
BEGIN
    IF INSERTING OR UPDATING THEN
        SELECT NOMBRE INTO v_ciudadMasPoblada FROM CIUDAD
        WHERE COD_PAIS = :new.COD_PAIS
        AND HABITANTES = (SELECT MAX(HABITANTES) FROM CIUDAD WHERE COD_PAIS=:new.COD_PAIS);
        
        SELECT HABITANTES INTO v_habCiudadMasPoblada FROM CIUDAD
        WHERE COD_PAIS = :new.COD_PAIS AND HABITANTES = (SELECT MAX(HABITANTES) FROM CIUDAD
        WHERE COD_PAIS = :new.COD_PAIS);
    END IF;

    IF INSERTING THEN
        INSERT INTO CIUDAD VALUES
            (:new.COD_PAIS, v_ciudadMasPoblada, v_habCiudadMasPoblada);
        INSERT INTO PAIS (COD_PAIS, NOMBRE, CAPITAL, NUM_HAB, CONTINENTE) VALUES 
            (:new.COD_PAIS, :new.NOMBRE, :new.CAPITAL, :new.DENSIDAD, 'Europa');
    ELSIF DELETING THEN
        DELETE FROM CIUDAD WHERE COD_PAIS = :old.COD_PAIS;
        
        DELETE FROM PAIS WHERE COD_PAIS = :old.COD_PAIS;
    ELSE
        UPDATE PAIS SET NOMBRE = :new.NOMBRE, CAPITAL = :new.CAPITAL, NUM_HAB = :new.DENSIDAD
            WHERE COD_PAIS = :old.COD_PAIS;
        UPDATE CIUDAD SET NOMBRE = v_ciudadMasPoblada, HABITANTES = v_habCiudadMasPoblada WHERE COD_PAIS = :old.COD_PAIS;
    END IF;
END;
/

--ej3
CREATE OR REPLACE TRIGGER TRG_ACTUALIZA_NUMCIUDADES
AFTER INSERT OR DELETE
ON ciudad
FOR EACH ROW
DECLARE
    v_numHab NUMBER DEFAULT 0;
BEGIN
    SELECT NUM_HAB INTO v_numHab FROM PAIS WHERE COD_PAIS = :new.COD_PAIS;

    IF v_numHab > 1000000 THEN
        IF INSERTING THEN
        
            UPDATE PAIS SET NUMCIUDADES = NUMCIUDADES + 1 WHERE COD_PAIS = :new.COD_PAIS;
        ELSE
            UPDATE PAIS SET NUMCIUDADES = NUMCIUDADES - 1 WHERE COD_PAIS = :new.COD_PAIS;
        END IF;
    END IF;
END;

--ej4
CREATE OR REPLACE TRIGGER TRG_CONTINENTES
AFTER INSERT
ON PAIS
FOR EACH ROW
DECLARE
    v_extension CONTINENTE_SUMMARY.EXTPAISGRANDE%TYPE;
    v_numHab CONTINENTE_SUMMARY.POBPAISMASPOBLADO%TYPE;
BEGIN
    SELECT EXTPAISGRANDE, POBPAISMASPOBLADO INTO v_extension, v_numHab 
    FROM CONTINENTE_SUMMARY;

    IF INSERTING THEN
        IF :new.EXTENSION > v_extension THEN
            UPDATE CONTINENTE_SUMMARY 
            SET PAISMASGRANDE = :new.NOMBRE, EXTPAISGRANDE = :new.EXTENSION 
            WHERE CONTINENTE = :new.CONTINENTE;
        END IF;
        
        IF :new.NUM_HAB > v_numHab THEN
            UPDATE CONTINENTE_SUMMARY 
            SET PAISMASPOBLADO = :new.NOMBRE, POBPAISMASPOBLADO = :new.NUM_HAB 
            WHERE CONTINENTE = :new.CONTINENTE;
        END IF;
    ELSIF UPDATING
        -- sin acabar
    ELSE
        -- sin acabar
    END IF;
END;
