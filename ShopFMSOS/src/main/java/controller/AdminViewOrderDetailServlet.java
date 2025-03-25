package controller;

import dal.OrderDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.util.List;
import model.Order;
import model.OrderDetail;

public class AdminViewOrderDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String orderIdStr = request.getParameter("orderId");

        if (orderIdStr == null || orderIdStr.isEmpty()) {
            response.sendRedirect("ManageOrder"); // Redirect to order management if no orderId
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);
            OrderDAO orderDAO = new OrderDAO();
            Order order = orderDAO.getOrderById(orderId);
            List<OrderDetail> orderDetails = orderDAO.getOrderDetailsByOrderId(orderId);

            if (order != null) {
                // Update total price if necessary
                BigDecimal total = BigDecimal.ZERO;
                for (OrderDetail o : orderDetails) {
                    total = total.add(o.getSubtotal());
                }
                orderDAO.setTotalPrice(total, orderId); // Update total_price in database

                // Set order and orderDetails in request scope
                request.setAttribute("order", order);
                request.setAttribute("orderDetails", orderDetails);

                // Forward to admin-specific JSP
                request.getRequestDispatcher("adminViewOrderDetail.jsp").forward(request, response);
            } else {
                response.sendRedirect("ManageOrder"); // Redirect if order not found
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("ManageOrder"); // Redirect if orderId is invalid
        }
    }

    @Override
    public String getServletInfo() {
        return "Admin View Order Detail Servlet";
    }
}