/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.AbstractMap;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import model.Order;

/**
 *
 * @author Dang Chi Vi CE182507
 */
public class OrderDAO extends DBContext {

    public List<Order> getOrdersByUserId(int userId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ?";
        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order order = new Order(
                        rs.getInt("order_id"),
                        rs.getInt("user_id"),
                        rs.getBigDecimal("total_price"),
                        rs.getTimestamp("order_date"),
                        rs.getInt("status"),
                        rs.getString("note"),
                        rs.getString("receiver_name"),
                        rs.getString("receiver_address"),
                        rs.getString("receiver_phone"),
                        rs.getString("payment_method"),
                        rs.getString("discount_code"),
                        rs.getTimestamp("delivered_at"),
                        rs.getTimestamp("canceled_at")
                );
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    // Phương thức lấy đơn hàng trong khoảng thời gian
    public List<Order> getOrdersByDateRange(LocalDate startDate, LocalDate endDate) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE order_date BETWEEN ? AND ?";

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setDate(1, Date.valueOf(startDate));
            ps.setDate(2, Date.valueOf(endDate));
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Order order = new Order(
                        rs.getInt("order_id"),
                        rs.getInt("user_id"),
                        rs.getBigDecimal("total_price"),
                        rs.getTimestamp("order_date"),
                        rs.getInt("status"),
                        rs.getString("note"),
                        rs.getString("receiver_name"),
                        rs.getString("receiver_address"),
                        rs.getString("receiver_phone"),
                        rs.getString("payment_method"),
                        rs.getString("discount_code"),
                        rs.getTimestamp("delivered_at"),
                        rs.getTimestamp("canceled_at")
                );
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    // Phương thức đếm số đơn hàng đang chờ (pending)
    public int getPendingOrdersCount() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM orders WHERE status = 0";  // 0 cho status "pending"

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                count = rs.getInt(1);  // Lấy số lượng đơn hàng có trạng thái "pending"
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    //Phuong th?c in ra pending
    public ArrayList<Order> getPendingOrders() {
        ArrayList<Order> pendingOrders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE status = 0";
        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Order order = new Order(
                        rs.getInt("order_id"),
                        rs.getInt("user_id"),
                        rs.getBigDecimal("total_price"),
                        rs.getTimestamp("order_date"),
                        rs.getInt("status"),
                        rs.getString("note"),
                        rs.getString("receiver_name"),
                        rs.getString("receiver_address"),
                        rs.getString("receiver_phone"),
                        rs.getString("payment_method"),
                        rs.getString("discount_code"),
                        rs.getTimestamp("delivered_at"),
                        rs.getTimestamp("canceled_at")
                );
                pendingOrders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return pendingOrders;
    }

    public ArrayList<Order> getTrackedOrders() {
        ArrayList<Order> trackedOrders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE status = 1";
        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Order order = new Order(
                        rs.getInt("order_id"),
                        rs.getInt("user_id"),
                        rs.getBigDecimal("total_price"),
                        rs.getTimestamp("order_date"),
                        rs.getInt("status"),
                        rs.getString("note"),
                        rs.getString("receiver_name"),
                        rs.getString("receiver_address"),
                        rs.getString("receiver_phone"),
                        rs.getString("payment_method"),
                        rs.getString("discount_code"),
                        rs.getTimestamp("delivered_at"),
                        rs.getTimestamp("canceled_at")
                );
                trackedOrders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return trackedOrders;
    }

    public void confirmOrder(int orderId) {
        String sql = "UPDATE orders SET status = 1 WHERE order_id = ?";
        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.executeUpdate();
            System.out.println("Order ID " + orderId + " has been confirmed.");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Order> searchOrders(String filterType, String filterValue) throws SQLException {
        List<Order> orders = new ArrayList<>();
        String sql = "";

        if ("byCustomerId".equals(filterType)) {
            sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY order_date DESC";
        } else if ("byDate".equals(filterType)) {
            sql = "SELECT * FROM orders WHERE CAST(order_date AS DATE) = ? ORDER BY order_date DESC";
        }

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, filterValue);  // Gán giá trị filterValue vào SQL query
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
// Lấy tất cả đơn hàng

    public List<Order> getAllOrders() throws SQLException {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders ORDER BY order_date DESC";

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

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
// Tính tổng doanh thu theo tháng và năm

    public BigDecimal getTotalRevenueByMonth(int year, int month) {
        BigDecimal revenue = BigDecimal.ZERO;
        String sql = "SELECT SUM(total_price) FROM orders WHERE YEAR(order_date) = ? AND MONTH(order_date) = ?";

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, year);
            ps.setInt(2, month);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                revenue = rs.getBigDecimal(1);
                if (revenue == null) {
                    revenue = BigDecimal.ZERO;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return revenue;
    }

// Lấy tổng doanh thu từ tất cả các đơn hàng
    public BigDecimal getTotalRevenue() {
        BigDecimal revenue = BigDecimal.ZERO;
        String sql = "SELECT SUM(total_price) FROM orders"; // Lấy tổng doanh thu từ tất cả đơn hàng

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                revenue = rs.getBigDecimal(1);
                if (revenue == null) {
                    revenue = BigDecimal.ZERO;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return revenue;
    }

// Tính tổng doanh thu theo năm (không quan tâm đến tháng)
    public BigDecimal getTotalRevenueByYear(int year) {
        BigDecimal revenue = BigDecimal.ZERO;
        String sql = "SELECT SUM(total_price) FROM orders WHERE YEAR(order_date) = ?";

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, year);  // Truyền năm
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                revenue = rs.getBigDecimal(1);
                if (revenue == null) {
                    revenue = BigDecimal.ZERO;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return revenue;
    }
    //Lay don hang da huy in vao bang cancelled order
    public List<Order> getCancelledOrders() {
        List<Order> cancelledOrders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE status = -1";
        
        try (Connection con = getConnection(); 
             PreparedStatement ps = con.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Order order = new Order(
                    rs.getInt("order_id"),
                    rs.getInt("user_id"),
                    rs.getBigDecimal("total_price"),
                    rs.getTimestamp("order_date"),
                    rs.getInt("status"),
                    rs.getString("note"),
                    rs.getString("receiver_name"),
                    rs.getString("receiver_address"),
                    rs.getString("receiver_phone"),
                    rs.getString("payment_method"),
                    rs.getString("discount_code"),
                    rs.getTimestamp("delivered_at"),
                    rs.getTimestamp("canceled_at")
                );
                cancelledOrders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return cancelledOrders;
    }
}
