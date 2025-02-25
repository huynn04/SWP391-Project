/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.OrderDAO;
import dal.ProductDAO;
import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.math.BigDecimal;

/**
 *
 * @author Nguyễn Ngoc Huy CE180178
 */
public class DashboardServlet extends HttpServlet {


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Tạo DAO
        UserDAO userDAO = new UserDAO();
        ProductDAO productDAO = new ProductDAO();
        OrderDAO orderDAO = new OrderDAO();

        // Đếm số lượng user và product
        int totalUsers = userDAO.countAllUsers();
        int totalProducts = productDAO.countAllProducts();

        // Tính tổng doanh thu (Revenue)
        BigDecimal totalRevenue = orderDAO.getTotalRevenue();

        // Đưa dữ liệu vào request attribute
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalRevenue", totalRevenue);

        // Chuyển tiếp sang dashboard.jsp
        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }


}
