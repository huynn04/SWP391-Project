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
        <h2 class="mb-4 text-center">📦 Thông tin thanh toán</h2>

        <c:if test="${empty cart}">
            <div class="alert alert-warning text-center">🛒 Giỏ hàng của bạn đang trống.</div>
        </c:if>

        <c:if test="${not empty cart}">
            <form action="CheckoutInfoServlet" method="post">
                <div class="card p-4 shadow">
                    <h4 class="mb-3">📍 Chọn địa chỉ giao hàng</h4>

                    <c:choose>
                        <c:when test="${not empty addressList}">
                            <div class="mb-3">
                                <label for="selectedAddress" class="form-label">Địa chỉ hiện có</label>
                                <select id="selectedAddress" name="selectedAddress" class="form-select" onchange="toggleNewAddress()">
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
                            <div class="alert alert-info">🔹 Bạn chưa có địa chỉ nào. Hãy nhập địa chỉ mới bên dưới.</div>
                        </c:otherwise>
                    </c:choose>

                    <!-- Form nhập địa chỉ mới -->
                    <div id="newAddressForm" class="mt-4 p-3 bg-light border rounded" style="display: none;">
                        <h5>📌 Nhập địa chỉ mới</h5>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="fullName" class="form-label">Họ và tên</label>
                                <input type="text" id="fullName" name="fullName" class="form-control" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="phone" class="form-label">Số điện thoại</label>
                                <input type="text" id="phone" name="phone" class="form-control" required>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <label for="city" class="form-label">Tỉnh/Thành phố</label>
                                <input type="text" id="city" name="city" class="form-control" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label for="district" class="form-label">Quận/Huyện</label>
                                <input type="text" id="district" name="district" class="form-control" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label for="ward" class="form-label">Phường/Xã</label>
                                <input type="text" id="ward" name="ward" class="form-control" required>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="specificAddress" class="form-label">Địa chỉ cụ thể</label>
                            <input type="text" id="specificAddress" name="specificAddress" class="form-control" required>
                        </div>
                    </div>

                    <div class="text-center mt-4">
                        <button type="submit" class="btn btn-success px-4">✅ Xác nhận địa chỉ</button>
                    </div>
                </div>
            </form>
        </c:if>
    </div>

    <%@ include file="footer.jsp" %>
</body>
</html>
