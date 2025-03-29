package controller;

import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.User;

public class CustomerManagerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String searchQuery = request.getParameter("searchQuery");
        String searchBy = request.getParameter("searchBy");
        String sortOption = request.getParameter("sortOption");

        // Default sort option if none provided
        if (sortOption == null || sortOption.isEmpty()) {
            sortOption = "name-asc";
        }

        UserDAO userDao = new UserDAO();
        List<User> customerList;

        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            customerList = userDao.searchAndSortCustomers(searchQuery, searchBy, sortOption);
        } else {
            customerList = userDao.getAllCustomers(sortOption);
        }

        request.setAttribute("customerList", customerList);
        request.setAttribute("sortOption", sortOption); // Preserve sort state

        request.getRequestDispatcher("CustomerManager.jsp").forward(request, response);
    }
}