create table personas (
    dni varchar(8) primary key,
    nombre varchar(20) not null,
    direccion varchar(20),
    poblacion varchar(20),
    codprovin number(3) not null,
    constraint chk_provincia foreign key (codprovin) references provincias (cod_provincia)
)

create table provincias (
    cod_provincia number(3) primary key,
    nom_provincia varchar(20)
)