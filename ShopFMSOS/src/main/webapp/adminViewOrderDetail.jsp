<%-- 
    Document   : adminViewOrderDetail
    Created on : Mar 25, 2025, 12:00:00 PM
    Author     : [Your Name]
--%>
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin - View Order Detail</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
    <style>
        body {
            padding-top: 56px;
            background-color: #f8f9fa;
        }
        .sidebar {
            height: 100vh;
            padding-top: 20px;
            background-color: #f8f9fa;
        }
        .sidebar a {
            color: #333;
            display: block;
            padding: 10px 15px;
            text-decoration: none;
        }
        .sidebar a:hover {
            background-color: #ddd;
        }
        .table th {
            background-color: #007bff;
            color: white;
        }

        /* Product card styles */
        .product-card {
            display: flex;
            width: 100%;
            border: 2px solid #6c757d;
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
            background: #f8f9fa;
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
            background-color: #007bff;
            color: white;
            font-weight: bold;
            padding: 12px;
            border-radius: 5px;
        }
        .product-table td {
            text-align: left;
            padding: 12px;
            font-size: 16px;
            color: #343a40;
            background: #f8f9fa;
            border-radius: 5px;
        }
        .view-product {
            display: block;
            text-align: right;
            margin-top: 10px;
        }
        .view-product a {
            font-weight: bold;
            color: #007bff;
            text-decoration: none;
            transition: color 0.3s ease-in-out;
        }
        .view-product a:hover {
            color: #28a745;
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <!-- Top Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
        <a class="navbar-brand" href="dashboard">Admin Dashboard</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarResponsive"
                aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
    </nav>

    <div class="container-fluid">
        <div class="row">
            <jsp:include page="sidebar.jsp" />

            <!-- Main content area -->
            <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">
                <div class="pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Order Detail - Order ID: ${order.orderId}</h1>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="ManageOrder">Order Management</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Order Detail</li>
                        </ol>
                    </nav>
                </div>

              

                <!-- Order Items with Product Cards -->
                <div class="card">
                    <div class="card-header">Order Items</div>
                    <div class="card-body">
                        <c:forEach var="detail" items="${orderDetails}">
                            <div class="product-card">
                                <div class="product-img-container">
                                    <c:choose>
                                        <c:when test="${not empty detail.product.image}">
                                            <img src="${detail.product.image}" class="product-img" alt="${detail.product.productName}">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="default-product-image.jpg" class="product-img" alt="No product image">
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="product-info">
                                    <table class="product-table">
                                        <tr>
                                            <th>Product Name</th>
                                            <td>${detail.product.productName}</td>
                                        </tr>
                                        <tr>
                                            <th>Quantity</th>
                                            <td>${detail.quantity}</td>
                                        </tr>
                                        <tr>
                                            <th>Price</th>
                                            <td>$${detail.price}</td>
                                        </tr>
                                        <tr>
                                            <th>Subtotal</th>
                                            <td>$${detail.subtotal}</td>
                                        </tr>
                                        <tr>
                                            <th>Tax</th>
                                            <td>$${detail.tax}</td>
                                        </tr>
                                    </table>
                                    <!-- View product detail link -->
                                    <div class="view-product">
                                        <a href="ProductDetail?productId=${detail.productId}">🔍 View Product Detail</a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <!-- Back Button -->
                <div class="mt-3">
                    <a href="ManageOrder" class="btn btn-secondary">Back to Order Management</a>
                </div>
            </main>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
</body>
</html>