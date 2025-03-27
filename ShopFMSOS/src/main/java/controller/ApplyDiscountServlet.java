package controller;

import dal.DiscountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Discount;
import model.User;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "ApplyDiscountServlet", urlPatterns = {"/ApplyDiscount"})
public class ApplyDiscountServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try (PrintWriter out = response.getWriter()) {
            String discountCode = request.getParameter("discountCode");

            // Kiểm tra mã giảm giá hợp lệ
            DiscountDAO discountDAO = new DiscountDAO();
            Discount discount = discountDAO.getDiscountByCode(discountCode);

            if (discount != null) {
                // Lấy thông tin người dùng từ session
                HttpSession session = request.getSession();
                User user = (User) session.getAttribute("loggedInUser");

                // Lưu mã giảm giá vào bảng orders
                discountDAO.applyDiscountToOrder(user.getId(), discountCode);

                // Kiểm tra xem mã giảm giá đã được lưu vào bảng orders chưa
                if (discountDAO.isDiscountApplied(user.getId(), discountCode)) {
                    out.write("{\"success\": true, \"message\": \"Discount applied successfully!\"}");
                } else {
                    out.write("{\"success\": false, \"message\": \"Failed to apply discount!\"}");
                }
            } else {
                // Nếu mã giảm giá không hợp lệ
                out.write("{\"success\": false, \"message\": \"Invalid discount code!\"}");
            }
        }
    }
}
