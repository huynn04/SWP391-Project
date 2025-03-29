package controller;

import dal.CategoryDAO;
import dal.ProductDAO;
import model.Product;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ManageProductServlet extends HttpServlet {

    private static final int PAGE_SIZE = 10; // Number of products per page

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get request parameters
        String searchQuery = request.getParameter("searchQuery");
        String searchBy = request.getParameter("searchBy");
        String sortBy = request.getParameter("sortBy");
        String pageParam = request.getParameter("page");

        // Set default values for parameters if not provided
        if (searchQuery == null) {
            searchQuery = "";
        }
        if (searchBy == null) {
            searchBy = "name"; // Default search by name
        }
        if (sortBy == null) {
            sortBy = "id-asc"; // Default sort by ID (ascending)
        }
        int page = (pageParam != null && !pageParam.isEmpty()) ? Integer.parseInt(pageParam) : 1;

        // Create an instance of ProductDAO to handle data retrieval
        ProductDAO productDAO = new ProductDAO();

        // Get paginated products based on search and sorting criteria
        List<Product> products = productDAO.searchProducts(searchQuery, searchBy, sortBy);

        // Get total number of products for pagination
        int totalProducts = productDAO.countAllProducts();
        int totalPages = (int) Math.ceil((double) totalProducts / PAGE_SIZE);

        // Get category names for each product
        CategoryDAO categoryDao = new CategoryDAO();
        Map<Integer, String> categoryNames = new HashMap<>();
        for (Product product : products) {
            String categoryName = categoryDao.getCategoryNameById(product.getCategoryId());
            categoryNames.put(product.getProductId(), categoryName);
        }

        // Set the attributes to be passed to the JSP
        request.setAttribute("productList", products);
        request.setAttribute("categoryNames", categoryNames);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("searchQuery", searchQuery);
        request.setAttribute("searchBy", searchBy);
        request.setAttribute("sortBy", sortBy);

        // Forward the request to the JSP page for rendering
        request.getRequestDispatcher("/ManageProduct.jsp").forward(request, response);
    }
}
