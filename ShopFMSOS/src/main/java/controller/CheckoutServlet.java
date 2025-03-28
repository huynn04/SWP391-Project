package controller;

import dal.CartDAO;
import dal.OrderDAO;
import dal.OrderDetailDAO;
import dal.ProductDAO;
import dal.DiscountDAO; // Import DiscountDAO
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletResponse;
import model.Order;
import model.OrderDetail;
import model.Product;
import model.User;

public class CheckoutServlet extends HttpServlet {

    protected void doPost(jakarta.servlet.http.HttpServletRequest request, jakarta.servlet.http.HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println(">>> [DEBUG] CheckoutServlet doPost()");

        HttpSession session = request.getSession(true);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect("LoginServlet");
            return;
        }
        User user = (User) session.getAttribute("loggedInUser");
        List<Product> cart = (List<Product>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            System.out.println(">>> [DEBUG] Giỏ hàng trống, return sớm.");
            response.sendRedirect("cartDetail.jsp?error=CartEmpty");
            return;
        }

        int userId = user.getId();
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String specificAddress = request.getParameter("specificAddress");
        String ward = request.getParameter("ward");
        String district = request.getParameter("district");
        String city = request.getParameter("city");
        String paymentMethod = request.getParameter("paymentMethod");
        String discountCode = request.getParameter("discountCode");
        String address = String.join(", ", specificAddress, ward, district, city);

        if (user == null || fullName == null || address == null || phone == null || paymentMethod == null) {
            System.out.println(">>> [DEBUG] Thiếu thông tin nhận hàng, return sớm.");
            response.sendRedirect("checkoutInfo.jsp?error=Missing delivery information");
            return;
        }

        CartDAO cartDAO = new CartDAO();
        ProductDAO productDAO = new ProductDAO();
        OrderDAO orderDAO = new OrderDAO();
        OrderDetailDAO orderDetailDAO = new OrderDetailDAO();
        DiscountDAO discountDAO = new DiscountDAO(); // Tạo đối tượng DiscountDAO

        BigDecimal totalPrice = cartDAO.getTotalPrice(userId, discountCode);

        for (Product product : cart) {
            Product dbProduct = productDAO.getProductById(product.getProductId());
            if (dbProduct.getQuantity() < product.getQuantity()) {
                session.setAttribute("error", "Product " + dbProduct.getProductName() + " insuffiction.");
                response.sendRedirect("cartDetail.jsp");
                return;
            }
        }

        Order order = new Order();
        order.setUserId(userId);
        order.setTotalPrice(totalPrice);
        order.setOrderDate(new Date());
        order.setStatus(0);
        order.setReceiverName(fullName);
        order.setReceiverAddress(address);
        order.setReceiverPhone(phone);
        order.setPaymentMethod(paymentMethod);
        order.setDiscountCode(discountCode);

        int orderId = orderDAO.createOrder(order);
        if (orderId > 0) {
            System.out.println(">>> [DEBUG] Order được tạo thành công với orderId = " + orderId);
            boolean allStockUpdated = true;

            for (Product product : cart) {
                OrderDetail orderDetail = new OrderDetail();
                orderDetail.setOrderId(orderId);
                orderDetail.setProductId(product.getProductId());
                orderDetail.setQuantity(product.getQuantity());
                orderDetail.setPrice(product.getPrice());
                orderDetail.setSubtotal(product.getPrice().multiply(BigDecimal.valueOf(product.getQuantity())));

                boolean addedDetail = orderDetailDAO.addOrderDetail(orderDetail);
                if (addedDetail) {
                    System.out.println(">>> [DEBUG] OrderDetail thêm thành công cho ProductID = "
                            + product.getProductId());
                } else {
                    System.out.println(">>> [DEBUG] Lỗi khi thêm OrderDetail cho ProductID = "
                            + product.getProductId());
                    allStockUpdated = false;
                }

                System.out.println(">>> [DEBUG] Đang gọi updateProductStock cho ProductID = "
                        + product.getProductId()
                        + ", Số lượng mua = " + product.getQuantity());

                if (!productDAO.updateProductStock(product.getProductId(), product.getQuantity())) {
                    System.out.println(">>> [DEBUG] Lỗi updateProductStock cho ProductID = "
                            + product.getProductId());
                    allStockUpdated = false;
                }
            }

            if (allStockUpdated) {
                cartDAO.clearCart(userId);
                session.removeAttribute("cart");
                session.removeAttribute("discountCode");
                System.out.println(">>> [DEBUG] Thanh toán thành công, giỏ hàng đã được xoá.");

                // Cập nhật trạng thái mã giảm giá sau khi thanh toán thành công
                if (discountCode != null && !discountCode.isEmpty()) {
                    discountDAO.updateDiscountStatus(discountCode, 0);  // Cập nhật trạng thái mã giảm giá
                    System.out.println(">>> [DEBUG] Mã giảm giá đã được sử dụng, cập nhật trạng thái thành 0.");
                }

                response.sendRedirect("thongbao.jsp?message=success");
            } else {
                System.out.println(">>> [DEBUG] Lỗi cập nhật tồn kho hoặc thêm chi tiết đơn hàng, rollback.");
                response.sendRedirect("checkoutInfo.jsp?error=Error updating inventory or adding order please try again");
            }
        } else {
            System.out.println(">>> [DEBUG] Tạo Order thất bại.");
            response.sendRedirect("checkoutInfo.jsp?error=Order failed");
        }
    }
}
