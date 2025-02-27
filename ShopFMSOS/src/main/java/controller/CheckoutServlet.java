/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Product;

/**
 *
 * @author Nguyễn Ngoc Huy CE180178
 */
public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy giỏ hàng từ session
        HttpSession session = request.getSession();
        List<Product> cart = (List<Product>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect("cartDetail.jsp"); // Giỏ hàng trống, quay lại giỏ hàng
            return;
        }

        // Chuyển giỏ hàng vào request để hiển thị
        request.setAttribute("cart", cart);
        request.getRequestDispatcher("thongbao.jsp").forward(request, response);
    }

   @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    HttpSession session = request.getSession();
    List<Product> cart = (List<Product>) session.getAttribute("cart");

    if (cart == null || cart.isEmpty()) {
        response.sendRedirect("cartDetail.jsp"); // Giỏ hàng trống, quay lại giỏ hàng
        return;
    }

    // Lấy thông tin người dùng từ session
    String fullName = (String) session.getAttribute("fullName");
    String address = (String) session.getAttribute("address");
    String phone = (String) session.getAttribute("phone");
    String paymentMethod = (String) session.getAttribute("paymentMethod");

    if (fullName == null || address == null || phone == null || paymentMethod == null) {
        response.sendRedirect("checkoutInfo.jsp"); // Chưa có thông tin, quay lại nhập
        return;
    }

    // Lưu đơn hàng vào database (có thể cập nhật sau)
    // OrderDAO orderDAO = new OrderDAO();
    // orderDAO.createOrder(userId, fullName, address, phone, paymentMethod, cart);

    // Xóa giỏ hàng sau khi đặt hàng thành công
    session.removeAttribute("cart");
    session.removeAttribute("fullName");
    session.removeAttribute("address");
    session.removeAttribute("phone");
    session.removeAttribute("paymentMethod");

    // Chuyển hướng đến trang thông báo
    response.sendRedirect("thongbao.jsp");
}


}
