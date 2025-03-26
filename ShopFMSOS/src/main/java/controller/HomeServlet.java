package controller;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.News;
import dal.NewsDAO;

public class HomeServlet extends HttpServlet {

    private final NewsDAO newsDAO = new NewsDAO(); // Tạo DAO để lấy dữ liệu

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy danh sách bài viết mới nhất từ database
        List<News> newsList = newsDAO.getRecentNews();

        // Gửi danh sách bài viết đến trang JSP
        request.setAttribute("newsList", newsList);

        // Chuyển hướng đến home.jsp
        request.getRequestDispatcher("home.jsp").forward(request, response);
    }
}