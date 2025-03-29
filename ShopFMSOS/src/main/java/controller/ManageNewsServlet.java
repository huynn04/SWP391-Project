package controller;

import dal.NewsDAO;
import model.News;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class ManageNewsServlet extends HttpServlet {

    private static final int PAGE_SIZE = 10; // Number of news per page

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String searchQuery = request.getParameter("searchQuery");
        String searchBy = request.getParameter("searchBy");
        String sortBy = request.getParameter("sortBy");
        String pageParam = request.getParameter("page");

        // Set default values
        if (searchQuery == null) {
            searchQuery = "";
        }
        if (searchBy == null) {
            searchBy = "title"; // Default search by title
        }
        if (sortBy == null) {
            sortBy = "date-desc"; // Default sort by date (newest first)
        }

        int page = (pageParam != null && !pageParam.isEmpty()) ? Integer.parseInt(pageParam) : 1;

        // Initialize DAO and fetch the data with sorting
        NewsDAO newsDAO = new NewsDAO();
        List<News> newsList = newsDAO.searchNews(searchQuery, searchBy, page, PAGE_SIZE, sortBy);
        int totalNews = newsDAO.countSearchNews(searchQuery, searchBy);
        int totalPages = (int) Math.ceil((double) totalNews / PAGE_SIZE);

        // Set the attributes for JSP page
        request.setAttribute("newsList", newsList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("searchQuery", searchQuery);
        request.setAttribute("searchBy", searchBy);
        request.setAttribute("sortBy", sortBy);

        request.getRequestDispatcher("/ManageNews.jsp").forward(request, response);
    }
}
