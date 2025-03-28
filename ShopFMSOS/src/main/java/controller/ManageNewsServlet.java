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
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author Tran Huy Lam CE180899
 */
public class ManageNewsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String searchQuery = request.getParameter("searchQuery");
        String searchBy = request.getParameter("searchBy");
        String sortBy = request.getParameter("sortBy");
        int currentPage = 1; // Default to page 1
        int newsPerPage = 10; // Number of news per page

        // Get the page number from the request
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                currentPage = 1; // If not a valid number, default to page 1
            }
        }

        // Set default values if no parameters are provided
        if (searchQuery == null) {
            searchQuery = "";
        }
        if (searchBy == null || (!searchBy.equals("id") && !searchBy.equals("title"))) {
            searchBy = "title"; // Default search by title (thay vì id)
        }
        if (sortBy == null || (!sortBy.equals("id") && !sortBy.equals("date"))) {
            sortBy = "id"; // Default sort by ID
        }

        // Initialize NewsDAO to get the news data
        NewsDAO newsDAO = new NewsDAO();

        // Perform search with pagination
        List<News> newsList = newsDAO.searchNews(searchQuery, searchBy, currentPage, newsPerPage);

        // Calculate total pages
        int totalNews = newsDAO.countSearchNews(searchQuery, searchBy);
        int totalPages = (int) Math.ceil((double) totalNews / newsPerPage);

        // Set attributes for the JSP
        request.setAttribute("newsList", newsList);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

        // Forward the request to the JSP
        try {
            request.getRequestDispatcher("/ManageNews.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while retrieving news.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}
