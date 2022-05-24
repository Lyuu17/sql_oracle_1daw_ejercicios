--ej1
CREATE OR REPLACE TYPE tipo_direccion AS OBJECT (
    direccion VARCHAR2(128),
    codigo_postal NUMBER(6)
);

--ej2
CREATE OR REPLACE TYPE tipo_contacto AS OBJECT (
    num_tlf VARCHAR2(16),
    email VARCHAR2(128)
);

--ej3
CREATE OR REPLACE TYPE tipo_persona AS OBJECT (
    id NUMBER,
    nombre VARCHAR2(32),
    apellido VARCHAR(64),
    direccion tipo_direccion,
    contacto tipo_contacto
);
/

CREATE OR REPLACE TYPE tipo_cliente UNDER tipo_persona (
    num_pedidos NUMBER(3)
);

--ej4
CREATE OR REPLACE TYPE tipo_articulo AS OBJECT (
    id NUMBER,
    nombre VARCHAR2(32),
    descripcion VARCHAR2(128),
    precio NUMBER(5,2),
    porcentaje_iva NUMBER(5,2)
);
/
CREATE TABLE tabla_articulos OF tipo_articulo;

--EJ5
CREATE OR REPLACE TYPE tipo_lista_detalle AS OBJECT (
    numero NUMBER,
    articulo tipo_articulo,
    cantidad NUMBER(3)
);
/

CREATE TYPE tab_lista_detalle IS TABLE OF tipo_lista_detalle;
/

CREATE OR REPLACE TYPE tipo_lista_compra AS OBJECT (
    id NUMBER,
    fecha DATE,
    cliente tipo_cliente,
    detalles tab_lista_detalle,
    MEMBER FUNCTION total RETURN NUMBER
);
/

--ej6
CREATE OR REPLACE TYPE BODY tipo_lista_compra AS
MEMBER FUNCTION total
RETURN NUMBER
IS
    suma NUMBER := 0;
BEGIN
    FOR i IN detalles.FIRST .. detalles.LAST LOOP
        suma := suma + detalles(i).cantidad * detalles(i).articulo.precio;
    END LOOP;
    RETURN suma;
END;
END;
/

--EJ7
CREATE TABLE clientes OF tipo_cliente;
INSERT INTO clientes VALUES(tipo_cliente(0, 'nombre', 'apellido', 'dir', '0', 0));

--ej8
CREATE TABLE tab_lista_compra OF tipo_lista_compra 
NESTED TABLE detalles STORE AS detalles_tab;

INSERT INTO tab_lista_compra VALUES(
    tipo_lista_compra(0, SYSDATE, (SELECT VALUE(C) FROM CLIENTES C WHERE ID = 0), 
        tab_lista_detalle(
            tipo_lista_detalle(0, tipo_articulo(0, 'articulo 1', 'desc', 1.0, 21.0), 1),
            tipo_lista_detalle(1, tipo_articulo(1, 'articulo 2', 'desc', 5.0, 21.0), 1)
        )
    )
);

--ej9
DECLARE
    CURSOR c1 IS
        SELECT * FROM tab_lista_compra;
BEGIN
    FOR c_curRow IN c1 LOOP
        dbms_output.put_line('ID: ' || c_curRow.ID);
        dbms_output.put_line('FECHA: ' || c_curRow.FECHA);
        
        dbms_output.put_line('CLIENTE: ');
        dbms_output.put_line('  ID: ' || c_curRow.cliente.ID);
        dbms_output.put_line('  NOMBRE: ' || c_curRow.cliente.NOMBRE);
        dbms_output.put_line('  APELLIDO: ' || c_curRow.cliente.APELLIDO);
        dbms_output.put_line('  DIRECCION: ' || c_curRow.cliente.DIRECCION);
        dbms_output.put_line('  CONTACTO: ' || c_curRow.cliente.CONTACTO);
        dbms_output.put_line('  NUM_PEDIDOS: ' || c_curRow.cliente.NUM_PEDIDOS);
        
        FOR i IN c_curRow.detalles.FIRST..c_curRow.detalles.LAST LOOP
            dbms_output.put_line('DETALLE: ');
            dbms_output.put_line('  NUMERO: ' || c_curRow.detalles(i).NUMERO);
            dbms_output.put_line('  ARTICULO: ');
            dbms_output.put_line('      ID: ' || c_curRow.detalles(i).articulo.ID);
            dbms_output.put_line('      NOMBRE: ' || c_curRow.detalles(i).articulo.NOMBRE);
            dbms_output.put_line('      DESCRIPCION: ' || c_curRow.detalles(i).articulo.DESCRIPCION);
            dbms_output.put_line('      PRECIO: ' || c_curRow.detalles(i).articulo.PRECIO);
            dbms_output.put_line('      PORCENTAJE IVA: ' || c_curRow.detalles(i).articulo.PORCENTAJE_IVA);
            dbms_output.put_line('  CANTIDAD: ' || c_curRow.detalles(i).CANTIDAD);
        END LOOP;
    END LOOP;
END;
/

--ej10
SELECT detalles.total FROM tab_lista_compra WHERE id = 0;