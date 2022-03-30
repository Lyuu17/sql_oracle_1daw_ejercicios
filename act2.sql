CREATE TABLE TIENDAS(
    NIF VARCHAR2(10) ,
    POBLACION VARCHAR2(20),
    NOMBRE VARCHAR2(20) ,
    PROVINCIA VARCHAR2(20),
    DIRECCION VARCHAR2(20),
    CODPOSTAL NUMBER(5)
);

Alter table TIENDAS add constraint pk_NIF primary key (NIF);
Alter table TIENDAS add constraint upper_Provincia check (upper(provincia) = provincia);
Alter table TIENDAS modify NOMBRE varchar2(30) constraint changelong_nom not null;