package controller;

import dal.CartDAO;
import dal.DiscountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Discount;
import model.Cart;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import model.User;

public class ApplyDiscountServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(true);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect("LoginServlet");
            return;
        }
        User user = (User) session.getAttribute("loggedInUser");
        int userId = user.getId();

        try (PrintWriter out = response.getWriter()) {

            String discountCode = request.getParameter("discountCode");
            double currentTotal = Double.parseDouble(request.getParameter("currentTotal"));
            double newPrice;

            if (discountCode == null || discountCode.trim().isEmpty()) {
                out.print("EMPTY_CODE");
                return;
            }

            CartDAO cartDAO = new CartDAO();
            DiscountDAO discountDAO = new DiscountDAO();

            Discount discount = discountDAO.getDiscountByCode(discountCode);
            if (discount == null || discount.getStatus() != 1) {
                // Nếu mã giảm giá không hợp lệ hoặc đã hết hạn, trả về lỗi
                out.print("INVALID_CODE");
                return;
            }

            // Áp dụng giảm giá
            newPrice = currentTotal - (currentTotal * (discount.getDiscountValue() / 100));
            session.setAttribute("totalPrice", newPrice);

            // Cập nhật trạng thái mã giảm giá trong giỏ hàng thành "1" (chưa sử dụng)
            discountDAO.updateDiscountStatus(discountCode, 1);

            // Trả về tổng giá trị mới sau khi áp dụng giảm giá
            out.print(newPrice);

        } catch (Exception e) {
            e.printStackTrace(); // Log lỗi
            response.getWriter().print("ERROR");
        }
    }
}
