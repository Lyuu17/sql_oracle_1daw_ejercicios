--ej1
create table provincias (
    cod_provi number(2) primary key,
    nombre varchar(2) not null,
    pais varchar2(25),
    constraint chk_pais check (pais IN('España', 'Portugal', 'Italia'))
);

--ej2
create table empresas (
    cod_empre number(2),
    nombre varchar2(25) not null default 'empresa1',
    fecha_crea date default sysdate+1
);

--ej3
create table continentes (
    cod_conti number primary key,
    nombre varchar2(20) default 'EUROPA' not null
);

--ej4
create table alumnos (
    codigo number(3) primary key,
    nombre varchar(21) not null,
    apellido varchar(30) not null,
    curso number,
    fecha_matri date default sysdate,
    constraint chk_apellido check (upper(apellido) = apellido),
    constraint chk_curso check (curso IN(1, 2, 3))
);

--ej5
create table empleados (
    cod_emple number(2) primary key,
    nombre varchar(20) not null
    apellido varchar(25),
    salario number(7, 2),
    provincia number(2),
    empre number(2),
    constraint chk_salario check (salario > 0),
    constraint fk_provincias foreign key (provincia) references provincias(cod_provi) on delete CASCADE,
    constraint fk_empresa foreign key (empre) references empresas(cod_empre)
) ;

create table provincias (
    cod_provi number(2) primary key,
    nombre varchar(2) not null,
    pais varchar2(25),
    constraint chk_pais check (pais IN('España', 'Portugal', 'Italia'))
);

create table empresas (
    cod_empre number(2),
    nombre varchar2(25) not null default 'empresa1',
    fecha_crea date default sysdate+1
);

--ej6
create table personas (
    dni varchar(8) primary key,
    nombre varchar(20) not null,
    direccion varchar(20),
    poblacion varchar(20),
    codprovin number(3) not null,
    constraint chk_provincia foreign key (codprovin) references provincias (cod_provincia)
);

create table provincias (
    cod_provincia number(3) primary key,
    nom_provincia varchar(20)
);

--ej7
create table ejemplo3 (
    dni varchar2(10) primary key,
    nombre varchar2(30),
    edad number(2),
    curso number,
    constraint chk_nombre check (upper(nombre) = nombre)
    constraint chk_edad check (edad BETWEEN 5 AND 20)
);

--ej8
CREATE TABLE ALUMNO(
    Codigo number(2),
    Nombre varchar2(25) not null
);

CREATE TABLE MODULOS(
    Codigo number Primary Key,
    Nombre varchar2(25)
);

CREATE TABLE NOTAS(
    Cod_alumno number(2) PRIMARY KEY,
    Cod_modulo number check (upper(number) = number) PRIMARY KEY,
    Nota number(2), check between 0 and 10,
    constraint FOREIGN KEY Cod_alumno REFERENCES ALUMNO,
    constraint FOREING KEY Cod_modulo REFERENCES MODULO
);

--ej9
CREATE TABLE PEDIDOS(
    NIF VARCHAR2 (10),
    ARTICULO VARCHAR2 (20),
    COD_FABRICANTE number(3),
    PESO number(3),
    CATEGORIA VARCHAR2(10),
    FECHA_PEDIDO date,
    UNIDADES_PEDIDAS number(4),
    CONSTRAINT PK_PEDIDOS PRIMARY KEY (NIF,ARTICULO,COD_FABRICANTE,PESO,CATEGORIA,FECHA_PEDIDO),
    CONSTRAINT FK_PEDIDOS1 FOREIGN KEY (COD_FABRICANTE) REFERENCES FABRICANTES,
    CONSTRAINT UNIDADES_PEDIDAS check (UNIDADES_PEDIDAS>0),
    CONSTRAINT CATEGORIA1 check (CATEGORIA IN('PRIMERA','SEGUNDA','TERCERA')),
    CONSTRAINT FK_PEDIDOS2 FOREIGN KEY (ARTICULO, COD_FABRICANTE, PESO , CATEGORIA) REFERENCES ARTICULOS,
    CONSTRAINT FK_PEDIDOS3 FOREIGN KEY (NIF) REFERENCES TIENDAS
);
CREATE TABLE VENTAS(
    NIF VARCHAR2(10),
    ARTICULO VARCHAR2(20),
    COD_FABRICANTE NUMBER(3),
    PESO NUMBER(3),
    CATEGORIA VARCHAR2(10),
    FECHA_VENTA DATE,
    UNIDADES_VENDIDAS NUMBER(4),
    CONSTRAINT pk_ventas primary key (NIF, ARTICULO,COD_FABRICANTE, PESO, CATEGORIA ,FECHA_VENTA),
    CONSTRAINT fk_ventas1 foreign key (COD_FABRICANTE) REFERENCES FABRICANTES,
    CONSTRAINT UNIDADES_VENDIDAS CHECK (UNIDADES_VENDIDAS>0),
    CONSTRAINT CATEGORIA check (CATEGORIA IN('PRIMERA','SEGUNDA','TERCERA')),
    CONSTRAINT FK_VENTAS2 FOREIGN KEY (ARTICULO, COD_FABRICANTE, PESO , CATEGORIA) REFERENCES ARTICULOS ON DELETE CASCADE,
    CONSTRAINT FK_VENTAS3 FOREIGN KEY (NIF) REFERENCES TIENDAS
);

CREATE TABLE FABRICANTES(
    COD_FABRICANTE NUMBER(3) PRIMARY KEY,
    NOMBRE VARCHAR2(15),
    PAIS VARCHAR2(15), 
    CONSTRAINT CK_NOMBRE  CHECK (NOMBRE=UPPER(NOMBRE)),
    CONSTRAINT CK_PAIS CHECK (PAIS=UPPER(PAIS))
);

CREATE TABLE ARTICULOS(
    ARTICULO VARCHAR2(20),
    COD_FABRICANTE NUMBER(3),
    PESO NUMBER(3),
    CATEGORIA VARCHAR2(10),
    PRECIO_VENTA NUMBER(6,2),
    PRECIO_COSTO NUMBER(6,2),
    EXISTENCIAS NUMBER(5),
    CONSTRAINT PK_ARTICULO PRIMARY KEY (ARTICULO,COD_FABRICANTE,PESO,CATEGORIA),
    CONSTRAINT FK_COD_FABRICANTE FOREIGN KEY (COD_FABRICANTE) REFERENCES FABRICANTES(COD_FABRICANTE),
    CONSTRAINT CK_PRECIO_VENTA CHECK (PRECIO_VENTA>0),
    CONSTRAINT CK_PRECIO_COSTO CHECK (PRECIO_COSTO>0),
    CONSTRAINT CK_PESO CHECK (PESO>0),
    CONSTRAINT CK_CATEGORIA CHECK (CATEGORIA IN ('PRIMERA','SEGUNDA','TERCERA'))
);

CREATE TABLE TIENDAS (
    nif varchar2(10) primary key
);

--ej10
ALTER TABLE pedidos MODIFY unidades_vendidas number(6);
ALTER TABLE ventas MODIFY unidades_pedidas number(6);

--ej11
ALTER TABLE pedidos ADD pvp NUMBER(6, 2);
ALTER TABLE ventas ADD pvp NUMBER(6, 2);

--ej12
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

--ej13
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

--ej14
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

--ej15
CREATE TABLE M_Mecanicos(
empleado integer primary key,
nombre varchar(30) not null,
direccion varchar(30) not null,
telefono varchar2(9),
fecha_nacimiento date,
fecha_ingreso date,
funcion varchar2(15)
);
Alter table M_Mecanicos add salario number(2);
Alter table M_Mecanicos modify (fecha_ingreso Default SYSDATE);
Alter table M_Mecanicos drop (funcion);
Alter table M_Mecanicos add CONSTRAINT salarimayor800 check (salario>800);
Alter table M_Mecanicos add CONSTRAINT mayor_edad CHECK (YEAR(now()) - YEAR(fechanac) >= 18);
