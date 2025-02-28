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

@WebServlet(name = "CartDetailServlet", urlPatterns = {"/CartDetail"})
public class CartDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        CartDAO cartDAO = new CartDAO();
        Cart cart = cartDAO.getCartByUserId(userId);

        BigDecimal totalPrice = (BigDecimal) session.getAttribute("totalPrice");
        if (totalPrice == null && cart != null) {
            totalPrice = cartDAO.getTotalPrice(cart.getCartId());
        }

        request.setAttribute("cart", cart);
        request.setAttribute("totalPrice", totalPrice);
        request.getRequestDispatcher("cartDetail.jsp").forward(request, response);
    }
}
