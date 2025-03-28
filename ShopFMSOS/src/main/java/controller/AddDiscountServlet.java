package controller;

import dal.DiscountDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Discount;

import java.io.IOException;
import java.text.SimpleDateFormat;

/**
 * Servlet for handling the addition of a new Discount using Post-Redirect-Get (PRG).
 */
public class AddDiscountServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handles GET requests:
     * - Loads AddDiscount.jsp.
     * - If there's a "success" message in session, moves it to request so JSP can display, then removes it.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if there's a success message stored in session
        Object successMessage = request.getSession().getAttribute("success");
        if (successMessage != null) {
            // Put success message into request so the JSP can display it
            request.setAttribute("success", successMessage);
            // Remove it from session so it won't persist
            request.getSession().removeAttribute("success");
        }

        // Forward to AddDiscount.jsp
        RequestDispatcher dispatcher = request.getRequestDispatcher("/AddDiscount.jsp");
        dispatcher.forward(request, response);
    }

    /**
     * Handles POST requests (when user submits the "Add Discount" form).
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 0) Kiểm tra xem user có thực sự ấn nút submit form hay không
        String action = request.getParameter("action");
        // Nếu form của bạn dùng button name="action" value="submitForm", ví dụ.
        if (action == null || !action.equals("submitForm")) {
            // Người dùng chưa bấm nút "Add Discount" hoặc request không đúng
            // => Quay lại trang AddDiscount qua GET, không hiển thị lỗi
            response.sendRedirect("AddDiscount");
            return;
        }

        // Từ đây trở xuống, chắc chắn user đã bấm "Add Discount"
        String errorMsg = null;
        boolean isAdded = false;

        // 1) Lấy tham số form
        String code = request.getParameter("code");
        String discountValueStr = request.getParameter("discountValue");
        String discountType = request.getParameter("discountType");
        String minOrderValueStr = request.getParameter("minOrderValue");
        String expiryDateStr = request.getParameter("expiryDate");
        String statusStr = request.getParameter("status");

        // 2) Validate discountValue
        int discountValue = 0;
        try {
            discountValue = Integer.parseInt(discountValueStr);
            if (discountValue < 1 || discountValue > 100) {
                errorMsg = "Discount value must be an integer between 1 and 100.";
            }
        } catch (NumberFormatException e) {
            errorMsg = "Invalid discount value.";
        }

        // 3) Validate minOrderValue
        int minOrderValue = 0;
        try {
            minOrderValue = Integer.parseInt(minOrderValueStr);
            if (minOrderValue <= 0) {
                errorMsg = "Minimum order value must be a positive integer.";
            }
        } catch (NumberFormatException e) {
            errorMsg = "Invalid minimum order value.";
        }

        // 4) Validate discountType
        if (discountType == null
                || (!discountType.equals("percent") && !discountType.equals("fixed"))) {
            errorMsg = "Discount type must be 'percent' or 'fixed'.";
        }

        // 5) Validate status
        int status = 1;
        try {
            status = Integer.parseInt(statusStr);
        } catch (NumberFormatException e) {
            errorMsg = "Invalid status.";
        }

        // 6) Validate expiryDate
        java.sql.Date expiryDate = null;
        if (expiryDateStr != null && !expiryDateStr.trim().isEmpty()) {
            try {
                java.util.Date utilDate = new SimpleDateFormat("yyyy-MM-dd")
                        .parse(expiryDateStr);
                expiryDate = new java.sql.Date(utilDate.getTime());
            } catch (Exception e) {
                errorMsg = "Invalid expiry date format.";
            }
        } else {
            errorMsg = "Expiry date is required.";
        }

        // Nếu có lỗi => forward về JSP cùng errorMsg
        if (errorMsg != null) {
            request.setAttribute("error", errorMsg);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/AddDiscount.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // 7) Tạo đối tượng Discount
        Discount discount = new Discount(code, discountValue, discountType,
                                         minOrderValue, expiryDate, status);

        // 8) Gọi DAO để thêm
        DiscountDAO discountDAO = new DiscountDAO();
        isAdded = discountDAO.addDiscount(discount);

        // 9) Kiểm tra kết quả
        if (isAdded) {
            // Thành công => Lưu success message vào session => redirect (PRG)
            request.getSession().setAttribute("success", "Discount added successfully!");
            response.sendRedirect("AddDiscount"); 
        } else {
            // Thêm thất bại => hiển thị lỗi
            request.setAttribute("error", "Failed to add discount.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/AddDiscount.jsp");
            dispatcher.forward(request, response);
        }
    }
}
