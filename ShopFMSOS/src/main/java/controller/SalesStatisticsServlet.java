package controller;

import dal.OrderDAO;
import dal.CategoryDAO;
import dal.UserDAO;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Order;

/**
 *
 * @author Nguyễn Ngoc Huy CE180178
 */
public class SalesStatisticsServlet extends HttpServlet {

@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    // Existing DAO for order and category statistics
    OrderDAO orderDAO = new OrderDAO();
    CategoryDAO categoryDAO = new CategoryDAO();
    
    // Get product count by category and total revenue
    Map<String, Integer> productCountByCategory = categoryDAO.getProductCountByCategory();
    BigDecimal totalRevenue = orderDAO.getTotalRevenue();

    // Get user counts for customers and staff
    UserDAO userDAO = new UserDAO();
    int customerCount = userDAO.countUsersByRole(3); // 3 represents customers
    int staffCount = userDAO.countUsersByRole(2); // 2 represents staff

    // Set attributes for JSP
    request.setAttribute("productCountByCategory", productCountByCategory);
    request.setAttribute("totalRevenue", totalRevenue);
    request.setAttribute("customerCount", customerCount);
    request.setAttribute("staffCount", staffCount);

    // Forward to JSP
    request.getRequestDispatcher("salesStatistics.jsp").forward(request, response);
}


}
