-- ################### CONSULTAS ###################

-- 1. Listar Vehículos Disponibles: Obtener una lista de todos los vehículos disponibles para la venta, 
-- incluyendo detalles como marca, modelo, y precio.

SELECT marca, modelo, precio 
FROM vehiculo
WHERE id NOT IN (SELECT id_vehiculo FROM cliente_vehiculo);

-- 2. Clientes con Compras Recientes: Mostrar los clientes que han realizado compras recientemente, 
-- junto con la información de los vehículos adquiridos.

SELECT c.nombre, c.cedula, v.marca, v.modelo, v.precio
FROM cliente c
JOIN cliente_vehiculo cv ON c.id = cv.id_cliente
JOIN vehiculo v ON v.id = cv.id_vehiculo
WHERE cv.id_vehiculo IS NOT NULL
ORDER BY cv.id_vehiculo DESC; 

-- 3. Historial de Servicios por Vehículo: Obtener el historial completo de servicios realizados para un vehículo 
-- específico, incluyendo detalles sobre los empleados involucrados y las fechas de servicio.

SELECT s.servicio, s.fechaInicio, s.fechaFin, e.nombre AS empleado
FROM servicio s
JOIN departamento_servicio ds ON s.id = ds.id_servicio
JOIN empleado e ON ds.id_empleado = e.id
WHERE s.id_vehiculo = 1; 

-- 4. Proveedores de Piezas Utilizados: Listar los proveedores de piezas que han suministrado componentes utilizados
--  en los servicios de mantenimiento.

SELECT p.nombre, p.pieza, s.servicio, s.fechaInicio, s.fechaFin
FROM servicio s
JOIN proovedor p ON s.id_proovedor = p.id;

-- 5. Rendimiento del Personal de Ventas: Calcular las comisiones generadas por cada empleado del departamento 
-- de ventas en un período específico.

SELECT e.nombre, SUM(dv.comision) AS total_comision
FROM departamento_ventas dv
JOIN empleado e ON dv.id_empleado = e.id
WHERE dv.fecha BETWEEN '2024-06-01' AND '2024-12-31' 
GROUP BY e.nombre;

-- 6. Servicios Realizados por un Empleado: Identificar todos los servicios de mantenimiento realizados por 
-- un empleado específico, incluyendo detalles sobre los vehículos atendidos.

SELECT s.servicio, s.fechaInicio, s.fechaFin, v.marca, v.modelo
FROM servicio s
JOIN departamento_servicio ds ON s.id = ds.id_servicio
JOIN empleado e ON ds.id_empleado = e.id
JOIN vehiculo v ON s.id_vehiculo = v.id
WHERE e.id = 3; 

-- 7. Clientes Potenciales y Vehículos de Interés: Mostrar información sobre los clientes potenciales
--  y los vehículos de su interés, proporcionando pistas valiosas para estrategias de marketing.

SELECT cp.nombre, cp.cedula, v.marca, v.modelo
FROM cliente_potencial cp
JOIN vehiculo v ON cp.id_vehiculoInteres = v.id;

-- 8. Empleados del Departamento de Servicio: Listar todos los empleados que pertenecen al departamento de servicio,
--  junto con sus horarios de trabajo.

SELECT e.nombre, e.cedula, ds.horario
FROM departamento_servicio ds
JOIN empleado e ON ds.id_empleado = e.id;

-- 9. Vehículos Vendidos en un Rango de Precios: Encontrar los vehículos vendidos en un rango de precios específico, 
-- proporcionando datos útiles para análisis de ventas.

SELECT v.marca, v.modelo, v.precio
FROM vehiculo v
JOIN cliente_vehiculo cv ON v.id = cv.id_vehiculo
WHERE v.precio BETWEEN 15000 AND 30000; 

-- 10. Clientes con Múltiples Compras: Identificar a aquellos clientes que han realizado más de una compra 
-- en el concesionario, destacando la lealtad del cliente.

SELECT c.nombre, c.cedula, COUNT(cv.id_vehiculo) AS cantidad_compras
FROM cliente c
JOIN cliente_vehiculo cv ON c.id = cv.id_cliente
GROUP BY c.nombre, c.cedula
HAVING COUNT(cv.id_vehiculo) > 1;



