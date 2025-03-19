<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, model.Product, java.math.BigDecimal" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Your Shopping Cart</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    </head>
    <body>
        <%@ include file="header.jsp" %>
        <div class="container mt-5">
            <h2 class="mb-4">Your Shopping Cart</h2>
            <%
                List<Product> cart = (List<Product>) session.getAttribute("cart");
                Object totalPriceObj = session.getAttribute("totalPrice");
                double totalPrice = (totalPriceObj != null) ? (double) totalPriceObj : 0;
                if (cart != null && !cart.isEmpty()) {
            %>
            <table class="table table-bordered">
                <thead class="table-dark">
                    <tr>
                        <th>Image</th>
                        <th>Product Name</th>
                        <th>Price</th>
                        <th>Quantity</th>
                        <th>Total</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (Product p : cart) {
                    %>
                    <tr class="cart-item">
                        <td class="text-center">
                            <% if (p.getImage() != null && !p.getImage().trim().isEmpty()) {%>
                            <img src="<%= p.getImage()%>" alt="<%= p.getProductName()%>" width="100">
                            <% } else { %>
                            <img src="images/no-image.png" alt="No Image" width="100">
                            <% }%>
                        </td>
                        <td><%= p.getProductName()%></td>
                        <td class="item-price">$<%= String.format("%.3f", p.getPrice().doubleValue())%></td>
                        <td>
                            <input onchange="changeQuantity(this, <%= p.getProductId()%>)" type="number" class="quantity-input form-control text-center" data-product-id="<%= p.getProductId()%>" 
                                   data-max-quantity="<%= p.getQuantity()%>" value="<%= p.getQuantity()%>" min="1" style="width: 80px;">
                        </td>
                        <td class="item-total">$<%= String.format("%.3f", p.getPrice().doubleValue() * p.getQuantity())%></td>
                        <td class="text-center">
                            <a href="RemoveFromCart?productId=<%= p.getProductId()%>" class="btn btn-danger btn-sm">Remove</a>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
            <form onsubmit="doDiscount(event)" class="mb-3">
                <label for="discountCode">Enter Discount Code:</label>
                <input type="text" name="discountCode" id="discountCode" class="form-control w-50 d-inline">
                <button type="submit" class="btn btn-primary">Apply</button>
            </form>

            <script>
                function applyDiscount(e) {
                    e.preventDefault();
                    const discountInput = document.querySelector('#discountCode');
                    const discountCode = discountInput.value.trim();

                    if (!discountCode) {
                        alert("Please enter a discount code.");
                        return;
                    }

                    fetch("ApplyDiscount", {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/x-www-form-urlencoded"
                        },
                        body: "discountCode=" + encodeURIComponent(discountCode)
                    })
                            .then(response => response.json())
                            .then(data => {
                                if (data.error) {
                                    alert(data.error);
                                } else {
                                    document.querySelector('#cart-total').textContent = "$" + parseFloat(data.newTotal).toFixed(2);
                                    alert(data.success);
                                }
                            })
                            .catch(error => console.error("Error:", error));
                }
            </script>

            <div class="mt-3 p-3 bg-light border text-end">
                <h4>Total Cart Value: <strong id="cart-total" class="text-danger">$<%= String.format("%.3f", totalPrice)%></strong></h4>
            </div>
            <div class="mt-3 text-end">
                <a href="CheckoutInfo" class="btn btn-success btn-lg">Checkout</a>
            </div>
            <%
            } else {
            %>
            <div class="alert alert-warning text-center">Your cart is empty.</div>
            <%
                }
            %>
        </div>
        <%@ include file="footer.jsp" %>
        <script>
            function changeQuantity(input, id) {
                const cart_total = document.querySelector('#cart-total');
                const itemPrice = input.parentElement.parentElement.querySelector('.item-price');
                const currPrice = input.parentElement.parentElement.querySelector('.item-total');

                let initPriceVal = Number(itemPrice.textContent.replace(/[^0-9]/g, ''));
                let quantity = Number(input.value);
                let newPrice = initPriceVal * quantity;
                newPrice = newPrice.toLocaleString('en-US');
                currPrice.innerHTML = `$\${newPrice}`;
                updateTotalPrice();
                fetch(`AddToCart?action=changeQuantity&id=\${id}&quantity=\${quantity}`, {method: 'post'})
                        .then(response => response.text())
                        .then(data => console.log(data))
                        .catch(err => console.log(err));
            }
            function updateTotalPrice() {
                const getAllInputs = document.querySelectorAll('.item-total');
                const cart_total = document.querySelector('#cart-total');
                let totalPrice = 0;
                if (getAllInputs) {
                    Array.from(getAllInputs).forEach(input => {
                        let currentVal = Number(input.textContent.replace(/[^0-9]/g, ''));
                        totalPrice += currentVal;
                    });
                    totalPrice = totalPrice.toLocaleString('en-US');
                    cart_total.innerHTML = `$\${totalPrice}`;
                }
            }
            updateTotalPrice();

            function doDiscount(e) {
                e.preventDefault();
                const cartTotal = document.querySelector('#cart-total');
                let currentTotal = parseFloat(cartTotal.textContent.replace(/[^0-9.]/g, ''));
                const input = document.querySelector('#discountCode');
                let url = `ApplyDiscount?currentTotal=\${currentTotal}`;

                fetch(url, {
                    method: 'POST',
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded"
                    },
                    body: "discountCode=" + encodeURIComponent(input.value)
                })
                        .then(response => response.text())
                        .then(data => {
                            if (data === "LOGIN_REQUIRED") {
                                alert("You need to log in to use a discount code.");
                                return;
                            }
                            if (data === "EMPTY_CODE") {
                                alert("Please enter a discount code.");
                                return;
                            }
                            if (data === "CART_EMPTY" || data === "NO_ITEMS") {
                                alert("Your cart is empty.");
                                return;
                            }
                            if (data.startsWith("MIN_ORDER_")) {
                                let minOrderValue = data.split("_")[2];
                                alert("Discount code applies only for orders over $" + minOrderValue);
                                return;
                            }
                            if (data === "INVALID_CODE") {
                                alert("Invalid or expired discount code.");
                                return;
                            }
                            if (data === "ERROR") {
                                alert("An error occurred while applying the discount code.");
                                return;
                            }

                            // Update total cart value

                            cartTotal.textContent = "$" + data;
                            alert("Discount code applied successfully!");
                        })
                        .catch(err => console.log("Error:", err));
            }
        </script>
        <c:if test="${not empty sessionScope.error}">
            <script>
                alert('${error}');
            </script>
            <c:remove var="error" scope="session"/>
        </c:if>

    </body>
</html>
