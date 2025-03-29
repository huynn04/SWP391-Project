<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Order Detail</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
    <style>
        body {
            padding-top: 56px;
            background: #f0f2f5;
            font-family: 'Roboto', sans-serif;
        }
        .sidebar {
            height: 100vh;
            padding-top: 20px;
            background-color: #f8f9fa;
            position: fixed;
            width: 250px;
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
        main {
            margin-left: 250px;
        }
        .table-responsive {
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
        }
        .order-info {
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-bottom: 20px;
        }
        .btn-back {
            background: #6c757d;
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            font-weight: bold;
        }
        .btn-back:hover {
            background: #343a40;
            color: white;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
        <a class="navbar-brand" href="dashboard">Admin Dashboard</a>
    </nav>

    <div class="container-fluid">
        <div class="row">
            <nav class="col-md-3 col-lg-2 d-md-block sidebar">
                <div class="sidebar-sticky">
                    <jsp:include page="sidebar.jsp" />
                </div>
            </nav>

            <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">
                <div class="pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Order Detail</h1>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="ManageOrder">Order Management</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Order Detail</li>
                        </ol>
                    </nav>
                    <p>View detailed information about the selected order below.</p>
                </div>

                <c:choose>
                    <c:when test="${empty order}">
                        <div class="alert alert-warning" role="alert">
                            No order details available.
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- Order Information -->
                        <div class="order-info">
                            <h4>Order ID: ${order.orderId}</h4>
                            <table class="table table-sm">
                                <tr><th>Customer ID</th><td>${order.userId}</td></tr>
                                <tr><th>Order Date</th><td>${order.orderDate}</td></tr>
                                <tr><th>Receiver Name</th><td>${order.receiverName}</td></tr>
                                <tr><th>Delivery Address</th><td>${order.receiverAddress}</td></tr>
                                <tr><th>Phone Number</th><td>${order.receiverPhone}</td></tr>
                                <tr><th>Payment Method</th><td>${order.paymentMethod}</td></tr>
                                <tr><th>Total Price</th><td>$${order.totalPrice}</td></tr>
                                <tr><th>Note</th><td>${empty order.note ? 'No notes' : order.note}</td></tr>
                                <tr>
                                    <th>Status</th>
                                    <td>
                                        <c:choose>
                                            <c:when test="${order.status == 0}"><span class="text-warning">🟡 Pending</span></c:when>
                                            <c:when test="${order.status == 1}"><span class="text-info">🚚 In Transit</span></c:when>
                                            <c:when test="${order.status == 2}"><span class="text-success">✅ Delivered</span></c:when>
                                            <c:otherwise><span class="text-danger">❌ Canceled</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </table>
                        </div>

                        <!-- Order Details Table -->
                        <div class="table-responsive">
                            <table class="table table-striped table-sm">
                                <thead>
                                    <tr>
                                        <th>Product Image</th>
                                        <th>Product Name</th>
                                        <th>Quantity</th>
                                        <th>Price</th>
                                        <th>Subtotal</th>
                                        <th>Shipping Fee</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="detail" items="${orderDetails}">
                                        <tr>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty detail.product.image}">
                                                        <img src="${detail.product.image}" alt="Product" style="width: 100px; height: auto; border-radius: 5px;">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="default-product-image.jpg" alt="No Image" style="width: 100px; height: auto; border-radius: 5px;">
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${detail.product.productName}</td>
                                            <td>${detail.quantity}</td>
                                            <td>$${detail.price}</td>
                                            <td>$${detail.subtotal}</td>
                                            <td>$${detail.tax}</td>
                                            <td>
                                                <a href="ProductDetail?productId=${detail.productId}" class="btn btn-sm btn-info">View Product</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <div class="text-center mt-4">
                            <a href="ManageOrder" class="btn btn-back">Back to Order Management</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </main>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
    <script src="https://unpkg.com/feather-icons"></script>
    <script>
        feather.replace();
    </script>
</body>
</html>