/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.OrderDAO;
import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Optional;
import model.Order;
import model.User;

/**
 *
 * @author Nguyễn Ngoc Huy CE180178
 */
public class DetailCustomerServlet extends HttpServlet {


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy id khách hàng từ request
        String idParam = request.getParameter("id");
        int userId = Integer.parseInt(idParam);

        // Lấy thông tin khách hàng
        UserDAO userDao = new UserDAO();
        Optional<User> optUser = userDao.getUserById(userId);  // bạn cần thêm method getUserById() trong UserDAO
        if (!optUser.isPresent()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "User not found");
            return;
        }
        User customer = optUser.get();

        // Lấy danh sách đơn hàng của khách hàng
        OrderDAO orderDao = new OrderDAO();
        List<Order> orderList = orderDao.getOrdersByUserId(userId);

        // Nếu cần lấy chi tiết từng đơn hàng, bạn có thể gọi thêm một method khác ở OrderDAO
        // Đẩy dữ liệu ra request
        request.setAttribute("customer", customer);
        request.setAttribute("orderList", orderList);
        request.getRequestDispatcher("detailCustomer.jsp").forward(request, response);
    }


}
