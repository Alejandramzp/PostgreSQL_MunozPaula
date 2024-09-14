
package CampusCar;

import Connection.Conexion;
import java.sql.Connection;
import java.util.InputMismatchException;
import java.util.Scanner;




public class Main {
 
    public static void main(String[] args) {
       Conexion con = new Conexion();
       Connection conex = con.establecerConexion();
       
       if (conex!= null) {
            System.out.println("Conectado a la base de datos PostgreSQL.");
            Main m = new Main();
            m.mostrarMenu(conex);
            
        } else {
            System.out.println("No se pudo conectar a la base de datos PostgreSQL.");
        } 
    }
    
    Scanner scanner = new Scanner(System.in);
    int option = 0;
    
    private int leerOpcion() {
        int option = 0;
        while (true) {
            try {
                option = scanner.nextInt(); 
                scanner.nextLine();
                break; 
            } catch (InputMismatchException e) {
                System.out.println("La entrada no es válida. Por favor, ingrese un número entero.");
                scanner.nextLine(); 
            }
        }
        return option;
    }
    
    public void mostrarMenu(Connection conn) {
        Scanner scanner = new Scanner(System.in);
        do {
            System.out.println("\n------------------------------------------------");
            System.out.println("'                  Consultas                     '");
            System.out.println("'                                                '");
            System.out.println("' 1. Listar Vehículos Disponibles                '");
            System.out.println("' 2. Clientes con Compras Recientes              '");
            System.out.println("' 3. Historial de Servicios por Vehículo         '");
            System.out.println("' 4. Proveedores de Piezas Utilizados            '");
            System.out.println("' 5. Rendimiento del Personal de Ventas          '");
            System.out.println("' 6. Servicios Realizados por un Empleado        '");
            System.out.println("' 7. Clientes Potenciales y Vehículos de Interés '");
            System.out.println("' 8. Empleados del Departamento de Servicio      '");
            System.out.println("' 9. Vehículos Vendidos en un Rango de Precios   '");
            System.out.println("' 10. Clientes con Múltiples Compras             '");
            System.out.println("' 11. Salir                                      '");
            System.out.println("--------------------------------------------------");
            System.out.print("Ingrese su elección: ");
            option = leerOpcion();
            
            switch (option) {
                case 1 -> Consultas.vehiculosDisponibles(conn);
                case 2 -> Consultas.clientesConCompras(conn);
                case 3 -> {
                    System.out.print("Ingrese el ID del vehículo para ver el historial: ");
                    int idVehiculo = scanner.nextInt();
                    Consultas.historialServicios(conn, idVehiculo);
                }
                case 4 -> Consultas.listarProveedores(conn);
                case 5 -> Consultas.rendimientoPersonalVentas(conn);
                case 6 -> {
                    System.out.print("Ingrese el ID del empleado de servicios: ");
                    int idEmpleado = scanner.nextInt();
                    Consultas.serviciosPorEmpleado(conn, idEmpleado);
                }
                case 7 -> Consultas.clientesPotenciales(conn);
                case 8 -> Consultas.empleadosServicio(conn);
                case 9 -> {
                    System.out.print("Ingrese el precio mínimo: ");
                    int precioMin = scanner.nextInt();
                    System.out.print("Ingrese el precio máximo: ");
                    int precioMax = scanner.nextInt();
                    Consultas.vehiculosVendidosEnRangoDePrecios(conn, precioMin, precioMax);
                }
                case 10 -> Consultas.clientesMultiplesCompras(conn);
                case 11 -> System.out.println("Saliendo del programa...");
                default -> System.out.println("Opción no válida, por favor intente de nuevo.");
            }

        } while (option != 11);
        scanner.close();
    }
}
