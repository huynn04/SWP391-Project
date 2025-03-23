package dal;

import model.Category;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CategoryDAO extends DBContext {

    // Get all categories from the database
    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT category_id, category_name, description, image, status, created_at, updated_at FROM categories";
        
        try (Connection con = getConnection(); 
             PreparedStatement ps = con.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {
            
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
            // Better error handling and logging
            e.printStackTrace(); // Or use a logger here
        }

        return categories;
    }

    // Add a new category to the database
    public void addCategory(Category category) {
        String sql = "INSERT INTO categories (category_name, description, image, status) VALUES (?, ?, ?, ?)";
        
        try (Connection con = getConnection(); 
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, category.getCategoryName());
            ps.setString(2, category.getDescription());
            ps.setString(3, category.getImage());
            ps.setInt(4, category.getStatus());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace(); // Log the error
        }
    }

    // Get category name by category_id
    public String getCategoryNameById(int categoryId) {
        String categoryName = null;
        String sql = "SELECT category_name FROM categories WHERE category_id = ?";
        
        try (Connection con = getConnection(); 
             PreparedStatement ps = con.prepareStatement(sql)) {
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

    // Get the number of products per category
    public Map<String, Integer> getProductCountByCategory() {
        Map<String, Integer> productCountMap = new HashMap<>();
        String sql = "SELECT c.category_name, COUNT(p.product_id) AS product_count FROM categories c "
                + "LEFT JOIN products p ON c.category_id = p.category_id "
                + "GROUP BY c.category_name";

        try (Connection con = getConnection(); 
             PreparedStatement ps = con.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                productCountMap.put(rs.getString("category_name"), rs.getInt("product_count"));
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Log error
        }

        return productCountMap;
    }

    // Update category details
    public void updateCategory(Category category) {
        String sql = "UPDATE categories SET category_name = ?, description = ?, image = ?, status = ?, updated_at = NOW() WHERE category_id = ?";
        
        try (Connection con = getConnection(); 
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, category.getCategoryName());
            ps.setString(2, category.getDescription());
            ps.setString(3, category.getImage());
            ps.setInt(4, category.getStatus());
            ps.setInt(5, category.getCategoryId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Delete category by ID
    public void deleteCategory(int categoryId) {
        String sql = "DELETE FROM categories WHERE category_id = ?";
        
        try (Connection con = getConnection(); 
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace(); // Log error
        }
    }

    // Search categories by name or ID
    public List<Category> searchCategories(String keyword) {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM categories WHERE category_name LIKE ? OR category_id LIKE ?";
        
        try (Connection con = getConnection(); 
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                categories.add(new Category(
                        rs.getInt("category_id"),
                        rs.getString("category_name"),
                        rs.getString("description"),
                        rs.getString("image"),
                        rs.getInt("status"),
                        rs.getDate("created_at"),
                        rs.getDate("updated_at")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Log error
        }
        return categories;
    }
}
