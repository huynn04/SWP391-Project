package controller;

import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
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
        UserDAO userDAO = new UserDAO();

        String searchQuery = request.getParameter("searchQuery");
        String searchBy = request.getParameter("searchBy");
        String sortOption = request.getParameter("sortOption");

        if (sortOption == null || sortOption.isEmpty()) {
            sortOption = "name-asc"; // Mặc định Name A-Z
        }

        List<User> customerList;

        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            customerList = userDAO.searchAndSortCustomers(searchQuery, searchBy, sortOption);
        } else {
            customerList = userDAO.getAllCustomers(sortOption);
        }

        request.setAttribute("customerList", customerList);
        request.setAttribute("sortOption", sortOption);

        request.getRequestDispatcher("CustomerManager.jsp").forward(request, response);
    }
}