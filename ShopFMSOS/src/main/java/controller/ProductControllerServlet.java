package controller;

import dal.ProductDAO;
import dal.CategoryDAO;
import model.Product;
import model.Category;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class ProductControllerServlet extends HttpServlet {

    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;
    private static final int PAGE_SIZE = 6; // 6 products per page

    @Override
    public void init() {
        productDAO = new ProductDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get request parameters
        String searchQuery = request.getParameter("searchQuery");
        String[] selectedCategories = request.getParameterValues("categoryId");
        String sortOption = request.getParameter("sortOption");
        String pageStr = request.getParameter("page");
        int page = (pageStr != null && !pageStr.isEmpty()) ? Integer.parseInt(pageStr) : 1;

        // Get all categories for filter section
        List<Category> categories = categoryDAO.getAllCategories();

        // Get products with pagination
        List<Product> products;
        int totalProducts;

        // If no filters or sorting, use getPaginatedProducts directly
        if ((searchQuery == null || searchQuery.trim().isEmpty()) && 
            (selectedCategories == null || selectedCategories.length == 0) && 
            (sortOption == null || sortOption.isEmpty())) {
            totalProducts = productDAO.countAllProducts();
            products = productDAO.getPaginatedProducts(null, "name", "name-asc", page, PAGE_SIZE);
        } else {
            // Apply filters first
            products = productDAO.getFilteredProducts(searchQuery, selectedCategories);
            totalProducts = products.size();

            // Apply sorting if specified
            if (sortOption != null && !sortOption.isEmpty()) {
                products = productDAO.getSortedProducts(sortOption);
            }

            // Apply pagination
            int start = (page - 1) * PAGE_SIZE;
            int end = Math.min(start + PAGE_SIZE, products.size());
            if (start < products.size()) {
                products = products.subList(start, end);
            } else {
                products = List.of(); // Empty list if no products for this page
            }
        }

        // Calculate total pages
        int totalPages = (int) Math.ceil((double) totalProducts / PAGE_SIZE);

        // Ensure page is within bounds
        if (page > totalPages && totalPages > 0) {
            page = totalPages;
        } else if (page < 1) {
            page = 1;
        }

        // Set attributes for JSP
        request.setAttribute("categories", categories);
        request.setAttribute("products", products);
        request.setAttribute("searchQuery", searchQuery);
        request.setAttribute("selectedCategories", selectedCategories);
        request.setAttribute("sortOption", sortOption);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        // Forward to JSP
        request.getRequestDispatcher("/product.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response); // Handle POST the same as GET
    }
}