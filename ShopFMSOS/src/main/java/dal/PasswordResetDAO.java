package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.Optional;
import java.util.Date;

/**
 * DAO để quản lý token đặt lại mật khẩu.
 */
public class PasswordResetDAO extends DBContext {
    
    // Lưu token vào database với thời gian hết hạn là 30 phút
    public void createPasswordResetToken(int userId, String token) {
        String sql = "INSERT INTO password_reset_tokens (user_id, token, expires_at) VALUES (?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, token);
            ps.setTimestamp(3, new Timestamp(System.currentTimeMillis() + 30 * 60 * 1000)); // 30 phút
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Lấy token từ database
    public Optional<Integer> getUserIdByToken(String token) {
    String sql = "SELECT user_id FROM password_reset_tokens WHERE token = ? AND expires_at > ?";
    try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, token);
        ps.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return Optional.of(rs.getInt("user_id")); // 🛠 FIX: Đổi từ "userId" thành "user_id"
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return Optional.empty();
}


    // Xóa token sau khi sử dụng
    public void deleteToken(String token) {
        String sql = "DELETE FROM password_reset_tokens WHERE token = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
