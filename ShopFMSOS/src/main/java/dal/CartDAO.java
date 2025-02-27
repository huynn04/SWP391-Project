package dal;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.Cart;
import model.Discount;

/**
 * Quản lý giỏ hàng (CartDAO)
 */
public class CartDAO extends DBContext {

    /**
     * Lấy tổng giá trị giỏ hàng dựa trên cartId (Có hỗ trợ mã giảm giá)
     */
    public BigDecimal getTotalPrice(int cartId, Discount discount) {
        BigDecimal total = BigDecimal.ZERO;
        String sql = "SELECT SUM(cd.quantity * cd.price) FROM cart_details cd WHERE cd.cart_id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    total = rs.getBigDecimal(1);
                    if (total == null) {
                        total = BigDecimal.ZERO;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Áp dụng mã giảm giá nếu có
        if (discount != null) {
            BigDecimal discountAmount;
            if ("percent".equals(discount.getDiscountType())) {
                discountAmount = total.multiply(discount.getDiscountValue()).divide(BigDecimal.valueOf(100));
            } else {
                discountAmount = discount.getDiscountValue();
            }

            if (discountAmount.compareTo(total) > 0) {
                discountAmount = total; // Không cho giảm giá vượt quá tổng tiền
            }
            total = total.subtract(discountAmount);
        }

        return total;
    }

    /**
     * Lấy giỏ hàng của người dùng dựa trên userId
     */
    public Cart getCartByUserId(int userId) {
        Cart cart = null;
        String sql = "SELECT cart_id, user_id, created_at, updated_at FROM cart WHERE user_id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    cart = new Cart(
                            rs.getInt("cart_id"),
                            rs.getInt("user_id"),
                            rs.getDate("created_at"),
                            rs.getDate("updated_at")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cart;
    }

    /**
     * Lấy thông tin mã giảm giá dựa trên discount_id
     */
    public Discount getDiscountById(int discountId) {
        Discount discount = null;
        String sql = "SELECT discount_id, code, discount_value, discount_type, min_order_value, expiry_date, status FROM discount WHERE discount_id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, discountId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    discount = new Discount(
                        rs.getInt("discount_id"),
                        rs.getString("code"),
                        rs.getBigDecimal("discount_value"),
                        rs.getString("discount_type"),
                        rs.getBigDecimal("min_order_value") != null ? rs.getBigDecimal("min_order_value") : BigDecimal.ZERO,
                        rs.getDate("expiry_date"),
                        rs.getInt("status")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return discount;
    }

    /**
     * Cập nhật hoặc xóa mã giảm giá cho giỏ hàng
     */
    public void applyDiscountToCart(int cartId, Integer discountId) {
        String sql;
        
        if (discountId == null) {
            // Nếu không có mã giảm giá, xóa discount_id
            sql = "UPDATE cart SET discount_id = NULL WHERE cart_id = ?";
        } else {
            // Nếu có mã giảm giá, cập nhật discount_id
            sql = "UPDATE cart SET discount_id = ? WHERE cart_id = ?";
        }

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            if (discountId == null) {
                ps.setInt(1, cartId); // Nếu không có mã, chỉ cần set cart_id
            } else {
                ps.setInt(1, discountId);
                ps.setInt(2, cartId);
            }
            
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public BigDecimal getTotalPrice(int cartId) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

   
}
