/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.CategoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import model.Category;

/**
 *
 * @author Dang Chi Vi CE182507
 */
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class UpdateCategoryServlet extends HttpServlet {

    private CategoryDAO categoryDAO;

    @Override
    public void init() {
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy categoryId từ URL
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        
        // Lấy thông tin danh mục từ cơ sở dữ liệu
        Category category = categoryDAO.getCategoryById(categoryId);
        
        // Gửi thông tin danh mục vào JSP để hiển thị trên form
        request.setAttribute("category", category);
        request.getRequestDispatcher("updatecategory.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy thông tin từ form
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        String categoryName = request.getParameter("categoryName");
        String description = request.getParameter("description");
        int status = Integer.parseInt(request.getParameter("status"));

        // Lấy thông tin danh mục hiện tại để giữ ảnh cũ nếu không upload ảnh mới
        Category existingCategory = categoryDAO.getCategoryById(categoryId);
        String image = existingCategory.getImage(); // Giữ ảnh cũ mặc định

        // Handle Image Upload
        Part filePart = request.getPart("imageFile");
        if (filePart != null && filePart.getSize() > 0) { // Nếu có ảnh mới được upload
            String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();
            filePart.write(uploadPath + File.separator + fileName);
            image = "uploads/" + fileName; // Cập nhật đường dẫn ảnh mới
        }

        // Tạo đối tượng Category để lưu thông tin cập nhật
        Category category = new Category();
        category.setCategoryId(categoryId);
        category.setCategoryName(categoryName);
        category.setDescription(description);
        category.setImage(image);
        category.setStatus(status);
        
        // Cập nhật thông tin vào cơ sở dữ liệu
        boolean isUpdated = categoryDAO.updateCategory(category);
        
        // Chuyển hướng về CategoryServlet để cập nhật danh sách
        if (isUpdated) {
            response.sendRedirect("CategoryServlet");
        } else {
            response.sendRedirect("UpdateCategory?categoryId=" + categoryId);
        }
    }
}