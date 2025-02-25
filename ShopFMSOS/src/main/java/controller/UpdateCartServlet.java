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
import java.util.List;
import model.Product;

/**
 *
 * @author Nguyễn Ngoc Huy CE180178
 */
public class UpdateCartServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy thông tin sản phẩm và số lượng từ yêu cầu
        int productId = Integer.parseInt(request.getParameter("productId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        // Lấy giỏ hàng từ session
        HttpSession session = request.getSession();
        List<Product> cart = (List<Product>) session.getAttribute("cart");

        // Lấy số lượng tồn kho của sản phẩm từ cơ sở dữ liệu
        ProductDAO productDAO = new ProductDAO();
        int maxQuantity = productDAO.getProductMaxQuantity(productId);  // Lấy số lượng tồn kho thực tế

        // Kiểm tra số lượng không vượt quá tồn kho
        if (quantity > maxQuantity) {
            // Nếu số lượng lớn hơn tồn kho, gửi lỗi
            response.getWriter().write("error");
            return;
        }

        if (cart != null && !cart.isEmpty()) {
            // Duyệt qua giỏ hàng và cập nhật số lượng của sản phẩm
            for (Product p : cart) {
                if (p.getProductId() == productId) {
                    // Cập nhật số lượng mới
                    p.setQuantity(quantity);
                    break;
                }
            }

            // Lưu giỏ hàng đã cập nhật vào session
            session.setAttribute("cart", cart);
        }

        // Gửi phản hồi thành công
        response.getWriter().write("success");
    }
}
