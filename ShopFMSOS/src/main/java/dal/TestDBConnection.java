/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class TestDBConnection {
    public static void main(String[] args) {
        String url = "jdbc:sqlserver://localhost:1433;databaseName=ShopFMSOS;encrypt=false;trustServerCertificate=true";
        String user = "sa";  // Kiểm tra user trong SQL Server
        String password = "123456";  // Đảm bảo đúng mật khẩu

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            Connection conn = DriverManager.getConnection(url, user, password);
            System.out.println("Kết nối thành công đến SQL Server!");
            conn.close();
        } catch (ClassNotFoundException e) {
            System.err.println("Không tìm thấy driver SQL Server. Hãy kiểm tra thư viện JDBC.");
        } catch (SQLException e) {
            System.err.println("Lỗi kết nối: " + e.getMessage());
        }
    }
}
