alter session set  nls_date_format = 'dd/mm/yyyy hh24:mi';

drop table arreglos ;
DROP TABLE MECANICOS;
drop table coches_taller;
drop table clientes_taller;

Create table mecanicos
(nempleado number primary key,
nombre	varchar2(30) not null,
direccion	varchar2(30) not null,
telefono	varchar2(9),
fecha_nac	date,
fecha_ing	date,
funcion	varchar2(15));

insert into mecanicos values ( 1, 'JUAN MARTIN','SAN BENITO, 6', '614324323', '1/10/1979', '2/10/2011','MECANICO');
insert into mecanicos values ( 2, 'PABLO SEBASTIAN','JUAN MONTALVO, 3', '617509875', '24/05/1979', '2/10/2008','MECANICO');
insert into mecanicos values ( 3, 'RAMON SANCHEZ','HONTANILLA, 43', '914567686', '12/4/1983', '22/3/2008','CHAPISTA');
insert into mecanicos values ( 4, 'SERGIO RUIZ','TORRECUADRADA, 123', '612343456', '30/7/1965', '25/2/2006','CHAPISTA');
insert into mecanicos values ( 5, 'ANA ROMERO','SAN BERNARDO, 124', '614678765', '23/8/1983', '23/12/2006','LUNAS');
insert into mecanicos values ( 6, 'ESTRELLA ROMERO','SAN BERNARDO, 124', '612888727', '23/6/1987', '25/2/2006','ADMINISTRATIVA');



create table clientes_taller
(ncliente	number primary key,
nombre        	varchar2 (30),
direccion	varchar2 (30),
telefono	varchar2 (9),
fecha_alta	date );

insert into clientes_taller values 
(1, 'RAMON GOMEZ','TORRENTE, 23','623453421','1/12/2010');
insert into clientes_taller values 
(2, 'LUIS GIL','SEBASTIAN 342','614375647','24/5/2011');
insert into clientes_taller values 
(3, 'PILAR RAMIREZ','MAYOR, 324','917654343','2/3/2008');
insert into clientes_taller values
(4,'JAIME SANTIAGO', 'SAN FELIPE, 35', '613245687', '3/12/2009');
insert into clientes_taller values
(5, 'RAMIRO PEREZ','MAYOR, 15','616545454','3/2/2010');
insert into clientes_taller values
(6,'MARIA PEREZ', 'ESQUINA, 76', '912897656', '6/3/2009');

create table coches_taller
(matricula 	varchar2 (7) primary key,
modelo	 	varchar2 (20) not null,
año_matricula 	varchar2(4),
ncliente	number references clientes_taller);
 
insert into coches_taller values
('2435BDC', 'OPEL VECTRA', '2010',4);
insert into coches_taller values
('1234ADC', 'CITROEN XANTIA', '2008',5);
insert into coches_taller values
('4567CDA', 'OPEL MERIVA', '2011',1);
insert into coches_taller values
('2356ATS', 'FORD MONDEO', '2009',1);
insert into coches_taller values
('6546CDB', 'CITROEN C3', '2009',2);
insert into coches_taller values
('6543ACS', 'FORD FIESTA', '2008',3);
 
create table arreglos
(matricula varchar2(7),
nempleado	number,
fecha_entrada	date ,
fecha_salida	date,
importe	number(8,2),
constraint pk_arreglos primary key(matricula,nempleado,fecha_entrada),
constraint fk_empleado foreign key (nempleado) references mecanicos,
constraint fk_matricula foreign key (matricula) references coches_taller
);

insert into arreglos values ('6546CDB', 2, '18/12/2013', '20/12/2013', 1000);
insert into arreglos values ('6546CDB', 4, '13/12/2013', '04/01/2014', 3000);
insert into arreglos values ('6546CDB', 2, '10/03/2014', '15/03/2014', 1000);
insert into arreglos values ('6546CDB', 4, '18/03/2014', '20/03/2014', 1000);
insert into arreglos values ('2435BDC', 1, '22/07/2014', '28/07/2014', 300);
insert into arreglos values ('1234ADC', 2, '29/03/2014', '04/04/2014', 3000);
insert into arreglos values ('4567CDA', 5, '13/11/2014', NULL, 800);
insert into arreglos values ('2356ATS', 1, '10/09/2014', '20/09/2014', 300);
insert into arreglos values ('6546CDB', 3, '12/11/2014',  NULL, 400);
insert into arreglos values ('6543ACS', 4, '12/11/2014', '14/11/2014', 350);
insert into arreglos values ('6543ACS', 4, '30/10/2014', NULL, 350);
insert into arreglos values ('2435BDC', 2, '22/05/2014', '28/05/2014', 300);
insert into arreglos values ('2435BDC', 5, '12/05/2014', '18/05/2014', 300);
insert into arreglos values ('1234ADC', 5, '08/11/2014', NULL, 250);


commit;
