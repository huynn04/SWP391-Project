package controller;

import dal.OrderDAO;
import dal.CategoryDAO;
import dal.UserDAO;
import java.io.IOException;
import java.math.BigDecimal;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.Map;

public class SalesStatisticsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy tham số từ yêu cầu, mặc định là "all" nếu không có giá trị
        String yearParam = request.getParameter("year") != null ? request.getParameter("year") : "all";
        String monthParam = request.getParameter("month") != null ? request.getParameter("month") : "all";

        try {
            // Khai báo các biến năm và tháng
            int year = 0;
            int month = 1;

            // Chuyển year thành số nếu không phải "all"
            if (!"all".equals(yearParam)) {
                year = Integer.parseInt(yearParam);
            }

            // Chuyển month thành số nếu không phải "all"
            if (!"all".equals(monthParam)) {
                month = Integer.parseInt(monthParam);
            }

            // Tiến hành lấy thông tin thống kê doanh thu từ DAO
            OrderDAO orderDAO = new OrderDAO();
            BigDecimal totalRevenue;

            // Xử lý các trường hợp doanh thu
            if ("all".equals(yearParam) && "all".equals(monthParam)) {
                totalRevenue = orderDAO.getTotalRevenue();
            } else if (!"all".equals(yearParam) && "all".equals(monthParam)) {
                totalRevenue = orderDAO.getTotalRevenueByYear(year);
            } else {
                totalRevenue = orderDAO.getTotalRevenueByMonth(year, month);
            }

            // Lấy số lượng Customer và Staff từ UserDAO
            UserDAO userDAO = new UserDAO();
            int customerCount = userDAO.countCustomers();
            int staffCount = userDAO.countStaff();

            // Lấy số lượng sản phẩm theo danh mục từ CategoryDAO
            CategoryDAO categoryDAO = new CategoryDAO();
            Map<String, Integer> productCountByCategory = categoryDAO.getProductCountByCategory();

            // Set attributes cho JSP
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("customerCount", customerCount);
            request.setAttribute("staffCount", staffCount);
            request.setAttribute("productCountByCategory", productCountByCategory);
            request.setAttribute("year", yearParam);
            request.setAttribute("month", monthParam);

            // Forward tới JSP
            request.getRequestDispatcher("salesStatistics.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid year or month format");
        }
    }
}