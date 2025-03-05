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
            e.printStackTrace();
        }
        return null; // Không tìm thấy mã giảm giá hợp lệ
    }
}
