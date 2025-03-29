/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.Product;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import model.Order;

/**
 *
 * @author Nguyễn Ngoc Huy CE180178
 */
public class ProductDAO extends DBContext {

    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.product_id, p.category_id, p.product_name, p.detail_desc, p.image, p.price, p.discount, p.quantity, p.sold, p.target, p.factory, p.status, p.created_at, p.updated_at, c.category_name "
                + "FROM products p "
                + "JOIN categories c ON p.category_id = c.category_id "
                + "WHERE p.quantity > 0 OR p.status = 1";  // Lọc sản phẩm có quantity > 0 hoặc status = 1

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Product product = new Product(
                        rs.getInt("product_id"),
                        rs.getInt("category_id"),
                        rs.getString("product_name"),
                        rs.getString("detail_desc"),
                        rs.getString("image"),
                        rs.getBigDecimal("price"),
                        rs.getBigDecimal("discount"),
                        rs.getInt("quantity"),
                        rs.getInt("sold"),
                        rs.getString("target"),
                        rs.getString("factory"),
                        rs.getInt("status"),
                        rs.getDate("created_at"),
                        rs.getDate("updated_at")
                );
                // Chỉ sử dụng category_name từ ResultSet và không cần thêm thuộc tính vào Product
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    public int countAllProducts() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM [products]";

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    // Phương thức lấy chi tiết sản phẩm theo productId
    public Product getProductById(int productId) {
        String sql = "SELECT product_id, category_id, product_name, detail_desc, image, price, discount, quantity, sold, target, factory, status, created_at, updated_at FROM [products] WHERE product_id = ?";
        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Product product = new Product(
                            rs.getInt("product_id"),
                            rs.getInt("category_id"),
                            rs.getString("product_name"),
                            rs.getString("detail_desc"),
                            rs.getString("image"),
                            rs.getBigDecimal("price"),
                            rs.getBigDecimal("discount"),
                            rs.getInt("quantity"),
                            rs.getInt("sold"),
                            rs.getString("target"),
                            rs.getString("factory"),
                            rs.getInt("status"),
                            rs.getDate("created_at"),
                            rs.getDate("updated_at")
                    );
                    return product;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int getProductMaxQuantity(int productId) {
        String sql = "SELECT quantity FROM [products] WHERE product_id = ?";
        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("quantity");  // Lấy số lượng tồn kho của sản phẩm
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;  // Nếu không tìm thấy sản phẩm, trả về 0
    }

    //Ðung xoa nha anh em
    public List<Order> searchOrders(String filterType, String filterValue) throws SQLException {
        List<Order> orders = new ArrayList<>();
        String sql = "";

        // Kiểm tra filterType để chọn kiểu lọc
        if ("byCustomerId".equals(filterType)) {
            sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY order_date DESC";
        } else if ("byDate".equals(filterType)) {
            sql = "SELECT * FROM orders WHERE CAST(order_date AS DATE) = ? ORDER BY order_date DESC";
        }

        // Kết nối và truy vấn CSDL
        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, filterValue); // Gán giá trị cho tham số ?
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                // Chuyển dữ liệu từ ResultSet thành đối tượng Order
                orders.add(new Order(
                        rs.getInt("order_id"),
                        rs.getInt("user_id"),
                        rs.getBigDecimal("total_price"),
                        rs.getDate("order_date"),
                        rs.getInt("status"),
                        rs.getString("note"),
                        rs.getString("receiver_name"),
                        rs.getString("receiver_address"),
                        rs.getString("receiver_phone"),
                        rs.getString("payment_method"),
                        rs.getString("discount_code"),
                        rs.getTimestamp("delivered_at"),
                        rs.getTimestamp("canceled_at")
                ));
            }
        }
        return orders;
    }

    public List<Order> getAllOrders() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    // ===========================
    // Các hàm mới được bổ sung
    // ===========================
    // Kiểm tra trùng tên sản phẩm (BR1 - Product Name Uniqueness)
    public boolean checkProductNameExists(String productName) {
        String sql = "SELECT COUNT(*) FROM [products] WHERE product_name = ?";
        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, productName);
            try ( ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    return true; // Tên sản phẩm đã tồn tại
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Thêm sản phẩm mới (UC-26_Add Product)
    public boolean addProduct(Product product) {
        String sql = "INSERT INTO [products] (category_id, product_name, detail_desc, image, price, discount, quantity, sold, target, factory, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {

            if (checkProductNameExists(product.getProductName())) {
                System.out.println("Product name already exists.");
                return false; // Trùng tên sản phẩm
            }

            ps.setInt(1, product.getCategoryId());
            ps.setString(2, product.getProductName());
            ps.setString(3, product.getDetailDesc());
            ps.setString(4, product.getImage());
            ps.setBigDecimal(5, product.getPrice());
            ps.setBigDecimal(6, product.getDiscount());
            ps.setInt(7, product.getQuantity());
            ps.setInt(8, product.getSold());
            ps.setString(9, product.getTarget());
            ps.setString(10, product.getFactory());
            ps.setInt(11, product.getStatus());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Cập nhật sản phẩm (UC-27_Edit Product)
    public boolean updateProduct(Product product) {
        String sql = "UPDATE [products] SET category_id = ?, product_name = ?, detail_desc = ?, image = ?, price = ?, discount = ?, quantity = ?, sold = ?, target = ?, factory = ?, status = ?, updated_at = GETDATE() WHERE product_id = ?";

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, product.getCategoryId());
            ps.setString(2, product.getProductName());
            ps.setString(3, product.getDetailDesc());
            ps.setString(4, product.getImage());
            ps.setBigDecimal(5, product.getPrice());
            ps.setBigDecimal(6, product.getDiscount());
            ps.setInt(7, product.getQuantity());
            ps.setInt(8, product.getSold());
            ps.setString(9, product.getTarget());
            ps.setString(10, product.getFactory());
            ps.setInt(11, product.getStatus());
            ps.setInt(12, product.getProductId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Xóa sản phẩm (UC-28_Delete Product)
    public boolean deleteProduct(int productId) {
        String sql = "DELETE FROM [products] WHERE product_id = ?";
        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, productId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Product> searchProducts(String searchQuery, String searchBy, String sortBy) {
        List<Product> products = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM [products] WHERE 1=1");

        // Handle dynamic search based on searchBy field (name, id, price, quantity, sold)
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            switch (searchBy) {
                case "id":
                    sql.append(" AND product_id LIKE ?");
                    break;
                case "name":
                    sql.append(" AND LOWER(product_name) LIKE LOWER(?)");
                    break;
                case "price":
                    sql.append(" AND price LIKE ?");
                    break;
                case "quantity":
                    sql.append(" AND quantity LIKE ?");
                    break;
                case "sold":
                    sql.append(" AND sold LIKE ?");
                    break;
                default:
                    sql.append(" AND LOWER(product_name) LIKE LOWER(?)"); // Default to search by name
                    break;
            }
        }

        // Handle sorting based on the sortBy parameter
        if (sortBy != null && !sortBy.isEmpty()) {
            String[] sortParts = sortBy.split("-");
            String column = sortParts[0];
            String direction = (sortParts.length > 1 && "desc".equals(sortParts[1])) ? "DESC" : "ASC";

            switch (column) {
                case "name":
                    sql.append(" ORDER BY product_name ").append(direction);
                    break;
                case "id":
                    sql.append(" ORDER BY product_id ").append(direction);
                    break;
                case "price":
                    sql.append(" ORDER BY price ").append(direction);
                    break;
                case "quantity":
                    sql.append(" ORDER BY quantity ").append(direction);
                    break;
                case "sold":
                    sql.append(" ORDER BY sold ").append(direction);
                    break;
                default:
                    sql.append(" ORDER BY product_id ASC");  // Default sorting by ID
                    break;
            }
        } else {
            sql.append(" ORDER BY product_id ASC");  // Default sorting by ID ascending
        }

        // Execute the query
        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql.toString())) {
            // Set search query parameter
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                String searchPattern = "%" + searchQuery + "%";
                ps.setString(1, searchPattern); // Bind search parameter
            }

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product product = new Product(
                            rs.getInt("product_id"),
                            rs.getInt("category_id"),
                            rs.getString("product_name"),
                            rs.getString("detail_desc"),
                            rs.getString("image"),
                            rs.getBigDecimal("price"),
                            rs.getBigDecimal("discount"),
                            rs.getInt("quantity"),
                            rs.getInt("sold"),
                            rs.getString("target"),
                            rs.getString("factory"),
                            rs.getInt("status"),
                            rs.getDate("created_at"),
                            rs.getDate("updated_at")
                    );
                    products.add(product);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    public List<Product> getFilteredProducts(String searchQuery, String[] categoryIds) {
        List<Product> products = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM products WHERE 1=1");

        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            sql.append(" AND LOWER(product_name) LIKE LOWER(?)");
        }
        if (categoryIds != null && categoryIds.length > 0) {
            sql.append(" AND category_id IN (").append("?,".repeat(categoryIds.length - 1)).append("?)");
        }

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + searchQuery + "%");
            }
            if (categoryIds != null && categoryIds.length > 0) {
                for (String categoryId : categoryIds) {
                    ps.setInt(paramIndex++, Integer.parseInt(categoryId));
                }
            }

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product product = new Product(
                            rs.getInt("product_id"),
                            rs.getInt("category_id"),
                            rs.getString("product_name"),
                            rs.getString("detail_desc"),
                            rs.getString("image"),
                            rs.getBigDecimal("price"),
                            rs.getBigDecimal("discount"),
                            rs.getInt("quantity"),
                            rs.getInt("sold"),
                            rs.getString("target"),
                            rs.getString("factory"),
                            rs.getInt("status"),
                            rs.getDate("created_at"),
                            rs.getDate("updated_at")
                    );
                    products.add(product);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    public boolean updateProductStock(int productId, int quantityPurchased) {
        String sql = "UPDATE products "
                + "SET quantity = quantity - ?, sold = sold + ? "
                + "WHERE product_id = ? AND quantity >= ?";

        try ( Connection conn = getConnection();  PreparedStatement ps = conn.prepareStatement(sql)) {

            conn.setAutoCommit(false);

            ps.setInt(1, quantityPurchased);
            ps.setInt(2, quantityPurchased);
            ps.setInt(3, productId);
            ps.setInt(4, quantityPurchased);

            int rowsUpdated = ps.executeUpdate();
            if (rowsUpdated > 0) {
                conn.commit();
                System.out.println("✅ Cập nhật tồn kho sản phẩm #" + productId
                        + " - Giảm " + quantityPurchased);
                return true;
            } else {
                conn.rollback();
                System.out.println("⚠️ Không thể cập nhật tồn kho sản phẩm #" + productId);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Cập nhật category_id của các sản phẩm thuộc danh mục cần xóa
    public boolean updateProductCategory(int oldCategoryId, int newCategoryId) {
        String sql = "UPDATE products SET category_id = ? WHERE category_id = ?";

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, newCategoryId);  // Cập nhật category_id mới
            ps.setInt(2, oldCategoryId);  // Tìm các sản phẩm thuộc category_id cũ

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;  // Trả về true nếu có sản phẩm được cập nhật
        } catch (SQLException e) {
            e.printStackTrace();
            return false;  // Nếu có lỗi, trả về false
        }
    }
    // Lấy tất cả các sản phẩm thuộc categoryId

    public List<Product> getProductsByCategoryId(int categoryId) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE category_id = ?";

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, categoryId);  // Gắn categoryId vào câu truy vấn

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product product = new Product();
                    product.setProductId(rs.getInt("product_id"));
                    product.setCategoryId(rs.getInt("category_id"));
                    product.setProductName(rs.getString("product_name"));
                    product.setDetailDesc(rs.getString("detail_desc"));
                    product.setImage(rs.getString("image"));
                    product.setPrice(rs.getBigDecimal("price"));
                    product.setDiscount(rs.getBigDecimal("discount"));
                    product.setQuantity(rs.getInt("quantity"));
                    product.setSold(rs.getInt("sold"));
                    product.setTarget(rs.getString("target"));
                    product.setFactory(rs.getString("factory"));
                    product.setStatus(rs.getInt("status"));

                    products.add(product);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return products;
    }

    public List<Product> getSortedProducts(String sortOption) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE quantity > 0 OR status = 1";

        // Sorting logic based on the sortOption
        switch (sortOption) {
            case "name-asc":
                sql += " ORDER BY product_name ASC";
                break;
            case "name-desc":
                sql += " ORDER BY product_name DESC";
                break;
            case "price-asc":
                sql += " ORDER BY price ASC";
                break;
            case "price-desc":
                sql += " ORDER BY price DESC";
                break;
            default:
                sql += " ORDER BY product_name ASC";  // Default sorting by Name Ascending
                break;
        }

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Product product = new Product(
                        rs.getInt("product_id"),
                        rs.getInt("category_id"),
                        rs.getString("product_name"),
                        rs.getString("detail_desc"),
                        rs.getString("image"),
                        rs.getBigDecimal("price"),
                        rs.getBigDecimal("discount"),
                        rs.getInt("quantity"),
                        rs.getInt("sold"),
                        rs.getString("target"),
                        rs.getString("factory"),
                        rs.getInt("status"),
                        rs.getDate("created_at"),
                        rs.getDate("updated_at")
                );
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return products;
    }

    public List<Product> getPaginatedProducts(String searchQuery, String searchBy, String sortBy, int page, int pageSize) {
        List<Product> products = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM [products] WHERE 1=1");

        // Handle search for specific columns only
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            switch (searchBy) {
                case "id":
                    sql.append(" AND LOWER(product_id) LIKE LOWER(?)");
                    break;
                case "name":
                    sql.append(" AND LOWER(product_name) LIKE LOWER(?)");
                    break;
                case "price":
                    sql.append(" AND LOWER(price) LIKE LOWER(?)");
                    break;
                case "quantity":
                    sql.append(" AND LOWER(quantity) LIKE LOWER(?)");
                    break;
                case "sold":
                    sql.append(" AND LOWER(sold) LIKE LOWER(?)");
                    break;
                default:
                    sql.append(" AND LOWER(product_name) LIKE LOWER(?)"); // Default to name
                    break;
            }
        }

        // Handle sorting (remains unchanged)
        if (sortBy != null && !sortBy.isEmpty()) {
            String[] sortParts = sortBy.split("-");
            String column = sortParts[0];
            String direction = (sortParts.length > 1 && "desc".equals(sortParts[1])) ? "DESC" : "ASC";

            switch (column) {
                case "name":
                    sql.append(" ORDER BY product_name ").append(direction);
                    break;
                case "id":
                    sql.append(" ORDER BY product_id ").append(direction);
                    break;
                case "price":
                    sql.append(" ORDER BY price ").append(direction);
                    break;
                case "quantity":
                    sql.append(" ORDER BY quantity ").append(direction);
                    break;
                case "sold":
                    sql.append(" ORDER BY sold ").append(direction);
                    break;
                default:
                    sql.append(" ORDER BY product_id ASC");
                    break;
            }
        } else {
            sql.append(" ORDER BY product_id ASC");
        }

        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql.toString())) {
            int paramIndex = 1;

            // Set search parameter
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                String searchPattern = "%" + searchQuery + "%";
                ps.setString(paramIndex++, searchPattern);
            }

            // Set pagination parameters
            ps.setInt(paramIndex++, (page - 1) * pageSize);
            ps.setInt(paramIndex, pageSize);

            try ( ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product product = new Product(
                            rs.getInt("product_id"),
                            rs.getInt("category_id"),
                            rs.getString("product_name"),
                            rs.getString("detail_desc"),
                            rs.getString("image"),
                            rs.getBigDecimal("price"),
                            rs.getBigDecimal("discount"),
                            rs.getInt("quantity"),
                            rs.getInt("sold"),
                            rs.getString("target"),
                            rs.getString("factory"),
                            rs.getInt("status"),
                            rs.getDate("created_at"),
                            rs.getDate("updated_at")
                    );
                    products.add(product);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }
}
