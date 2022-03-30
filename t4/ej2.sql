create table empresas (
    cod_empre number(2),
    nombre varchar2(25) not null default 'empresa1',
    fecha_crea date default sysdate+1
)