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

-- ################### Consultas sobre una tabla ###################

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

-- 9.Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de entrega de los pedidos que no han sido entregados a tiempo.

Select codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega from pedido where fecha_esperada < fecha_entrega;

-- 10.Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de entrega de los pedidos cuya fecha de entrega ha sido al menos dos días antes de la fecha esperada.
-- ADDDATE 

Select codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega from pedido where fecha_entrega <= fecha_esperada - INTERVAL '2 days';

-- DATEDIFF

Select codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega from pedido where (fecha_esperada - fecha_entrega) >=2;

-- 11.Devuelve un listado de todos los pedidos que fueron rechazados en 2009.

SELECT codigo_pedido, fecha_pedido, codigo_cliente FROM pedido WHERE estado = 'Rechazado' AND EXTRACT(YEAR FROM fecha_pedido) = 2009;

-- 12.Devuelve un listado de todos los pedidos que han sido entregados en el mes de enero de cualquier año.

SELECT codigo_pedido, fecha_pedido, codigo_cliente from pedido where extract(month from fecha_pedido)='01';

-- 13.Devuelve un listado con todos los pagos que se realizaron en el año 2008 mediante Paypal. Ordene el resultado de mayor a menor.

SELECT codigo_cliente, total FROM pago WHERE EXTRACT(YEAR FROM fecha_pago) = 2008 AND forma_pago = 'Paypal' ORDER BY total DESC;

-- 14.Devuelve un listado con todas las formas de pago que aparecen en la tabla pago. Tenga en cuenta que no deben aparecer formas de pago repetidas.

select distinct forma_pago from pago;

-- 15.Devuelve un listado con todos los productos que pertenecen a la gama Ornamentales y que tienen más de 100 unidades en stock. 
-- El listado deberá estar ordenado por su precio de venta, mostrando en primer lugar los de mayor precio.

SELECT nombre, cantidad_en_stock, precio_venta FROM producto  WHERE gama = 'Ornamentales' AND cantidad_en_stock > 100 ORDER BY precio_venta DESC;

-- 16.Devuelve un listado con todos los clientes que sean de la ciudad de Madrid y cuyo representante de ventas tenga el código de empleado 11 o 30.

select * from cliente where ciudad = 'Madrid' and (codigo_empleado_rep_ventas = '11' or codigo_empleado_rep_ventas = '30');

-- ################### Consultas multitabla (Composición interna) ###################

-- 1.Obtén un listado con el nombre de cada cliente y el nombre y apellido de su representante de ventas.

Select cliente.nombre_cliente as NombreCliente, empleado.nombre as NombreEmpleado, empleado.apellido1 as ApellidoEmpleado
from cliente 
inner join empleado on cliente.codigo_empleado_rep_ventas = empleado.codigo_empleado; 

-- 2. Muestra el nombre de los clientes que hayan realizado pagos junto con el nombre de sus representantes de ventas.

select cliente.nombre_cliente as NombreCliente, empleado.nombre as NombreEmpleado
from cliente
inner join pago on pago.codigo_cliente = cliente.codigo_cliente
inner join empleado on empleado.codigo_empleado = cliente.codigo_empleado_rep_ventas;

-- 3.Muestra el nombre de los clientes que no hayan realizado pagos junto con el nombre de sus representantes de ventas.

Select cliente.nombre_cliente as NombreCliente, empleado.nombre as NombreRepresentante
from cliente
inner join pago on pago.codigo_cliente = cliente.codigo_cliente
inner join empleado on empleado.codigo_empleado = cliente.codigo_empleado_rep_ventas
where pago.codigo_cliente = null;

-- 4.Devuelve el nombre de los clientes que hayan hecho pagos y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante.

Select cliente.nombre_cliente as NombreCliente, empleado.nombre as NombreRepresentante, oficina.ciudad as CiudadRepresentante
from cliente
inner join pago on pago.codigo_cliente = cliente.codigo_cliente
inner join empleado on empleado.codigo_empleado = cliente.codigo_empleado_rep_ventas
inner join oficina on oficina.codigo_oficina = empleado.codigo_oficina;

-- 5.Devuelve el nombre de los clientes que no hayan hecho pagos y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante.

SELECT c.nombre_cliente, e.nombre, e.apellido1, o.ciudad 
FROM cliente c 
INNER JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado 
INNER JOIN oficina o ON e.codigo_oficina = o.codigo_oficina 
LEFT JOIN pago p ON c.codigo_cliente = p.codigo_cliente 
WHERE p.codigo_cliente IS NULL;

-- 6.Lista la dirección de las oficinas que tengan clientes en Fuenlabrada.

select oficina.linea_direccion1 as DireccionOficina
from cliente
inner join empleado on empleado.codigo_empleado= cliente.codigo_empleado_rep_ventas
inner join oficina on oficina.codigo_oficina = empleado.codigo_oficina
where cliente.ciudad = 'Fuenlabrada';

-- 7.Devuelve el nombre de los clientes y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante. 

Select cliente.nombre_cliente as NombreCliente, empleado.nombre as NombreRepresentante, oficina.ciudad as CiudadOficina
from cliente 
inner join empleado on empleado.codigo_empleado= cliente.codigo_empleado_rep_ventas
inner join oficina on oficina.codigo_oficina = empleado.codigo_oficina;

-- 8.Devuelve un listado con el nombre de los empleados junto con el nombre de sus jefes.

Select a.nombre as NombreEmpleado, b.nombre as NombreJefe
from empleado a
left join empleado b on b.codigo_empleado = a.codigo_jefe;

-- 9.Devuelve un listado que muestre el nombre de cada empleados, el nombre de su jefe y el nombre del jefe de sus jefe.

Select a.nombre as NombreEmpleado, b.nombre as NombreJefe, c.nombre as NombreJefeDelJefe
from empleado a
inner join empleado b on b.codigo_empleado = a.codigo_jefe
inner join empleado c on c.codigo_empleado = b.codigo_jefe;

-- 10.Devuelve el nombre de los clientes a los que no se les ha entregado a tiempo un pedido.

Select cliente.nombre_cliente as NombreCliente
from cliente
inner join pedido on pedido.codigo_cliente = cliente.codigo_cliente
where pedido.fecha_esperada < pedido.fecha_entrega;
 
-- 11.Devuelve un listado de las diferentes gamas de producto que ha comprado cada cliente.

Select distinct cliente.nombre_cliente as NombreCliente, gama_producto.gama as GamaProducto
from cliente
inner join pedido on pedido.codigo_cliente = cliente.codigo_cliente
inner join detalle_pedido on detalle_pedido.codigo_pedido = pedido.codigo_pedido
inner join producto on producto.codigo_producto = detalle_pedido.codigo_producto
inner join gama_producto on gama_producto.gama = producto.gama;

-- ################### Consultas multitabla (Composición externa) ###################

-- 1. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.

SELECT c.nombre_cliente 
FROM cliente c 
LEFT JOIN pago p ON c.codigo_cliente = p.codigo_cliente 
WHERE p.codigo_cliente IS NULL;

-- 2. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pedido.

SELECT c.nombre_cliente 
FROM cliente c 
LEFT JOIN pedido p ON c.codigo_cliente = p.codigo_cliente 
WHERE p.codigo_cliente IS NULL;

-- 3. Devuelve un listado que muestre los clientes que no han realizado ningún pago y los que no han realizado ningún pedido.

SELECT c.nombre_cliente 
FROM cliente c 
LEFT JOIN pago p ON c.codigo_cliente = p.codigo_cliente 
LEFT JOIN pedido d ON c.codigo_cliente = d.codigo_cliente 
WHERE p.codigo_cliente IS NULL OR d.codigo_cliente IS NULL;

-- 4. Devuelve un listado que muestre solamente los empleados que no tienen una oficina asociada.

SELECT e.nombre, e.apellido1 
FROM empleado e 
LEFT JOIN oficina o ON e.codigo_oficina = o.codigo_oficina 
WHERE o.codigo_oficina IS NULL;

-- 5. Devuelve un listado que muestre solamente los empleados que no tienen un cliente asociado.

SELECT e.nombre, e.apellido1 
FROM empleado e 
LEFT JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas 
WHERE c.codigo_empleado_rep_ventas IS NULL;

-- 6. Devuelve un listado que muestre solamente los empleados que no tienen un cliente asociado junto con los datos de la oficina donde trabajan.

SELECT e.nombre, e.apellido1, o.linea_direccion1, o.ciudad 
FROM empleado e 
LEFT JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas 
LEFT JOIN oficina o ON e.codigo_oficina = o.codigo_oficina 
WHERE c.codigo_empleado_rep_ventas IS NULL;

-- 7. Devuelve un listado que muestre los empleados que no tienen una oficina asociada y los que no tienen un cliente asociado.

SELECT e.nombre, e.apellido1 
FROM empleado e 
LEFT JOIN oficina o ON e.codigo_oficina = o.codigo_oficina 
LEFT JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas 
WHERE o.codigo_oficina IS NULL OR c.codigo_empleado_rep_ventas IS NULL;

--8. Devuelve un listado de los productos que nunca han aparecido en un pedido.

SELECT p.codigo_producto 
FROM producto p 
LEFT JOIN detalle_pedido dp ON p.codigo_producto = dp.codigo_producto 
WHERE dp.codigo_producto IS NULL;

-- 9. Devuelve un listado de los productos que nunca han aparecido en un pedido. El resultado debe mostrar el nombre, la descripción y la imagen del producto.

SELECT p.nombre, p.descripcion, gp.imagen 
FROM producto p 
LEFT JOIN detalle_pedido dp ON p.codigo_producto = dp.codigo_producto 
inner join gama_producto gp on gp.gama  = p.gama 
WHERE dp.codigo_producto IS NULL;

-- 10. Devuelve las oficinas donde no trabajan ninguno de los empleados que hayan sido los representantes de ventas de algún cliente que haya realizado la compra de algún producto de la gama Frutales.

SELECT o.ciudad, o.pais 
FROM oficina o 
LEFT JOIN empleado e ON o.codigo_oficina = e.codigo_oficina 
LEFT JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas 
LEFT JOIN pedido p ON c.codigo_cliente = p.codigo_cliente 
LEFT JOIN detalle_pedido dp ON p.codigo_pedido = dp.codigo_pedido 
LEFT JOIN producto pr ON dp.codigo_producto = pr.codigo_producto 
WHERE pr.gama = 'Frutales' AND c.codigo_cliente IS NULL;

-- 11. Devuelve un listado con los clientes que han realizado algún pedido pero no han realizado ningún pago.

SELECT c.nombre_cliente 
FROM cliente c 
LEFT JOIN pedido p ON c.codigo_cliente = p.codigo_cliente 
LEFT JOIN pago pa ON c.codigo_cliente = pa.codigo_cliente 
WHERE p.codigo_cliente IS NOT NULL AND pa.codigo_cliente IS NULL;

-- 12. Devuelve un listado con los datos de los empleados que no tienen clientes asociados y el nombre de su jefe asociado.

SELECT e.nombre, e.apellido1, j.nombre AS nombre_jefe, j.apellido1 AS apellido_jefe 
FROM empleado e 
LEFT JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas 
LEFT JOIN empleado j ON e.codigo_jefe = j.codigo_empleado 
WHERE c.codigo_empleado_rep_ventas IS NULL;

-- ################### Consultas resumen ################### 

-- 1. ¿Cuántos empleados hay en la compañía?

SELECT COUNT(*) AS total_empleados FROM empleado;

-- 2. ¿Cuántos clientes tiene cada país?

SELECT pais, COUNT(*) AS total_clientes 
FROM cliente 
GROUP BY pais;

-- 3. ¿Cuál fue el pago medio en 2009?

SELECT AVG(total) AS pago_medio 
FROM pago 
WHERE EXTRACT(YEAR FROM fecha_pago) = 2009;

-- 4. ¿Cuántos pedidos hay en cada estado? Ordena el resultado de forma descendente por el número de pedidos.

SELECT estado, COUNT(*) AS total_pedidos 
FROM pedido 
GROUP BY estado 
ORDER BY total_pedidos DESC;

-- 5. Calcula el precio de venta del producto más caro y más barato en una misma consulta.

SELECT MAX(precio_venta) AS producto_mas_caro, MIN(precio_venta) AS producto_mas_barato 
FROM producto;

-- 6. Calcula el número de clientes que tiene la empresa.

SELECT COUNT(*) AS total_clientes 
FROM cliente;

-- 7. ¿Cuántos clientes existen con domicilio en la ciudad de Madrid?

SELECT COUNT(*) AS total_clientes 
FROM cliente 
WHERE ciudad = 'Madrid';

-- 8. ¿Calcula cuántos clientes tiene cada una de las ciudades que empiezan por M?

SELECT ciudad, COUNT(*) AS total_clientes 
FROM cliente 
WHERE ciudad LIKE 'M%' 
GROUP BY ciudad;

-- 9. Devuelve el nombre de los representantes de ventas y el número de clientes al que atiende cada uno.

SELECT e.nombre, e.apellido1, COUNT(c.codigo_cliente) AS total_clientes 
FROM empleado e 
LEFT JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas 
GROUP BY e.nombre, e.apellido1;

-- 10. Calcula el número de clientes que no tiene asignado representante de ventas.

SELECT COUNT(*) AS total_clientes_sin_representante 
FROM cliente 
WHERE codigo_empleado_rep_ventas IS NULL;

-- 11. Calcula la fecha del primer y último pago realizado por cada uno de los clientes. El listado deberá mostrar el nombre y los apellidos de cada cliente.

SELECT c.nombre_cliente, MIN(p.fecha_pago) AS primer_pago, MAX(p.fecha_pago) AS ultimo_pago 
FROM cliente c 
JOIN pago p ON c.codigo_cliente = p.codigo_cliente 
GROUP BY c.nombre_cliente;

-- 12. Calcula el número de productos diferentes que hay en cada uno de los pedidos.

SELECT codigo_pedido, COUNT(DISTINCT codigo_producto) AS productos_diferentes 
FROM detalle_pedido 
GROUP BY codigo_pedido;

-- 13. Calcula la suma de la cantidad total de todos los productos que aparecen en cada uno de los pedidos.

SELECT codigo_pedido, SUM(cantidad) AS cantidad_total 
FROM detalle_pedido 
GROUP BY codigo_pedido;

-- 14. Devuelve un listado de los 20 productos más vendidos y el número total de unidades que se han vendido de cada uno. El listado deberá estar ordenado por el número total de unidades vendidas.

SELECT codigo_producto, SUM(cantidad) AS total_unidades_vendidas 
FROM detalle_pedido 
GROUP BY codigo_producto 
ORDER BY total_unidades_vendidas DESC 
LIMIT 20;

-- 15. La facturación que ha tenido la empresa en toda la historia, indicando la base imponible, el IVA y el total facturado. La base imponible se calcula sumando el coste del producto por el número de 
-- unidades vendidas de la tabla detalle_pedido. El IVA es el 21 % de la base imponible, y el total la suma de los dos campos anteriores.

SELECT SUM(dp.cantidad * dp.precio_unidad) AS base_imponible, 
       SUM(dp.cantidad * dp.precio_unidad) * 0.21 AS iva, 
       SUM(dp.cantidad * dp.precio_unidad) * 1.21 AS total_facturado 
FROM detalle_pedido dp;

--16. La misma información que en la pregunta anterior, pero agrupada por código de producto.

SELECT codigo_producto, 
       SUM(dp.cantidad * dp.precio_unidad) AS base_imponible, 
       SUM(dp.cantidad * dp.precio_unidad) * 0.21 AS iva, 
       SUM(dp.cantidad * dp.precio_unidad) * 1.21 AS total_facturado 
FROM detalle_pedido dp 
GROUP BY codigo_producto;

-- 17. La misma información que en la pregunta anterior, pero agrupada por código de producto filtrada por los códigos que empiecen por OR.

SELECT codigo_producto, 
       SUM(dp.cantidad * dp.precio_unidad) AS base_imponible, 
       SUM(dp.cantidad * dp.precio_unidad) * 0.21 AS iva, 
       SUM(dp.cantidad * dp.precio_unidad) * 1.21 AS total_facturado 
FROM detalle_pedido dp 
WHERE codigo_producto LIKE 'OR%' 
GROUP BY codigo_producto;

-- 18. Lista las ventas totales de los productos que hayan facturado más de 3000 euros. Se mostrará el nombre, unidades vendidas, total facturado y total facturado con impuestos (21% IVA).

SELECT p.nombre, SUM(dp.cantidad) AS unidades_vendidas, 
       SUM(dp.cantidad * dp.precio_unidad) AS total_facturado, 
       SUM(dp.cantidad * dp.precio_unidad) * 1.21 AS total_facturado_con_iva 
FROM detalle_pedido dp 
JOIN producto p ON dp.codigo_producto = p.codigo_producto 
GROUP BY p.nombre 
HAVING SUM(dp.cantidad * dp.precio_unidad) > 3000;

-- 19. Muestre la suma total de todos los pagos que se realizaron para cada uno de los años que aparecen en la tabla pagos.

SELECT EXTRACT(YEAR FROM fecha_pago) AS año, SUM(total) AS total_pagos 
FROM pago 
GROUP BY EXTRACT(YEAR FROM fecha_pago);

-- ################### Subconsultas ###################

--  ######### Con operadores básicos de comparación #########

-- 1. Devuelve el nombre del cliente con mayor límite de crédito.

SELECT nombre_cliente 
FROM cliente 
WHERE limite_credito = (SELECT MAX(limite_credito) FROM cliente);

-- 2. Devuelve el nombre del producto que tenga el precio de venta más caro.

SELECT nombre 
FROM producto 
WHERE precio_venta = (SELECT MAX(precio_venta) FROM producto);

-- 3. Devuelve el nombre del producto del que se han vendido más unidades.(Tenga en cuenta que tendrá que calcular cuál es el número total de unidades que se han vendido de cada producto a partir de los datos de la tabla detalle_pedido)

SELECT nombre 
FROM producto 
WHERE codigo_producto = (
    SELECT codigo_producto 
    FROM detalle_pedido 
    GROUP BY codigo_producto 
    ORDER BY SUM(cantidad) DESC 
    LIMIT 1);

--4. Los clientes cuyo límite de crédito sea mayor que los pagos que haya realizado. (Sin utilizar INNER JOIN).
   
SELECT nombre_cliente 
FROM cliente 
WHERE limite_credito > (SELECT COALESCE(SUM(total), 0) 
                        FROM pago 
                        WHERE cliente.codigo_cliente = pago.codigo_cliente);

-- 5. Devuelve el producto que más unidades tiene en stock.
                       
SELECT nombre 
FROM producto 
WHERE cantidad_en_stock = (SELECT MAX(cantidad_en_stock) FROM producto);

-- 6. Devuelve el producto que menos unidades tiene en stock.

SELECT nombre 
FROM producto 
WHERE cantidad_en_stock = (SELECT MIN(cantidad_en_stock) FROM producto);

-- 7. Devuelve el nombre, los apellidos y el email de los empleados que están a cargo de Alberto Soria.

SELECT nombre, apellido1, apellido2, email 
FROM empleado 
WHERE codigo_jefe = (SELECT codigo_empleado 
                     FROM empleado 
                     WHERE nombre = 'Alberto' AND apellido1 = 'Soria');

-- ######### Subconsultas con ALL y ANY #########
                    
-- 8. Devuelve el nombre del cliente con mayor límite de crédito.
                    
SELECT nombre_cliente 
FROM cliente 
WHERE limite_credito >= ALL (SELECT limite_credito FROM cliente);

-- 9. Devuelve el nombre del producto que tenga el precio de venta más caro.

SELECT nombre 
FROM producto 
WHERE precio_venta >= ALL (SELECT precio_venta FROM producto);

-- 10. Devuelve el producto que menos unidades tiene en stock.

SELECT nombre 
FROM producto 
WHERE cantidad_en_stock <= ALL (SELECT cantidad_en_stock FROM producto);

-- ######### Subconsultas con IN y NOT IN #########

-- 11. Devuelve el nombre, apellido1 y cargo de los empleados que no representen a ningún cliente.

SELECT nombre, apellido1, puesto 
FROM empleado 
WHERE codigo_empleado NOT IN (SELECT codigo_empleado_rep_ventas FROM cliente);

-- 12. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.

SELECT nombre_cliente 
FROM cliente 
WHERE codigo_cliente NOT IN (SELECT codigo_cliente FROM pago);

-- 13. Devuelve un listado que muestre solamente los clientes que sí han realizado algún pago.

SELECT nombre_cliente 
FROM cliente 
WHERE codigo_cliente IN (SELECT codigo_cliente FROM pago);

-- 14. Devuelve un listado de los productos que nunca han aparecido en un pedido.

SELECT nombre 
FROM producto 
WHERE codigo_producto NOT IN (SELECT codigo_producto FROM detalle_pedido);

-- 15. Devuelve el nombre, apellidos, puesto y teléfono de la oficina de aquellos empleados que no sean representante de ventas de ningún cliente.

SELECT e.nombre, e.apellido1, e.puesto, o.telefono 
FROM empleado e 
JOIN oficina o ON e.codigo_oficina = o.codigo_oficina 
WHERE e.codigo_empleado NOT IN (SELECT codigo_empleado_rep_ventas FROM cliente);

-- 16. Devuelve las oficinas donde no trabajan ninguno de los empleados que hayan sido los representantes de ventas de algún cliente que haya realizado la compra de algún producto de la gama Frutales.

SELECT DISTINCT o.ciudad 
FROM oficina o 
WHERE o.codigo_oficina NOT IN (
    SELECT e.codigo_oficina 
    FROM empleado e 
    JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas 
    JOIN detalle_pedido dp ON c.codigo_cliente = dp.codigo_pedido 
    JOIN producto p ON dp.codigo_producto = p.codigo_producto 
    WHERE p.gama = 'Frutales');

--17. Devuelve un listado con los clientes que han realizado algún pedido pero no han realizado ningún pago.
   
SELECT nombre_cliente 
FROM cliente 
WHERE codigo_cliente IN (SELECT codigo_cliente FROM pedido) 
AND codigo_cliente NOT IN (SELECT codigo_cliente FROM pago);

-- ######### Subconsultas con EXISTS y NOT EXISTS #########

--18. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.

SELECT nombre_cliente 
FROM cliente 
WHERE NOT EXISTS (SELECT 1 FROM pago p WHERE p.codigo_cliente = cliente.codigo_cliente);

-- 19. Devuelve un listado que muestre solamente los clientes que sí han realizado algún pago.

SELECT nombre_cliente 
FROM cliente 
WHERE EXISTS (SELECT 1 FROM pago p WHERE p.codigo_cliente = cliente.codigo_cliente);

-- 20. Devuelve un listado de los productos que nunca han aparecido en un pedido.

SELECT nombre 
FROM producto 
WHERE NOT EXISTS (SELECT 1 FROM detalle_pedido dp WHERE dp.codigo_producto = producto.codigo_producto);

-- 21. Devuelve un listado de los productos que han aparecido en un pedido alguna vez.

SELECT nombre 
FROM producto 
WHERE EXISTS (SELECT 1 FROM detalle_pedido dp WHERE dp.codigo_producto = producto.codigo_producto);

-- ################### Consultas Variadas ###################

-- 1. Devuelve el listado de clientes indicando el nombre del cliente y cuántos pedidos ha realizado. Tenga en cuenta que pueden existir clientes que no han realizado ningún pedido.

SELECT c.nombre_cliente, 
       (SELECT COUNT(*) 
        FROM pedido p 
        WHERE p.codigo_cliente = c.codigo_cliente) AS total_pedidos
FROM cliente c;

-- 2. Devuelve un listado con los nombres de los clientes y el total pagado por cada uno de ellos. Tenga en cuenta que pueden existir clientes que no han realizado ningún pago.

SELECT c.nombre_cliente, 
       (SELECT COALESCE(SUM(p.total), 0) 
        FROM pago p 
        WHERE p.codigo_cliente = c.codigo_cliente) AS total_pagado
FROM cliente c;

-- 3. Devuelve el nombre de los clientes que hayan hecho pedidos en 2008 ordenados alfabéticamente de menor a mayor.

SELECT DISTINCT c.nombre_cliente
FROM cliente c
WHERE EXISTS (SELECT 1 
              FROM pedido p 
              WHERE p.codigo_cliente = c.codigo_cliente 
              AND EXTRACT(YEAR FROM p.fecha_pedido) = 2008)
ORDER BY c.nombre_cliente;

-- 4. Devuelve el nombre del cliente, el nombre y primer apellido de su representante de ventas y el número de teléfono de la oficina del representante de ventas, de aquellos clientes que no hayan realizado ningún pago.

SELECT c.nombre_cliente, 
       e.nombre AS nombre_representante, 
       e.apellido1 AS apellido_representante, 
       o.telefono AS telefono_oficina
FROM cliente c
JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
WHERE NOT EXISTS (SELECT 1 
                  FROM pago p 
                  WHERE p.codigo_cliente = c.codigo_cliente);

-- 5. Devuelve el listado de clientes donde aparezca el nombre del cliente, el nombre y primer apellido de su representante de ventas y la ciudad donde está su oficina.
                 
SELECT c.nombre_cliente, 
       e.nombre AS nombre_representante, 
       e.apellido1 AS apellido_representante, 
       o.ciudad AS ciudad_oficina
FROM cliente c
JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
JOIN oficina o ON e.codigo_oficina = o.codigo_oficina;

-- 6. Devuelve el nombre, apellidos, puesto y teléfono de la oficina de aquellos empleados que no sean representante de ventas de ningún cliente.

SELECT e.nombre, 
       e.apellido1, 
       e.apellido2, 
       e.puesto, 
       o.telefono
FROM empleado e
JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
WHERE e.codigo_empleado NOT IN (SELECT codigo_empleado_rep_ventas FROM cliente);

-- 7. Devuelve un listado indicando todas las ciudades donde hay oficinas y el número de empleados que tiene.

SELECT o.ciudad, 
       (SELECT COUNT(*) 
        FROM empleado e 
        WHERE e.codigo_oficina = o.codigo_oficina) AS total_empleados
FROM oficina o;

-- REALIZADO POR PAULA MUÑOZ
