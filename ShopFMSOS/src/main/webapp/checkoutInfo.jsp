<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, model.Product, model.Address" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Payment information</title>
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
            <h2 class="mb-4">Payment information</h2>
            <c:if test="${empty cart}">
                <div class="alert alert-warning">Your cart is empty.</div>
            </c:if>
            <c:if test="${not empty cart}">
                <!-- Sửa action để gửi đến CheckoutServlet -->
                <form action="Checkout" method="post">
                    <h4 class="mb-3">Products in cart</h4>
                    <table class="table table-bordered text-center">
                        <thead>
                            <tr>
                                <th>Image</th>
                                <th>Product Name</th>
                                <th>Price</th>
                                <th>Quantity</th>
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
                        <h3 style="font-size: 24px; color: #333;">Total price:</h3>
                        <span style="font-size: 24px; font-weight: bold; color: #FF5733; background-color: #F4F4F4; padding: 10px 15px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);">
                            <span>$${requestScope.totalPrice}</span>
                        </span>
                    </div>
                    <h4 class="mb-3">Shipping address</h4>
                    <div class="form-group">
                        <!-- Danh sách địa chỉ hiện có -->
                    </div>
                    <div class="form-group mt-3">
                        <label for="fullName">Full Name</label>
                        <input type="text" id="fullName" name="fullName" class="form-control">
                    </div>
                    <div class="form-group">
                        <label for="phone">Phone number</label>
                        <input type="text" id="phone" name="phone" class="form-control">
                    </div>
                    <div class="form-group">
                        <label for="specificAddress">Specific address</label>
                        <input type="text" id="specificAddress" name="specificAddress" class="form-control">
                    </div>
                    <div class="form-group">
                        <label for="ward">Ward/Commune</label>
                        <input type="text" id="ward" name="ward" class="form-control">
                    </div>
                    <div class="form-group">
                        <label for="district">District</label>
                        <input type="text" id="district" name="district" class="form-control">
                    </div>
                    <div class="form-group">
                        <label for="city">Province/City</label>
                        <input type="text" id="city" name="city" class="form-control">
                    </div>
                    <h4 class="mt-4">Payment method</h4>
                    <div class="form-group">
                        <label for="paymentMethod">Select payment method</label>
                        <select id="paymentMethod" name="paymentMethod" class="form-control" required>
                            <option value="COD">Cash on Delivery</option>
                            <option value="Online">Online Payment</option>
                            <option value="Debit">Debit Payment</option>
                        </select>
                    </div>

                    <!-- Đoạn mã QR sẽ hiển thị nếu chọn Online Payment -->
                    <div id="qrContainer" style="display:none;">
                        <h4 class="mt-3">Scan QR Code for Payment</h4>
                        <img id="qrCodeImage" src="" alt="QR Code">
                        <p id="qrContent"></p>
                    </div>

                    <script src="https://cdn.jsdelivr.net/npm/@zxing/library@0.18.3/dist/index.min.js"></script>
                    <script>
            document.getElementById("paymentMethod").addEventListener("change", function () {
                var qrContainer = document.getElementById("qrContainer");
                var paymentMethod = this.value;
                if (paymentMethod === "Online") {
                    qrContainer.style.display = "block";

                    // Lấy thông tin từ session
                    var totalAmount = ${requestScope.totalPrice}; // Tổng số tiền
                    var userId = "${sessionScope.userId}"; // ID người dùng
                    var userName = "${sessionScope.userName}"; // Tên người dùng

                    // Kiểm tra nếu userName hoặc userId không có giá trị
                    if (!userId || !userName) {
                        alert("User information is missing!");
                        return;
                    }

                    // Nội dung chuyển khoản
                    var qrContent = "Amount: " + totalAmount + ", User: " + userName + ", ID: " + userId;

                    // Hiển thị nội dung chuyển khoản
                    document.getElementById("qrContent").textContent = "Amount: " + totalAmount + ", User: " + userName + ", ID: " + userId;

                    // Tạo mã QR bằng ZXing
                    var codeWriter = new ZXing.BrowserQRCodeSvgWriter();
                    var svg = codeWriter.write(qrContent);
                    document.getElementById("qrCodeImage").src = svg;
                } else {
                    qrContainer.style.display = "none";
                }
            });
                    </script>


                    <button type="submit" class="btn btn-primary mt-3">Purchase Confirmation</button>
                </form>
            </c:if>
        </div>
        <%@ include file="footer.jsp" %>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
