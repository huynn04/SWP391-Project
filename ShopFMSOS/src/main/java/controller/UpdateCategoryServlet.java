/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.CategoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import model.Category;

/**
 *
 * @author Dang Chi Vi CE182507
 */
public class UpdateCategoryServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy categoryId từ URL
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        
        // Lấy thông tin danh mục từ cơ sở dữ liệu
        CategoryDAO categoryDAO = new CategoryDAO();
        Category category = categoryDAO.getCategoryById(categoryId);
        
        // Gửi thông tin danh mục vào JSP để hiển thị trên form
        request.setAttribute("category", category);
        request.getRequestDispatcher("updatecategory.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy thông tin từ form
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        String categoryName = request.getParameter("categoryName");
        String description = request.getParameter("description");
        String image = request.getParameter("image");
        int status = Integer.parseInt(request.getParameter("status"));
        
        // Tạo đối tượng Category để lưu thông tin cập nhật
        Category category = new Category();
        category.setCategoryId(categoryId);
        category.setCategoryName(categoryName);
        category.setDescription(description);
        category.setImage(image);
        category.setStatus(status);
        
        // Cập nhật thông tin vào cơ sở dữ liệu
        CategoryDAO categoryDAO = new CategoryDAO();
        boolean isUpdated = categoryDAO.updateCategory(category);
        
        // Chuyển hướng về CategoryServlet để cập nhật danh sách
        if (isUpdated) {
            response.sendRedirect("CategoryServlet");
        } else {
            response.sendRedirect("UpdateCategory?categoryId=" + categoryId);
        }
    }
}
