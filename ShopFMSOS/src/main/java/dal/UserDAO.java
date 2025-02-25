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

/**
 *
 * @author Nguyễn Ngoc Huy CE180178
 */
public class UserDAO extends DBContext {

    public Optional<User> getUserByEmail(String email) {
        String query = "SELECT * FROM Users WHERE email = ?";
        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                User user = new User(
                        rs.getInt("userId"),
                        rs.getInt("roleId"),
                        rs.getString("fullName"),
                        rs.getString("email"),
                        rs.getString("phoneNumber"),
                        rs.getString("address"),
                        rs.getString("password"),
                        rs.getString("avatar"),
                        rs.getInt("status"),
                        rs.getDate("createdAt"),
                        rs.getDate("updatedAt")
                );
                return Optional.of(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    public boolean insertUser(User user) {
        String query = "INSERT INTO Users (full_name, email, phone_number, address, password, avatar, status, role_id, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPhoneNumber());
            stmt.setString(4, user.getAddress());
            stmt.setString(5, user.getPassword());
            stmt.setString(6, user.getAvatar());
            stmt.setInt(7, user.getStatus());
            stmt.setInt(8, user.getRoleId());
            stmt.setTimestamp(9, new Timestamp(user.getCreatedAt().getTime()));
            stmt.setTimestamp(10, new Timestamp(user.getUpdatedAt().getTime()));

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean validateUser(String email, String password) {
        String query = "SELECT * FROM Users WHERE email = ? AND password = ?";
        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, email);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
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
// Lấy danh sách Staff (không tìm kiếm, có sắp xếp)

    public List<User> getAllStaff(String sortBy) {
        List<User> staffList = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM [users] WHERE role_id = 2 ");
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
                staffList.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return staffList;
    }

    // Tìm kiếm và sắp xếp danh sách Staff theo từ khóa và tiêu chí
    public List<User> searchAndSortStaff(String searchQuery, String searchBy, String sortBy) {
        List<User> staffList = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM [users] WHERE role_id = 2 ");

        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            if ("id".equalsIgnoreCase(searchBy)) {
                sql.append("AND CAST(user_id AS VARCHAR) LIKE ? ");
            } else if ("name".equalsIgnoreCase(searchBy)) {
                sql.append("AND full_name LIKE ? ");
            }
        }

        if ("name".equalsIgnoreCase(sortBy)) {
            sql.append("ORDER BY full_name ASC");
        } else {
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
    
}
