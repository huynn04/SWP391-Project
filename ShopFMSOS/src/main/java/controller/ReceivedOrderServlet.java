/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.OrderDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Order;
import model.User;

/**
 *
 * @author Dang Chi Vi CE182507
 */
public class ReceivedOrderServlet extends HttpServlet {

     private static final long serialVersionUID = 1L;

    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        
        // Cập nhật trạng thái đơn hàng từ 1 (shipping) sang 2 (completed)
        boolean isUpdated = orderDAO.updateOrderStatus(orderId, 2); 
        
        if (isUpdated) {
            // Nếu cập nhật thành công, chuyển hướng về trang CustomerOrderHistory
            response.sendRedirect(request.getContextPath() + "/CustomerOrderHistory");
        } else {
            // Nếu không thành công, hiển thị thông báo lỗi và chuyển hướng về trang CustomerOrderHistory
            request.setAttribute("errorMessage", "Cập nhật trạng thái đơn hàng không thành công!");
            response.sendRedirect(request.getContextPath() + "/CustomerOrderHistory");
        }
    }

    private int getUserIdFromSession(HttpServletRequest request) {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        return user != null ? user.getUserId() : -1; // Trả về -1 nếu không tìm thấy user trong session
    }

    @Override
    public void destroy() {
    }
}