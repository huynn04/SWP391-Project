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

            // Tạo đối tượng Address và lưu vào bảng addresses
            Address address = new Address(0, userId, fullName, phone, city, district, ward, specificAddress, addressType, isDefault);
            AddressDAO addressDAO = new AddressDAO();
            boolean isAddressSaved = addressDAO.saveAddress(address);  // Lưu vào DB

            if (!isAddressSaved) {
                request.setAttribute("errorMessage", "Failed to save address. Please try again.");
                request.getRequestDispatcher("updateAddress.jsp").forward(request, response);
                return;
            }

            // Cập nhật thông tin địa chỉ vào bảng users với đầy đủ thông tin
            String fullAddress = city + ", " + district + ", " + ward + ", " + specificAddress;
            boolean isUserAddressUpdated = addressDAO.updateUserAddress(userId, phone, fullAddress);  // Cập nhật thông tin người dùng

            if (!isUserAddressUpdated) {
                request.setAttribute("errorMessage", "Failed to update address in user profile.");
                request.getRequestDispatcher("updateAddress.jsp").forward(request, response);
                return;
            }

            // Cập nhật nếu người dùng chọn địa chỉ mặc định (nếu cần)
            if (isDefault) {
                addressDAO.setAllOtherAddressesToNonDefault(userId); // Đảm bảo chỉ có một địa chỉ mặc định
            }

            response.sendRedirect("profile.jsp?updateSuccess=1");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while updating the address.");
            request.getRequestDispatcher("updateAddress.jsp").forward(request, response);
        }
    }

    // Kiểm tra dữ liệu rỗng
    private boolean isEmpty(String... values) {
        for (String value : values) {
            if (value == null || value.trim().isEmpty()) {
                return true;
            }
        }
        return false;
    }
}
