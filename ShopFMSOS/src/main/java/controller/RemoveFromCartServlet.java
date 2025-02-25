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
public class RemoveFromCartServlet extends HttpServlet {
   
   @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy tham số productId từ URL
        String productIdParam = request.getParameter("productId");
        if (productIdParam == null) {
            response.sendRedirect("cartDetail.jsp");
            return;
        }
        
        int productId;
        try {
            productId = Integer.parseInt(productIdParam);
        } catch (NumberFormatException ex) {
            response.sendRedirect("cartDetail.jsp");
            return;
        }
        
        // Lấy giỏ hàng từ session
        HttpSession session = request.getSession();
        List<Product> cart = (List<Product>) session.getAttribute("cart");
        
        if (cart != null && !cart.isEmpty()) {
            // Tìm và xóa sản phẩm có productId tương ứng (xóa 1 sản phẩm đầu tiên gặp được)
            for (int i = 0; i < cart.size(); i++) {
                if (cart.get(i).getProductId() == productId) {
                    cart.remove(i);
                    break;
                }
            }
            session.setAttribute("cart", cart);
        }
        
        // Sau khi xóa, chuyển hướng lại đến trang giỏ hàng
        response.sendRedirect("cartDetail.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
