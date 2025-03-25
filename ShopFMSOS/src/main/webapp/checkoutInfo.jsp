<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, model.Product, model.Address" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Payment Information</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                // Hiện form địa chỉ mới khi chọn "new"
                document.getElementById("selectedAddress")?.addEventListener("change", function () {
                    document.getElementById("newAddressForm").style.display = (this.value === "new") ? "block" : "none";
                });

                // Kiểm tra lỗi form
                document.getElementById("checkoutForm").addEventListener("submit", function (event) {
                    const requiredFields = ["fullName", "phone", "specificAddress", "ward", "district", "city"];
                    let isValid = true;

                    const validatePhone = (phone) => /^\d{10,11}$/.test(phone);
                    const validateText = (text) => /^[a-zA-ZÀ-ỹ0-9\s]+$/.test(text);
                    const validateQuantity = (quantity) => /^\d+$/.test(quantity) && parseInt(quantity, 10) > 0;

                    requiredFields.forEach(function (fieldId) {
                        const field = document.getElementById(fieldId);
                        const errorSpan = document.getElementById(fieldId + "Error");
                        const value = field.value.trim();

                        if (!value) {
                            errorSpan.textContent = "This field is required.";
                            isValid = false;
                        } else {
                            if (fieldId === "phone" && !validatePhone(value)) {
                                errorSpan.textContent = "Phone number must be 10-11 digits.";
                                isValid = false;
                            } else if (["fullName", "ward", "district", "city"].includes(fieldId) && !validateText(value)) {
                                errorSpan.textContent = "Invalid characters are not allowed.";
                                isValid = false;
                            } else if (fieldId === "fullName" && value.length < 3) {
                                errorSpan.textContent = "Full name must be at least 3 characters.";
                                isValid = false;
                            } else if (fieldId === "specificAddress" && value.length < 10) {
                                errorSpan.textContent = "Address must be at least 10 characters.";
                                isValid = false;
                            } else {
                                errorSpan.textContent = "";
                            }
                        }
                    });

                    document.querySelectorAll("input[name^='quantity_']").forEach(function (input) {
                        const errorSpan = document.createElement("span");
                        errorSpan.className = "text-danger";
                        input.parentNode.appendChild(errorSpan);

                        if (!validateQuantity(input.value)) {
                            errorSpan.textContent = "Quantity must be a positive number.";
                            isValid = false;
                        } else {
                            errorSpan.textContent = "";
                        }
                    });

                    if (!isValid) {
                        event.preventDefault();
                    }
                });
            });
        </script>
    </head>
    <body>
        <%@ include file="header.jsp" %>
        <div class="container mt-5">
            <h2 class="mb-4">Payment Information</h2>

            <c:if test="${empty cart}">
                <div class="alert alert-warning">Your cart is empty.</div>
            </c:if>

            <c:if test="${not empty cart}">
                <form id="checkoutForm" action="Checkout" method="post">
                    <h4 class="mb-3">Products in Cart</h4>
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

                    <h4 class="mb-3">Shipping Address</h4>
                    <div class="form-group">
                        <label for="fullName">Full Name</label>
                        <input type="text" id="fullName" name="fullName" class="form-control" value="${param.fullName}">
                        <span id="fullNameError" class="text-danger"></span>
                    </div>

                    <div class="form-group mt-3">
                        <label for="phone">Phone Number</label>
                        <input type="text" id="phone" name="phone" class="form-control" value="${param.phone}">
                        <span id="phoneError" class="text-danger"></span>
                    </div>

                    <div class="form-group mt-3">
                        <label for="specificAddress">Specific Address</label>
                        <input type="text" id="specificAddress" name="specificAddress" class="form-control" value="${param.specificAddress}">
                        <span id="specificAddressError" class="text-danger"></span>
                    </div>

                    <h4 class="mt-4">Payment Method</h4>
                    <div class="form-group">
                        <label for="paymentMethod">Select Payment Method</label>
                        <select id="paymentMethod" name="paymentMethod" class="form-control" required>
                            <option value="COD">Cash on Delivery</option>
                            <option value="Online">Online Payment</option>
                            <option value="Ghino">Debit Payment</option>
                        </select>
                    </div>

                    <button type="submit" class="btn btn-primary mt-4">Purchase Confirmation</button>
                </form>
            </c:if>
        </div>

        <%@ include file="footer.jsp" %>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
