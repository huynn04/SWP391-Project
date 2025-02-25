/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dal.ProductDAO;
import model.Product;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
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
        if (searchQuery == null) searchQuery = "";
        if (searchBy == null) searchBy = "name"; // Tìm kiếm theo tên mặc định
        if (sortBy == null) sortBy = "name"; // Sắp xếp theo tên mặc định

        ProductDAO productDAO = new ProductDAO();
        List<Product> products = productDAO.searchProducts(searchQuery, searchBy, sortBy);

        // Lưu danh sách sản phẩm vào request để hiển thị
        request.setAttribute("productList", products);
        request.getRequestDispatcher("/ManageProduct.jsp").forward(request, response);
    }
}