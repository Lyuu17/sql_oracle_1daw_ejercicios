create table alumnos (
    codigo number(3) primary key,
    nombre varchar(21) not null,
    apellido varchar(30) not null,
    curso number,
    fecha_matri date default sysdate,
    constraint chk_apellido check (upper(apellido) = apellido),
    constraint chk_curso check (curso IN(1, 2, 3))
)