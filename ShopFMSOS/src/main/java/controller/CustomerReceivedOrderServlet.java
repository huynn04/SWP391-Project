/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 *
 * @author Dang Chi Vi CE182507
 */
public class CustomerReceivedOrderServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy orderId từ URL
        int orderId = Integer.parseInt(request.getParameter("orderId"));

        // Tạo DAO để thao tác với cơ sở dữ liệu
        OrderDAO orderDAO = new OrderDAO();

        // Cập nhật trạng thái của đơn hàng thành "Đã giao" (status = 2)
        boolean isReceived = orderDAO.updateOrderStatusToReceived(orderId);

        if (isReceived) {
            // Nếu cập nhật thành công, chuyển hướng về trang Lịch sử đơn hàng
            response.sendRedirect("CustomerOrderHistory"); // Trang lịch sử đơn hàng
        } else {
            // Nếu cập nhật không thành công, chuyển hướng về trang thông báo lỗi
            response.sendRedirect("error.jsp");
        }
    }
    
}