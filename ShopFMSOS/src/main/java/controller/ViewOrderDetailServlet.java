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

public class ViewOrderDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String orderIdStr = request.getParameter("orderId");

        if (orderIdStr == null || orderIdStr.isEmpty()) {
            response.sendRedirect("orderHistory.jsp"); // Quay lại nếu thiếu orderId
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);
            OrderDAO orderDAO = new OrderDAO();
            Order order = orderDAO.getOrderById(orderId);
            List<OrderDetail> orderDetails = orderDAO.getOrderDetailsByOrderId(orderId);

            if (order != null) {
                // Cập nhật giá trị total_price nếu cần thiết
                BigDecimal total = BigDecimal.ZERO;
                for (OrderDetail o : orderDetails) {
                    total = total.add(o.getSubtotal()); // Cộng dồn tổng
                }
                orderDAO.setTotalPrice(total, orderId); // Cập nhật giá trị total_price trong database

                // Đặt cả order và orderDetails vào phạm vi request
                request.setAttribute("order", order);
                request.setAttribute("orderDetails", orderDetails);

                // Chuyển tiếp tới trang JSP
                request.getRequestDispatcher("viewOrderDetail.jsp").forward(request, response);
            } else {
                response.sendRedirect("orderHistory.jsp"); // Nếu không tìm thấy đơn hàng
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("orderHistory.jsp"); // Nếu orderId không hợp lệ
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
