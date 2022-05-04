--ej1
CREATE OR REPLACE TRIGGER tgr_ej1
AFTER UPDATE OF salario
ON EMPLE
FOR EACH ROW
WHEN (:new.salario*5/100 + :new.salario) > :old.salario
DECLARE
BEGIN
    INSERT INTO auditaremple VALUES (SYSDATE || '*' || :old.apellido || '*' || :old.salario || '*' || :new.salario);
END;
/

--ej2
CREATE OR REPLACE TRIGGER tgr_ej2
AFTER INSERT OR DELETE
ON EMPLE
FOR EACH ROW
DECLARE
    v_op VARCHAR(9) DEFAULT '';
BEGIN
    IF INSERTING THEN
        v_op := 'INSERCIÓN';
    ELSIF DELETING THEN
        v_op := 'BORRADO';
    END IF;

    INSERT INTO auditaremple VALUES (SYSDATE || '*' || :old.emp_no || '*' || :old.apellido || '*' || v_op);
END;

--ej3
CREATE OR REPLACE TRIGGER tgr_ej3
BEFORE UPDATE OF SALARY
ON EMPLOYEES
FOR EACH ROW
WHEN :old.salary > :new.salary
DECLARE
BEGIN
    RAISE_APPLICATION_ERROR(-20001, 'No se puede reducir el salario');
END;

--ej4
CREATE TABLE AUDITADEPARMENTS (
    usuario VARCHAR(256),
    operacion VARCHAR(12),
    fecha DATE DEFAULT SYSDATE);

CREATE OR REPLACE TRIGGER tgr_ej4
AFTER INSERT OR DELETE OR UPDATE
ON DEPARTMENTS
FOR EACH ROW
DECLARE
    v_op AUDITADEPARMENTS.operacion%type;
BEGIN
    IF INSERTING THEN
        v_op := 'ALTA';
    ELSIF DELETING THEN
        v_op := 'BAJA';
    ELSIF UPDATING THEN
        v_op := 'MODIFICACION';
    END IF;
    
    INSERT INTO AUDITADEPARMENTS VALUES (USER, v_op, SYSDATE);
END;
/

--ej5
ALTER TABLE DEPARTMENTS ADD n_empleados NUMBER(5);

CREATE OR REPLACE PROCEDURE proc_ej5
AS 
    CURSOR c1 IS
        SELECT DEPARTMENT_ID, N_EMPLEADOS FROM DEPARTMENTS
        FOR UPDATE;
    
    v_nEmpleados DEPARTMENTS.n_empleados%TYPE;
        
BEGIN
    FOR v_curRow IN c1 LOOP
        SELECT COUNT(DEPARTMENT_ID) "TOTAL" INTO v_nEmpleados FROM EMPLOYEES
        GROUP BY DEPARTMENT_ID
        HAVING DEPARTMENT_ID = v_curRow.DEPARTMENT_ID AND DEPARTMENT_ID IS NOT NULL;
    
        UPDATE DEPARTMENTS SET N_EMPLEADOS = v_nEmpleados WHERE CURRENT OF c1;
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('no encontrado');
END;
/

CREATE OR REPLACE TRIGGER tgr_ej5
AFTER INSERT OR DELETE
ON EMPLOYEES
DECLARE
BEGIN
    proc_ej5();
END;
/

--ej6
ALTER TABLE PUBLISHER ADD EJEMPLARES_VENDIDOS NUMBER(5) DEFAULT 0;

CREATE OR REPLACE PROCEDURE proc_ej6
AS
    CURSOR c1 IS
        SELECT * FROM PUBLISHER 
        FOR UPDATE;
    
    v_suma PUBLISHER.EJEMPLARES_VENDIDOS%TYPE;
BEGIN
    FOR v_curRow IN c1 LOOP
        SELECT SUM(YTD_SALE) INTO v_suma FROM TITLE
        GROUP BY PUB_ID
        HAVING PUB_ID = v_curRow.PUB_ID;
        
        UPDATE PUBLISHER SET EJEMPLARES_VENDIDOS = v_suma WHERE CURRENT OF c1;
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('error');
END;
/

--ej7
CREATE OR REPLACE TRIGGER tgr_ej7
AFTER UPDATE OF YTD_SALE
ON TITLE
BEGIN
    proc_ej6();
END;
/

--ej8
ALTER TABLE TITLE ADD LAST_UPDATE DATE;

CREATE OR REPLACE PROCEDURE proc_ej8
AS
BEGIN
    UPDATE TITLE SET LAST_UPDATE = SYSDATE;
END;
/

--ej9
CREATE OR REPLACE TRIGGER tgr_ej9
AFTER UPDATE
ON TITLE
FOR EACH ROW
BEGIN
    UPDATE TITLE SET LAST_UPDATE = SYSDATE WHERE TITLE_ID = :old.TITLE_ID; 
END;

--ej10
CREATE OR REPLACE TRIGGER tgr_ej10
BEFORE UPDATE OF JOB_LVL
ON EMPLOYEEPUB
FOR EACH ROW
DECLARE
    v_minlvl JOB.MIN_LVL%TYPE;
    v_maxlvl JOB.MAX_LVL%TYPE;
BEGIN
    SELECT MIN_LVL, MAX_LVL INTO v_minlvl, v_maxlvl FROM JOB WHERE JOB_ID = :old.JOB_ID;
    
    IF v_minlvl < :new.JOB_LVL OR :new.JOB_LVL > v_maxlvl THEN
        RAISE_APPLICATION_ERROR(-20000, 'ERROR: No se puede establecer el nivel de trabajo a un nivel incoherente');
    END IF;
END;

--ej11
CREATE OR REPLACE TRIGGER tgr_ej11
BEFORE INSERT 
ON TITLE
FOR EACH ROW
DECLARE
    v_title TITLE.TITLE%TYPE;
    v_pubId TITLE.PUB_ID%TYPE;
BEGIN
    SELECT TITLE, PUB_ID INTO v_title, v_pubId 
    FROM TITLE 
    WHERE TITLE = :new.TITLE AND PUB_ID = :new.PUB_ID;
    
    IF v_title = :new.TITLE AND v_pubId = :new.PUB_ID THEN
        RAISE_APPLICATION_ERROR(-20000, 'ERROR: LIBRO DUPLICADO');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('OK');
END;