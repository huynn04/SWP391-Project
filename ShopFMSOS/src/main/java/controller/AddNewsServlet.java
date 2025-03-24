/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.NewsDAO;
import model.News;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.sql.Timestamp;
import java.util.UUID;

/**
 *
 * @author Tran Huy Lam CE180899
 */
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class AddNewsServlet extends HttpServlet {

    private NewsDAO newsDAO;

    @Override
    public void init() {
        newsDAO = new NewsDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/AddNews.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        try {
            // Lấy các dữ liệu từ form
            String title = request.getParameter("title");
            String content = request.getParameter("content"); // Lấy nội dung HTML từ TinyMCE
            int status = Integer.parseInt(request.getParameter("status"));
            int userId = 1; // User ID mặc định

            // Lấy thời gian hiện tại
            Timestamp currentTimestamp = new Timestamp(System.currentTimeMillis());

            // Xử lý ảnh (nếu có thay đổi)
            Part filePart = request.getPart("image");
            String imageFileName = null;
            // Nếu không có ảnh mới, giữ lại ảnh cũ
            if (filePart != null && filePart.getSize() > 0) {
                // Xử lý ảnh mới
                String fileName = filePart.getSubmittedFileName();
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                filePart.write(uploadPath + File.separator + fileName);
                imageFileName = "/image/" + fileName;
            } else {
                // Nếu không thay đổi ảnh, giữ ảnh cũ
                imageFileName = request.getParameter("existingImage");
            }

            // Tạo đối tượng News và thiết lập thời gian
            News news = new News();
            news.setTitle(title);
            news.setContent(content); // Lưu dữ liệu HTML vào cơ sở dữ liệu
            news.setImage(imageFileName);
            news.setStatus(status);
            news.setUserId(userId);
            news.setCreatedAt(currentTimestamp);  // Thiết lập thời gian tạo
            news.setUpdatedAt(currentTimestamp);  // Thiết lập thời gian cập nhật

            // Lưu tin tức vào cơ sở dữ liệu
            boolean success = newsDAO.addNews(news);

            if (success) {
                response.sendRedirect("ManageNews");  // Redirect sau khi thành công
            } else {
                request.setAttribute("error", "❌ Failed to add news. Please check the data.");
                request.getRequestDispatcher("/AddNews.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "❌ Error occurred: " + e.getMessage());
            request.getRequestDispatcher("/AddNews.jsp").forward(request, response);
        }
    }
}
