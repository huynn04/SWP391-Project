package controller;

import dal.CartDAO;
import dal.OrderDAO;
import dal.OrderDetailDAO;
import dal.ProductDAO;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Order;
import model.OrderDetail;
import model.Product;
import model.User;

@WebServlet(name = "CheckoutServlet", urlPatterns = {"/Checkout"})
public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Log để xác nhận servlet được gọi
        System.out.println(">>> [DEBUG] CheckoutServlet doPost()");

        HttpSession session = request.getSession(true);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect("LoginServlet");
            return;
        }
        User user = (User) session.getAttribute("loggedInUser");
        List<Product> cart = (List<Product>) session.getAttribute("cart");

        // Kiểm tra giỏ hàng
        if (cart == null || cart.isEmpty()) {
            System.out.println(">>> [DEBUG] Giỏ hàng trống, return sớm.");
            response.sendRedirect("cartDetail.jsp?error=CartEmpty");
            return;
        }

        // Lấy thông tin thanh toán từ session
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

        // Kiểm tra thông tin bắt buộc
        if (user == null || fullName == null || address == null || phone == null || paymentMethod == null) {
            System.out.println(">>> [DEBUG] Thiếu thông tin nhận hàng, return sớm.");
            response.sendRedirect("checkoutInfo.jsp?error=Missing delivery information");
            return;
        }

        // Khởi tạo các DAO cần thiết
        CartDAO cartDAO = new CartDAO();
        ProductDAO productDAO = new ProductDAO();
        OrderDAO orderDAO = new OrderDAO();
        OrderDetailDAO orderDetailDAO = new OrderDetailDAO();

        // Tính tổng tiền đơn hàng
        BigDecimal totalPrice = cartDAO.getTotalPrice(userId, discountCode);

        // Kiểm tra số lượng tồn kho cho từng sản phẩm
        for (Product product : cart) {
            Product dbProduct = productDAO.getProductById(product.getProductId());
            System.out.println("quantity product: " + dbProduct.getQuantity());
            System.out.println("quantity actual: " + product.getQuantity());
            if (dbProduct.getQuantity() < product.getQuantity()) {
                session.setAttribute("error", "Product " + dbProduct.getProductName() + " insuffiction.");
                response.sendRedirect("cartDetail.jsp");
                return;
            }
        }

        // Tạo đối tượng Order
        Order order = new Order();
        order.setUserId(userId);
        order.setTotalPrice(totalPrice);
        order.setOrderDate(new Date());
        order.setStatus(0); // Giả sử status = 1 nghĩa là "đã đặt hàng"
        order.setReceiverName(fullName);
        order.setReceiverAddress(address);
        order.setReceiverPhone(phone);
        order.setPaymentMethod(paymentMethod);
        order.setDiscountCode(discountCode);

        // Tạo order trong DB và lấy orderId
        int orderId = orderDAO.createOrder(order);
        if (orderId > 0) {
            System.out.println(">>> [DEBUG] Order được tạo thành công với orderId = " + orderId);
            boolean allStockUpdated = true;

            // Xử lý từng sản phẩm trong giỏ hàng: tạo OrderDetail và cập nhật tồn kho
            for (Product product : cart) {
                // Tạo OrderDetail
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

                // Log trước khi gọi updateProductStock
                System.out.println(">>> [DEBUG] Đang gọi updateProductStock cho ProductID = "
                        + product.getProductId()
                        + ", Số lượng mua = " + product.getQuantity());

                // Cập nhật tồn kho
                if (!productDAO.updateProductStock(product.getProductId(), product.getQuantity())) {
                    System.out.println(">>> [DEBUG] Lỗi updateProductStock cho ProductID = "
                            + product.getProductId());
                    allStockUpdated = false;
                }
            }

            if (allStockUpdated) {
                // Xóa giỏ hàng sau khi thanh toán thành công
                cartDAO.clearCart(userId);
                session.removeAttribute("cart");
                session.removeAttribute("discountCode");
                System.out.println(">>> [DEBUG] Thanh toán thành công, giỏ hàng đã được xoá.");
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
