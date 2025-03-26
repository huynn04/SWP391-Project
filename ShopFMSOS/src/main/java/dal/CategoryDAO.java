/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Category;

/**
 *
 * @author Tran Huy Lam CE180899
 */
public class CategoryDAO extends DBContext {

    // Lấy tất cả các category từ database
    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT category_id, category_name, description, image, status, created_at, updated_at FROM categories";

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Category category = new Category(
                        rs.getInt("category_id"),
                        rs.getString("category_name"),
                        rs.getString("description"),
                        rs.getString("image"),
                        rs.getInt("status"),
                        rs.getDate("created_at"),
                        rs.getDate("updated_at")
                );
                categories.add(category);
            }

        } catch (SQLException e) {
            e.printStackTrace();  // Nên log lỗi thay vì chỉ in ra console
        }

        return categories;
    }

    // Lấy category_name dựa trên category_id
    public String getCategoryNameById(int categoryId) {
        String categoryName = null;
        String sql = "SELECT category_name FROM categories WHERE category_id = ?";

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, categoryId);

            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    categoryName = rs.getString("category_name");
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();  // Nên log lỗi thay vì chỉ in ra console
        }

        return categoryName;
    }

    // Lấy tổng số lượng sản phẩm theo danh mục
    public Map<String, Integer> getProductCountByCategory() {
        Map<String, Integer> productCountMap = new HashMap<>();
        String sql = "SELECT c.category_name, COUNT(p.product_id) AS product_count FROM categories c "
                + "LEFT JOIN products p ON c.category_id = p.category_id "
                + "GROUP BY c.category_name";

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                productCountMap.put(rs.getString("category_name"), rs.getInt("product_count"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return productCountMap;
    }
     // Hàm cập nhật danh mục
    public boolean updateCategory(Category category) {
        String sql = "UPDATE categories SET category_name = ?, description = ?, image = ?, status = ?, updated_at = GETDATE() WHERE category_id = ?";

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, category.getCategoryName());
            ps.setString(2, category.getDescription());
            ps.setString(3, category.getImage());
            ps.setInt(4, category.getStatus());
            ps.setInt(5, category.getCategoryId());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0; // Trả về true nếu cập nhật thành công
        } catch (SQLException e) {
            e.printStackTrace();
            return false; // Nếu có lỗi, trả về false
        }
    }

    // Hàm lấy Category theo categoryId
    public Category getCategoryById(int categoryId) {
        Category category = null;
        String sql = "SELECT * FROM categories WHERE category_id = ?";

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, categoryId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    category = new Category();
                    category.setCategoryId(rs.getInt("category_id"));
                    category.setCategoryName(rs.getString("category_name"));
                    category.setDescription(rs.getString("description"));
                    category.setImage(rs.getString("image"));
                    category.setStatus(rs.getInt("status"));
                    category.setCreatedAt(rs.getDate("created_at"));
                    category.setUpdatedAt(rs.getDate("updated_at"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return category;
    }
     // Xóa danh mục khỏi bảng categories
    public boolean deleteCategory(int categoryId) {
        String sql = "DELETE FROM categories WHERE category_id = ?";

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, categoryId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;  // Trả về true nếu danh mục đã được xóa
        } catch (SQLException e) {
            e.printStackTrace();
            return false;  // Nếu có lỗi, trả về false
        }
    }
    public boolean addCategory(Category category) {
        String sql = "INSERT INTO categories (category_name, description, image, status, created_at, updated_at) " +
                     "VALUES (?, ?, ?, ?, GETDATE(), GETDATE())";

        try (Connection con = getConnection(); 
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, category.getCategoryName());
            ps.setString(2, category.getDescription());
            ps.setString(3, category.getImage());  // Trường image có thể NULL, đảm bảo không gây lỗi
            ps.setInt(4, category.getStatus());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;  // Trả về true nếu thêm thành công
        } catch (SQLException e) {
            e.printStackTrace();
            return false;  // Trả về false nếu có lỗi
        }
    }
}
