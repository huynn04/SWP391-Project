package controller;

import dal.NewsDAO;
import model.News;

import java.io.File;
import java.io.IOException;
import java.sql.Timestamp;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.nio.file.Paths;

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
                // Tạo tên file duy nhất bằng thời gian
                String fileName = System.currentTimeMillis() + "_" + Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

                // Định nghĩa đường dẫn lưu ảnh
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();  // Tạo thư mục nếu chưa có
                }

                // Lưu ảnh lên server
                filePart.write(uploadPath + File.separator + fileName);
                imageFileName = "/uploads/" + fileName;  // Đường dẫn lưu trên server
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

            // Add news to database
            boolean success = newsDAO.addNews(news);

            if (success) {
                request.setAttribute("success", "✅ News added successfully!");
            } else {
                request.setAttribute("error", "❌ Failed to add news. Please check the data.");
            }

            // Forward back to AddNews.jsp
            request.getRequestDispatcher("AddNews.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "❌ Error occurred: " + e.getMessage());
            request.getRequestDispatcher("AddNews.jsp").forward(request, response);
        }
    }
}
