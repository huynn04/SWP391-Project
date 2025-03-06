package controller;

import dal.ProductDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.List;
import model.Product;

public class UpdateCartServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();
        
        try {
            // Lấy thông tin sản phẩm và số lượng từ yêu cầu
            String productIdStr = request.getParameter("productId");
            String quantityStr = request.getParameter("quantity");

            // Kiểm tra dữ liệu đầu vào không được null
            if (productIdStr == null || quantityStr == null) {
                out.write("error: invalid_input");
                return;
            }

            int productId = Integer.parseInt(productIdStr);
            int quantity = Integer.parseInt(quantityStr);

            // Kiểm tra số lượng không hợp lệ
            if (quantity <= 0) {
                out.write("error: invalid_quantity");
                return;
            }

            // Lấy giỏ hàng từ session
            HttpSession session = request.getSession();
            List<Product> cart = (List<Product>) session.getAttribute("cart");

            if (cart == null) {
                out.write("error: cart_not_found");
                return;
            }

            // Lấy số lượng tồn kho của sản phẩm từ cơ sở dữ liệu
            ProductDAO productDAO = new ProductDAO();
            int maxQuantity = productDAO.getProductMaxQuantity(productId);

            // Kiểm tra số lượng không vượt quá tồn kho
            if (quantity > maxQuantity) {
                out.write("error: exceed_stock");
                return;
            }

            boolean productUpdated = false;
            BigDecimal totalPrice = BigDecimal.ZERO; // Tính lại tổng giá trị giỏ hàng

            // Duyệt qua giỏ hàng và cập nhật số lượng của sản phẩm
            for (Product p : cart) {
                if (p.getProductId() == productId) {
                    p.setQuantity(quantity);
                    productUpdated = true;
                }
                // Cộng dồn tổng giá trị
                totalPrice = totalPrice.add(p.getPrice().multiply(BigDecimal.valueOf(p.getQuantity())));
            }

            if (!productUpdated) {
                out.write("error: product_not_found");
                return;
            }

            // Lưu giỏ hàng đã cập nhật vào session
            session.setAttribute("cart", cart);
            session.setAttribute("totalPrice", totalPrice); // Lưu tổng giá trị giỏ hàng

            out.write("success");
        } catch (NumberFormatException e) {
            out.write("error: invalid_number_format");
        } catch (Exception e) {
            out.write("error: server_error");
        }
    }
}
