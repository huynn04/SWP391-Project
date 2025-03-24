/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.NewsDAO;
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
import model.News;

/**
 *
 * @author Tran Huy Lam CE180899
 */
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class EditNewsServlet extends HttpServlet {

    private NewsDAO newsDAO;

    @Override
    public void init() {
        newsDAO = new NewsDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Lấy newsId từ request
            String newsIdParam = request.getParameter("newsId");

            if (newsIdParam != null && !newsIdParam.isEmpty()) {
                int newsId = Integer.parseInt(newsIdParam);

                // Lấy chi tiết tin tức từ database
                News news = newsDAO.getNewsById(newsId);

                // Kiểm tra xem có tin tức với newsId đó không
                if (news != null) {
                    request.setAttribute("news", news);
                    request.getRequestDispatcher("/EditNews.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "❌ Tin tức không tồn tại.");
                    request.getRequestDispatcher("/ManageNews").forward(request, response);
                }
            } else {
                request.setAttribute("error", "❌ News ID không hợp lệ.");
                request.getRequestDispatcher("/ManageNews").forward(request, response);
            }

        } catch (NumberFormatException e) {
            // Xử lý trường hợp lỗi khi chuyển đổi newsId sang số
            e.printStackTrace();
            request.setAttribute("error", "❌ Lỗi trong việc đọc ID tin tức.");
            request.getRequestDispatcher("/ManageNews").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        try {
            // Lấy dữ liệu từ form
            int newsId = Integer.parseInt(request.getParameter("newsId"));
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            int status = Integer.parseInt(request.getParameter("status"));
            int userId = 1; // Đặt userId mặc định cho admin

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

// Tiến hành cập nhật tin tức
            News news = new News();
            news.setNewsId(newsId);
            news.setTitle(title);
            news.setContent(content);
            news.setImage(imageFileName);
            news.setStatus(status);
            news.setUserId(userId);
            news.setUpdatedAt(currentTimestamp);  // Cập nhật thời gian

            boolean success = newsDAO.updateNews(news);

            if (success) {
                response.sendRedirect("ManageNews");
            } else {
                request.setAttribute("error", "❌ Failed to update news. Please check the data.");
                request.getRequestDispatcher("/EditNews.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "❌ Error occurred: " + e.getMessage());
            request.getRequestDispatcher("/EditNews.jsp").forward(request, response);
        }
    }
}
