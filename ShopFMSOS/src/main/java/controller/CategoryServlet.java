/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.CategoryDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Category;

/**
 *
 * @author Dang Chi Vi CE182507
 */
public class CategoryServlet extends HttpServlet {
 private static final long serialVersionUID = 1L;
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        categoryDAO = new CategoryDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Category> categories = categoryDAO.getAllCategories(); // Lấy tất cả các danh mục từ database
        request.setAttribute("categories", categories); // Đưa dữ liệu vào attribute
        RequestDispatcher dispatcher = request.getRequestDispatcher("categories.jsp"); // Chuyển tiếp đến category.jsp
        dispatcher.forward(request, response);
    }
}
