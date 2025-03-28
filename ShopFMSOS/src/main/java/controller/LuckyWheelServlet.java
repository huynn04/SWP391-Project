package controller;

import dal.DiscountDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Discount;
import java.util.Random;

public class LuckyWheelServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        Integer spins = (Integer) session.getAttribute("spins");
        if (spins == null) {
            spins = 0;
        }
        session.setAttribute("spins", spins);
        request.getRequestDispatcher("luckyWheel.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Kiểm tra đăng nhập
        if (session.getAttribute("user") == null) {
            response.setContentType("text/plain;charset=UTF-8");
            response.getWriter().write("Please log in to spin!");
            return;
        }

        // Tăng số lần quay
        Integer spins = (Integer) session.getAttribute("spins");
        spins = (spins == null) ? 1 : spins + 1;
        session.setAttribute("spins", spins);

        // Quyết định ngẫu nhiên xem có thắng không (70% cơ hội thắng, 30% thua)
        Random rand = new Random();
        boolean isWinner = rand.nextInt(100) < 70; // 70% cơ hội thắng
        String couponCode = "";

        if (isWinner) {
            couponCode = generateCouponCode();
            if (couponCode == null || couponCode.isEmpty()) {
                System.out.println("Error: Coupon code is null or empty! Using fallback code.");
                couponCode = "TESTCODE123"; // Mã cứng để kiểm tra
            }
            System.out.println("Generated coupon code: " + couponCode);

            // Lưu vào cơ sở dữ liệu
            try {
                DiscountDAO discountDAO = new DiscountDAO();
                Discount discount = new Discount(0, couponCode, 10.0, "percent", 0.0, java.sql.Date.valueOf("2025-12-31"), 1);
                discountDAO.insertDiscount(discount);
                System.out.println("Coupon code inserted into database: " + couponCode);
            } catch (Exception e) {
                System.out.println("Error inserting into database: " + e.getMessage());
            }

            // Lưu mã giảm giá vào session
            session.setAttribute("couponCode", couponCode);
            System.out.println("Coupon code saved to session: " + session.getAttribute("couponCode"));
        } else {
            System.out.println("Better luck next time"); // In thông báo khi không thắng
        }

        // Trả về mã giảm giá (hoặc thông báo "Better luck next time" nếu không thắng) cho AJAX
        response.setContentType("text/plain;charset=UTF-8");
        response.getWriter().write(couponCode != null ? couponCode : "Better luck next time");
        System.out.println("Response sent to AJAX: " + (couponCode != null ? couponCode : "Better luck next time"));
    }

    private String generateCouponCode() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        StringBuilder coupon = new StringBuilder();
        Random rand = new Random();
        DiscountDAO discountDAO = new DiscountDAO();
        String code;

        try {
            // Kiểm tra mã cho đến khi nó không trùng trong cơ sở dữ liệu
            do {
                coupon.setLength(0);
                for (int i = 0; i < 8; i++) {
                    coupon.append(chars.charAt(rand.nextInt(chars.length())));
                }
                code = coupon.toString();
            } while (discountDAO.getDiscountByCode(code) != null);

            System.out.println("Generated code in generateCouponCode: " + code);
            return code;
        } catch (Exception e) {
            System.out.println("Error in generateCouponCode: " + e.getMessage());
            return null;
        }
    }
}
