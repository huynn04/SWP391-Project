<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, model.Product, model.Address" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Thông tin thanh toán</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                document.getElementById("selectedAddress").addEventListener("change", function () {
                    var newAddressForm = document.getElementById("newAddressForm");
                    newAddressForm.style.display = (this.value === "new") ? "block" : "none";
                });
            });
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
                <!-- Sửa action để gửi đến CheckoutServlet -->
                <form action="Checkout" method="post">
                    <h4 class="mb-3">Sản phẩm trong giỏ hàng</h4>
                    <table class="table table-bordered text-center">
                        <thead>
                            <tr>
                                <th>Ảnh</th>
                                <th>Tên sản phẩm</th>
                                <th>Giá</th>
                                <th>Số lượng</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${cart}">
                                <tr>
                                    <td><img src="${p.image}" width="50"></td>
                                    <td>${p.productName}</td>
                                    <td>$${p.price}</td>
                                    <td><input readonly type="number" name="quantity_${p.productId}" value="${p.quantity}" min="1" class="form-control text-center"></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    <div style="display: flex; justify-content: space-between">
                        <h3>Toong gia:</h3>
                        <span>${requestScope.totalPrice}</span>
                    </div>
                    <h4 class="mb-3">Địa chỉ giao hàng</h4>
                    <div class="form-group">
                        <!-- Danh sách địa chỉ hiện có -->
                        <select id="selectedAddress" name="selectedAddress" class="form-control">
                            <c:forEach var="addr" items="${addressList}">
                                <option value="${addr.id}" ${addr.isDefault ? "selected" : ""}>
                                    ${addr.fullName} - ${addr.phone} - ${addr.specificAddress}, ${addr.ward}, ${addr.district}, ${addr.city}
                                </option>
                            </c:forEach>
                            <option value="new"> ★ Nhập địa chỉ </option>
                        </select>
                    </div>
                    <div class="form-group mt-3">
                        <label for="fullName">Họ và tên</label>
                        <input type="text" id="fullName" name="fullName" class="form-control">
                    </div>
                    <div class="form-group">
                        <label for="phone">Số điện thoại</label>
                        <input type="text" id="phone" name="phone" class="form-control">
                    </div>
                    <div class="form-group">
                        <label for="specificAddress">Địa chỉ cụ thể</label>
                        <input type="text" id="specificAddress" name="specificAddress" class="form-control">
                    </div>
                    <div class="form-group">
                        <label for="ward">Phường/Xã</label>
                        <input type="text" id="ward" name="ward" class="form-control">
                    </div>
                    <div class="form-group">
                        <label for="district">Quận/Huyện</label>
                        <input type="text" id="district" name="district" class="form-control">
                    </div>
                    <div class="form-group">
                        <label for="city">Tỉnh/Thành phố</label>
                        <input type="text" id="city" name="city" class="form-control">
                    </div>
                    <h4 class="mt-4">Phương thức thanh toán</h4>
                    <div class="form-group">
                        <label for="paymentMethod">Chọn phương thức thanh toán</label>
                        <select id="paymentMethod" name="paymentMethod" class="form-control" required>
                            <option value="COD">Thanh toán khi nhận hàng</option>
                            <option value="Online">Thanh toán trực tuyến</option>
                            <option value="Ghino">Thanh toán ghi nợ</option>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-primary mt-3">Xác nhận mua hàng</button>
                </form>
            </c:if>
        </div>
        <%@ include file="footer.jsp" %>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        
    </body>

</html>
