package dal;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Discount;

public class DiscountDAO extends DBContext {

    // Lấy mã giảm giá từ database theo code
    public Discount getDiscountByCode(String code) {
        String sql = "SELECT * FROM discounts WHERE code = ? AND status = 1 AND expiry_date >= GETDATE()";
        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, code);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return new Discount(
                        rs.getInt("discount_id"),
                        rs.getString("code"),
                        rs.getDouble("discount_value"),
                        rs.getString("discount_type"),
                        rs.getDouble("min_order_value"),
                        rs.getDate("expiry_date"),
                        rs.getInt("status")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null; // Không tìm thấy mã giảm giá hợp lệ
    }

    // Tìm kiếm mã giảm giá theo query
    public List<Discount> searchDiscounts(String searchQuery, String searchBy, String sortBy) {
        List<Discount> discounts = new ArrayList<>();
        String sql = "SELECT discount_id, code, discount_value, discount_type, "
                + "min_order_value, expiry_date, status FROM discounts";

        // Thêm điều kiện WHERE nếu có searchQuery
        if (searchQuery != null && !searchQuery.isEmpty()) {
            sql += " WHERE " + searchBy + " LIKE ?";
        }

        // Thêm ORDER BY nếu có sortBy
        if (sortBy != null && !sortBy.isEmpty()) {
            sql += " ORDER BY " + sortBy;
        }

        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {

            // Nếu có searchQuery, gán tham số
            if (searchQuery != null && !searchQuery.isEmpty()) {
                stmt.setString(1, "%" + searchQuery + "%");
            }

            try ( ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Discount discount = new Discount(
                            rs.getInt("discount_id"),
                            rs.getString("code"),
                            rs.getDouble("discount_value"),
                            rs.getString("discount_type"),
                            rs.getDouble("min_order_value"),
                            rs.getDate("expiry_date"),
                            rs.getInt("status")
                    );
                    discounts.add(discount);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return discounts;
    }

    // Thêm mã giảm giá mới
    public boolean addDiscount(Discount discount) {
        String sql = "INSERT INTO discounts (code, discount_value, discount_type, min_order_value, expiry_date, status) VALUES (?, ?, ?, ?, ?, ?)";

        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, discount.getCode());
            stmt.setDouble(2, discount.getDiscountValue());
            stmt.setString(3, discount.getDiscountType());
            stmt.setDouble(4, discount.getMinOrderValue());

            // Nếu expiryDate là java.util.Date, chuyển đổi sang java.sql.Date
            if (discount.getExpiryDate() != null) {
                stmt.setDate(5, new Date(discount.getExpiryDate().getTime()));  // Chuyển đổi từ java.util.Date sang java.sql.Date
            } else {
                stmt.setNull(5, java.sql.Types.DATE);  // Nếu expiryDate null, thì gán là null
            }

            stmt.setInt(6, discount.getStatus());

            int result = stmt.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Lấy tất cả mã giảm giá còn hiệu lực
    public List<Discount> getAllDiscounts() {
        List<Discount> discountList = new ArrayList<>();
        String sql = "SELECT * FROM discounts WHERE status = 1 AND expiry_date >= GETDATE()";

        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql);  ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Discount discount = new Discount(
                        rs.getInt("discount_id"),
                        rs.getString("code"),
                        rs.getDouble("discount_value"),
                        rs.getString("discount_type"),
                        rs.getDouble("min_order_value"),
                        rs.getDate("expiry_date"),
                        rs.getInt("status")
                );
                discountList.add(discount);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return discountList;
    }

    // Lấy mã giảm giá theo ID
    public Discount getDiscountById(int id) {
        String sql = "SELECT * FROM discounts WHERE discount_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return new Discount(
                        rs.getInt("discount_id"),
                        rs.getString("code"),
                        rs.getDouble("discount_value"),
                        rs.getString("discount_type"),
                        rs.getDouble("min_order_value"),
                        rs.getDate("expiry_date"),
                        rs.getInt("status")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Cập nhật mã giảm giá
    public boolean updateDiscount(Discount discount) {
        String sql = "UPDATE discounts "
                + "SET code=?, discount_value=?, discount_type=?, "
                + "    min_order_value=?, expiry_date=?, status=? "
                + "WHERE discount_id=?";

        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, discount.getCode());
            stmt.setDouble(2, discount.getDiscountValue());
            stmt.setString(3, discount.getDiscountType());
            stmt.setDouble(4, discount.getMinOrderValue());

            // expiryDate (java.sql.Date)
            if (discount.getExpiryDate() != null) {
                stmt.setDate(5, new Date(discount.getExpiryDate().getTime()));
            } else {
                stmt.setNull(5, java.sql.Types.DATE);
            }

            stmt.setInt(6, discount.getStatus());
            stmt.setInt(7, discount.getDiscountId());

            int rowsUpdated = stmt.executeUpdate();
            return (rowsUpdated > 0); // true nếu update thành công
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false; // Lỗi hoặc rowsUpdated=0 => false
    }

    // Xóa mã giảm giá
    public boolean deleteDiscount(int discountId) {
        String sql = "DELETE FROM discounts WHERE discount_id = ?";
        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, discountId);
            int result = stmt.executeUpdate();
            return (result > 0);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public void insertDiscount(Discount discount) {
        String sql = "INSERT INTO discounts (code, discount_value, discount_type, min_order_value, expiry_date, status) VALUES (?, ?, ?, ?, ?, ?)";
        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, discount.getCode());
            stmt.setDouble(2, discount.getDiscountValue());
            stmt.setString(3, discount.getDiscountType());
            stmt.setDouble(4, discount.getMinOrderValue());
            stmt.setDate(5, new java.sql.Date(discount.getExpiryDate().getTime()));
            stmt.setInt(6, discount.getStatus());

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Coupon inserted successfully into the database: " + discount.getCode());
            } else {
                System.out.println("Failed to insert coupon into the database.");
            }
        } catch (SQLException e) {
            System.err.println("Error in insertDiscount: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public void updateDiscountStatus(String code, int status) {
        String query = "UPDATE discounts SET status = ? WHERE code = ?";
        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, status);
            stmt.setString(2, code);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Discount> searchAndSortDiscounts(String searchQuery, String searchBy, String sortOption) {
        List<Discount> discounts = new ArrayList<>();
        String orderBy = "code ASC"; // Default: Code A-Z

        // Set sort order based on the provided option
        switch (sortOption != null ? sortOption.toLowerCase() : "") {
            case "code-asc":
                orderBy = "code ASC";
                break;
            case "code-desc":
                orderBy = "code DESC";
                break;
            case "discountvalue-asc":
                orderBy = "discount_value ASC";
                break;
            case "discountvalue-desc":
                orderBy = "discount_value DESC";
                break;
            case "expirydate-asc":
                orderBy = "expiry_date ASC";
                break;
            case "expirydate-desc":
                orderBy = "expiry_date DESC";
                break;
            default:
                orderBy = "code ASC"; // Default
        }

        StringBuilder sql = new StringBuilder("SELECT * FROM discounts WHERE status = 1 ");

        // Add WHERE clause based on search query
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            if ("code".equalsIgnoreCase(searchBy)) {
                sql.append("AND code LIKE ? ");
            } else if ("discountValue".equalsIgnoreCase(searchBy)) {
                sql.append("AND CAST(discount_value AS VARCHAR) LIKE ? ");
            } else if ("expiryDate".equalsIgnoreCase(searchBy)) {
                sql.append("AND expiry_date LIKE ? ");
            }
        }

        sql.append("ORDER BY ").append(orderBy);

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql.toString())) {

            // Set search query parameter if present
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                ps.setString(1, "%" + searchQuery + "%");
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Discount discount = new Discount(
                        rs.getInt("discount_id"),
                        rs.getString("code"),
                        rs.getDouble("discount_value"),
                        rs.getString("discount_type"),
                        rs.getDouble("min_order_value"),
                        rs.getDate("expiry_date"),
                        rs.getInt("status")
                );
                discounts.add(discount);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return discounts;
    }

}
