/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;
import model.OrderDetail;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author Nguyễn Ngoc Huy CE180178
 */
public class OrderDetailDAO extends DBContext {
    // Lấy chi tiết của đơn hàng từ order_details theo orderId
    public List<OrderDetail> getOrderDetailsByOrderId(int orderId) {
        List<OrderDetail> orderDetails = new ArrayList<>();
        String sql = "SELECT * FROM order_details WHERE order_id = ?";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderDetail orderDetail = new OrderDetail(
                        rs.getInt("order_detail_id"),
                        rs.getInt("order_id"),
                        rs.getInt("product_id"),
                        rs.getInt("quantity"),
                        rs.getBigDecimal("price"),
                        rs.getBigDecimal("subtotal"),
                        rs.getBigDecimal("tax")
                    );
                    orderDetails.add(orderDetail);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orderDetails;
    }

    // Thêm một chi tiết đơn hàng vào bảng order_details
    public boolean addOrderDetail(OrderDetail orderDetail) {
        String sql = "INSERT INTO order_details (order_id, product_id, quantity, price, subtotal, tax) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderDetail.getOrderId());
            ps.setInt(2, orderDetail.getProductId());
            ps.setInt(3, orderDetail.getQuantity());
            ps.setBigDecimal(4, orderDetail.getPrice());
            ps.setBigDecimal(5, orderDetail.getSubtotal());
            ps.setBigDecimal(6, orderDetail.getTax());
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Lấy thông tin chi tiết đơn hàng theo ID
    public OrderDetail getOrderDetailById(int orderDetailId) {
        OrderDetail orderDetail = null;
        String sql = "SELECT * FROM order_details WHERE order_detail_id = ?";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderDetailId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    orderDetail = new OrderDetail(
                        rs.getInt("order_detail_id"),
                        rs.getInt("order_id"),
                        rs.getInt("product_id"),
                        rs.getInt("quantity"),
                        rs.getBigDecimal("price"),
                        rs.getBigDecimal("subtotal"),
                        rs.getBigDecimal("tax")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orderDetail;
    }

    // Cập nhật số lượng và giá chi tiết đơn hàng khi có sự thay đổi
    public boolean updateOrderDetail(OrderDetail orderDetail) {
        String sql = "UPDATE order_details SET quantity = ?, price = ?, subtotal = ?, tax = ? WHERE order_detail_id = ?";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderDetail.getQuantity());
            ps.setBigDecimal(2, orderDetail.getPrice());
            ps.setBigDecimal(3, orderDetail.getSubtotal());
            ps.setBigDecimal(4, orderDetail.getTax());
            ps.setInt(5, orderDetail.getOrderDetailId());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

}