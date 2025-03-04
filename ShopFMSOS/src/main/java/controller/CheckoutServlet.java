package controller;

import dal.CartDAO;
import dal.OrderDAO;
import dal.OrderDetailDAO;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Order;
import model.OrderDetail;
import model.Product;

public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy giỏ hàng từ session
        HttpSession session = request.getSession();
        List<Product> cart = (List<Product>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect("cartDetail.jsp"); // Giỏ hàng trống, quay lại giỏ hàng
            return;
        }

        // Chuyển giỏ hàng vào request để hiển thị
        request.setAttribute("cart", cart);
        request.getRequestDispatcher("thongbao.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        List<Product> cart = (List<Product>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect("cartDetail.jsp"); // Giỏ hàng trống, quay lại giỏ hàng
            return;
        }

        // Lấy thông tin người dùng
        Integer userId = (Integer) session.getAttribute("userId");
        String fullName = (String) session.getAttribute("fullName");
        String address = (String) session.getAttribute("address");
        String phone = (String) session.getAttribute("phone");
        String paymentMethod = (String) session.getAttribute("paymentMethod");
        String discountCode = (String) session.getAttribute("discountCode");

        if (userId == null || fullName == null || address == null || phone == null || paymentMethod == null) {
            response.sendRedirect("checkoutInfo.jsp");
            return;
        }

        // Tính tổng tiền giỏ hàng (có áp dụng mã giảm giá nếu có)
       CartDAO cartDAO = new CartDAO();
        BigDecimal totalPrice = cartDAO.getTotalPrice(userId, discountCode);

        // Tạo đơn hàng
        Order order = new Order();
        order.setUserId(userId);
        order.setTotalPrice(totalPrice);
        order.setOrderDate(new Date());
        order.setStatus(1); // Trạng thái "Đang xử lý"
        order.setReceiverName(fullName);
        order.setReceiverAddress(address);
        order.setReceiverPhone(phone);
        order.setPaymentMethod(paymentMethod);
        order.setDiscountCode(discountCode);

        OrderDAO orderDAO = new OrderDAO();
        int orderId = orderDAO.createOrder(order);

        if (orderId > 0) {
            // Lưu chi tiết đơn hàng
            OrderDetailDAO orderDetailDAO = new OrderDetailDAO();
            for (Product product : cart) {
                OrderDetail orderDetail = new OrderDetail();
                orderDetail.setOrderId(orderId);
                orderDetail.setProductId(product.getProductId());
                orderDetail.setQuantity(product.getQuantity());
                orderDetail.setPrice(product.getPrice());
                orderDetail.setSubtotal(product.getPrice().multiply(BigDecimal.valueOf(product.getQuantity())));
                orderDetailDAO.addOrderDetail(orderDetail);
            }

            // Xóa giỏ hàng sau khi đặt hàng thành công
            session.removeAttribute("cart");
            session.removeAttribute("discountCode");

            response.sendRedirect("thongbao.jsp?message=success"); // Chuyển sang trang thông báo
        } else {
            response.sendRedirect("checkoutInfo.jsp?error=checkout_failed");
        }
    }
}
