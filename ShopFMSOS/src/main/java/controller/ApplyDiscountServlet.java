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
import java.math.BigDecimal;

@WebServlet(name = "ApplyDiscountServlet", urlPatterns = {"/ApplyDiscount"})
public class ApplyDiscountServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String discountCode = request.getParameter("discountCode");

        CartDAO cartDAO = new CartDAO();
        DiscountDAO discountDAO = new DiscountDAO();

        Cart cart = cartDAO.getCartByUserId(userId);
        if (cart == null) {
            session.setAttribute("error", "Giỏ hàng của bạn đang trống!");
            response.sendRedirect("cartDetail.jsp");
            return;
        }

        Discount discount = discountDAO.getDiscountByCode(discountCode);
        if (discount == null) {
            session.setAttribute("error", "Mã giảm giá không hợp lệ hoặc đã hết hạn.");
        } else {
            BigDecimal totalPrice = cartDAO.getTotalPrice(cart.getCartId(), discount);
            session.setAttribute("totalPrice", totalPrice);
            session.setAttribute("discountCode", discountCode);
            session.setAttribute("success", "Mã giảm giá được áp dụng thành công!");
        }

        response.sendRedirect("cartDetail.jsp");
    }
}
