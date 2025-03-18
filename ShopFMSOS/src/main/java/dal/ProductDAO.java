package dal;

import model.Product;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Order;
import java.math.BigDecimal;

public class ProductDAO extends DBContext {

    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.product_id, p.category_id, p.product_name, p.detail_desc, p.image, p.price, "
                   + "       p.discount, p.quantity, p.sold, p.target, p.factory, p.status, "
                   + "       p.created_at, p.updated_at, c.category_name "
                   + "FROM products p "
                   + "JOIN categories c ON p.category_id = c.category_id";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

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

    public int countAllProducts() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM products";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    public Product getProductById(int productId) {
        String sql = "SELECT product_id, category_id, product_name, detail_desc, image, price, discount, quantity, "
                   + "       sold, target, factory, status, created_at, updated_at "
                   + "FROM products WHERE product_id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
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
        String sql = "SELECT quantity FROM products WHERE product_id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("quantity");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Demo
    public List<Order> searchOrders(String filterType, String filterValue) throws SQLException {
        List<Order> orders = new ArrayList<>();
        String sql = "";

        if ("byCustomerId".equals(filterType)) {
            sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY order_date DESC";
        } else if ("byDate".equals(filterType)) {
            sql = "SELECT * FROM orders WHERE CAST(order_date AS DATE) = ? ORDER BY order_date DESC";
        }

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, filterValue);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
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
        throw new UnsupportedOperationException("Not supported yet.");
    }

    // Kiểm tra trùng tên sản phẩm
    public boolean checkProductNameExists(String productName) {
        String sql = "SELECT COUNT(*) FROM products WHERE product_name = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, productName);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    return true;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Thêm sản phẩm
    public boolean addProduct(Product product) {
        String sql = "INSERT INTO products (category_id, product_name, detail_desc, image, price, discount, "
                   + "quantity, sold, target, factory, status, created_at, updated_at) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            if (checkProductNameExists(product.getProductName())) {
                System.out.println("Product name already exists.");
                return false;
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

    // Sửa sản phẩm
    public boolean updateProduct(Product product) {
        String sql = "UPDATE products SET category_id = ?, product_name = ?, detail_desc = ?, image = ?, "
                   + "price = ?, discount = ?, quantity = ?, sold = ?, target = ?, factory = ?, status = ?, "
                   + "updated_at = GETDATE() WHERE product_id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

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

    // Xoá sản phẩm
    public boolean deleteProduct(int productId) {
        String sql = "DELETE FROM products WHERE product_id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Tìm kiếm sản phẩm
    public List<Product> searchProducts(String searchQuery, String searchBy, String sortBy) {
        List<Product> products = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM products WHERE 1=1");

        if ("id".equalsIgnoreCase(searchBy)) {
            // Tìm theo product_id
            sql.append(" AND product_id LIKE ?");
        } else {
            // Mặc định tìm theo tên
            sql.append(" AND LOWER(product_name) LIKE LOWER(?)");
        }

        if ("name".equalsIgnoreCase(sortBy)) {
            sql.append(" ORDER BY product_name");
        } else if ("id".equalsIgnoreCase(sortBy)) {
            sql.append(" ORDER BY product_id");
        }

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            ps.setString(1, "%" + searchQuery + "%");
            try (ResultSet rs = ps.executeQuery()) {
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
            sql.append(" AND category_id IN (")
               .append("?,".repeat(categoryIds.length - 1))
               .append("?)");
        }

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + searchQuery + "%");
            }
            if (categoryIds != null && categoryIds.length > 0) {
                for (String categoryId : categoryIds) {
                    ps.setInt(paramIndex++, Integer.parseInt(categoryId));
                }
            }

            try (ResultSet rs = ps.executeQuery()) {
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

    // Quan trọng: Cập nhật tồn kho
    public boolean updateProductStock(int productId, int quantityPurchased) {
        String sql = "UPDATE products "
                   + "SET quantity = quantity - ?, sold = sold + ? "
                   + "WHERE product_id = ? AND quantity >= ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

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
}
