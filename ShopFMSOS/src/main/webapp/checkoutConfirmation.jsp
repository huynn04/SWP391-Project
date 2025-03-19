<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Address" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Payment Confirmation</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
    <%@ include file="header.jsp" %>

    <div class="container mt-5">
        <h2 class="mb-4">Payment Confirmation</h2>

        <h4 class="mb-3">Delivery information</h4>
        <c:choose>
            <c:when test="${not empty selectedAddress}">
                <p><strong>Full name:</strong> ${selectedAddress.fullName}</p>
                <p><strong>Phone number:</strong> ${selectedAddress.phone}</p>
                <p><strong>Address:</strong> ${selectedAddress.specificAddress}, ${selectedAddress.ward}, ${selectedAddress.district}, ${selectedAddress.city}</p>
            </c:when>
            <c:otherwise>
                <p class="text-danger">No shipping address.</p>
            </c:otherwise>
        </c:choose>

        <!-- Nút xác nhận đơn hàng -->
        <form action="CheckoutServlet" method="post">
            <input type="hidden" name="fullName" value="${selectedAddress.fullName}">
            <input type="hidden" name="phone" value="${selectedAddress.phone}">
            <input type="hidden" name="specificAddress" value="${selectedAddress.specificAddress}">
            <input type="hidden" name="ward" value="${selectedAddress.ward}">
            <input type="hidden" name="district" value="${selectedAddress.district}">
            <input type="hidden" name="city" value="${selectedAddress.city}">

            <button type="submit" class="btn btn-primary mt-3">Purchase Confirmation</button>
        </form>
    </div>

    <%@ include file="footer.jsp" %>
</body>
</html>
