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
                document.getElementById("paymentMethod").addEventListener("change", function () {
                    var onlinePaymentInfo = document.getElementById("onlinePaymentInfo");
                    // Kiểm tra nếu lựa chọn là "Online", hiển thị phần thông tin chuyển khoản
                    if (this.value === "Online") {
                        onlinePaymentInfo.style.display = "block";
                    } else {
                        onlinePaymentInfo.style.display = "none";
                    }
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
                <form action="Checkout" method="post" id="checkoutForm">
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
                    <% if (request.getAttribute("errorMessage") != null) { %>
                    <div class="alert alert-danger mt-3" role="alert">
                        <%= request.getAttribute("errorMessage") %>
                    </div>
                    <% } %>

                    <div class="form-group">
                        <!-- Danh sách địa chỉ hiện có -->
                    </div>
                    <div class="form-group mt-3">
                        <label for="fullName">Full Name</label>
                        <input type="text" id="fullName" name="fullName" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label for="phone">Phone number</label>
                        <input type="text" id="phone" name="phone" class="form-control" required pattern="\d{10}">
                    </div>
                    <div class="form-group">
                        <label for="specificAddress">Specific address</label>
                        <input type="text" id="specificAddress" name="specificAddress" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label for="ward">Ward/Commune</label>
                        <input type="text" id="ward" name="ward" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label for="district">District</label>
                        <input type="text" id="district" name="district" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label for="city">Province/City</label>
                        <input type="text" id="city" name="city" class="form-control" required>
                    </div>
                    <h4 class="mt-4">Payment method</h4>
                    <div class="form-group">
                        <label for="paymentMethod">Select payment method</label>
                        <select id="paymentMethod" name="paymentMethod" class="form-control" required>
                            <option value="COD">Cash on Delivery</option>
                            <option value="Online">Online Payment</option>
                            <option value="Ghino">Debit payment</option>
                        </select>
                    </div>

                    <!-- Online Payment Information (Mặc định ẩn) -->
                    <div id="onlinePaymentInfo" style="display:none;" class="mt-4 p-3 border rounded bg-light">
                        <h5>Online Payment Information</h5>
                        <p><strong>Amount:</strong> $${requestScope.totalPrice}</p>
                        <p><strong>Transfer Note:</strong> <%= loggedInUser.getFullName() + " " + loggedInUser.getId() %></p>
                        <img src="image/98cc3294e4bf54e10dae.jpg" alt="Bank QR" style="max-width: 300px;" class="img-fluid mt-2">
                    </div>

                    <button type="submit" class="btn btn-primary mt-3">Purchase Confirmation</button>
                </form>
                <script>
                    document.addEventListener("DOMContentLoaded", function () {
                        document.getElementById("checkoutForm").addEventListener("submit", function (event) {
                            let fullName = document.getElementById("fullName").value;
                            let phone = document.getElementById("phone").value;
                            let city = document.getElementById("city").value;
                            let district = document.getElementById("district").value;
                            let ward = document.getElementById("ward").value;
                            let specificAddress = document.getElementById("specificAddress").value;

                            // Check if the user has filled in all shipping address fields
                            if (!fullName || !phone || !city || !district || !ward || !specificAddress) {
                                alert("Please fill out all shipping address fields.");
                                event.preventDefault(); // Prevent form submission
                            }

                            // Check if the phone number is valid
                            if (phone && !phone.match(/^\d{10}$/)) {
                                alert("Please enter a valid phone number with exactly 10 digits.");
                                event.preventDefault(); // Prevent form submission
                            }
                        });
                    });
                </script>


            </c:if>
        </div>
        <%@ include file="footer.jsp" %>

    </body>

</html>
