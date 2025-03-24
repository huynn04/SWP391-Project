package controller;

import dal.ProductDAO;
import dal.ProductReviewDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Product;
import model.ProductReview;

import java.util.List;

public class ProductDetailServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String productIdParam = request.getParameter("productId");
        if (productIdParam != null) {
            try {
                int productId = Integer.parseInt(productIdParam);
                ProductDAO productDAO = new ProductDAO();
                Product product = productDAO.getProductById(productId);
                
                if (product != null) {
                    // Fetch product reviews
                    ProductReviewDAO reviewDAO = new ProductReviewDAO();
                    List<ProductReview> reviews = reviewDAO.getReviewsByProductId(productId);
                    
                    // Set product and reviews in request
                    request.setAttribute("product", product);
                    request.setAttribute("reviews", reviews);
                    
                    request.getRequestDispatcher("productDetail.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Product not found");
                }
            } catch (NumberFormatException ex) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid product id");
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Product id is missing");
        }
    }
}
