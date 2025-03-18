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

@WebServlet(name = "ApplyDiscountServlet", urlPatterns = {"/ApplyDiscount"})
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

        // Debug để kiểm tra session có userId không
        try ( PrintWriter out = response.getWriter()) {

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
                out.print("INVALID_CODE");
                return;
            }
            
            newPrice = currentTotal - (currentTotal * (discount.getDiscountValue() / 100));
            session.setAttribute("totalPrice", newPrice);
            System.out.println(newPrice);

            // Trả về số phần trăm hoặc số tiền giảm giá để cập nhật trên giao diện
            out.print(newPrice);
        } catch (Exception e) {
            e.printStackTrace(); // Ghi lỗi vào console server
            response.getWriter().print("ERROR");
        }
        // Lưu mã giảm giá vào giỏ hàng

    }
}
