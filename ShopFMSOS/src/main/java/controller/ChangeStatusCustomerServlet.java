/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Nguyễn Ngoc Huy CE180178
 */
public class ChangeStatusCustomerServlet extends HttpServlet {
   
     @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy tham số id từ request
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            // Nếu không có id, chuyển hướng về trang quản lý khách hàng
            response.sendRedirect("CustomerManager");
            return;
        }
        
        int userId = Integer.parseInt(idStr);
        
        // Gọi DAO để lấy thông tin người dùng
        UserDAO userDAO = new UserDAO();
        boolean success = userDAO.changeStatus(userId);
        
        // Sau khi cập nhật trạng thái, chuyển hướng về trang quản lý khách hàng
        response.sendRedirect("CustomerManager");
    }

}
