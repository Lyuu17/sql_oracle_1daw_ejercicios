﻿
DROP TABLE SERIE CASCADE CONSTRAINTS;

CREATE TABLE SERIE ( SERIE_ID VARCHAR2(6) PRIMARY KEY,
					 SERIE_TITULO VARCHAR2(20),
					 PAIS VARCHAR2(25),
					 FECHA_INICIO DATE,
					 TEMPORADAS NUMBER(2),
					 CAPITULOS NUMBER(3));
					 
INSERT INTO SERIE VALUES ('BRGN',	'Borgen',	'Dinamarca',	'26/09/2010',3, NULL);
INSERT INTO SERIE VALUES ('KLLNG1',	'The Killing', 'Dinamarca',	'07/01/2007',3, NULL);
INSERT INTO SERIE VALUES ('KLLNG2','The Killing', 'Estados Unidos-Canadá', '03/04/2011', 3, NULL);
INSERT INTO SERIE VALUES ('THEOC', 'The O. C.', 'Estados Unidos', '05/08/2003', 4, NULL);
INSERT INTO SERIE VALUES ('BRKNG','Breaking Bad','Estados Unidos','20/01/2008',	5, NULL	);
INSERT INTO SERIE VALUES ('MDRNF','Modern Family','Estados Unidos','23/09/2009',6, NULL);
INSERT INTO SERIE VALUES ('WWRLD', 'Westworld', 'Estados Unidos', '02/10/2016',1,NULL);
INSERT INTO SERIE VALUES ('THWR', 'The wire',  'Estados Unidos', '16/03/2008',5, NULL);

DROP TABLE CAPITULO CASCADE CONSTRAINTS;

CREATE TABLE CAPITULO ( SERIE_ID VARCHAR2(6) REFERENCES SERIE,
						TEMPORADA NUMBER(2),
						CAPITULO NUMBER(2),
						TITULO_ORIGINAL VARCHAR2(30),
						DURACION NUMBER(3),
						PRIMARY KEY (SERIE_ID, TEMPORADA, CAPITULO));

INSERT INTO CAPITULO VALUES ('BRGN',1,1,'Dyden i midten',55);
INSERT INTO CAPITULO VALUES ('BRGN',2,4,'Op til kamp',50);
INSERT INTO CAPITULO VALUES ('BRGN',2,3,'Den sidste arbejder',55);
INSERT INTO CAPITULO VALUES ('KLLNG2',1,2,'The Cage',48);
INSERT INTO CAPITULO VALUES ('KLLNG2',3,2,'That You Fear the Most',45);
INSERT INTO CAPITULO VALUES ('BRKNG',5,9,'Blood Money',60);
INSERT INTO CAPITULO VALUES ('BRKNG',5,10,'Buried',55);
INSERT INTO CAPITULO VALUES ('MDRNF',1,2,'The Bicycle Thief',40);

DROP TABLE ACTOR CASCADE CONSTRAINTS;


CREATE TABLE ACTOR ( ACTOR_ID VARCHAR2(6) PRIMARY KEY,
					ACTOR_NOMBRE VARCHAR2(30), 
					NACIONALIDAD VARCHAR2(15),
					FECHA_NAC DATE,
					DEBUT NUMBER(4),
					TIPO_DEBUT VARCHAR2(6));

INSERT INTO ACTOR VALUES ('A001','Sidse Babett Knudsen','Danesa','22/11/1968',1997,'CINE');					
INSERT INTO ACTOR VALUES ('A002','Pilou Asbæk','Danesa','02/03/1982', NULL, NULL);			
INSERT INTO ACTOR VALUES ('A003', 'Sofie Gråbøl', 'Danesa', '30/07/1968', 1999, 'TV');
INSERT INTO ACTOR VALUES ('A004', 'Mireille Enos', 'Estadounidense', '22/09/1975', 1994, 'TV');
INSERT INTO ACTOR VALUES ('A005', 'Billy Campbell', 'Estadounidense', '07/06/1959', 1981, 'TV');
INSERT INTO ACTOR VALUES ('A006', 'Joel Kinnaman', 'Sueco', '25/11/1979', 2002, 'CINE');
INSERT INTO ACTOR VALUES ('A008', 'Anna Gunn', 'Mejicana', '11/08/1968', 1992, 'CINE');
INSERT INTO ACTOR VALUES ('A007', 'Bryan Cranston', 'Estadounidense', '07/03/1956', 1980, 'CINE');
INSERT INTO ACTOR VALUES ('A009', 'John Doman', 'Estadounidense', '09/01/1945', 2002,'TV'); 

DROP TABLE REPARTO CASCADE CONSTRAINTS;

CREATE TABLE REPARTO ( SERIE_ID VARCHAR2(6) REFERENCES SERIE,
					 PERSONAJE_NOMBRE VARCHAR2(30),
					 ACTOR_ID VARCHAR2(6) REFERENCES ACTOR,
					 DESCRIPCION VARCHAR2(50),
					 PRIMARY KEY (SERIE_ID, ACTOR_ID));
					 
INSERT INTO REPARTO VALUES ('BRGN','Birgitte Nyborg Christensen','A001','Primera Ministra y líder del Partido Moderado');		
INSERT INTO REPARTO VALUES ('BRGN','Kasper Juul','A002','Jefe de Comunicaciones de Birgitte Nyborg');
INSERT INTO REPARTO VALUES ('KLLNG1','Sarah Lund','A003','Detective-inspectora');
INSERT INTO REPARTO VALUES ('KLLNG2','Sarah Linden','A004','Detective del departamento de homicidios');
INSERT INTO REPARTO VALUES ('KLLNG2','Darren Richmond','A005','Político que se presenta a alcalde de Seattle');
INSERT INTO REPARTO VALUES ('THEOC','Carter Buckley','A005',NULL);
INSERT INTO REPARTO VALUES ('KLLNG2','Stephen Holder','A006','Detective del departamento de homicidios');
INSERT INTO REPARTO VALUES ('BRKNG','Walter White','A007','"Heisenberg", químico y profesor de química');
INSERT INTO REPARTO VALUES ('BRKNG','Skyler White','A008','Esposa de Walter White');
INSERT INTO REPARTO VALUES ('MDRNF','Javier Delgado','A007','Padre de familia');			 

COMMIT;













