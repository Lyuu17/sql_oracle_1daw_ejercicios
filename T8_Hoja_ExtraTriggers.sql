

--ej1
CREATE TABLE superpotencias AS
SELECT *
FROM pais
WHERE ((pib*1000000)/num_hab) >= 40000
ORDER BY pib/num_hab DESC;

CREATE OR REPLACE TRIGGER TRG_SUPERPOTENCIAS
AFTER INSERT OR UPDATE OR DELETE
ON pais
FOR EACH ROW
DECLARE
    v_paises NUMBER := 0;
BEGIN
    IF INSERTING THEN
        IF :new.PIB > 40000 THEN
            INSERT INTO SUPERPOTENCIAS VALUES 
                (:new.COD_PAIS, :new.NOMBRE, :new.CAPITAL, :new.EXTENSION,
                :new.MONEDA, :new.NUM_HAB, :new.PIB, :new.CONTINENTE);
        END IF;
    ELSIF UPDATING THEN
        SELECT COUNT(*) INTO v_paises FROM SUPERPOTENCIAS WHERE COD_PAIS = :new.COD_PAIS;
        IF v_paises = 1 THEN
            IF :new.PIB < 40000 THEN
                DELETE FROM SUPERPOTENCIAS WHERE COD_PAIS = :new.COD_PAIS;
            ELSE
                UPDATE SUPERPOTENCIAS SET COD_PAIS = :NEW.COD_PAIS, NOMBRE = :NEW.NOMBRE,
                    CAPITAL = :NEW.CAPITAL, EXTENSION = :NEW.EXTENSION,
                    MONEDA = :NEW.MONEDA, NUM_HAB = :NEW.NUM_HAB,
                    PIB = :NEW.PIB, CONTINENTE = :NEW.CONTINENTE
                    WHERE COD_PAIS = :OLD.COD_PAIS;
            END IF;
        ELSE
            INSERT INTO SUPERPOTENCIAS VALUES 
                (:new.COD_PAIS, :new.NOMBRE, :new.CAPITAL, :new.EXTENSION,
                :new.MONEDA, :new.NUM_HAB, :new.PIB, :new.CONTINENTE);
        END IF;
    ELSE
        DELETE FROM SUPERPOTENCIAS WHERE COD_PAIS = :new.COD_PAIS;
    END IF;
EXCEPTION
    WHEN dup_val_on_index THEN
        RAISE_APPLICATION_ERROR(-20000, 'error');
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'error no existe');
END;
/

--ej2
CREATE TABLE top_10_potencias_por_pib AS
SELECT cod_pais, nombre, pib, capital
FROM (SELECT cod_pais, nombre, pib, capital
FROM pais
WHERE pib IS NOT NULL
ORDER BY pib DESC)
WHERE ROWNUM<=10
ORDER BY ROWNUM DESC;

CREATE OR REPLACE TRIGGER TRG_PAIS_1
AFTER INSERT OR DELETE
ON PAIS
FOR EACH ROW
DECLARE
    v_potenciaConteo NUMBER := 0;

    CURSOR c_potencias IS
        SELECT ROWID, COD_PAIS, PIB FROM TOP_10_POTENCIAS_POR_PIB
        ORDER BY PIB ASC;
BEGIN
    IF INSERTING THEN
        FOR curRow IN c_potencias LOOP
            IF :new.PIB > curRow.PIB THEN
                INSERT INTO TOP_10_POTENCIAS_POR_PIB VALUES 
                    (:new.COD_PAIS, :new.NOMBRE, :new.PIB, :new.CAPITAL);
            
                DELETE FROM TOP_10_POTENCIAS_POR_PIB WHERE ROWID = curRow.ROWID;
            
                RETURN; 
            END IF;
        END LOOP;
    ELSE
        DELETE FROM TOP_10_POTENCIAS_POR_PIB WHERE COD_PAIS = :old.COD_PAIS;

        dbms_output.put_line('a');
        FOR curPais IN c_pais LOOP
            dbms_output.put_line('ba');

            SELECT COUNT(*) INTO v_potenciaConteo FROM TOP_10_POTENCIAS_POR_PIB
            WHERE COD_PAIS = curPais.COD_PAIS
            ORDER BY PIB ASC;
        
            IF v_potenciaConteo = 0 THEN
                INSERT INTO TOP_10_POTENCIAS_POR_PIB VALUES
                    (curPais.COD_PAIS, curPais.NOMBRE, curPais.PIB, curPais.CAPITAL);
            END IF;
        END LOOP;
    END IF;
END;

INSERT INTO PAIS VALUES (1000, 'test', null, null, null, null, 9999999, null);

DELETE FROM PAIS WHERE COD_PAIS = 1000;