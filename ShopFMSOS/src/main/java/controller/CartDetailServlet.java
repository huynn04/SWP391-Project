/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dal.CartDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Cart;

/**
 *
 * @author Nguyễn Ngoc Huy CE180178
 */
@WebServlet(name="CartDetailServlet", urlPatterns={"/CartDetail"})
public class CartDetailServlet extends HttpServlet {
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Giả sử userId được lưu trong session sau khi đăng nhập
        Integer userId = (Integer) request.getSession().getAttribute("userId");
        if (userId == null) {
            // Nếu chưa đăng nhập thì chuyển hướng đến trang đăng nhập
            response.sendRedirect("login.jsp");
            return;
        }
        
        CartDAO cartDAO = new CartDAO();
        Cart cart = cartDAO.getCartByUserId(userId);
        
        request.setAttribute("cart", cart);
        request.getRequestDispatcher("cartDetail.jsp").forward(request, response);
    }
    
    // Nếu cần xử lý POST thì có thể chuyển hướng về doGet
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
