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
}