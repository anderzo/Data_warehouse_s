
CREATE DATABASE ventas_dw;

CREATE TABLE cargo(
    id_cargo int,
	nombre_cargo char(200)
    salario money
	add constraint id_cargo_cargo_pk primary key (id_cargo)
)

create table region(
	id_region int,
	nombre_region varchar(100),
	codigo_iso varchar(15)
	add constraint id_region_region_pk primary key (id_region)
)

create table tienda(
	id_tienda int, 
	codigo_tienda varchar(15),
	nombre_sucursal varchar(100),
	id_region int,
	add constraint id_tienda_tienda_pk primary key (id_tienda),
	add constraint id_region_tienda_fk foreign key (id_region) references region(id_region)
)