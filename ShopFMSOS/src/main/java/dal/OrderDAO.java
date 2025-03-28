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
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.AbstractMap;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import model.Order;
import model.OrderDetail;
import model.Product;

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
                cancelledOrders.add(order);
            }
        } catch (SQLException e) {
        }

        return cancelledOrders;
    }
//Huy don

    public void cancelOrder(int orderId) {
        String sql = "UPDATE orders SET status = -1, canceled_at = GETDATE() WHERE order_id = ? AND status = 0";
        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Order ID " + orderId + " has been canceled.");
            } else {
                System.out.println("Order ID " + orderId + " could not be canceled (maybe already processed).");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void cancelOrderAndReturnStock(int orderId) {
        String updateOrderSql = "UPDATE orders SET status = -1, canceled_at = GETDATE() WHERE order_id = ? AND status = 0";
        String updateProductSql = "UPDATE products SET quantity = quantity + ? WHERE product_id = ?";
        String selectDetailsSql = "SELECT product_id, quantity FROM order_details WHERE order_id = ?";

        try ( Connection con = getConnection()) {
            con.setAutoCommit(false); // Bắt đầu transaction

            // Bước 1: Lấy danh sách sản phẩm trong đơn
            try ( PreparedStatement ps = con.prepareStatement(selectDetailsSql)) {
                ps.setInt(1, orderId);
                ResultSet rs = ps.executeQuery();

                // Bước 2: Cập nhật lại số lượng kho cho từng sản phẩm
                try ( PreparedStatement updateProductStmt = con.prepareStatement(updateProductSql)) {
                    while (rs.next()) {
                        int productId = rs.getInt("product_id");
                        int quantity = rs.getInt("quantity");

                        updateProductStmt.setInt(1, quantity);
                        updateProductStmt.setInt(2, productId);
                        updateProductStmt.addBatch(); // Gom lại thực hiện 1 lần
                    }
                    updateProductStmt.executeBatch();
                }
            }

            // Bước 3: Cập nhật trạng thái đơn hàng sang -1
            try ( PreparedStatement ps = con.prepareStatement(updateOrderSql)) {
                ps.setInt(1, orderId);
                ps.executeUpdate();
            }

            con.commit(); // Thành công thì commit
            System.out.println("Canceled order and returned stock to warehouse.");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

//Lay Order Detail
    public List<OrderDetail> getOrderDetailsByOrderId(int orderId) {
        List<OrderDetail> orderDetails = new ArrayList<>();
        String sql = "SELECT od.order_detail_id, od.order_id, od.product_id, od.quantity, od.price, od.subtotal, od.tax, "
                + "p.product_id, p.product_name, p.image "
                + "FROM order_details od "
                + "JOIN products p ON od.product_id = p.product_id "
                + "WHERE od.order_id = ?";

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                // Tạo đối tượng Product
                Product product = new Product(
                        rs.getInt("product_id"),
                        rs.getString("product_name"),
                        rs.getString("image")
                );

                // Tạo đối tượng OrderDetail có Product
                OrderDetail orderDetail = new OrderDetail(
                        rs.getInt("order_detail_id"),
                        rs.getInt("order_id"),
                        rs.getInt("product_id"),
                        rs.getInt("quantity"),
                        rs.getBigDecimal("price"),
                        rs.getBigDecimal("subtotal"),
                        rs.getBigDecimal("tax"),
                        product // Truyền đối tượng Product vào
                );

                orderDetails.add(orderDetail);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orderDetails;
    }

    public Order getOrderById(int orderId) {
        Order order = null;
        String sql = "SELECT * FROM orders WHERE order_id = ?";

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                order = new Order(
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
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return order;
    }
    // Cập nhật thông tin đơn hàng trong bảng orders

    public void updateOrderInfo(Order order) {
        String sql = "UPDATE orders SET receiver_name = ?, receiver_address = ?, receiver_phone = ?, payment_method = ?, updated_at = NOW() WHERE order_id = ?";

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, order.getReceiverName());
            ps.setString(2, order.getReceiverAddress());
            ps.setString(3, order.getReceiverPhone());
            ps.setString(4, order.getPaymentMethod());
            ps.setInt(5, order.getOrderId());
            ps.executeUpdate();  // Thực thi cập nhật thông tin đơn hàng
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Cập nhật thông tin chi tiết đơn hàng trong bảng order_details
    public void updateOrderDetails(List<OrderDetail> updatedOrderDetails) throws SQLException {
        String sql = "UPDATE order_details SET quantity = ?, subtotal = ?, tax = ? WHERE order_detail_id = ?";

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            for (OrderDetail orderDetail : updatedOrderDetails) {
                ps.setInt(1, orderDetail.getQuantity());  // Số lượng mới
                ps.setBigDecimal(2, orderDetail.getSubtotal());  // Subtotal mới (quantity * price)
                ps.setBigDecimal(3, orderDetail.getTax());  // Thuế mới
                ps.setInt(4, orderDetail.getOrderDetailId());  // ID chi tiết đơn hàng
                ps.addBatch();  // Thêm vào batch để thực hiện nhiều update cùng lúc
            }
            ps.executeBatch();  // Thực thi batch update
        } catch (SQLException e) {
            e.printStackTrace();
            throw new SQLException("Error updating order details", e);
        }
    }

    // Phương thức kết hợp để thực hiện cập nhật cả hai bảng orders và order_details
    public boolean updateOrder(Order order, List<OrderDetail> updatedOrderDetails) {
        Connection con = null;
        boolean success = false;

        try {
            con = getConnection();
            con.setAutoCommit(false); // Start transaction

            // Cập nhật thông tin đơn hàng trong bảng orders
            updateOrderInfo(order);  // Cập nhật thông tin đơn hàng

            // Cập nhật thông tin chi tiết đơn hàng trong bảng order_details
            updateOrderDetails(updatedOrderDetails);  // Cập nhật chi tiết đơn hàng

            con.commit();  // Commit transaction
            success = true;
        } catch (SQLException e) {
            e.printStackTrace();
            if (con != null) {
                try {
                    con.rollback(); // Rollback nếu có lỗi
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        } finally {
            try {
                if (con != null) {
                    con.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return success;
    }

    public void setTotalPrice(BigDecimal total, int id) {
        String sql = "UPDATE [dbo].[orders] SET [total_price] = ? WHERE [order_id] = ?"; // Sử dụng ? để thay thế các giá trị cứng
        Connection connection = getConnection();

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            connection.setAutoCommit(false); // Bắt đầu transaction

            // Thiết lập các giá trị vào PreparedStatement
            ps.setBigDecimal(1, total);  // Gán giá trị cho total_price
            ps.setInt(2, id);             // Gán giá trị cho order_id

            ps.executeUpdate();  // Thực thi câu lệnh UPDATE

            connection.commit();  // Commit transaction
        } catch (SQLException e) {
            e.printStackTrace();
            try {
                connection.rollback();  // Rollback nếu có lỗi
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }

    public OrderDetail getOrderDetailById(int orderDetailId) {
        OrderDetail orderDetail = null;
        String sql = "SELECT * FROM order_details WHERE order_detail_id = ?";

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderDetailId);
            ResultSet rs = ps.executeQuery();

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
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orderDetail;
    }

    public void updateOrderDetail(int orderDetailId, int quantity, BigDecimal subtotal, BigDecimal tax) {
        String sql = "UPDATE order_details SET quantity = ?, subtotal = ?, tax = ? WHERE order_detail_id = ?";

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setBigDecimal(2, subtotal);
            ps.setBigDecimal(3, tax);
            ps.setInt(4, orderDetailId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public BigDecimal getTotalPriceByOrderId(int orderId) {
        BigDecimal total = BigDecimal.ZERO;
        String sql = "SELECT SUM(subtotal) FROM order_details WHERE order_id = ?";

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                total = rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }

    public BigDecimal calculateTotalPrice(int orderId) {
        BigDecimal total = BigDecimal.ZERO;
        String sql = "SELECT SUM(subtotal) FROM order_details WHERE order_id = ?";

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                total = rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }

    public int createOrder(Order order) {
        String sql = "INSERT INTO orders (user_id, total_price, order_date, status, receiver_name, receiver_address, receiver_phone, payment_method, discount_code) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        int orderId = -1;

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, order.getUserId());
            ps.setBigDecimal(2, order.getTotalPrice());
            ps.setTimestamp(3, new Timestamp(order.getOrderDate().getTime()));
            ps.setInt(4, order.getStatus());
            ps.setString(5, order.getReceiverName());
            ps.setString(6, order.getReceiverAddress());
            ps.setString(7, order.getReceiverPhone());
            ps.setString(8, order.getPaymentMethod());
            ps.setString(9, order.getDiscountCode());

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    orderId = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orderId;
    }

    public boolean updateOrderStatus(int orderId, int status) {
        String sql = "UPDATE orders SET status = ? WHERE order_id = ?";

        try ( Connection conn = getConnection();  PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, status); // Tham số trạng thái mới (2 cho "Completed")
            stmt.setInt(2, orderId); // Tham số ID đơn hàng

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0; // Nếu có dòng bị ảnh hưởng, trả về true
        } catch (SQLException e) {
            e.printStackTrace();
            return false; // Nếu có lỗi xảy ra, trả về false
        }
    }

    public boolean cancelCustomerOrder(int orderId) {
        String updateOrderSql = "UPDATE orders SET status = -1, canceled_at = GETDATE() WHERE order_id = ? AND status = 0";
        String updateProductSql = "UPDATE products SET quantity = quantity + ? WHERE product_id = ?";
        String selectDetailsSql = "SELECT product_id, quantity FROM order_details WHERE order_id = ?";

        try ( Connection con = getConnection()) {
            con.setAutoCommit(false); // Bắt đầu transaction

            // Lấy danh sách sản phẩm trong đơn
            try ( PreparedStatement ps = con.prepareStatement(selectDetailsSql)) {
                ps.setInt(1, orderId);
                ResultSet rs = ps.executeQuery();

                try ( PreparedStatement updateProductStmt = con.prepareStatement(updateProductSql)) {
                    while (rs.next()) {
                        int productId = rs.getInt("product_id");
                        int quantity = rs.getInt("quantity");

                        updateProductStmt.setInt(1, quantity);
                        updateProductStmt.setInt(2, productId);
                        updateProductStmt.addBatch();
                    }
                    updateProductStmt.executeBatch(); // Cập nhật kho
                }
            }

            // Cập nhật trạng thái đơn hàng
            try ( PreparedStatement ps = con.prepareStatement(updateOrderSql)) {
                ps.setInt(1, orderId);
                int rowsAffected = ps.executeUpdate();
                if (rowsAffected > 0) {
                    con.commit(); // Mọi thứ ok thì commit
                    return true;
                } else {
                    con.rollback(); // Không update được đơn hàng thì rollback
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false; // Có lỗi xảy ra hoặc không thành công
    }

    public boolean updateOrderStatusToReceived(int orderId) {
        String sql = "UPDATE orders SET status = 2 WHERE order_id = ? AND status = 1"; // Cập nhật trạng thái từ 1 (Đang giao) thành 2 (Đã giao)

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;  // Trả về true nếu có bản ghi được cập nhật
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;  // Nếu không có bản ghi nào được cập nhật hoặc xảy ra lỗi
    }

    public List<Order> getAllOrdersSorted(String sortOption) throws SQLException {
        List<Order> orders = new ArrayList<>();
        String orderBy = "total_price DESC"; // Mặc định giảm dần

        if ("total-asc".equals(sortOption)) {
            orderBy = "total_price ASC"; // Tăng dần
        }

        String sql = "SELECT * FROM orders ORDER BY " + orderBy;

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql);  ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                orders.add(new Order(
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
                ));
            }
        }
        return orders;
    }

    public List<Order> searchOrdersSorted(String filterType, String filterValue, String sortOption) throws SQLException {
        List<Order> orders = new ArrayList<>();
        String orderBy = "total_price DESC"; // Mặc định giảm dần

        if ("total-asc".equals(sortOption)) {
            orderBy = "total_price ASC"; // Tăng dần
        }

        String sql = "";
        if ("byCustomerId".equals(filterType)) {
            sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY " + orderBy;
        } else if ("byDate".equals(filterType)) {
            sql = "SELECT * FROM orders WHERE CAST(order_date AS DATE) = ? ORDER BY " + orderBy;
        }

        try ( Connection con = getConnection();  PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, filterValue);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                orders.add(new Order(
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
                ));
            }
        }
        return orders;
    }

}
