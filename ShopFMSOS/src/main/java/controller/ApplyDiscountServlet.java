package controller;

import dal.CartDAO;
import dal.DiscountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Discount;
import model.Cart;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;

@WebServlet(name = "ApplyDiscountServlet", urlPatterns = {"/ApplyDiscount"})
public class ApplyDiscountServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        // Debug để kiểm tra session có userId không
        System.out.println("Session userId: " + session.getAttribute("userId"));

        try (PrintWriter out = response.getWriter()) {
            if (userId == null) {
                out.print("LOGIN_REQUIRED"); // Thông báo đăng nhập
                return;
            }

            String discountCode = request.getParameter("discountCode");
            if (discountCode == null || discountCode.trim().isEmpty()) {
                out.print("EMPTY_CODE");
                return;
            }

            CartDAO cartDAO = new CartDAO();
            DiscountDAO discountDAO = new DiscountDAO();

            Cart cart = cartDAO.getCartByUserId(userId);
            if (cart == null) {
                out.print("CART_EMPTY");
                return;
            }

            BigDecimal totalPrice = cartDAO.getTotalPrice(cart.getCartId());
            if (totalPrice == null || totalPrice.compareTo(BigDecimal.ZERO) == 0) {
                out.print("NO_ITEMS");
                return;
            }

            Discount discount = discountDAO.getDiscountByCode(discountCode);
            if (discount == null || discount.getStatus() != 1) {
                out.print("INVALID_CODE");
                return;
            }

            if (totalPrice.compareTo(BigDecimal.valueOf(discount.getMinOrderValue())) < 0) {
                out.print("MIN_ORDER_" + discount.getMinOrderValue()); // Mã lỗi kèm giá trị tối thiểu
                return;
            }

            // Tính toán giá trị giảm giá
            BigDecimal discountAmount;
            if ("percent".equalsIgnoreCase(discount.getDiscountType())) {
                discountAmount = totalPrice.multiply(BigDecimal.valueOf(discount.getDiscountValue())).divide(BigDecimal.valueOf(100));
            } else {
                discountAmount = BigDecimal.valueOf(discount.getDiscountValue());
            }

            BigDecimal newTotal = totalPrice.subtract(discountAmount);
            if (newTotal.compareTo(BigDecimal.ZERO) < 0) {
                newTotal = BigDecimal.ZERO;
            }

            // Lưu mã giảm giá vào giỏ hàng
            cartDAO.applyDiscountToCart(cart.getCartId(), discountCode, discountAmount);

            // Trả về số phần trăm hoặc số tiền giảm giá để cập nhật trên giao diện
            out.print(discount.getDiscountValue() + "|" + discount.getDiscountType());

            // Debug để kiểm tra session sau khi cập nhật
            System.out.println("New total after discount: " + newTotal);
            System.out.println("Applied discount code: " + discountCode);
        } catch (Exception e) {
            e.printStackTrace(); // Ghi lỗi vào console server
            response.getWriter().print("ERROR");
        }
    }
}
