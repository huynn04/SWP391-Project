package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Category;

public class CategoryDAO extends DBContext {

    // Lấy tất cả các category từ database
    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT category_id, category_name, description, image, status, created_at, updated_at FROM categories";

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
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
            e.printStackTrace();
        }

        return categories;
    }

    // Thêm category mới
    public void addCategory(Category category) {
        String sql = "INSERT INTO categories (category_name, description, image, status) VALUES (?, ?, ?, ?)";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, category.getCategoryName());
            ps.setString(2, category.getDescription());
            ps.setString(3, category.getImage());
            ps.setInt(4, category.getStatus());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Lấy category_name dựa trên category_id
    public String getCategoryNameById(int categoryId) {
        String categoryName = null;
        String sql = "SELECT category_name FROM categories WHERE category_id = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    categoryName = rs.getString("category_name");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categoryName;
    }

    // Lấy tổng số lượng sản phẩm theo danh mục
    public Map<String, Integer> getProductCountByCategory() {
        Map<String, Integer> productCountMap = new HashMap<>();
        String sql = "SELECT c.category_name, COUNT(p.product_id) AS product_count FROM categories c "
                + "LEFT JOIN products p ON c.category_id = p.category_id "
                + "GROUP BY c.category_name";

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                productCountMap.put(rs.getString("category_name"), rs.getInt("product_count"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return productCountMap;
    }
    
    public static void main(String[] args) {
        CategoryDAO categoryDAO = new CategoryDAO();
        List<Category> categories = categoryDAO.getAllCategories();
        for (Category category : categories) {
            System.out.println(category); 
       }
    }
}
