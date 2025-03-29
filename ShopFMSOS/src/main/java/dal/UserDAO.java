/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Date;
import model.Address;

/**
 *
 * @author Nguyễn Ngoc Huy CE180178
 */
public class UserDAO extends DBContext {

    public Optional<User> getUserByEmail(String email) {
    String sql = "SELECT user_id, full_name, email, role_id, password, phone_number, address, avatar, status FROM users WHERE email = ?";
    try (Connection conn = getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setString(1, email);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            User user = new User();
            user.setUserId(rs.getInt("user_id"));
            user.setFullName(rs.getString("full_name"));
            user.setEmail(rs.getString("email"));
            user.setRoleId(rs.getInt("role_id")); // ✅ FIXED
            user.setPassword(rs.getString("password"));
            user.setPhoneNumber(rs.getString("phone_number"));
            user.setAddress(rs.getString("address"));
            user.setAvatar(rs.getString("avatar"));
            user.setStatus(rs.getInt("status"));

            System.out.println("📌 Found user: " + user.getFullName() + " (ID: " + user.getUserId() + "), Role: " + user.getRoleId());

            return Optional.of(user);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return Optional.empty();
}




public boolean insertUser(User user) {
    String query = "INSERT INTO users (full_name, email, phone_number, address, password, avatar, status, role_id, created_at, updated_at) "
                 + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";  // Sử dụng GETDATE() cho SQL Server
    
    try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
        // Đảm bảo các trường không bị null hoặc rỗng
        if (user.getFullName() == null || user.getFullName().isEmpty() || 
            user.getEmail() == null || user.getEmail().isEmpty()) {
            System.out.println("Error: Full Name or Email is required.");
            return false;
        }
        
        stmt.setString(1, user.getFullName());
        stmt.setString(2, user.getEmail());
        stmt.setString(3, user.getPhoneNumber());
        stmt.setString(4, user.getAddress());  // Address should be properly set, i.e., city or full address
        stmt.setString(5, user.getPassword());
        stmt.setString(6, user.getAvatar());  // Ensure avatar is not null or empty if not allowed
        stmt.setInt(7, user.getStatus());
        stmt.setInt(8, user.getRoleId());
        
        // Execute insert
        int rowsAffected = stmt.executeUpdate();
        System.out.println("Rows affected: " + rowsAffected);
        
        // Lấy ID người dùng mới tạo
        ResultSet generatedKeys = stmt.getGeneratedKeys();
        if (generatedKeys.next()) {
            int userId = generatedKeys.getInt(1);
            
            // Thêm địa chỉ vào bảng addresses
            Address address = new Address(0, userId, user.getFullName(), user.getPhoneNumber(), user.getCity(), "", "", "", "", false);
            AddressDAO addressDAO = new AddressDAO();
            addressDAO.saveAddress(address); // Lưu địa chỉ vào bảng addresses.
        }

        return rowsAffected > 0;
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}





public Optional<User> validateUser(String email, String password) {
    String query = "SELECT * FROM Users WHERE email = ? AND password = ?";
    try (Connection conn = getConnection();
         PreparedStatement stmt = conn.prepareStatement(query)) {
        stmt.setString(1, email);
        stmt.setString(2, password);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            User user = new User(
                rs.getInt("user_id"),
                rs.getInt("role_id"),
                rs.getString("full_name"),
                rs.getString("email"),
                rs.getString("phone_number"),
                rs.getString("address"),
                rs.getString("password"),
                rs.getString("avatar"),
                rs.getInt("status"),
                rs.getDate("created_at"),
                rs.getDate("updated_at")
            );
            return Optional.of(user);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return Optional.empty();
}


    public int countAllUsers() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM [users]";
        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    public List<User> getAllCustomers() {
        List<User> customers = new ArrayList<>();
        String sql = "SELECT * FROM [users] WHERE role_id = 3";

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User user = new User(
                        rs.getInt("user_id"),
                        rs.getInt("role_id"),
                        rs.getString("full_name"),
                        rs.getString("email"),
                        rs.getString("phone_number"),
                        rs.getString("address"),
                        rs.getString("password"),
                        rs.getString("avatar"),
                        rs.getInt("status"),
                        rs.getDate("created_at"),
                        rs.getDate("updated_at")
                );
                customers.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customers;
    }

    public Optional<User> getUserById(int userId) {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = new User(
                        rs.getInt("user_id"),
                        rs.getInt("role_id"),
                        rs.getString("full_name"),
                        rs.getString("email"),
                        rs.getString("phone_number"),
                        rs.getString("address"),
                        rs.getString("password"),
                        rs.getString("avatar"),
                        rs.getInt("status"),
                        rs.getDate("created_at"),
                        rs.getDate("updated_at")
                );
                return Optional.of(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    public boolean updateUser(User user) {
        String sql = "UPDATE users "
                + "   SET full_name = ?, "
                + "       email = ?, "
                + "       phone_number = ?, "
                + "       address = ?, "
                + "       status = ?, "
                + "       updated_at = ?, "
                + "       avatar = ? " // <-- Thêm dòng này
                + " WHERE user_id = ?";

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhoneNumber());
            ps.setString(4, user.getAddress());
            ps.setInt(5, user.getStatus());
            ps.setTimestamp(6, new java.sql.Timestamp(user.getUpdatedAt().getTime()));
            ps.setString(7, user.getAvatar());          // <-- Gán giá trị avatar mới
            ps.setInt(8, user.getUserId());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteUser(int userId) {
        String sql = "DELETE FROM users WHERE user_id = ?";
        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
// Phương thức tìm kiếm khách hàng theo từ khóa và sắp xếp theo yêu cầu

    public List<User> searchAndSortCustomers(String searchQuery, String searchBy, String sortBy) {
        List<User> customers = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM [users] WHERE role_id = 3 ");

        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            if ("id".equalsIgnoreCase(searchBy)) {
                // Dùng CAST để chuyển đổi user_id thành chuỗi, sau đó dùng LIKE
                sql.append("AND CAST(user_id AS VARCHAR) LIKE ? ");
            } else if ("name".equalsIgnoreCase(searchBy)) {
                sql.append("AND full_name LIKE ? ");
            }
        }

        if ("name".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY full_name ASC");
        } else { // Mặc định sắp xếp theo ID
            sql.append("ORDER BY user_id ASC");
        }

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql.toString())) {

            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                ps.setString(1, "%" + searchQuery + "%");
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User user = new User(
                        rs.getInt("user_id"),
                        rs.getInt("role_id"),
                        rs.getString("full_name"),
                        rs.getString("email"),
                        rs.getString("phone_number"),
                        rs.getString("address"),
                        rs.getString("password"),
                        rs.getString("avatar"),
                        rs.getInt("status"),
                        rs.getDate("created_at"),
                        rs.getDate("updated_at")
                );
                customers.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customers;
    }

// Phiên bản getAllCustomers cho trường hợp không có tìm kiếm, nhưng vẫn hỗ trợ sắp xếp
    public List<User> getAllCustomers(String sortBy) {
        List<User> customers = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM [users] WHERE role_id = 3 ");

        if ("name".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY full_name ASC");
        } else {
            sql.append("ORDER BY user_id ASC");
        }

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql.toString());  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User user = new User(
                        rs.getInt("user_id"),
                        rs.getInt("role_id"),
                        rs.getString("full_name"),
                        rs.getString("email"),
                        rs.getString("phone_number"),
                        rs.getString("address"),
                        rs.getString("password"),
                        rs.getString("avatar"),
                        rs.getInt("status"),
                        rs.getDate("created_at"),
                        rs.getDate("updated_at")
                );
                customers.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customers;
    }
public List<User> getAllStaff(String sortOption) {
        List<User> staffList = new ArrayList<>();
        String orderBy = "full_name ASC"; // Default: Name A-Z

        switch (sortOption != null ? sortOption.toLowerCase() : "") {
            case "name-desc":
                orderBy = "full_name DESC";
                break;
            case "email-asc":
                orderBy = "email ASC";
                break;
            case "email-desc":
                orderBy = "email DESC";
                break;
            default:
                orderBy = "full_name ASC"; // Default
        }

        String sql = "SELECT * FROM [users] WHERE role_id = 2 ORDER BY " + orderBy;

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User user = new User(
                        rs.getInt("user_id"),
                        rs.getInt("role_id"),
                        rs.getString("full_name"),
                        rs.getString("email"),
                        rs.getString("phone_number"),
                        rs.getString("address"),
                        rs.getString("password"),
                        rs.getString("avatar"),
                        rs.getInt("status"),
                        rs.getDate("created_at"),
                        rs.getDate("updated_at")
                );
                staffList.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return staffList;
    }

    // Tìm kiếm và sắp xếp danh sách Staff theo từ khóa và tiêu chí
    // Tìm kiếm và sắp xếp danh sách Staff theo từ khóa và tiêu chí
    public List<User> searchAndSortStaff(String searchQuery, String searchBy, String sortOption) {
        List<User> staffList = new ArrayList<>();
        String orderBy = "full_name ASC"; // Default: Name A-Z

        switch (sortOption != null ? sortOption.toLowerCase() : "") {
            case "name-desc":
                orderBy = "full_name DESC";
                break;
            case "email-asc":
                orderBy = "email ASC";
                break;
            case "email-desc":
                orderBy = "email DESC";
                break;
            default:
                orderBy = "full_name ASC"; // Default
        }

        StringBuilder sql = new StringBuilder("SELECT * FROM [users] WHERE role_id = 2 ");

        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            if ("id".equalsIgnoreCase(searchBy)) {
                sql.append("AND CAST(user_id AS VARCHAR) LIKE ? ");
            } else if ("name".equalsIgnoreCase(searchBy)) {
                sql.append("AND full_name LIKE ? ");
            }
        }

        sql.append("ORDER BY ").append(orderBy);

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql.toString())) {

            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                ps.setString(1, "%" + searchQuery + "%");
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User user = new User(
                        rs.getInt("user_id"),
                        rs.getInt("role_id"),
                        rs.getString("full_name"),
                        rs.getString("email"),
                        rs.getString("phone_number"),
                        rs.getString("address"),
                        rs.getString("password"),
                        rs.getString("avatar"),
                        rs.getInt("status"),
                        rs.getDate("created_at"),
                        rs.getDate("updated_at")
                );
                staffList.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return staffList;
    }


    // ------------------ Cập nhật lại phương thức updateUser ------------------
    // (Bao gồm cập nhật luôn cả role_id cho chức năng Edit Staff)
    public boolean updateStaff(User user) {
        String sql = "UPDATE users "
                + "SET full_name = ?, "
                + "    email = ?, "
                + "    phone_number = ?, "
                + "    address = ?, "
                + "    status = ?, "
                + "    role_id = ?, " // Cập nhật role_id
                + "    updated_at = ?, "
                + "    avatar = ? "
                + "WHERE user_id = ?";

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhoneNumber());
            ps.setString(4, user.getAddress());
            ps.setInt(5, user.getStatus());
            ps.setInt(6, user.getRoleId()); // cập nhật chức vụ (role)
            ps.setTimestamp(7, new java.sql.Timestamp(user.getUpdatedAt().getTime()));
            ps.setString(8, user.getAvatar());
            ps.setInt(9, user.getUserId());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean changeStatus(int userId) {
        String sql = "UPDATE users SET status = CASE WHEN status = 1 THEN 0 ELSE 1 END WHERE user_id = ?";

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean changeRoleToCustomer(int userId) {
        String sql = "UPDATE users SET role_id = 3 WHERE user_id = ?"; // 3 represents the customer role

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Đếm số lượng Customer (role = 3)
    public int countCustomers() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM users WHERE role_id = 3"; // Giả sử role_id = 3 là Customer

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    // Đếm số lượng Staff (role = 2)
    public int countStaff() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM users WHERE role_id = 2"; // Giả sử role_id = 2 là Staff

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }
    public boolean updateUserPassword(int userId, String newPassword) {
    String sql = "UPDATE users SET password = ? WHERE user_id = ?";
    try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setString(1, newPassword); // Mật khẩu chưa mã hóa (mã hóa sau)
        ps.setInt(2, userId);
        int rowsAffected = ps.executeUpdate();
        return rowsAffected > 0;
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}
    public boolean verifyPassword(String email, String password) {
    String query = "SELECT * FROM users WHERE email = ? AND password = ?";
    try (Connection conn = getConnection();
         PreparedStatement stmt = conn.prepareStatement(query)) {
        stmt.setString(1, email);
        stmt.setString(2, password);
        ResultSet rs = stmt.executeQuery();
        return rs.next();
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}

public boolean updatePassword(int userId, String newPassword) {
    String query = "UPDATE users SET password = ?, updated_at = GETDATE() WHERE user_id = ?";
    try (Connection conn = getConnection();
         PreparedStatement stmt = conn.prepareStatement(query)) {
        stmt.setString(1, newPassword);
        stmt.setInt(2, userId);
        return stmt.executeUpdate() > 0;
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}
 public boolean updateUserProfile(User user) {
    String query = "UPDATE users SET full_name = ?, avatar = ?, phone_number = ?, address = ?, updated_at = GETDATE() WHERE email = ?";
    try (Connection conn = getConnection();
         PreparedStatement stmt = conn.prepareStatement(query)) {

        stmt.setString(1, user.getFullName());
        stmt.setString(2, user.getAvatar());
        stmt.setString(3, user.getPhoneNumber());
        stmt.setString(4, user.getAddress());
        stmt.setString(5, user.getEmail());  // Update bằng email để tìm user cụ thể

        return stmt.executeUpdate() > 0; // Nếu có ảnh hưởng dòng, trả về true
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}





}
