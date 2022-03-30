CREATE TABLE empleados_check (
    numero NUMBER(5) PRIMARY KEY CHECK (numero BETWEEN 1 AND 10000),
    nombre VARCHAR2(20) UNIQUE NOT NULL,
    direccion VARCHAR2(30) NOT NULL,
    distancia NUMBER(5, 3),
    oficio VARCHAR2(20) CONSTRAINT oficio CHECK (oficio IN('vendedor', 'gerente', 'otros')),
    telefono_fijo VARCHAR2(10) CONSTRAINT tlf_fijo CHECK (telefono_fijo LIKE '91%'),
    telefono_movil VARCHAR2(10) CONSTRAINT tlf_movil CHECK (telefono_movil LIKE '6%'),
    fecha_nac DATE CONSTRAINT f_nac CHECK (fecha_nac < '1990-1-1'),
    fecha_alta DATE DEFAULT SYSDATE,
    depart NUMBER(3) CHECK (depart IN (10, 20, 30)),
    num_hijos NUMBER(2) DEFAULT 0 CONSTRAINT n_hijos CHECK (num_hijos BETWEEN 1 AND 10),
    titulado CHAR DEFAULT 'N' CONSTRAINT titulado CHECK (titulado IN('S', 'N')),
    salario NUMBER(10)
);