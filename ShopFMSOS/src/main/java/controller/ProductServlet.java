package controller;

import dal.ProductDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Product;

public class ProductServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get sort parameter from request
        String sortOption = request.getParameter("sortOption");

        // Default value (sorting by Name Ascending)
        if (sortOption == null) sortOption = "name-asc"; // Default sort to Name Ascending

        // Fetch products from the database, sorted by the specified criteria
        ProductDAO productDAO = new ProductDAO();
        List<Product> products = productDAO.getSortedProducts(sortOption);

        // Pagination logic
        int totalProducts = products.size();
        int pageSize = 6;  // Define the number of products per page
        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);  // Calculate total pages
        int currentPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;  // Get current page, default to 1
        int start = (currentPage - 1) * pageSize;  // Calculate the start index
        int end = Math.min(start + pageSize, totalProducts);  // Calculate the end index

        // Set attributes for products and pagination
        request.setAttribute("products", products.subList(start, end));  // Set the subset of products for the current page
        request.setAttribute("totalPages", totalPages);  // Set total number of pages
        request.setAttribute("currentPage", currentPage);  // Set the current page number

        // Forward to the JSP page
        request.getRequestDispatcher("product.jsp").forward(request, response);
    }
}
