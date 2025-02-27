package controller;

import dal.CartDAO;
import java.io.IOException;
import java.math.BigDecimal;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Cart;

/**
 * Servlet hiển thị chi tiết giỏ hàng của người dùng.
 */
@WebServlet(name = "CartDetailServlet", urlPatterns = {"/CartDetail"})
public class CartDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        // Nếu người dùng chưa đăng nhập, chuyển hướng đến trang đăng nhập
//        if (userId == null) {
//            response.sendRedirect("login.jsp");
//            return;
//        }

        // Khởi tạo DAO và lấy giỏ hàng
        CartDAO cartDAO = new CartDAO();
        Cart cart = cartDAO.getCartByUserId(userId);

        BigDecimal totalPrice = BigDecimal.ZERO; // Giá trị mặc định nếu không có giỏ hàng
        if (cart != null) {
            totalPrice = cartDAO.getTotalPrice(cart.getCartId());
            request.setAttribute("cart", cart);
        } else {
            request.setAttribute("cart", null);
        }

        request.setAttribute("totalPrice", totalPrice);

        // Chuyển tiếp tới trang JSP để hiển thị giỏ hàng
        request.getRequestDispatcher("cartDetail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
