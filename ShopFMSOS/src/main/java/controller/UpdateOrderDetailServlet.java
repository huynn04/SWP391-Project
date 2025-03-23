/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.OrderDAO;
import dal.ProductDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.OrderDetail;
import model.Product;

/**
 *
 * @author Dang Chi Vi CE182507
 */
public class UpdateOrderDetailServlet extends jakarta.servlet.http.HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(jakarta.servlet.http.HttpServletRequest request, jakarta.servlet.http.HttpServletResponse response)
            throws jakarta.servlet.ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try ( PrintWriter out = response.getWriter()) {
            int orderDetailId = Integer.parseInt(request.getParameter("orderDetailId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            OrderDAO orderDAO = new OrderDAO();
            OrderDetail orderDetail = orderDAO.getOrderDetailById(orderDetailId);

            if (orderDetail != null) {
                ProductDAO productDAO = new ProductDAO();
                Product product = productDAO.getProductById(orderDetail.getProductId());

                // Tính lại subtotal đúng giá trị mới
                BigDecimal newSubtotal = product.getPrice().multiply(new BigDecimal(quantity));
                BigDecimal tax = newSubtotal.multiply(new BigDecimal("0.1")); // 10% thuế VAT

                // Cập nhật chi tiết đơn hàng với số lượng mới
                orderDAO.updateOrderDetail(orderDetailId, quantity, newSubtotal, tax);

                // Lấy tổng giá trị mới của đơn hàng
                BigDecimal newTotal = orderDAO.calculateTotalPrice(orderDetail.getOrderId());

                // Cập nhật tổng tiền của đơn hàng
                orderDAO.setTotalPrice(newTotal, orderDetail.getOrderId());

                // Trả về JSON
                out.println("{\"success\": true, \"newSubtotal\": " + newSubtotal + ", \"newTotal\": " + newTotal + "}");
            } else {
                out.println("{\"success\": false}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("{\"success\": false, \"message\": \"Lỗi khi cập nhật!\"}");
        }
    }
}
