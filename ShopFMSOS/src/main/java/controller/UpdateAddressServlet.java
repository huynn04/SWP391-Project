package controller;

import dal.AddressDAO;
import model.Address;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/update-address")
public class UpdateAddressServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId"); // Lấy userId từ session

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int addressId = Integer.parseInt(request.getParameter("addressId"));
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String city = request.getParameter("city");
        String district = request.getParameter("district");
        String ward = request.getParameter("ward");
        String specificAddress = request.getParameter("specificAddress");
        String addressType = request.getParameter("addressType");
        boolean isDefault = request.getParameter("isDefault") != null;

        Address address = new Address(addressId, userId, fullName, phone, city, district, ward, specificAddress, addressType, isDefault);
        AddressDAO addressDAO = new AddressDAO();

        addressDAO.updateAddress(address);

        if (isDefault) {
            addressDAO.setDefaultAddress(userId, addressId);
        }

        response.sendRedirect("checkout.jsp"); // Chuyển hướng về trang thanh toán hoặc trang quản lý địa chỉ
    }
}
