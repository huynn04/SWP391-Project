package dal;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.Cart;
import model.Discount;

public class CartDAO extends DBContext {

    // Lấy giỏ hàng của user
    public Cart getCartByUserId(int userId) {
        Cart cart = null;
        String sql = "SELECT cart_id, user_id, created_at, updated_at "
                   + "FROM cart WHERE user_id = ?";
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

    // Lấy tổng giá trị giỏ hàng theo cartId và discount
    public BigDecimal getTotalPrice(int cartId, Discount discount) {
        BigDecimal total = BigDecimal.ZERO;
        String sql = "SELECT SUM(cd.quantity * cd.price) "
                   + "FROM cart_details cd WHERE cd.cart_id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getBigDecimal(1) != null) {
                    total = rs.getBigDecimal(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return BigDecimal.ZERO;
        }
        return applyDiscount(total, discount);
    }

    // Lấy tổng giá trị giỏ hàng theo userId, discountCode
    public BigDecimal getTotalPrice(int userId, String discountCode) {
        Cart cart = getCartByUserId(userId);
        if (cart == null) {
            return BigDecimal.ZERO;
        }
        DiscountDAO discountDAO = new DiscountDAO();
        Discount discount = (discountCode != null)
                ? discountDAO.getDiscountByCode(discountCode)
                : null;
        return getTotalPrice(cart.getCartId(), discount);
    }

    // Tính toán giảm giá
    public BigDecimal applyDiscount(BigDecimal total, Discount discount) {
        if (discount == null || total.compareTo(BigDecimal.valueOf(discount.getMinOrderValue())) < 0) {
            return total;
        }
        BigDecimal discountAmount =
                "percent".equalsIgnoreCase(discount.getDiscountType())
                ? total.multiply(BigDecimal.valueOf(discount.getDiscountValue()))
                       .divide(BigDecimal.valueOf(100), 2, BigDecimal.ROUND_HALF_UP)
                : BigDecimal.valueOf(discount.getDiscountValue());

        if (discountAmount.compareTo(total) > 0) {
            discountAmount = total;
        }
        return total.subtract(discountAmount);
    }

    // Chưa dùng
    public BigDecimal getTotalPrice(int cartId) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void applyDiscountToCart(int cartId, String discountCode, BigDecimal discountAmount) {
        String sql = "UPDATE carts SET discount_code = ?, discount_amount = ? WHERE cart_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, discountCode);
            stmt.setBigDecimal(2, discountAmount);
            stmt.setInt(3, cartId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Xoá giỏ hàng sau khi mua
    public void clearCart(int userId) {
        try (Connection conn = getConnection()) {
            // Xoá cart_details
            String sqlDeleteCartDetails =
                "DELETE FROM cart_details WHERE cart_id IN "
              + "(SELECT cart_id FROM cart WHERE user_id = ?)";
            try (PreparedStatement psDetails = conn.prepareStatement(sqlDeleteCartDetails)) {
                psDetails.setInt(1, userId);
                psDetails.executeUpdate();
            }

            // Xoá cart
            String sqlDeleteCart = "DELETE FROM cart WHERE user_id = ?";
            try (PreparedStatement psCart = conn.prepareStatement(sqlDeleteCart)) {
                psCart.setInt(1, userId);
                psCart.executeUpdate();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Ví dụ updateProductQuantity, có thể không cần
    public boolean updateProductQuantity(int productId, int quantitySold) {
        Connection conn = getConnection();
        String sql = "UPDATE products SET quantity = quantity - ? "
                   + "WHERE product_id = ? AND quantity >= ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantitySold);
            ps.setInt(2, productId);
            ps.setInt(3, quantitySold);
            int updatedRows = ps.executeUpdate();
            return updatedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
