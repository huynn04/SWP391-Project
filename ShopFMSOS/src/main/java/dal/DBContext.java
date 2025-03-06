package dal;

import java.sql.*;

public class DBContext {

    protected Connection connection;
    protected PreparedStatement statement;
    protected ResultSet resultSet;

    // Phương thức để kết nối cơ sở dữ liệu
    public Connection getConnection() {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            String url = "jdbc:sqlserver://localhost:1433;databaseName=ShopFMSOS";
            String user = "sa";
            String password = "123456";
            connection = DriverManager.getConnection(url, user, password);
            return connection;
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Không thể kết nối cơ sở dữ liệu: " + e.getMessage());
            return null;
        }
    }

    // Phương thức main để kiểm tra kết nối
    public static void main(String[] args) {
        DBContext test = new DBContext();
        test.connection = test.getConnection();

        // Kiểm tra xem kết nối có thành công không
        if (test.connection != null) {
            System.out.println("Kết nối thành công: " + test.connection);
        } else {
            System.err.println("Không thể kết nối đến cơ sở dữ liệu.");
        }
    }

    // Phương thức đóng kết nối
    public void closeConnection() {
        try {
            // Kiểm tra và đóng các đối tượng nếu không phải null
            if (resultSet != null) {
                resultSet.close();
            }
            if (statement != null) {
                statement.close();
            }
            if (connection != null) {
                connection.close();
            }
        } catch (Exception e) {
            System.err.println("Lỗi khi đóng kết nối: " + e.getMessage());
        }
    }
}
