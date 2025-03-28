package controller;

import dal.NewsDAO;
import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet; // Thêm import này
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.News;

public class AllNewsServlet extends HttpServlet {

    private static final int NEWS_PER_PAGE = 10;
    private static final Logger LOGGER = Logger.getLogger(AllNewsServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String searchQuery = request.getParameter("search");
        String pageParam = request.getParameter("page");
        String sortOption = request.getParameter("sortOption");

        int currentPage = (pageParam == null || pageParam.isEmpty()) ? 1 : Integer.parseInt(pageParam);
        if (sortOption == null) {
            sortOption = "created-desc"; // Mặc định
        }

        LOGGER.log(Level.INFO, "Received sortOption: {0}, page: {1}, search: {2}", new Object[]{sortOption, currentPage, searchQuery});

        NewsDAO newsDAO = new NewsDAO();
        int totalNews = searchQuery != null ? newsDAO.countSearchNews(searchQuery) : newsDAO.countAllNews();
        int totalPages = (int) Math.ceil((double) totalNews / NEWS_PER_PAGE);

        List<News> newsList = newsDAO.getNewsSortedByUser(currentPage, sortOption, searchQuery);

        request.setAttribute("newsList", newsList);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("search", searchQuery);
        request.setAttribute("sortOption", sortOption);

        request.getRequestDispatcher("AllNews.jsp").forward(request, response);
    }
}