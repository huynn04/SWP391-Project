package controller;

import dal.AddressDAO;
import dal.CartDAO;
import dal.ProductDAO;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Address;
import model.Product;
import model.User;

@WebServlet("/CheckoutInfoServlet")
public class CheckoutInfoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user"); // Lấy user từ session

        // Lấy giỏ hàng từ session
        List<Product> cart = (List<Product>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect("cartDetail.jsp");
            return;
        }

        // Tính tổng tiền
        double totalPrice = (double) session.getAttribute("totalPrice");

        List<Address> addressList = null;

        // Nếu đăng nhập, lấy địa chỉ từ database
        if (user != null) {
            AddressDAO addressDAO = new AddressDAO();
            addressList = addressDAO.getAddressesByUserId(user.getUserId());
        }

        // Đưa dữ liệu vào request
        request.setAttribute("cart", cart);
        request.setAttribute("totalPrice", totalPrice);
        request.setAttribute("addressList", addressList);

        request.getRequestDispatcher("checkoutInfo.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        int userId = (user != null) ? user.getUserId() : 0;

        // Lấy thông tin địa chỉ từ form
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String city = request.getParameter("city");
        String district = request.getParameter("district");
        String ward = request.getParameter("ward");
        String specificAddress = request.getParameter("specificAddress");
        String addressType = request.getParameter("addressType");

        if (fullName == null || phone == null || city == null || district == null || ward == null ||
                specificAddress == null || addressType == null ||
                fullName.isEmpty() || phone.isEmpty() || city.isEmpty() || district.isEmpty() ||
                ward.isEmpty() || specificAddress.isEmpty() || addressType.isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin!");
            doGet(request, response);
            return;
        }

        // Nếu đăng nhập, lưu địa chỉ vào database
        if (user != null) {
            Address newAddress = new Address(0, userId, fullName, phone, city, district, ward, specificAddress, addressType, false);
            AddressDAO addressDAO = new AddressDAO();
            addressDAO.saveAddress(newAddress);
        }

        // Cập nhật số lượng sản phẩm trong kho
        ProductDAO productDAO = new ProductDAO();
        List<Product> cart = (List<Product>) session.getAttribute("cart");

        if (cart != null) {
            for (Product product : cart) {
                productDAO.updateProductStock(product.getProductId(), product.getQuantity());
            }
        }

        // Xóa giỏ hàng khỏi database
        CartDAO cartDAO = new CartDAO();
        if (user != null) {
            cartDAO.clearCart(user.getUserId());
        }

        // Xóa giỏ hàng trong session
        session.removeAttribute("cart");

        // Chuyển hướng đến trang thông báo
        response.sendRedirect("thongbao.jsp");
    }
}
