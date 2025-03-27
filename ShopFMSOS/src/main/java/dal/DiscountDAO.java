package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.Discount;

public class DiscountDAO extends DBContext {

    // Lấy mã giảm giá từ database theo code
    public Discount getDiscountByCode(String code) {
        String sql = "SELECT * FROM discounts WHERE code = ? AND status = 1 AND expiry_date >= GETDATE()";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
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
            System.err.println("Error in getDiscountByCode: " + e.getMessage());
            e.printStackTrace();
        }
        return null; // Không tìm thấy mã giảm giá hợp lệ
    }

    public void insertDiscount(Discount discount) {
        String sql = "INSERT INTO discounts (code, discount_value, discount_type, min_order_value, expiry_date, status) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, discount.getCode());
            stmt.setDouble(2, discount.getDiscountValue());
            stmt.setString(3, discount.getDiscountType());
            stmt.setDouble(4, discount.getMinOrderValue());
            stmt.setDate(5, new java.sql.Date(discount.getExpiryDate().getTime()));
            stmt.setInt(6, discount.getStatus());
            int rowsAffected = stmt.executeUpdate();
            System.out.println("Inserted discount with code: " + discount.getCode() + ", Rows affected: " + rowsAffected);
        } catch (SQLException e) {
            System.err.println("Error in insertDiscount: " + e.getMessage());
            e.printStackTrace();
        }
    }
}