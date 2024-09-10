-- TABLA OFICINA
CREATE TABLE oficina (
    codigo_oficina VARCHAR(10) PRIMARY KEY NOT NULL,
    ciudad VARCHAR(30) NOT NULL,
    pais VARCHAR(50) NOT NULL,
    region VARCHAR(50),
    codigo_postal VARCHAR(10) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    linea_direccion1 VARCHAR(50) NOT NULL,
    linea_direccion2 VARCHAR(50)
);

-- TABLA GAMA_PRODUCTO
CREATE TABLE gama_producto (
    gama VARCHAR(50) PRIMARY KEY NOT NULL,
    descripcion_texto TEXT,
    descripcion_html TEXT,
    imagen VARCHAR(256)
);

-- TABLA PRODUCTO
CREATE TABLE producto (
    codigo_producto VARCHAR(15) PRIMARY KEY NOT NULL,
    nombre VARCHAR(70) NOT NULL,
    gama VARCHAR(50) NOT NULL,
    FOREIGN KEY (gama) REFERENCES gama_producto(gama),
    dimensiones VARCHAR(25),
    proveedor VARCHAR(50),
    descripcion TEXT,
    cantidad_en_stock SMALLINT NOT NULL,
    precio_venta DECIMAL(15, 2) NOT NULL,
    precio_proveedor DECIMAL(15, 2)
);

-- TABLA EMPLEADO
CREATE TABLE empleado (
    codigo_empleado SERIAL PRIMARY KEY NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido1 VARCHAR(50) NOT NULL,
    apellido2 VARCHAR(50),
    extension VARCHAR(10) NOT NULL,
    email VARCHAR(100) NOT NULL,
    codigo_oficina VARCHAR(10) NOT NULL,
    codigo_jefe INT,
    puesto VARCHAR(50),
    FOREIGN KEY (codigo_oficina) REFERENCES oficina(codigo_oficina),
    FOREIGN KEY (codigo_jefe) REFERENCES empleado(codigo_empleado)
);

-- TABLA CLIENTE
CREATE TABLE cliente (
    codigo_cliente SERIAL PRIMARY KEY NOT NULL,
    nombre_cliente VARCHAR(50) NOT NULL,
    nombre_contacto VARCHAR(30),
    apellido_contacto VARCHAR(30),
    telefono VARCHAR(15) NOT NULL,
    fax VARCHAR(15) NOT NULL,
    linea_direccion1 VARCHAR(50) NOT NULL,
    linea_direccion2 VARCHAR(50),
    ciudad VARCHAR(50) NOT NULL,
    region VARCHAR(50),
    pais VARCHAR(50),
    codigo_postal VARCHAR(10),
    codigo_empleado_rep_ventas INT,
    FOREIGN KEY (codigo_empleado_rep_ventas) REFERENCES empleado(codigo_empleado),
    limite_credito DECIMAL(15, 2)
);

-- TABLA PAGO
CREATE TABLE pago (
    codigo_cliente INT NOT NULL,
    FOREIGN KEY (codigo_cliente) REFERENCES cliente(codigo_cliente),
    forma_pago VARCHAR(40) NOT NULL,
    id_transaccion VARCHAR(50) PRIMARY KEY NOT NULL,
    fecha_pago DATE NOT NULL,
    total DECIMAL(15, 2) NOT NULL
);

-- TABLA PEDIDO
CREATE TABLE pedido (
    codigo_pedido SERIAL PRIMARY KEY NOT NULL,
    fecha_pedido DATE NOT NULL,
    fecha_esperada DATE NOT NULL,
    fecha_entrega DATE,
    estado VARCHAR(15) NOT NULL,
    comentarios TEXT,
    codigo_cliente INT NOT NULL,
    FOREIGN KEY (codigo_cliente) REFERENCES cliente(codigo_cliente)
);

-- TABLA DETALLE PEDIDO
CREATE TABLE detalle_pedido (
    codigo_pedido INT NOT NULL,
    FOREIGN KEY (codigo_pedido) REFERENCES pedido(codigo_pedido),
    codigo_producto VARCHAR(15) NOT NULL,
    FOREIGN KEY (codigo_producto) REFERENCES producto(codigo_producto),
    cantidad INT NOT NULL,
    precio_unidad DECIMAL(15, 2) NOT NULL,
    numero_linea SMALLINT NOT NULL
);

SELECT tablename  FROM pg_catalog.pg_tables where schemaname = 'public';

-- -------------------- Consultas sobre una tabla-----------------------

-- 1.Devuelve un listado con el código de oficina y la ciudad donde hay oficinas.

SELECT codigo_oficina, ciudad from oficina;

-- 2.Devuelve un listado con la ciudad y el teléfono de las oficinas de España.

SELECT ciudad,telefono from oficina where pais = 'España';

-- 3.Devuelve un listado con el nombre, apellidos y email de los empleados cuyo jefe tiene un código de jefe igual a 7.

SELECT nombre, apellido1, apellido2, email from empleado where codigo_jefe = '7';

-- 4.Devuelve el nombre del puesto, nombre, apellidos y email del jefe de la empresa.

SELECT puesto, nombre, apellido1, apellido2, email from empleado where codigo_jefe is null;

-- 5.Devuelve un listado con el nombre, apellidos y puesto de aquellos empleados que no sean representantes de ventas.

SELECT nombre, apellido1, apellido2, puesto from empleado where puesto != 'Representante Ventas';

-- 6.Devuelve un listado con el nombre de todos los clientes españoles.

SELECT nombre_cliente from cliente where pais = 'Spain';

-- 7.Devuelve un listado con los distintos estados por los que puede pasar un pedido.

SELECT distinct estado from pedido;

-- 8.Devuelve un listado con el código de cliente de aquellos clientes que realizaron algún pago en 2008.
-- EXTRACT de PostgreSQL 

SELECT distinct codigo_cliente from pago where EXTRACT(year from fecha_pago) = 2008;

-- DATE_TRUNC de PostgreSQL 

SELECT distinct codigo_cliente from pago where DATE_TRUNC('year', fecha_pago) = DATE '2008-01-01';

-- Sin usar funciones específicas para obtener el año

SELECT distinct codigo_cliente from pago where fecha_pago >= '2008-01-01' AND fecha_pago < '2009-01-01';


