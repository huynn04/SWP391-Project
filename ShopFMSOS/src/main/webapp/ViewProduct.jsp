<%-- 
    Document   : ViewProduct
    Created on : 25 thg 2, 2025, 15:34:32
    Author     : Tran Huy Lam CE180899 
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>View Product</title>
        <!-- Using Bootstrap CDN for UI -->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
        <style>
            body {
                padding-top: 56px;
                background-color: #f2f2f2;
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
            .product-img {
                width: 300px;
                height: 300px;
                object-fit: cover;
                border-radius: 15px;
                margin-bottom: 20px;
            }
            .detail-section {
                margin-bottom: 30px;
            }
            /* Style for the product card */
            .product-card {
                background: #fff;
                padding: 20px;
                border-radius: 15px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
                margin-bottom: 30px;
            }
            .product-card h3 {
                margin-bottom: 20px;
                border-bottom: 1px solid #e5e5e5;
                padding-bottom: 10px;
            }
            .product-info p {
                margin: 0 0 10px;
                font-size: 16px;
            }
            .product-info p strong {
                width: 150px;
                display: inline-block;
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
                        <h1 class="h2">Product Detail</h1>
                        <!-- Breadcrumb -->
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item">
                                    <a href="ManageProduct">Product Management</a>
                                </li>
                                <li class="breadcrumb-item active" aria-current="page">View Product</li>
                            </ol>
                        </nav>
                    </div>

                    <!-- Card displaying product details -->
                    <div class="product-card">
                        <h3>Product Information</h3>
                        <div class="row">
                            <div class="col-md-4 text-center">
                                <c:choose>
                                    <c:when test="${not empty product.image}">
                                        <img src="${product.image}" alt="Product Image" class="product-img"/>
                                    </c:when>
                                    <c:otherwise>
                                        <img src="image/noimage.jpg" alt="No Image" class="product-img"/>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="col-md-8 product-info">
                                <p><strong>Product ID:</strong> ${product.productId}</p>
                                <p><strong>Product Name:</strong> ${product.productName}</p>
                                <p><strong>Description:</strong> ${product.detailDesc}</p>
                                <p><strong>Price:</strong> ${product.price}</p>
                                <p><strong>Discount:</strong> ${product.discount}%</p>
                                <p><strong>Quantity:</strong> ${product.quantity}</p>
                                <p><strong>Sold:</strong> ${product.sold}</p>
                                <p><strong>Target Audience:</strong> ${product.target}</p>
                                <p><strong>Factory:</strong> ${product.factory}</p>
                                <p><strong>Status:</strong>
                                    <c:choose>
                                        <c:when test="${product.status == 1}">Active</c:when>
                                        <c:otherwise>Inactive</c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                        </div>
                    </div>

                    <!-- Optionally, add more sections like related products, etc. -->
                </main>
            </div>
        </div>

        <!-- Bootstrap and required scripts -->
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
        <script src="https://unpkg.com/feather-icons"></script>
        <script>
            feather.replace();
        </script>
    </body>
</html>