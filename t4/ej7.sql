create table ejemplo3 (
    dni varchar2(10) primary key,
    nombre varchar2(30),
    edad number(2),
    curso number,
    constraint chk_nombre check (upper(nombre) = nombre)
    constraint chk_edad check (edad BETWEEN 5 AND 20)
)