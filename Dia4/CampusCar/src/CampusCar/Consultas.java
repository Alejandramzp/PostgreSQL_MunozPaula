
package CampusCar;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class Consultas {
   
    //1. Listar Vehículos Disponibles 
    
    public static void vehiculosDisponibles(Connection conn) {
        String query = """
                       SELECT marca, modelo, precio 
                       FROM vehiculo
                       WHERE id NOT IN (SELECT id_vehiculo FROM cliente_vehiculo);""";
        try (PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            System.out.println("\n--------------------Vehiculos Disponibles----------------------------");
            while (rs.next()) {
                System.out.println("Marca: " + rs.getString("marca") + "| Modelo: " + rs.getString("modelo") + "| Precio: " + rs.getDouble("precio"));
            }
            System.out.println("-----------------------------------------------------------------------");
        } catch (SQLException e) {
            System.err.println("Error al ejecutar la consulta: " + e.getMessage());
        }
    }
    
    //2. Clientes con Compras Recientes
    
    public static void clientesConCompras(Connection conn) {
        String query = """
                       SELECT c.nombre, c.cedula, v.marca, v.modelo, v.precio
                       FROM cliente c
                       JOIN cliente_vehiculo cv ON c.id = cv.id_cliente
                       JOIN vehiculo v ON v.id = cv.id_vehiculo
                       WHERE cv.id_vehiculo IS NOT NULL
                       ORDER BY cv.id_vehiculo DESC; """;

        try (PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            System.out.println("\n---------------------Clientes Con Compras---------------------------");
            while (rs.next()) {
                System.out.println("Cliente: " + rs.getString("nombre") + " | " + rs.getString("cedula") + 
                                   " || Vehículo: " + rs.getString("marca") + " | " + rs.getString("modelo") +
                                   " | Precio: " + rs.getDouble("precio"));
            }
            System.out.println("----------------------------------------------------------------------");
        } catch (SQLException e) {
            System.err.println("Error al ejecutar la consulta: " + e.getMessage());
        }
    }

    //3. Historial de Servicios por Vehículo
    
    public static void historialServicios(Connection conn, int idVehiculo) {
        String query = """
                       SELECT s.servicio, s.fechaInicio, s.fechaFin, e.nombre AS empleado
                       FROM servicio s
                       JOIN departamento_servicio ds ON s.id = ds.id_servicio
                       JOIN empleado e ON ds.id_empleado = e.id
                       WHERE s.id_vehiculo = ?;""";

        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, idVehiculo);
            ResultSet rs = stmt.executeQuery();
            
            System.out.println("\n-------------------Historial Servicios-----------------------------");
            while (rs.next()) {
                System.out.println("Servicio: " + rs.getString("servicio") + " | Fecha Inicio: " + rs.getString("fechaInicio") + " | Fecha Fin: " + rs.getString("fechaFin") +"|| Empleado: " + rs.getString("empleado"));
            }
            System.out.println("---------------------------------------------------------------------");
        } catch (SQLException e) {
            System.err.println("Error al ejecutar la consulta: " + e.getMessage());
        }
    }

    //4. Proveedores de Piezas Utilizados
    
    public static void listarProveedores(Connection conn) {
        String query = """
                       SELECT p.nombre, p.pieza, s.servicio, s.fechaInicio, s.fechaFin
                       FROM servicio s
                       JOIN proovedor p ON s.id_proovedor = p.id;""";

        try (PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            System.out.println("\n--------------------Lista de Proveedores----------------------------");
            while (rs.next()) {
                System.out.println("Proveedor: " + rs.getString("nombre") + " | " + "Pieza: " + rs.getString("pieza") + " || "+ "Servicio: " + rs.getString("servicio") + " | " +"Fecha Inicio: " + rs.getString("fechaInicio") + " | " + "Fecha Fin: " + rs.getString("fechaFin"));
            }
            System.out.println("----------------------------------------------------------------------");
        } catch (SQLException e) {
            System.err.println("Error al ejecutar la consulta: " + e.getMessage());
        }
    }

    //5. Rendimiento del Personal de Ventas
    
    public static void rendimientoPersonalVentas(Connection conn) {
        String query = """
                       SELECT e.nombre, SUM(dv.comision) AS total_comision
                       FROM departamento_ventas dv
                       JOIN empleado e ON dv.id_empleado = e.id
                       WHERE dv.fecha BETWEEN '2024-06-01' AND '2024-12-31' 
                       GROUP BY e.nombre;""";

        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            ResultSet rs = stmt.executeQuery();
            
            System.out.println("\n---------------------Rendimiento Personal Ventas---------------------------");
            while (rs.next()) {
                System.out.println("Empleado: " + rs.getString("nombre") + " | " + 
                                   "Total Comisiones: " + rs.getDouble("total_comision"));
            }
            System.out.println("-----------------------------------------------------------------------------");
        } catch (SQLException e) {
            System.err.println("Error al ejecutar la consulta: " + e.getMessage());
        }
    }

    //6. Servicios Realizados por un Empleado
    
    public static void serviciosPorEmpleado(Connection conn, int idEmpleado) {
        String query = """
                       SELECT s.servicio, s.fechaInicio, s.fechaFin, v.marca, v.modelo
                       FROM servicio s
                       JOIN departamento_servicio ds ON s.id = ds.id_servicio
                       JOIN empleado e ON ds.id_empleado = e.id
                       JOIN vehiculo v ON s.id_vehiculo = v.id
                       WHERE e.id = ?;""";

        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, idEmpleado);
            ResultSet rs = stmt.executeQuery();
            
            System.out.println("\n---------------------Servicios Por Empleado---------------------------");
            while (rs.next()) {
                System.out.println("Servicio: " + rs.getString("servicio") + " | " + "Fecha Inicio: " + rs.getString("fechaInicio") + " | " + "Fecha Fin: " + rs.getString("fechaFin") + "|| Vehículo: " + rs.getString("marca") + " | " + rs.getString("modelo"));
            }
            System.out.println("------------------------------------------------------------------------");
        } catch (SQLException e) {
            System.err.println("Error al ejecutar la consulta: " + e.getMessage());
        }
    }

    //7. Clientes Potenciales y Vehículos de Interés
    
     public static void clientesPotenciales(Connection conn) {
        String query = """
                       SELECT cp.nombre, cp.cedula, v.marca, v.modelo
                       FROM cliente_potencial cp
                       JOIN vehiculo v ON cp.id_vehiculoInteres = v.id;""";

        try (PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            System.out.println("\n--------------------- Clientes Potenciales---------------------------");
            while (rs.next()) {
                System.out.println("Cliente Potencial: " + rs.getString("nombre") + "| Cedula " + rs.getString("cedula") +
                                   "|| Vehículo de Interés: " + rs.getString("marca") + " " + rs.getString("modelo"));
            }
            System.out.println("-----------------------------------------------------------------------");
        } catch (SQLException e) {
            System.err.println("Error al ejecutar la consulta: " + e.getMessage());
        }
    }

    //8. Empleados del Departamento de Servicio
     
    public static void empleadosServicio(Connection conn) {
        String query = """
                       SELECT e.nombre, e.cedula, ds.horario
                       FROM departamento_servicio ds
                       JOIN empleado e ON ds.id_empleado = e.id;""";

        try (PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            System.out.println("\n----------------------Empleados Servicio--------------------------");
            while (rs.next()) {
                System.out.println("Empleado: " + rs.getString("nombre") + "| Cedula " + rs.getString("cedula") + 
                                   "| Horario: " + rs.getString("horario"));
            }
            System.out.println("--------------------------------------------------------------------");
        } catch (SQLException e) {
            System.err.println("Error al ejecutar la consulta: " + e.getMessage());
        }
    } 

    //9. Vehículos Vendidos en un Rango de Precios
    
    public static void vehiculosVendidosEnRangoDePrecios(Connection conn, int precioMin, int precioMax) {
        String query = """
                       SELECT v.marca, v.modelo, v.precio
                       FROM vehiculo v
                       JOIN cliente_vehiculo cv ON v.id = cv.id_vehiculo
                       WHERE v.precio BETWEEN ? AND ?; """;

        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, precioMin);
            stmt.setInt(2, precioMax);
            ResultSet rs = stmt.executeQuery();
            
            System.out.println("\n-------------Vehiculos Vendidos---------------------");
            while (rs.next()) {
                System.out.println("Vehículo: " + rs.getString("marca") + " | " + rs.getString("modelo") + 
                                   "| Precio de Venta: " + rs.getDouble("precio"));
            }
            System.out.println("------------------------------------------------------");
        } catch (SQLException e) {
            System.err.println("Error al ejecutar la consulta: " + e.getMessage());
        }
    }

    //10. Clientes con Múltiples Compras
    
    public static void clientesMultiplesCompras(Connection conn) {
        String query = """
                       SELECT c.nombre, c.cedula, COUNT(cv.id_vehiculo) AS cantidad_compras
                       FROM cliente c
                       JOIN cliente_vehiculo cv ON c.id = cv.id_cliente
                       GROUP BY c.nombre, c.cedula
                       HAVING COUNT(cv.id_vehiculo) > 1;""";

        try (PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            System.out.println("\n--------------------Clientes Multiples Compras----------------------------");
            while (rs.next()) {
                System.out.println("Cliente: " + rs.getString("nombre") + "| Cedula" + rs.getString("cedula") + 
                                   "| Cantidad de Compras: " + rs.getInt("cantidad_compras"));
            }
            System.out.println("----------------------------------------------------------------------------");
        } catch (SQLException e) {
            System.err.println("Error al ejecutar la consulta: " + e.getMessage());
        }
    }
     
}
