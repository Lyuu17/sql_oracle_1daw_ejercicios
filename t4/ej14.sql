Create Table Sucursales(
    Num_Sucursal NUMBER PRIMARY KEY CONSTRAINT num_exact CHECK (Num_Sucursal >= 100 AND Num_Sucursal <= 999),
    Direccion VARCHAR2(10) NOT NULL,
    Director VARCHAR2(10) NOT NULL,
    CONSTRAINT mayus CHECK (upper(Direccion)=Direccion AND upper(Director) = Director)
);
Create Table Clientes(
    NIF VARCHAR2(9) PRIMARY KEY CONSTRAINT nif CHECK (upper(SUBSTR(NIF, 9, 1)) = SUBSTR(NIF, 9, 1)),
    Nombre VARCHAR2(10),
    Direccion VARCHAR2(7),
    Telefono NUMBER CONSTRAINT tlf CHECK (Telefono >= 9000000000 OR Telefono <= 7000000000)
);
Create Table Cuentas(
    Num_Cuenta NUMBER,
    NIF_Titular VARCHAR2(9) REFERENCES Clientes(NIF),
    NIF_CoTitular VARCHAR2(9) REFERENCES Clientes(NIF),
    FechaAbierta DATE DEFAULT SYSDATE CONSTRAINT ck_fecha CHECK (to_char(FechaAbierta, 'd') < 6),
    Num_Sucursal NUMBER(3) REFERENCES Sucursales(Num_Sucursal),
    Tipo CHAR CONSTRAINT ck_tipo CHECK (Tipo IN('C', 'P', 'F')),
    Saldo NUMBER(10) DEFAULT 100000 CONSTRAINT ck_saldo CHECK (Saldo >= 100000),
    Control CHAR NOT NULL CONSTRAINT ck_control CHECK (Control IN('A', 'B'))
);
Create Table Movimientos(
    Num_Cuenta NUMBER REFERENCES Cuentas(Num_Cuenta),
    FechaHora DATE DEFAULT SYSDATE,
    Importe NUMBER(*, 2) NOT NULL,
    Concepto VARCHAR2(30) DEFAULT 'SIN CONCEPTO' CONSTRAINT ck_concepto CHECK ((upper(Concepto) LIKE '%CARGO%' AND Importe < 0) 
        OR (upper(Concepto) LIKE '%ABONO%' AND Importe > 0)),
    Num_Sucursal NUMBER REFERENCES Sucursales(Num_Sucursal)
);