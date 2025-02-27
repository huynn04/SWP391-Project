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
import model.Product;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import model.Cart;

@WebServlet("/ApplyDiscount")
public class ApplyDiscountServlet extends HttpServlet {

   @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String data = request.getParameter("data");
        DiscountDAO dDAO = new DiscountDAO();
        Discount dis = dDAO.getDiscountByCode(data);
        if(dis != null) {
            double discountValue = dis.getDiscountValue();
            response.getWriter().write(discountValue + "");
        } else {
            response.getWriter().write("Discount is not exists!");
        }
        

//        HttpSession session = request.getSession();
//        Integer userId = (Integer) session.getAttribute("userId"); // Lấy ID người dùng
//
//        if (userId == null) {
//            response.sendRedirect("login.jsp"); // Yêu cầu đăng nhập trước khi áp dụng mã giảm giá
//            return;
//        }
//
//        String discountCode = request.getParameter("discountCode"); // Lấy mã giảm giá từ form
//
//        DiscountDAO discountDAO = new DiscountDAO();
//        CartDAO cartDAO = new CartDAO();
//
//        Cart cart = cartDAO.getCartByUserId(userId);
//        if (cart == null) {
//            request.setAttribute("error", "Giỏ hàng của bạn đang trống!");
//            request.getRequestDispatcher("cartDetail.jsp").forward(request, response);
//            return;
//        }
//
//        Discount discount = discountDAO.getDiscountByCode(discountCode);
//
//        if (discount == null) {
//            request.setAttribute("error", "Mã giảm giá không hợp lệ hoặc đã hết hạn.");
//        } else {
//            cartDAO.applyDiscountToCart(cart.getCartId(), discount.getDiscountId());
//            BigDecimal totalPrice = cartDAO.getTotalPrice(cart.getCartId(), discount);
//            session.setAttribute("totalPrice", totalPrice);
//            request.setAttribute("success", "Mã giảm giá được áp dụng thành công!");
//        }
//
//        request.getRequestDispatcher("cartDetail.jsp").forward(request, response);
    }
}

