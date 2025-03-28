package controller;

import dal.NewsDAO;
import java.io.IOException;
import java.io.File;
import java.nio.file.Paths;
import java.sql.Timestamp;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.News;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
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
            String newsIdParam = request.getParameter("newsId");

            if (newsIdParam != null && !newsIdParam.isEmpty()) {
                int newsId = Integer.parseInt(newsIdParam);
                News news = newsDAO.getNewsById(newsId);

                if (news != null) {
                    request.setAttribute("news", news);
                    request.getRequestDispatcher("/EditNews.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "❌ News not found.");
                    request.getRequestDispatcher("/ManageNews").forward(request, response);
                }
            } else {
                request.setAttribute("error", "❌ Invalid news ID.");
                request.getRequestDispatcher("/ManageNews").forward(request, response);
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("error", "❌ Failed to parse news ID.");
            request.getRequestDispatcher("/ManageNews").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        try {
            int newsId = Integer.parseInt(request.getParameter("newsId"));
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            int status = Integer.parseInt(request.getParameter("status"));
            String oldImage = request.getParameter("oldImage");
            int userId = 1; // hardcoded admin user ID

            Timestamp currentTimestamp = new Timestamp(System.currentTimeMillis());

            // Handle image upload
            Part filePart = request.getPart("image");
            String imagePath = oldImage; // default to old image

            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String uploadPath = getServletContext().getRealPath("") + File.separator + "image";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                String savedFileName = System.currentTimeMillis() + "_" + fileName;
                File savedFile = new File(uploadDir, savedFileName);
                filePart.write(savedFile.getAbsolutePath());

                imagePath = "/image/" + savedFileName; // use relative path to /image
            }

            // Prepare updated news object
            News news = new News();
            news.setNewsId(newsId);
            news.setTitle(title);
            news.setContent(content);
            news.setImage(imagePath);
            news.setStatus(status);
            news.setUserId(userId);
            news.setUpdatedAt(currentTimestamp);

            boolean success = newsDAO.updateNews(news);

            if (success) {
                response.sendRedirect("ManageNews");
            } else {
                request.setAttribute("error", "❌ Failed to update news. Please check the data.");
                request.setAttribute("news", news); // keep entered data
                request.getRequestDispatcher("/EditNews.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "❌ An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/EditNews.jsp").forward(request, response);
        }
    }
}
