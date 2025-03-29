package controller;

import dal.DiscountDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Discount;

import java.io.IOException;
import java.util.List;

public class ManageDiscountServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String searchQuery = request.getParameter("searchQuery");
        String searchBy = request.getParameter("searchBy");
        String sortBy = request.getParameter("sortBy");

        // Set default values for searchBy and sortBy if not provided
        if (searchBy == null || searchBy.isEmpty()) {
            searchBy = "code";  // Default search by code
        }
        if (sortBy == null || sortBy.isEmpty()) {
            sortBy = "code";        // Default sort by code
        }
        DiscountDAO discountDAO = new DiscountDAO();

        // Get the list of discounts based on search and sort parameters
        List<Discount> discountList = discountDAO.searchAndSortDiscounts(searchQuery, searchBy, sortBy);

        // Send data to JSP
        request.setAttribute("discountList", discountList);
        request.setAttribute("searchQuery", searchQuery);
        request.setAttribute("searchBy", searchBy);
        request.setAttribute("sortBy", sortBy);

        // Forward the request to the JSP page
        RequestDispatcher dispatcher = request.getRequestDispatcher("/ManageDiscount.jsp");
        dispatcher.forward(request, response);
    }

}
