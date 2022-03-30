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
)