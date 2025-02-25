<%-- 
    Document   : managePayment
    Created on : Feb 17, 2025, 4:06:53 PM
    Author     : Nguyễn Ngoc Huy CE180178
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Home - FMSOS</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <style>
            /* CSS cho phần nội dung bên trái */
            .welcome-section {
                margin-bottom: 30px;
            }
            /* CSS cho phần bài viết sản phẩm bên phải */
            .product-post {
                margin-bottom: 20px;
            }
            .product-post img {
                height: 150px;
                object-fit: cover;
                width: 100%;
            }
            .card-title {
                font-size: 1.1rem;
                font-weight: bold;
                margin-bottom: 0.5rem;
            }
            .card-text {
                font-size: 0.95rem;
            }
            .read-more {
                text-decoration: none;
                font-weight: bold;
                color: #28a745;
            }
            .read-more:hover {
                text-decoration: underline;
            }
        </style>
    </head>
    <body>
        <%@ include file="header.jsp" %>

        <div class="container mt-5">
            <h2>Manage Payment Methods</h2>

            <form action="ManagePaymentServlet" method="POST">
                <div class="mb-3">
                    <label for="paymentMethod" class="form-label">Select Payment Method</label>
                    <select class="form-select" id="paymentMethod" name="paymentMethod" required>
                        <option value="creditCard">Credit Card</option>
                        <option value="paypal">PayPal</option>
                        <option value="bankTransfer">Bank Transfer</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label for="cardNumber" class="form-label">Card Number</label>
                    <input type="text" class="form-control" id="cardNumber" name="cardNumber" placeholder="Enter your card number" required>
                </div>
                <button type="submit" class="btn btn-primary">Save Payment Method</button>
            </form>
        </div>
    </body>
</html>
