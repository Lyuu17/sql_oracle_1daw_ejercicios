create table provincias (
    cod_provi number(2) primary key,
    nombre varchar(2) not null,
    pais varchar2(25),
    constraint chk_pais check (pais IN('España', 'Portugal', 'Italia'))
);