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
