<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="model.Order, java.util.List, model.OrderDetail" %>

<jsp:useBean id="order" type="model.Order" scope="request"/>
<jsp:useBean id="orderDetails" type="java.util.List<model.OrderDetail>" scope="request"/>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Order Details - FMSOS</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <style>
            /* Main color */
            :root {
                --primary-color: #007bff;
                --secondary-color: #6c757d;
                --light-bg: #f8f9fa;
                --dark-bg: #343a40;
                --highlight-color: #28a745;
                --warning-color: #ffc107;
                --danger-color: #dc3545;
            }

            /* Ensure content isn't hidden behind the header */
            body {
                padding-top: 80px;
                background-color: var(--light-bg);
            }

            h2 {
                color: var(--primary-color);
                font-weight: bold;
            }

            .product-card {
                display: flex;
                width: 100%;
                border: 2px solid var(--secondary-color);
                border-radius: 10px;
                padding: 20px;
                background: white;
                box-shadow: 2px 2px 15px rgba(0, 0, 0, 0.2);
                margin-bottom: 25px;
                transition: transform 0.2s ease-in-out, box-shadow 0.3s ease-in-out;
            }

            .product-card:hover {
                transform: scale(1.03);
                box-shadow: 2px 2px 20px rgba(0, 0, 0, 0.3);
            }

            .product-img-container {
                width: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                background: var(--light-bg);
                border-radius: 10px;
                padding: 20px;
            }

            .product-img {
                width: 100%;
                max-width: 450px;
                height: auto;
                border-radius: 10px;
            }

            .product-info {
                width: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                flex-direction: column;
                padding: 20px;
            }

            .product-table {
                width: 100%;
            }

            .product-table th {
                text-align: left;
                width: 200px;
                background-color: var(--primary-color);
                color: white;
                font-weight: bold;
                padding: 12px;
                border-radius: 5px;
            }

            .product-table td {
                text-align: left;
                padding: 12px;
                font-size: 16px;
                color: var(--dark-bg);
                background: var(--light-bg);
                border-radius: 5px;
            }

            /* View product link */
            .view-product {
                display: block;
                text-align: right;
                margin-top: 10px;
            }

            .view-product a {
                font-weight: bold;
                color: var(--primary-color);
                text-decoration: none;
                transition: color 0.3s ease-in-out;
            }

            .view-product a:hover {
                color: var(--highlight-color);
                text-decoration: underline;
            }

            /* Order information table */
            .order-card {
                background: white;
                border-radius: 10px;
                padding: 20px;
                box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.15);
            }

            .table th {
                background-color: var(--primary-color);
                color: white;
                padding: 10px;
            }

            .table td {
                padding: 10px;
            }

            .btn-back {
                background: var(--secondary-color);
                color: white;
                padding: 10px 20px;
                border-radius: 5px;
                font-weight: bold;
                transition: background 0.3s ease-in-out;
            }

            .btn-back:hover {
                background: var(--dark-bg);
            }

        </style>
    </head>
    <body>
        <%@ include file="header.jsp" %>

        <div class="container mt-5">
            <h2 class="text-center">Order Details</h2>

            <!-- Display product list (50% image - 50% information) -->
            <%
                BigDecimal totalPriceOrder = BigDecimal.ZERO;
                for (OrderDetail detail : orderDetails) {
                    totalPriceOrder = totalPriceOrder.add(detail.getSubtotal());
            %>
            <div class="product-card">
                <div class="product-img-container">
                    <% if (detail.getProduct() != null) { %>
                        <img src="<%= detail.getProduct().getImage() %>" class="product-img" alt="Product">
                    <% } else { %>
                        <img src="default-product-image.jpg" class="product-img" alt="No product image">
                    <% } %>
                </div>
                <div class="product-info">
                    <table class="product-table">
                        <tr>
                            <th>Product Name</th>
                            <td><%= detail.getProduct().getProductName() %></td>
                        </tr>
                        <tr>
                            <th>Quantity</th>
                            <td><%= detail.getQuantity() %></td>
                        </tr>
                        <tr>
                            <th>Price</th>
                            <td>$<%= detail.getPrice() %></td>
                        </tr>
                        <tr>
                            <th>Subtotal</th>
                            <td>$<%= detail.getSubtotal() %></td>
                        </tr>
                        <tr>
                            <th>Tax</th>
                            <td>$<%= detail.getTax() %></td>
                        </tr>
                    </table>
                    <!-- View product detail link -->
                    <div class="view-product">
                        <a href="ProductDetail?productId=<%= detail.getProductId() %>">🔍 View Product Detail</a>
                    </div>
                </div>
            </div>
            <% } %>

            <!-- Order information table -->
            <div class="order-card mb-4">
                <table class="table">
                    <tr><th>Order Date</th><td><%= order.getOrderDate() %></td></tr>
                    <tr><th>Receiver Name</th><td><%= order.getReceiverName() %></td></tr>
                    <tr><th>Delivery Address</th><td><%= order.getReceiverAddress() %></td></tr>
                    <tr><th>Phone Number</th><td><%= order.getReceiverPhone() %></td></tr>
                    <tr><th>Payment Method</th><td><%= order.getPaymentMethod() %></td></tr>
                    <tr><th>Total Order Value</th><td>$<%= totalPriceOrder %></td></tr>
                    <tr><th>Note</th><td><%= order.getNote() != null ? order.getNote() : "No notes" %></td></tr>
                    <tr>
                        <th>Order Status</th>
                        <td>
                            <% if (order.getStatus() == 0) { %> <span class="text-warning">🟡 Pending</span>
                            <% } else if (order.getStatus() == 1) { %> <span class="text-info">🚚 In Transit</span>
                            <% } else if (order.getStatus() == 2) { %> <span class="text-success">✅ Delivered</span>
                            <% } else { %> <span class="text-danger">❌ Canceled</span> <% }
                            %>
                        </td>
                    </tr>
                </table>
            </div>

            <div class="text-center mt-4">
                <a href="CustomerOrderHistory" class="btn btn-back">⬅ Back</a>
            </div>
        </div>

        <%@ include file="footer.jsp" %>

    </body>
</html>
