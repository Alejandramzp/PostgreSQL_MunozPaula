create database campusCar;

--ENUM
create type estado as enum('Nuevo','Usado');
create type horario as enum('Lunes','Martes','Miercoles','Jueves','Viernes','Sabado');

create table vehiculo(
	id serial primary key not null,
	marca varchar(100),
	modelo varchar(100),
	anyo varchar(50),
	precio double precision,
	estado estado 
);

create table cliente(
	id serial primary key not null,
	nombre varchar(200),
	cedula varchar(100),
	celular varchar(100)
);

create table cliente_vehiculo(
	id_cliente int not null,
	id_vehiculo int not null,
	primary key(id_cliente,id_vehiculo),
	foreign key (id_cliente) references cliente(id),
	foreign key (id_vehiculo) references vehiculo(id)
);

create table cliente_potencial(
	id serial primary key not null,
	nombre varchar(200),
	cedula varchar(100),
	celular varchar(100),
	id_vehiculoInteres int,
	foreign key (id_vehiculoInteres) references vehiculo(id)
);

create table proovedor(
	id serial primary key not null,
	nombre varchar(200),
	pieza varchar(200),
	cantidad int
);

create table servicio(
	id serial primary key not null,
	servicio varchar(200),
	id_vehiculo int,
	fechaInicio varchar(100),
	fechaFin varchar(100),
	id_proovedor int,
	foreign key (id_vehiculo) references vehiculo(id),
	foreign key (id_proovedor) references proovedor(id)
);

create table empleado(
	id serial primary key not null,
	nombre varchar(200),
	cedula varchar(100),
	celular varchar(100),
	rol varchar(200),
	fecha_contratacion date
);


create table departamento_servicio(
	id serial primary key not null,
	id_empleado int,
	id_servicio int,
	foreign key (id_empleado) references empleado(id),
	foreign key (id_servicio) references servicio(id),
	horario horario
);

create table departamento_ventas(
	id serial primary key not null,
	id_empleado int,
	comision double precision,
	id_cliente int,
	foreign key (id_empleado) references empleado(id),
	foreign key (id_cliente) references cliente(id),
	fecha date
);


