/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
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
import model.Category;

/**
 *
 * @author Tran Huy Lam CE180899
 */
public class ManageProductServlet extends HttpServlet {

    private static final int PAGE_SIZE = 10; // Số sản phẩm mỗi trang

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String searchQuery = request.getParameter("searchQuery");
        String searchBy = request.getParameter("searchBy");
        String sortBy = request.getParameter("sortBy");
        String pageParam = request.getParameter("page");

        // Set default values
        if (searchQuery == null) {
            searchQuery = "";
        }
        if (searchBy == null) {
            searchBy = "name"; // Default to search by name instead of 'all'
        }
        if (sortBy == null) {
            sortBy = "id-asc";
        }
        int page = (pageParam != null && !pageParam.isEmpty()) ? Integer.parseInt(pageParam) : 1;

        ProductDAO productDAO = new ProductDAO();
        List<Product> products = productDAO.getPaginatedProducts(searchQuery, searchBy, sortBy, page, PAGE_SIZE);
        int totalProducts = productDAO.countAllProducts();
        int totalPages = (int) Math.ceil((double) totalProducts / PAGE_SIZE);

        CategoryDAO categoryDao = new CategoryDAO();
        Map<Integer, String> categoryNames = new HashMap<>();
        for (Product product : products) {
            String categoryName = categoryDao.getCategoryNameById(product.getCategoryId());
            categoryNames.put(product.getProductId(), categoryName);
        }

        request.setAttribute("productList", products);
        request.setAttribute("categoryNames", categoryNames);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("searchQuery", searchQuery);
        request.setAttribute("searchBy", searchBy);
        request.setAttribute("sortBy", sortBy);

        request.getRequestDispatcher("/ManageProduct.jsp").forward(request, response);
    }
}
