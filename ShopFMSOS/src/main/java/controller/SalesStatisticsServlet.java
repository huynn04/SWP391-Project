/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.OrderDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import model.Order;

/**
 *
 * @author Nguyễn Ngoc Huy CE180178
 */
public class SalesStatisticsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Tính tổng doanh thu
        OrderDAO orderDAO = new OrderDAO();
        BigDecimal totalRevenue = orderDAO.getTotalRevenue();

        // Lấy thông tin về đơn hàng trong tuần qua
        List<Order> recentOrders = orderDAO.getOrdersByDateRange(LocalDate.now().minusWeeks(1), LocalDate.now());

        // Số đơn hàng đang chờ
        int pendingOrders = orderDAO.getPendingOrdersCount();

        // Chuyển thông tin vào request
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("recentOrders", recentOrders);
        request.setAttribute("pendingOrders", pendingOrders);

        // Chuyển hướng đến trang dashboard
        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }

}
