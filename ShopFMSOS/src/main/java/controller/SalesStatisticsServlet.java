package controller;

import dal.OrderDAO;
import java.io.IOException;
import java.math.BigDecimal;
<<<<<<< Updated upstream
=======
import java.util.List;
import java.util.Map;
>>>>>>> Stashed changes
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
<<<<<<< Updated upstream
import model.Order;
import java.util.Map;
=======
>>>>>>> Stashed changes

public class SalesStatisticsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
<<<<<<< Updated upstream
        // Lấy tham số từ yêu cầu
        String yearParam = request.getParameter("year");
        String monthParam = request.getParameter("month");

        // Nếu year hoặc month không có giá trị, gán "all"
        if (yearParam == null || "all".equals(yearParam)) {
            yearParam = "all"; 
        }
        if (monthParam == null || "all".equals(monthParam)) {
            monthParam = "all"; 
        }

        try {
            // Khai báo các biến năm và tháng
            int year = 0;
            int month = 1;
=======
        String yearParam = request.getParameter("year");
        String monthParam = request.getParameter("month");

        // Kiểm tra xem year và month có tồn tại trong request không
        if (yearParam == null || monthParam == null) {
            // Nếu không có tham số, trả về lỗi 400
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Year or month parameter is missing");
            return;
        }

        try {
            // Chuyển đổi các tham số thành kiểu số nguyên
            int year = Integer.parseInt(yearParam);
            int month = Integer.parseInt(monthParam);

            // Tiến hành lấy thông tin thống kê doanh thu từ DAO
            OrderDAO orderDAO = new OrderDAO();
            BigDecimal totalRevenue = orderDAO.getTotalRevenueByMonth(year, month);
            List<Map.Entry<String, Integer>> productCountByCategory = orderDAO.getProductCountByCategoryAndMonth(year, month);

            // Set attributes cho JSP
            request.setAttribute("productCountByCategory", productCountByCategory);
            request.setAttribute("totalRevenue", totalRevenue);

            // Forward tới JSP
            request.getRequestDispatcher("salesStatistics.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid year or month format");
        }
    }
>>>>>>> Stashed changes

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
                totalRevenue = orderDAO.getTotalRevenue();  // Lấy tổng doanh thu từ tất cả các đơn hàng
            } else if (!"all".equals(yearParam) && "all".equals(monthParam)) {
                totalRevenue = orderDAO.getTotalRevenueByYear(year);  // Lấy tổng doanh thu theo năm
            } else if (!"all".equals(yearParam) && !"all".equals(monthParam)) {
                totalRevenue = orderDAO.getTotalRevenueByMonth(year, month);  // Lấy tổng doanh thu theo tháng và năm
            } else {
                totalRevenue = BigDecimal.ZERO;  // Trường hợp không hợp lệ
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
            request.setAttribute("month", month);    

            // Forward tới JSP
            request.getRequestDispatcher("salesStatistics.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid year or month format");
        }
    }
}
