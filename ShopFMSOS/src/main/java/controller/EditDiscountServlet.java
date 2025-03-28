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
 * Servlet để xử lý việc edit (cập nhật) một Discount.
 */
public class EditDiscountServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // GET: Khi user nhấn link Edit => ?id=xxx, sẽ tới doGet để hiển thị form sửa
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy "id" từ tham số URL, ví dụ: EditDiscount?id=5
        String idStr = request.getParameter("id");
        if (idStr == null) {
            // Nếu không có id, chuyển về trang ManageDiscount (hoặc báo lỗi)
            response.sendRedirect("ManageDiscount");
            return;
        }

        int discountId = 0;
        try {
            discountId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            // ID không hợp lệ => quay lại trang quản lý
            response.sendRedirect("ManageDiscount");
            return;
        }

        // Gọi DAO lấy Discount
        DiscountDAO discountDAO = new DiscountDAO();
        Discount discount = discountDAO.getDiscountById(discountId);
        if (discount == null) {
            // Nếu không tìm thấy Discount => quay lại trang quản lý
            response.sendRedirect("ManageDiscount");
            return;
        }

        // Đưa discount vào request để EditDiscount.jsp hiển thị
        request.setAttribute("discount", discount);

        // Forward sang trang EditDiscount.jsp
        RequestDispatcher dispatcher = request.getRequestDispatcher("/EditDiscount.jsp");
        dispatcher.forward(request, response);
    }

    // POST: Khi người dùng submit form "Update Discount"
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Biến báo lỗi
        String errorMsg = null;

        // 1) Lấy id (hidden input) từ form
        String idStr = request.getParameter("discountId");
        int discountId = 0;
        try {
            discountId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            errorMsg = "Invalid discount ID.";
        }

        // 2) Lấy các field khác từ form
        String code = request.getParameter("code");
        String discountValueStr = request.getParameter("discountValue");
        String discountType = request.getParameter("discountType");
        String minOrderValueStr = request.getParameter("minOrderValue");
        String expiryDateStr = request.getParameter("expiryDate");
        String statusStr = request.getParameter("status");

        // 3) Validate từng field
        // discountValue: phải là số >=1 <=100
        double discountValue = 0;
        try {
            discountValue = Double.parseDouble(discountValueStr);
            if (discountValue < 1 || discountValue > 100) {
                errorMsg = "Discount value must be between 1 and 100.";
            }
        } catch (NumberFormatException e) {
            errorMsg = "Invalid discount value.";
        }

        // minOrderValue: phải >= 0
        double minOrderValue = 0;
        try {
            minOrderValue = Double.parseDouble(minOrderValueStr);
            if (minOrderValue < 0) {
                errorMsg = "Minimum order value must be >= 0.";
            }
        } catch (NumberFormatException e) {
            errorMsg = "Invalid minimum order value.";
        }

        // discountType: "percent" hoặc "fixed"
        if (discountType == null
            || (!discountType.equals("percent") && !discountType.equals("fixed"))) {
            errorMsg = "Discount type must be 'percent' or 'fixed'.";
        }

        // status: 0 hoặc 1
        int status = 1;
        try {
            status = Integer.parseInt(statusStr);
        } catch (NumberFormatException e) {
            errorMsg = "Invalid status.";
        }

        // expiryDate: cần parse "yyyy-MM-dd"
        java.sql.Date expiryDate = null;
        if (expiryDateStr != null && !expiryDateStr.trim().isEmpty()) {
            try {
                java.util.Date utilDate = new SimpleDateFormat("yyyy-MM-dd").parse(expiryDateStr);
                expiryDate = new java.sql.Date(utilDate.getTime());
            } catch (Exception e) {
                errorMsg = "Invalid expiry date format.";
            }
        } else {
            errorMsg = "Expiry date is required.";
        }

        // 4) Nếu có lỗi => forward lại EditDiscount.jsp kèm thông tin cũ
        if (errorMsg != null) {
            request.setAttribute("error", errorMsg);

            // Tạo Discount tạm để hiện lại các giá trị user vừa nhập
            Discount tempDiscount = new Discount(
                    discountId,
                    code,
                    discountValue,
                    discountType,
                    minOrderValue,
                    expiryDate,
                    status
            );
            request.setAttribute("discount", tempDiscount);

            RequestDispatcher dispatcher = request.getRequestDispatcher("/EditDiscount.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // 5) Tạo discount với dữ liệu mới
        Discount updatedDiscount = new Discount(
                discountId,
                code,
                discountValue,
                discountType,
                minOrderValue,
                expiryDate,
                status
        );

        // 6) Gọi DAO update
        DiscountDAO discountDAO = new DiscountDAO();
        boolean isUpdated = discountDAO.updateDiscount(updatedDiscount);

        if (isUpdated) {
            // 7) Thành công => quay về trang ManageDiscount + có thể show success
            // (ở đây ta set 1 session message, hoặc param, tùy ý)
            request.getSession().setAttribute("success", "Discount updated successfully!");
            response.sendRedirect("ManageDiscount");
        } else {
            // 8) Thất bại => báo lỗi
            request.setAttribute("error", "Failed to update discount.");
            request.setAttribute("discount", updatedDiscount);

            RequestDispatcher dispatcher = request.getRequestDispatcher("/EditDiscount.jsp");
            dispatcher.forward(request, response);
        }
    }
}
