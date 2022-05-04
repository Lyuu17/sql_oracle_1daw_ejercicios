alter session set nls_date_format ='dd/mm/yyyy hh24:mi';
drop table visitas;
drop table animales;
drop table dueños;
drop table veterinarios;
create table dueños
(dni varchar2(10) primary key,
 nombre varchar2(30),
 direccion varchar2(35),
 tfno_contacto number(9),
 alta_clinica varchar(7),
 cuota_mensual char(1));

create table animales
(ident VARCHAR2(3) primary key,
 nombre varchar2(30),
 especie varchar2(20),
 raza varchar2(20),
 fecha_nacimiento date,
 peso number (5,2),
 sexo char(1),
 dni_dueño varchar2(10));

create table veterinarios
(numcolegiado number primary key,
 nombre varchar(20),
telefono number(9));

create table visitas
(ident_animal VARCHAR2(3) references animales,
 fh_visita date,
numcolegiado number references veterinarios,
 Motivo varchar(30), 
 Diagnostico varchar(30),
 precio number(*,2)
);

insert into dueños values ('221221P','Angel Manzano','c/Estación 9',913453456,'10-2008','S');
insert into dueños values ('342545L','Nuria Aguilera','c/Estrecho 49',911221125,'11-2008','S');
insert into dueños values ('132123K','Lucía Gómez','c/Estación 19',917178989,'11-2008','N');
insert into dueños values ('231239S','Antonio Pedrosa','c/Illescas 176',913154664,'01-2011','N');
insert into dueños values ('231121J','Esther Flores','c/Maderuelo 20',918908998,'02-2011','N');
insert into dueños values ('453445J','Maria Carrasco','c/Estrecho 23',911232342,'03-2011','N');

 
insert into animales values (1,'JUK','PERRO','Affenpinscher','11/10/2009',10,'M','221221P');
insert into animales values (2,'SOL','PERRO','Affenpinscher','21/06/2006',15,'M','342545L');
insert into animales values (3,'JAS','PERRO','Alaskan Malamute','16/02/2012',35,'M','132123K');
insert into animales values (4,'GRESCA','PERRO','Boxer','17/10/2006',20,'H','231239S');
insert into animales values (5,'TRITÓN','PERRO','Dobermann','01/01/2011',40,'H','231239S');
 insert into animales values (6,'CHUSCHUS','GATO','Persa','12/12/2009',6,'M','231121J');
 insert into animales values (7,'FILOMENA','GATO','Abisinio','14/02/2011',10,'H','132123K');
 insert into animales values (8,'GRESCA','GATO','Abisinio','14/02/2002',12,'H','132123K');

insert into veterinarios values (1234,'ANA GIL', 686145232);
insert into veterinarios values (3443,'ELENA MORAGA', 686989766);
insert into veterinarios values (3888,'MARIA ELENA RUIZ', 626912436);

insert into visitas values (1,'02/01/2015 10:30',1234,'VACUNAS',NULL ,20);
insert into visitas values (2,'5/1/2015 12:30',1234,'REVISION',NULL,20);
insert into visitas values (1,'23/1/2015 17:40',3443,'GASTRITIS',NULL,30);
insert into visitas values (3,'26/1/2015 13:00',1234,'PONER VACUNA',NULL,22);
insert into visitas values (4,'23/1/2015 9:45',3443,'REVISION',NULL,20);
insert into visitas values (5,'1/2/2015 18:35',3443,'DENTADURA',NULL,45);
insert into visitas values (4,'12/2/2015 12:45',3443,'PARASITOS',NULL,25);
insert into visitas values (5,'14/2/2015 11:30',1234,'VACUNAS',NULL,20);
insert into visitas values (6,'24/2/2015 18:30',3443,'REVISION',NULL,20);
insert into visitas values (2,'28/2/2015 19:20',3443,'VACUNAS',NULL,20);
insert into visitas values (7,'2/3/2015 19:20',1234,'VISITA',NULL,25);
insert into visitas values (1,'2/3/2015 09:30',1234,'GASTRITIS',NULL,30);
insert into visitas values (2,'2/3/2015 17:30',3443,'DOLORES',NULL,24);
insert into visitas values (5,'2/3/2015 10:30',1234,'NO COME',NULL,25);
insert into visitas values (2,'15/3/2015 17:30',3443,'REVISIÓN',NULL,24);
insert into visitas values (5,'15/3/2015 10:30',1234,'VACUNA',NULL,25);
insert into visitas values (4,'15/3/2015 12:30',1234,'VACUNA',NULL,25);
insert into visitas values (8,'11/3/2015 16:00',1234,'REVISIÓN',NULL,25);
insert into visitas values (6,'12/3/2015 16:00',1234,'REVISIÓN',NULL,25);
insert into visitas values (2,'13/3/2015 16:00',1234,'REVISIÓN',NULL,25);

commit;