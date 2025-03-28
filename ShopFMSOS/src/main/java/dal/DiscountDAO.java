package dal;

import java.sql.Connection;
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
            System.err.println("Error in getDiscountByCode: " + e.getMessage());
            e.printStackTrace();
        }
        return null; // Không tìm thấy mã giảm giá hợp lệ
    }
    // Phương thức để cập nhật mã giảm giá vào bảng orders

    public void applyDiscountToOrder(int userId, String discountCode) {
        String sql = "UPDATE orders SET discount_code = ? WHERE user_id = ? AND discount_code IS NULL";
        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, discountCode);
            stmt.setInt(2, userId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
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


    public List<Discount> getAllActiveDiscounts() {
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
            System.err.println("Error in getAllActiveDiscounts: " + e.getMessage());
            e.printStackTrace();
        }
        return discountList;
    }

    public boolean isDiscountApplied(int userId, String discountCode) {
        String sql = "SELECT COUNT(*) FROM orders WHERE user_id = ? AND discount_code = ?";
        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setString(2, discountCode);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;  // Nếu số lượng bản ghi trả về > 0, nghĩa là mã giảm giá đã được lưu
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;  // Nếu không có bản ghi nào, nghĩa là mã giảm giá chưa được lưu
    }

}
