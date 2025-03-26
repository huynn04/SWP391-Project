package controller;

import dal.CartDAO;
import dal.ProductDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import model.Cart;
import model.Product;

@WebServlet(name="CartDetailServlet", urlPatterns={"/CartDetail"})
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

        ProductDAO productDAO = new ProductDAO();
        String errorMessage = null;

        // Check stock for each product in the cart
        if (cart != null) {
            for (Product product : cart.getProducts()) {
                Product dbProduct = productDAO.getProductById(product.getProductId());
                if (dbProduct.getQuantity() < product.getQuantity()) {
                    errorMessage = "Product " + dbProduct.getProductName() + " is out of stock or quantity exceeds availability.";
                    break;
                }
            }
        }

        // Set error message in session if any product is out of stock
        if (errorMessage != null) {
            session.setAttribute("error", errorMessage);
            response.sendRedirect("cartDetail.jsp");
            return;
        }

        BigDecimal totalPrice = (BigDecimal) session.getAttribute("totalPrice");
        if (totalPrice == null && cart != null) {
            totalPrice = cartDAO.getTotalPrice(cart.getCartId());
        }

        request.setAttribute("cart", cart);
        request.setAttribute("totalPrice", totalPrice);
        request.getRequestDispatcher("cartDetail.jsp").forward(request, response);
    }
}
