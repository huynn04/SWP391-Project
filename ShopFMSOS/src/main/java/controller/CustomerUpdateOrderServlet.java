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
            // Retrieve orderId from URL
            String orderIdParam = request.getParameter("orderId");
            if (orderIdParam == null || orderIdParam.trim().isEmpty()) {
                response.sendRedirect("CustomerOrderHistory?error=Invalid order ID");
                return;
            }

            int orderId = Integer.parseInt(orderIdParam);

            // Get order and order details
            Order order = orderDAO.getOrderById(orderId);
            List<OrderDetail> orderDetails = orderDAO.getOrderDetailsByOrderId(orderId);

            if (order == null) {
                response.sendRedirect("CustomerOrderHistory?error=Order not found");
                return;
            }

            // Check if the user is authorized to update the order
            if (loggedInUser.getRoleId() == 3 && order.getUserId() != loggedInUser.getUserId()) {
                response.sendRedirect("CustomerOrderHistory?error=Unauthorized");
                return;
            }

            // Calculate the total price
            BigDecimal totalPrice = BigDecimal.ZERO;
            for (OrderDetail detail : orderDetails) {
                totalPrice = totalPrice.add(detail.getSubtotal());
            }

            // Pass data to the JSP
            request.setAttribute("order", order);
            request.setAttribute("orderDetails", orderDetails);
            request.setAttribute("totalPrice", totalPrice);  // Pass totalPrice to the JSP
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
            // Retrieve form data
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

            // Retrieve order and order details
            Order order = orderDAO.getOrderById(orderId);
            List<OrderDetail> orderDetails = orderDAO.getOrderDetailsByOrderId(orderId);

            if (order == null) {
                response.sendRedirect("CustomerOrderHistory?error=Order not found");
                return;
            }

            // Check for permissions to update: Only allow customers to update their own orders
            if (loggedInUser.getRoleId() == 3 && order.getUserId() != loggedInUser.getUserId()) {
                response.sendRedirect("CustomerOrderHistory?error=Unauthorized");
                return;
            }

            // Update the order object with new values
            order.setReceiverName(receiverName);
            order.setReceiverAddress(receiverAddress);
            order.setReceiverPhone(receiverPhone);
            order.setPaymentMethod(paymentMethod);

            // Update the order details (if quantities were changed)
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

            // Update order in the database
            boolean isUpdated = orderDAO.updateOrder(order, updatedOrderDetails);

            if (isUpdated) {
                // Update the total price after the change
                BigDecimal total = BigDecimal.ZERO;
                for (OrderDetail detail : updatedOrderDetails) {
                    total = total.add(detail.getSubtotal());
                }
                orderDAO.setTotalPrice(total, orderId); // Update total price in the database

                // Redirect to order history page after update
                response.sendRedirect("CustomerOrderHistory?success=Order updated successfully");
            } else {
                // If update failed, display error message
                request.setAttribute("errorMessage", "Failed to update order.");
                request.getRequestDispatcher("customerUpdateOrder.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("customerOrderHistory.jsp");
        }
    }

}
