
import dal.CartDAO;
import dal.DiscountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import model.Cart;
import model.Discount;

@WebServlet(name = "ApplyDiscountServlet", urlPatterns = {"/ApplyDiscount"})
public class ApplyDiscountServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String discountCode = request.getParameter("discountCode").trim();
        
        if (discountCode.isEmpty()) {
            session.setAttribute("error", "Vui lòng nhập mã giảm giá.");
            response.sendRedirect("cartDetail.jsp");
            return;
        }

        CartDAO cartDAO = new CartDAO();
        DiscountDAO discountDAO = new DiscountDAO();

        Cart cart = cartDAO.getCartByUserId(userId);
        BigDecimal totalPrice = cartDAO.getTotalPrice(cart.getCartId());

        if (cart == null || totalPrice.compareTo(BigDecimal.ZERO) == 0) {
            session.setAttribute("error", "Giỏ hàng của bạn đang trống!");
            response.sendRedirect("cartDetail.jsp");
            return;
        }

        Discount discount = discountDAO.getDiscountByCode(discountCode);
        if (discount == null || discount.getStatus() != 1) {
            session.setAttribute("error", "Mã giảm giá không hợp lệ hoặc đã hết hạn.");
            response.sendRedirect("cartDetail.jsp");
            return;
        }

        // Kiểm tra đơn hàng tối thiểu
        if (totalPrice.compareTo(BigDecimal.valueOf(discount.getMinOrderValue())) < 0) {
            session.setAttribute("error", "Mã giảm giá chỉ áp dụng cho đơn hàng trên $" + discount.getMinOrderValue());
            response.sendRedirect("cartDetail.jsp");
            return;
        }

        // Áp dụng giảm giá
        BigDecimal discountAmount;
        if ("percent".equalsIgnoreCase(discount.getDiscountType())) {
            discountAmount = totalPrice.multiply(BigDecimal.valueOf(discount.getDiscountValue())).divide(BigDecimal.valueOf(100));
        } else {
            discountAmount = BigDecimal.valueOf(discount.getDiscountValue());
        }

        BigDecimal newTotal = totalPrice.subtract(discountAmount);
        if (newTotal.compareTo(BigDecimal.ZERO) < 0) {
            newTotal = BigDecimal.ZERO; // Đảm bảo tổng tiền không âm
        }

        session.setAttribute("totalPrice", newTotal);
        session.setAttribute("discountCode", discountCode);
        session.setAttribute("success", "Mã giảm giá đã được áp dụng!");

        response.sendRedirect("cartDetail.jsp");
    }
}
