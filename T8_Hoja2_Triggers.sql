--ej1
DROP TABLE PAISES_SUPERPOBLADOS;

CREATE TABLE PAISES_SUPERPOBLADOS AS
SELECT cod_pais, nombre, num_hab, extension, num_hab/extension AS densidad
FROM pais
WHERE num_hab > 90000000

CREATE OR REPLACE TRIGGER TRG_SUPERPOBLACION
BEFORE INSERT OR DELETE OR UPDATE
ON PAIS
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        IF :new.num_hab > 90000000 THEN
            INSERT INTO PAISES_SUPERPOBLADOS VALUES
                (:new.COD_PAIS, :new.NOMBRE, :new.NUM_HAB, :new.EXTENSION, :new.NUM_HAB/:new.EXTENSION);
        END IF;
    ELSIF DELETING THEN
        DELETE FROM PAISES_SUPERPOBLADOS WHERE COD_PAIS = :old.COD_PAIS;
    ELSIF UPDATING THEN
        DECLARE
            v_codpais PAIS.COD_PAIS%TYPE;
        BEGIN
            SELECT COD_PAIS INTO v_codpais FROM PAISES_SUPERPOBLADOS WHERE COD_PAIS = :old.COD_PAIS;
            
            --si existe
            IF :new.NUM_HAB < 90000000 THEN
                DELETE FROM PAISES_SUPERPOBLADOS WHERE COD_PAIS = :old.COD_PAIS;
            ELSE
                UPDATE PAISES_SUPERPOBLADOS SET COD_PAIS = :new.COD_PAIS, NOMBRE = :new.NOMBRE,
                    NUM_HAB = :new.NUM_HAB, EXTENSION = :new.EXTENSION, DENSIDAD = :new.NUM_HAB/:new.EXTENSION
                    WHERE COD_PAIS = :old.COD_PAIS;
            END IF;
        EXCEPTION
            -- si no existe
            WHEN NO_DATA_FOUND THEN
                IF :new.NUM_HAB >= 90000000 THEN
                    INSERT INTO PAISES_SUPERPOBLADOS VALUES
                        (:new.COD_PAIS, :new.NOMBRE, :new.NUM_HAB, :new.EXTENSION, :new.NUM_HAB/:new.EXTENSION);
                END IF;
        END;
    END IF;
END;
/