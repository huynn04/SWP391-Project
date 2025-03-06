package controller;

import dal.AddressDAO;
import model.Address;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/update-address")
public class UpdateAddressServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        Integer userId = (loggedInUser != null) ? loggedInUser.getUserId() : null;

        if (userId == null || userId <= 0) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // Lấy thông tin từ form
            int addressId = parseInteger(request.getParameter("addressId"), 0);
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String city = request.getParameter("city");
            String district = request.getParameter("district");
            String ward = request.getParameter("ward");
            String specificAddress = request.getParameter("specificAddress");
            String addressType = request.getParameter("addressType");

            boolean isDefault = request.getParameter("isDefault") != null;

            // Kiểm tra dữ liệu rỗng
            if (isEmpty(fullName, phone, city, district, ward, specificAddress, addressType)) {
                request.setAttribute("errorMessage", "All fields are required.");
                request.getRequestDispatcher("updateAddress.jsp").forward(request, response);
                return;
            }

            AddressDAO addressDAO = new AddressDAO();

            // Kiểm tra quyền sở hữu địa chỉ
            if (addressId > 0 && !addressDAO.isAddressOwnedByUser(userId, addressId)) {
                request.setAttribute("errorMessage", "You do not have permission to update this address.");
                request.getRequestDispatcher("updateAddress.jsp").forward(request, response);
                return;
            }

            // Kiểm tra địa chỉ trùng lặp
            if (addressDAO.isDuplicateAddress(userId, fullName, phone, city, district, ward, specificAddress, addressType, addressId)) {
                request.setAttribute("errorMessage", "This address already exists.");
                request.getRequestDispatcher("updateAddress.jsp").forward(request, response);
                return;
            }

            // Tạo đối tượng Address và lưu hoặc cập nhật
            Address address = new Address(addressId, userId, fullName, phone, city, district, ward, specificAddress, addressType, isDefault);
            boolean isSuccess = (addressId > 0) ? addressDAO.updateAddress(address) : addressDAO.saveAddress(address);

            if (!isSuccess) {
                request.setAttribute("errorMessage", "Failed to update address. Please try again.");
                request.getRequestDispatcher("updateAddress.jsp").forward(request, response);
                return;
            }

            response.sendRedirect("profile.jsp?updateSuccess=1");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while updating the address.");
            request.getRequestDispatcher("updateAddress.jsp").forward(request, response);
        }
    }

    private boolean isEmpty(String... values) {
        for (String value : values) {
            if (value == null || value.trim().isEmpty()) {
                return true;
            }
        }
        return false;
    }

    private int parseInteger(String value, int defaultValue) {
        try {
            return (value != null && !value.isEmpty()) ? Integer.parseInt(value) : defaultValue;
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
}
