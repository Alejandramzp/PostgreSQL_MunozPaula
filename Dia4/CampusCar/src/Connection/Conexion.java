
package Connection;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import javax.swing.JOptionPane;


public class Conexion {
    
    private Connection con;
    
    public Connection establecerConexion() {
        Properties props = new Properties();
        try(InputStream input = getClass().getClassLoader().getResourceAsStream("Connection/Config.properties")) {
            if (input == null) {
                throw new IllegalStateException("Archivo Config.properties no encontrado");
            }
            
            props.load(input);
            
            String url = props.getProperty("URL");
            String user = props.getProperty("USER");
            String password = props.getProperty("PASSWORD");
            
            if (url == null || user == null || password == null){
                throw new IllegalStateException("Una o más propiedades de conexión no están definidas");
            }
            
            Class.forName("org.postgresql.Driver");
            con = DriverManager.getConnection(url,user,password);
            
        } catch (IOException | ClassNotFoundException | SQLException | IllegalStateException e) {
            System.err.println("Error en la conexión, error: " + e);
            JOptionPane.showMessageDialog(null, "Error en la conexión: "+ e.toString());
        }
        return con;
    } 
}
