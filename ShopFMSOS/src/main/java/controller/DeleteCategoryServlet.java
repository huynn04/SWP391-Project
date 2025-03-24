/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.CategoryDAO;
import dal.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 *
 * @author Dang Chi Vi CE182507
 */
public class DeleteCategoryServlet extends HttpServlet {
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        
        // Trước khi xóa danh mục, cần thay đổi category_id của các sản phẩm liên quan
        ProductDAO productDAO = new ProductDAO();
        boolean isUpdated = productDAO.updateProductCategory(categoryId, 13); // Cập nhật category_id của các sản phẩm thành 13
        
        if (isUpdated) {
            // Nếu cập nhật thành công, xóa danh mục
            CategoryDAO categoryDAO = new CategoryDAO();
            boolean isDeleted = categoryDAO.deleteCategory(categoryId); // Xóa danh mục khỏi bảng categories
            
            if (isDeleted) {
                response.sendRedirect("CategoryServlet"); // Sau khi xóa danh mục, chuyển hướng về danh sách danh mục
            } else {
                response.sendRedirect("CategoryServlet?error=deleteFailed"); // Nếu xóa danh mục thất bại
            }
        } else {
            response.sendRedirect("CategoryServlet?error=updateFailed"); // Nếu cập nhật sản phẩm thất bại
        }
    }
}