create database productos;

create table fabricante(
	codigo INT primary key,
	nombre VARCHAR(100) not null
);

create table producto(
	codigo INT primary key,
	nombre VARCHAR(100) not null,
	precio double precision not null,
	codigo_fabricante INT not null,
	foreign key (codigo_fabricante) references fabricante(codigo)
);

select * from fabricante;

select * from producto;


INSERT INTO fabricante (codigo, nombre) VALUES
(1, 'Asus'),
(2, 'Lenovo'),
(3, 'Hewlett-Packard'),
(4, 'Samsung'),
(5, 'Seagate'),
(6, 'Crucial'),
(7, 'Gigabyte'),
(8, 'Huawei'),
(9, 'Xiaomi'); 

INSERT INTO producto (codigo, nombre, precio, codigo_fabricante) VALUES
(1, 'Disco duro SATA3 1TB', 86.99, 5),
(2, 'Memoria RAM DDR4 8GB', 120, 6),
(3, 'Disco SSD 1 TB', 150.99, 4),
(4, 'GeForce GTX 1050Ti', 185, 7),
(5, 'GeForce GTX 1080 Xtreme', 755, 6),
(6, 'Monitor 24 LED Full HD', 202, 1),
(7, 'Monitor 27 LED Full HD', 245.99, 1),
(8, 'Portátil Yoga 520', 559, 2),
(9, 'Portátil Ideapad 320', 444, 2),
(10, 'Impresora HP Deskjet 3720', 59.99, 3),
(11, 'Impresora HP Laserjet Pro M26nw', 180, 3);

-- -------------------- Consultas sobre una tabla-----------------------

-- 1. Lista el nombre de todos los productos que hay en la tabla producto.

select nombre from producto;

-- 2. Lista los nombres y los precios de todos los productos de la tabla producto.

select nombre,precio from producto;

-- 3. Lista todas las columnas de la tabla producto.

select * from producto;

-- 4. Lista el nombre de los productos, el precio en euros y el precio en dólares estadounidenses (USD).

select nombre,precio as precio_euros, (precio * 1.11) as precio_dolares from producto;

-- 5. Lista el nombre de los productos, el precio en euros y el precio en dólares estadounidenses (USD). 
-- Utiliza los siguientes alias para las columnas: nombre de producto, euros, dólares.

select nombre as nombre_de_producto ,precio as euros, (precio * 1.11) as dolares from producto;

-- 6. Lista los nombres y los precios de todos los productos de la tabla producto,
-- convirtiendo los nombres a mayúscula.

select UPPER(nombre), precio from producto;

-- 7. Lista los nombres y los precios de todos los productos de la tabla producto,
-- convirtiendo los nombres a minúscula.

select LOWER(nombre), precio from producto;

-- 8. Lista el nombre de todos los fabricantes en una columna, y en otra columna obtenga en mayúsculas
--  los dos primeros caracteres del nombre del fabricante.

select nombre, UPPER(SUBSTRING(nombre from 1 for 2)) from fabricante;

-- 9. Lista los nombres y los precios de todos los productos de la tabla producto,redondeando el valor del precio.

select nombre, ROUND(precio) from producto;

-- 10. Lista los nombres y los precios de todos los productos de la tabla producto,truncando el valor 
-- del precio para mostrarlo sin ninguna cifra decimal.

select nombre, TRUNC(precio) from producto;

-- 11. Lista el identificador de los fabricantes que tienen productos en la tabla producto.

-- 12. Lista el identificador de los fabricantes que tienen productos en la tabla producto, eliminando
--  los identificadores que aparecen repetidos.

-- 13. Lista los nombres de los fabricantes ordenados de forma ascendente.

-- 14. Lista los nombres de los fabricantes ordenados de forma descendente.

-- 15. Lista los nombres de los productos ordenados en primer lugar por el nombre de forma ascendente 
-- y en segundo lugar por el precio de forma descendente.

-- 16. Devuelve una lista con las 5 primeras filas de la tabla fabricante.

-- 17. Devuelve una lista con 2 filas a partir de la cuarta fila de la tabla fabricante.
-- La cuarta fila también se debe incluir en la respuesta.

-- 18. Lista el nombre y el precio del producto más barato. (Utilice solamente las cláusulas ORDER BY y LIMIT)

-- 19. Lista el nombre y el precio del producto más caro. (Utilice solamente las cláusulas ORDER BY y LIMIT)

-- 20. Lista el nombre de todos los productos del fabricante cuyo identificador de fabricante es igual a 2.

-- 



