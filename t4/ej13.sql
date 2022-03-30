DROP TABLE Conductores;
DROP TABLE Coches;
DROP TABLE Trayectos;
DROP TABLE Viajes;

CREATE TABLE Conductores (
    DNI VARCHAR2(9) PRIMARY KEY,
    Nombre VARCHAR(10) UNIQUE NOT NULL,
    Alta_Empresa DATE Default SYSDATE NOT NULL
);
CREATE TABLE Coches(
    Matricula VARCHAR2(10) PRIMARY KEY CONSTRAINT chk_matricula CHECK ((SUBSTR(Matricula, 1, 4) BETWEEN '0' AND '9999') AND (SUBSTR(Matricula, 6, 9) BETWEEN 'AAA' AND 'ZZZ') AND Matricula LIKE '%-%'),
    Num_Plazas NUMBER(9) CONSTRAINT chk_plazas CHECK (Num_Plazas > 0),
    Ult_Revison DATE
);
CREATE TABLE Trayectos(
    Origen VARCHAR2(20),
    Destino VARCHAR2(20),
    Precio NUMBER(2) DEFAULT 10 NOT NULL CONSTRAINT chk_precio CHECK (Precio > 10 AND Precio < 120),
    Kms NUMBER(2) DEFAULT 0 NOT NULL CONSTRAINT chk_kms CHECK (Kms > 5),
    CONSTRAINT PK_TRAYECTOS PRIMARY KEY (Origen, Destino),
    CONSTRAINT chk_origen CHECK (Origen != Destino),
    CONSTRAINT chk_destino CHECK (Destino != Origen)
);
CREATE TABLE Viajes(
    Origen VARCHAR2(20),
    Destino VARCHAR2(20),
    FH_Ida DATE DEFAULT SYSDATE+"",
    Matricula VARCHAR2(10),
    Hora_Vuelta CHAR(4) DEFAULT '0000' NOT NULL,
    DNI VARCHAR2(9),
    Billetes_Vendidos NUMBER,
    CONSTRAINT PK_VIAJES PRIMARY KEY (Origen, Destino, Matricula),
    CONSTRAINT FK_VIAJES FOREIGN KEY (Origen, Destino) REFERENCES Trayectos(Origen, Destino),
    CONSTRAINT FK_MATRICULA FOREIGN KEY (Matricula) REFERENCES Coches(Matricula),
    CONSTRAINT FK_DNI FOREIGN KEY (DNI) REFERENCES Conductores(DNI),
    CONSTRAINT chk_Hora_Vuelta CHECK (Hora_Vuelta > SUBSTR(FH_Ida, 12, LENGTH(FH_Ida)))
);