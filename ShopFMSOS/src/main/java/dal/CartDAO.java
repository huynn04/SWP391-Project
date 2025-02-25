/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.Cart;

/**
 *
 * @author Nguyễn Ngoc Huy CE180178
 */
public class CartDAO extends DBContext{
    public Cart getCartByUserId(int userId) {
        String sql = "SELECT cart_id, user_id, created_at, updated_at FROM Cart WHERE user_id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Cart cart = new Cart(
                            rs.getInt("cart_id"),
                            rs.getInt("user_id"),
                            rs.getDate("created_at"),
                            rs.getDate("updated_at")
                    );
                    return cart;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
