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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String searchQuery = request.getParameter("searchQuery");
        String searchBy = request.getParameter("searchBy");
        String sortBy = request.getParameter("sortBy");

        // Nếu không có giá trị nào, đặt mặc định
        if (searchQuery == null) {
            searchQuery = "";
        }
        if (searchBy == null) {
            searchBy = "id"; // Tìm kiếm theo tên mặc định
        }
        if (sortBy == null) {
            sortBy = "id"; // Sắp xếp theo tên mặc định
        }
        ProductDAO productDAO = new ProductDAO();
        List<Product> products = productDAO.searchProducts(searchQuery, searchBy, sortBy);

// Lấy danh sách tên danh mục
        CategoryDAO categoryDao = new CategoryDAO();
        Map<Integer, String> categoryNames = new HashMap<>();
        for (Product product : products) {
            String categoryName = categoryDao.getCategoryNameById(product.getCategoryId());
            categoryNames.put(product.getProductId(), categoryName);
        }

// Lưu danh sách sản phẩm và danh mục vào request để hiển thị
        request.setAttribute("productList", products);
        request.setAttribute("categoryNames", categoryNames);
        request.getRequestDispatcher("/ManageProduct.jsp").forward(request, response);
    }

}
