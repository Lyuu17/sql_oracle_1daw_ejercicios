SET SERVEROUTPUT ON;



--ej1
DECLARE
    texto VARCHAR2(32) DEFAULT 'Hola &nom_alumno';
BEGIN
    dbms_output.Put_line(texto);
END;
--ej2
DECLARE
    num1 NUMBER(6) DEFAULT 5;
    num2 NUMBER(6) DEFAULT 8;
    num3 NUMBER(6) DEFAULT 3;
    total NUMBER(8) DEFAULT 0;
BEGIN
    total := (num1 + num2) * num3;
    dbms_output.Put_line('Resultado total es: ' || total);
END;
--ej3
DECLARE
    radio NUMBER(5, 2);
    pi CONSTANT NUMBER(3, 2) DEFAULT 3.14;
BEGIN
    radio := &radio;
    dbms_output.Put_line('Área del círculo: ' || ((radio*radio) * pi));
END;
--ej4
DECLARE
    nombre VARCHAR2(32) DEFAULT 'asd';
    apellido VARCHAR(32) DEFAULT '';
    conca VARCHAR2(32) DEFAULT '';
BEGIN
    nombre := '&nombre';
    apellido := '&apellido';
    conca := UPPER(CONCAT(nombre, apellido));
    dbms_output.Put_line('Nombre: ' || nombre || ', apellido: ' || apellido || ', res: ' || conca || ', longitud: ' || LENGTH(conca));
END;
--ej5
DECLARE
    fecha_usuario DATE DEFAULT SYSDATE;
BEGIN
    fecha_usuario := '&fecha_usuario';
    dbms_output.Put_line('Día: ' || TO_CHAR(fecha_usuario, 'dd'));
    dbms_output.Put_line('Mes: ' || TO_CHAR(fecha_usuario, 'mm'));
    dbms_output.Put_line('Año: ' || TO_CHAR(fecha_usuario, 'yyyy'));
END;
--ej6
DECLARE
    fecha_usuario DATE DEFAULT SYSDATE;
BEGIN
    --fecha_usuario := '&fecha_usuario';
    dbms_output.Put_line('Día: ' || TO_CHAR(fecha_usuario, 'day'));
    dbms_output.Put_line('Mes: ' || TO_CHAR(fecha_usuario, 'month'));
    dbms_output.Put_line('Año: ' || TO_CHAR(fecha_usuario, 'yyyy'));
    dbms_output.Put_line('Hora y min: ' || TO_CHAR(fecha_usuario, 'hh24') || ':' || TO_CHAR(fecha_usuario, 'mi'));
END;
--ej7
DECLARE
    num_usuario NUMBER(3);
BEGIN
    num_usuario := &num_usuario;
    IF MOD(num_usuario, 2) = 0 THEN
        dbms_output.Put_line(num_usuario || ' es par');
    ELSE
        dbms_output.Put_line(num_usuario || ' no es par');
    END IF;
END;
--ej8
DECLARE
    texto VARCHAR2(32) DEFAULT '';
    letra CHAR(1) DEFAULT '';
BEGIN
    texto := '&texto';
    letra := '&letra';

    IF INSTR(texto, letra, 1) > 0 THEN
        dbms_output.Put_line('La letra existe en la cadena');
    ELSE
        dbms_output.Put_line('No existe la letra en la cadena');
    END IF;
END;
--ej9
DECLARE
    texto VARCHAR2(32) DEFAULT '';
    letras VARCHAR(2) DEFAULT '';
BEGIN
    texto := '&texto';
    letras := '&letras';
    
    IF INSTR(texto, letras, 1) > 0 THEN
        dbms_output.Put_line('Las dos letras existen en la cadena');
    ELSE
        IF INSTR(texto, SUBSTR(letras, 1), 1) > 0 THEN
            dbms_output.Put_line('La primera letra existe en la cadena');
        ELSIF INSTR(texto, SUBSTR(letras, 2), 1) > 0 THEN
            dbms_output.Put_line('La segunda letra existe en la cadena');
        ELSE
            dbms_output.Put_line('No existe la letra en la cadena');
        END IF;
        
    END IF;
END;
--ej10
DECLARE
    num1 NUMBER(10) DEFAULT 0;
    num2 NUMBER(10) DEFAULT 0;

    num_temp NUMBER(10) DEFAULT 0;
BEGIN
    num1 := &num1;
    num2 := &num2;
    IF num1 < 0 OR num2 < 0 THEN
        dbms_output.Put_line('No puede ser 0 un número o negativo');
    ELSE
        IF num1 < num2 THEN
            num_temp := num1;
            num1 := num2; --num1: menor, num2: mayor
            num2 := num_temp;
        END IF;

        dbms_output.Put_line('Resultado: ' || num1 || ':' || num2 || ' = ' || (num1 / num2));
    END IF;
END;
--ej11
DECLARE 
    num1 NUMBER(10) DEFAULT 0;
    num2 NUMBER(10) DEFAULT 0;
    num3 NUMBER(10) DEFAULT 0;
BEGIN
    num1 := &num1;
    num2 := &num2;
    num3 := &num3;
    CASE
        WHEN num1 = (num2 + num3) THEN
            dbms_output.Put_line(num1 || ' es equivalente a la suma de ' || num2 || '+' || num3);
        WHEN num2 = (num1 + num3) THEN
            dbms_output.Put_line(num2 || ' es equivalente a la suma de ' || num1 || '+' || num3);
        WHEN num3 = (num1 + num2) THEN
            dbms_output.Put_line(num3 || ' es equivalente a la suma de ' || num1 || '+' || num2);
        ELSE
            dbms_output.Put_line('No hay sumas equivalentes');
    END CASE;
END;