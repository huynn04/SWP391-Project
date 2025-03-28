package controller;

import dal.DiscountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class DeleteDiscountServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Xóa discount qua discountId (GET).
     * Link ví dụ: DeleteDiscount?id=5
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1) Lấy "id" từ query string
        String idStr = request.getParameter("id");
        int discountId = 0;
        try {
            discountId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            // Nếu id không hợp lệ => chuyển về ManageDiscount
            request.getSession().setAttribute("error", "Invalid discount ID.");
            response.sendRedirect("ManageDiscount");
            return;
        }

        // 2) Gọi DAO để xóa
        DiscountDAO discountDAO = new DiscountDAO();
        boolean deleted = discountDAO.deleteDiscount(discountId);

        // 3) Kiểm tra kết quả
        if (deleted) {
            // Nếu xóa thành công => ghi success message
            request.getSession().setAttribute("success", "Discount deleted successfully!");
        } else {
            // Nếu xóa thất bại => ghi error message
            request.getSession().setAttribute("error", "Failed to delete discount.");
        }

        // 4) Quay lại trang ManageDiscount
        response.sendRedirect("ManageDiscount");
    }
}
