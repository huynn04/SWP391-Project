/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.OrderDetailDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.OrderDetail;

/**
 *
 * @author Nguyễn Ngoc Huy CE180178
 */
public class OrderDetailServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int orderId = Integer.parseInt(request.getParameter("orderId"));

        // Lấy chi tiết đơn hàng từ database
        OrderDetailDAO orderDetailDAO = new OrderDetailDAO();
        List<OrderDetail> orderDetails = orderDetailDAO.getOrderDetailsByOrderId(orderId);

        // Chuyển dữ liệu vào request
        request.setAttribute("orderDetails", orderDetails);
        request.getRequestDispatcher("orderDetail.jsp").forward(request, response);
    }

}
