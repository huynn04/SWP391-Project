package controller;

import dal.OrderDAO;
import model.Order;
import model.OrderDetail;
import model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CustomerUpdateOrderServlet extends HttpServlet {

    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedInUser = (User) session.getAttribute("loggedInUser");

        if (loggedInUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // Lấy orderId từ URL
            String orderIdParam = request.getParameter("orderId");
            if (orderIdParam == null || orderIdParam.trim().isEmpty()) {
                response.sendRedirect("CustomerOrderHistory?error=Invalid order ID");
                return;
            }

            int orderId = Integer.parseInt(orderIdParam);

            // Lấy thông tin đơn hàng và chi tiết đơn hàng
            Order order = orderDAO.getOrderById(orderId);
            List<OrderDetail> orderDetails = orderDAO.getOrderDetailsByOrderId(orderId);

            if (order == null) {
                response.sendRedirect("CustomerOrderHistory?error=Order not found");
                return;
            }

            // Kiểm tra quyền cập nhật: chỉ cho phép khách hàng sửa đơn hàng của chính mình
            if (loggedInUser.getRoleId() == 3 && order.getUserId() != loggedInUser.getUserId()) {
                response.sendRedirect("CustomerOrderHistory?error=Unauthorized");
                return;
            }

            // Lấy danh sách đơn hàng của người dùng và truyền vào request
            List<Order> orders = orderDAO.getOrdersByUserId(loggedInUser.getUserId());
            request.setAttribute("orders", orders);  // Truyền orders vào request

            // Đặt đối tượng vào request và chuyển tiếp tới JSP
            request.setAttribute("order", order);
            request.setAttribute("orderDetails", orderDetails);
            request.getRequestDispatcher("customerUpdateOrder.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("CustomerOrderHistory?error=Error retrieving order details");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedInUser = (User) session.getAttribute("loggedInUser");

        if (loggedInUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // Lấy các tham số từ form
            String orderIdParam = request.getParameter("orderId");
            if (orderIdParam == null || orderIdParam.trim().isEmpty()) {
                response.sendRedirect("CustomerOrderHistory?error=Invalid order ID");
                return;
            }

            int orderId = Integer.parseInt(orderIdParam);
            String receiverName = request.getParameter("receiverName");
            String receiverAddress = request.getParameter("receiverAddress");
            String receiverPhone = request.getParameter("receiverPhone");
            String paymentMethod = request.getParameter("paymentMethod");

            // Lấy thông tin đơn hàng và chi tiết đơn hàng từ database
            Order order = orderDAO.getOrderById(orderId);
            List<OrderDetail> orderDetails = orderDAO.getOrderDetailsByOrderId(orderId);

            BigDecimal total = BigDecimal.ZERO;  // Khởi tạo giá trị ban đầu là 0

            for (OrderDetail o : orderDetails) {
                total = total.add(o.getSubtotal());  // Dùng phương thức add để cộng dồn
            }

            if (order == null) {
                response.sendRedirect("CustomerOrderHistory?error=Order not found");
                return;
            }

            // Kiểm tra quyền cập nhật: chỉ cho phép khách hàng sửa đơn hàng của chính mình
            if (loggedInUser.getRoleId() == 3 && order.getUserId() != loggedInUser.getUserId()) {
                response.sendRedirect("CustomerOrderHistory?error=Unauthorized");
                return;
            }

            // Cập nhật thông tin đơn hàng
            order.setReceiverName(receiverName);
            order.setReceiverAddress(receiverAddress);
            order.setReceiverPhone(receiverPhone);
            order.setPaymentMethod(paymentMethod);

            // Cập nhật số lượng sản phẩm trong order_details
            List<OrderDetail> updatedOrderDetails = new ArrayList<>();
            String[] orderDetailIds = request.getParameterValues("orderDetailId");
            String[] quantities = request.getParameterValues("quantity");

            if (orderDetailIds != null && quantities != null) {
                for (int i = 0; i < orderDetailIds.length; i++) {
                    int orderDetailId = Integer.parseInt(orderDetailIds[i]);
                    int newQuantity = Integer.parseInt(quantities[i]);

                    for (OrderDetail detail : orderDetails) {
                        if (detail.getOrderDetailId() == orderDetailId) {
                            detail.setQuantity(newQuantity);
                            updatedOrderDetails.add(detail);
                            break;
                        }
                    }
                }
            }

            // Cập nhật vào cơ sở dữ liệu
            boolean isUpdated = orderDAO.updateOrder(order, updatedOrderDetails);

            if (isUpdated) {
                orderDAO.setTotalPrice(total, orderId);  // Cập nhật giá trị total_price trong database

                // Lấy lại danh sách đơn hàng của người dùng sau khi cập nhật
                List<Order> orders = orderDAO.getOrdersByUserId(loggedInUser.getUserId());

                // Đặt danh sách đơn hàng vào request
                request.setAttribute("orders", orders);  // Truyền lại danh sách đơn hàng

                // Chuyển tiếp đến trang lịch sử đơn hàng
                request.getRequestDispatcher("customerOrderHistory.jsp").forward(request, response);
                return;
            } else {
                request.setAttribute("order", order);
                request.setAttribute("orderDetails", orderDetails);
                request.setAttribute("errorMessage", "Failed to update order.");
                request.getRequestDispatcher("customerUpdateOrder.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("customerOrderHistory.jsp");
        }
    }
}
