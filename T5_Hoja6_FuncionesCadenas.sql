--1 MISTEXTOS
SELECT REPLACE(TITULO, '"'), SUBSTR(EDITORIAL, 1, 3) FROM MISTEXTOS
--2
SELECT REPLACE(REPLACE(TITULO, '.'), '"'), LOWER(EDITORIAL) FROM MISTEXTOS
SELECT LTRIM(RTRIM(TITULO, '."'), '."'), LOWER(EDITORIAL) FROM MISTEXTOS
--3
SELECT INITCAP(REPLACE(REPLACE(TITULO, '.'), '"')) FROM MISTEXTOS
--4
SELECT TITULO FROM MISTEXTOS WHERE PAGINA = (SELECT MAX(PAGINA) FROM MISTEXTOS)
--5
SELECT AUTOR || '***' || EDITORIAL FROM MISTEXTOS ORDER BY LENGTH(EDITORIAL)
--6 LIBROS
SELECT AUTOR,SUBSTR(AUTOR,1, INSTR(AUTOR,',') - 1) FROM LIBROS
--7
SELECT AUTOR,SUBSTR(AUTOR,INSTR(AUTOR,',')+2) FROM LIBROS
--8
SELECT AUTOR,SUBSTR(AUTOR,INSTR(AUTOR,',')+2) || ' ' || SUBSTR(AUTOR,1, INSTR(AUTOR,',') - 1) FROM LIBROS
--9
SELECT SUBSTR(AUTOR, 1, 4) FROM LIBROS WHERE LENGTH(AUTOR) = (SELECT MIN(LENGTH(AUTOR)) FROM LIBROS)
--10
SELECT SUBSTR(EDITORIAL, -3), INITCAP(TITULO) FROM LIBROS WHERE PAGINA > (SELECT AVG(PAGINA) FROM LIBROS)