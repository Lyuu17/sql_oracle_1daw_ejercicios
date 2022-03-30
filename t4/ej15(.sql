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
