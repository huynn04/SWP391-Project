/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.ProductDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import model.Product;

/**
 *
 * @author Nguyễn Ngoc Huy CE180178
 */
public class AddToCartServlet extends HttpServlet {

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

        // Lấy thông tin sản phẩm từ CSDL
        ProductDAO productDAO = new ProductDAO();
        Product product = productDAO.getProductById(productId);
        if (product == null) {
            response.sendRedirect("cartDetail.jsp");
            return;
        }

        // Lấy giỏ hàng từ session, nếu chưa có thì tạo mới
        HttpSession session = request.getSession();
        List<Product> cart = (List<Product>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
        }

        // Kiểm tra nếu sản phẩm đã có trong giỏ hàng, nếu có thì tăng số lượng
        boolean found = false;
        for (Product p : cart) {
            if (p.getProductId() == product.getProductId()) {
                p.setQuantity(p.getQuantity() + 1);  // Tăng số lượng thêm 1
                found = true;
                break;
            }
        }

        // Nếu sản phẩm chưa có trong giỏ hàng, thêm mới và đặt số lượng là 1
        if (!found) {
            product.setQuantity(1);  // Đặt số lượng mặc định là 1 khi thêm mới
            cart.add(product);
        }

        // Lưu giỏ hàng vào session
        session.setAttribute("cart", cart);

        // Sau khi thêm, chuyển hướng (forward) sang trang giỏ hàng để hiển thị
        response.sendRedirect("cartDetail.jsp");
    }
//thay doi o cho nay

     @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("changeQuantity".equals(action)) {
            HttpSession session = request.getSession();
            List<Product> cart = (List<Product>) session.getAttribute("cart");
            if (cart != null) {
                if (cart == null) {
                    cart = new ArrayList<>();
                }

                // Kiểm tra nếu sản phẩm đã có trong giỏ hàng, nếu có thì tăng số lượng
                boolean found = false;
                int id = Integer.parseInt(request.getParameter("id"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                for (Product p : cart) {
                    if (p.getProductId() == id) {
                        p.setQuantity(quantity);  // Tăng số lượng thêm
                        response.getWriter().write("change success");
                        break;
                    }
                }
            }
            return;
        }
        doGet(request, response);
    }
}
