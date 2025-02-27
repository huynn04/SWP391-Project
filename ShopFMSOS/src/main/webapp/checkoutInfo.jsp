<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, model.Address" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thông tin thanh toán</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <script>
        function toggleNewAddress() {
            var selectedAddress = document.getElementById("selectedAddress").value;
            document.getElementById("newAddressForm").style.display = (selectedAddress === "new") ? "block" : "none";
        }
    </script>
</head>
<body>
    <%@ include file="header.jsp" %>

    <div class="container mt-5">
        <h2 class="mb-4">Thông tin thanh toán</h2>

        <c:if test="${empty cart}">
            <div class="alert alert-warning">Giỏ hàng của bạn đang trống.</div>
        </c:if>

        <c:if test="${not empty cart}">
            <form action="CheckoutInfoServlet" method="post">
                <h4 class="mb-3">Chọn địa chỉ giao hàng</h4>

                <c:choose>
                    <c:when test="${not empty addressList}">
                        <div class="form-group">
                            <label for="selectedAddress">Chọn địa chỉ</label>
                            <select id="selectedAddress" name="selectedAddress" class="form-control" onchange="toggleNewAddress()">
                                <c:forEach var="addr" items="${addressList}">
                                    <option value="${addr.id}" ${addr.isDefault ? "selected" : ""}>
                                        ${addr.fullName} - ${addr.phone} - ${addr.specificAddress}, ${addr.ward}, ${addr.district}, ${addr.city}
                                    </option>
                                </c:forEach>
                                <option value="new">🆕 Nhập địa chỉ mới</option>
                            </select>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p>🔹 Bạn chưa có địa chỉ nào. Hãy nhập địa chỉ mới bên dưới.</p>
                    </c:otherwise>
                </c:choose>

                <!-- Form nhập địa chỉ mới -->
                <div id="newAddressForm" style="display: none;">
                    <h4 class="mt-4">Nhập địa chỉ mới</h4>

                    <div class="form-group">
                        <label for="fullName">Họ và tên</label>
                        <input type="text" id="fullName" name="fullName" class="form-control" required>
                    </div>

                    <div class="form-group">
                        <label for="phone">Số điện thoại</label>
                        <input type="text" id="phone" name="phone" class="form-control" required>
                    </div>

                    <div class="form-group">
                        <label for="city">Tỉnh/Thành phố</label>
                        <input type="text" id="city" name="city" class="form-control" required>
                    </div>

                    <div class="form-group">
                        <label for="district">Quận/Huyện</label>
                        <input type="text" id="district" name="district" class="form-control" required>
                    </div>

                    <div class="form-group">
                        <label for="ward">Phường/Xã</label>
                        <input type="text" id="ward" name="ward" class="form-control" required>
                    </div>

                    <div class="form-group">
                        <label for="specificAddress">Địa chỉ cụ thể</label>
                        <input type="text" id="specificAddress" name="specificAddress" class="form-control" required>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary mt-3">Xác nhận địa chỉ</button>
            </form>
        </c:if>
    </div>

    <%@ include file="footer.jsp" %>
</body>
</html>
