--ej1
CREATE OR REPLACE PROCEDURE proc_h4ej1_m1(deptno NUMBER, porcentaje NUMBER)
AS
    CURSOR c1 IS
        SELECT SALARIO FROM EMPLE WHERE DEPT_NO = deptno FOR UPDATE;
BEGIN
    FOR v_cur IN c1 LOOP
        UPDATE EMPLE 
        SET SALARIO = SALARIO + (SALARIO * porcentaje / 100)
        WHERE CURRENT OF c1;
    END LOOP;
END;
/

CREATE OR REPLACE PROCEDURE proc_h4ej1_m2(deptno NUMBER, porcentaje NUMBER)
AS
    CURSOR c1 IS
        SELECT SALARIO, ROWID FROM EMPLE WHERE DEPT_NO = deptno FOR UPDATE;
BEGIN
    FOR v_cur IN c1 LOOP
        UPDATE EMPLE 
        SET SALARIO = SALARIO + (SALARIO * porcentaje/100) 
        WHERE ROWID = v_cur.ROWID;
    END LOOP;
END;
/

EXECUTE proc_h4ej1_m2(30, -100);

--ej2
CREATE OR REPLACE PROCEDURE proc_h4ej2(deptno NUMBER, importe NUMBER, porcentaje NUMBER)
AS
    CURSOR c1 IS
        SELECT SALARIO FROM EMPLE WHERE DEPT_NO = deptno FOR UPDATE;
    v_tmp_importe EMPLE.SALARIO%TYPE;
    v_tmp_porcentaje EMPLE.SALARIO%TYPE;
    v_tmp_valor EMPLE.SALARIO%TYPE;
    v_actualizadas NUMBER;
BEGIN
    FOR v_cur IN c1 LOOP
        v_tmp_importe := v_cur.SALARIO+importe;
        v_tmp_porcentaje := v_cur.SALARIO + v_cur.SALARIO*porcentaje/100;
        IF v_tmp_importe >= v_tmp_porcentaje THEN
            --importe >= porcentaje
            v_tmp_valor := v_tmp_importe;
        ELSE
            --porcentaje < importe
            v_tmp_valor := v_tmp_porcentaje;
        END IF;

        UPDATE EMPLE SET SALARIO = v_tmp_valor WHERE CURRENT OF c1;

        v_actualizadas := v_actualizadas + 1;
    END LOOP;

    dbms_output.put_line(v_actualizadas || ' líneas actualizadas.');
END;
/

EXECUTE proc_h4ej2(1, 2500, 5);