-- ################### INSERTS ###################

INSERT INTO vehiculo (marca, modelo, anyo, precio, estado) VALUES 
('Toyota', 'Corolla', '2023', 20000, 'Nuevo'),
('Honda', 'Civic', '2022', 22000, 'Nuevo'),
('Ford', 'Focus', '2021', 18000, 'Usado'),
('Chevrolet', 'Spark', '2020', 15000, 'Usado'),
('Mazda', 'CX-5', '2023', 25000, 'Nuevo');

INSERT INTO cliente (nombre, cedula, celular) VALUES 
('Juan Perez', '123456789', '3216549870'),
('Ana Gómez', '987654321', '3159876540'),
('Luis Martinez', '654789123', '3107896540');

INSERT INTO cliente_vehiculo (id_cliente, id_vehiculo) VALUES 
(1, 1), 
(2, 3),  
(3, 2);  

INSERT INTO cliente_potencial (nombre, cedula, celular, id_vehiculoInteres) VALUES 
('Pedro Pacheco', '321456987', '3126543210', 5), 
('Maria Lopez', '456789123', '3174569870', 4); 

INSERT INTO proovedor (nombre, pieza, cantidad) VALUES 
('AutoPiezas', 'Filtro de Aceite', 50),
('Motores y Más', 'Motor V6', 10),
('Repuestos Rápidos', 'Pastillas de Freno', 100);

INSERT INTO servicio (servicio, id_vehiculo, fechaInicio, fechaFin, id_proovedor) VALUES 
('Cambio de Aceite', 1, '2024-09-01', '2024-09-01', 1),  
('Reparación de Motor', 3, '2024-08-25', '2024-08-27', 2),
('Cambio de Pastillas de Freno', 2, '2024-08-30', '2024-08-31', 3); 

INSERT INTO empleado (nombre, cedula, celular, rol, fecha_contratacion) VALUES 
('Carlos Sánchez', '333444555', '3112233440', 'Mecánico', '2020-01-15'),
('Laura Torres', '444555666', '3115566770', 'Vendedor', '2019-03-10'),
('Jorge Diaz', '555666777', '3188877665', 'Mecánico', '2021-07-20');

INSERT INTO departamento_servicio (id_empleado, id_servicio, horario) VALUES 
(1, 1, 'Lunes'), 
(3, 2, 'Martes'), 
(1, 3, 'Viernes'); 

INSERT INTO departamento_ventas (id_empleado, comision, id_cliente, fecha) VALUES 
(2, 500, 1, '2024-09-10'),  
(2, 450, 3, '2024-08-28');  