<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Product Management</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-zoom/1.7.21/jquery.zoom.min.css">
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
            .product-card {
                background: #fff;
                padding: 15px;
                border-radius: 10px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
                margin-bottom: 20px;
                height: 100%;
            }
            .product-img {
                width: 100%;
                height: 150px;
                object-fit: cover;
                border-radius: 10px;
                cursor: zoom-in;
            }
        </style>
    </head>
    <body>
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

                <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">
                    <div class="pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">Product Management</h1>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="ManageProduct">Product Management</a></li>
                                <li class="breadcrumb-item active" aria-current="page">View Products</li>
                            </ol>
                        </nav>
                    </div>

                    <!-- Hiển thị tất cả sản phẩm -->
                    <div class="row">
                        <c:forEach var="product" items="${productList}" varStatus="loop">
                            <div class="col-md-4">
                                <div class="product-card">
                                    <c:choose>
                                        <c:when test="${not empty product.image}">
                                            <img src="${product.image}" alt="Product Image" class="product-img" data-toggle="modal" data-target="#productModal${loop.index}"/>
                                        </c:when>
                                        <c:otherwise>
                                            <img src="image/noimage.jpg" alt="No Image" class="product-img"/>
                                        </c:otherwise>
                                    </c:choose>
                                    <h5>${product.productName}</h5>
                                    <p><strong>Price:</strong> ${product.price}</p>
                                    <p><strong>Quantity:</strong> ${product.quantity}</p>
                                    <p><strong>Status:</strong> 
                                        <c:choose>
                                            <c:when test="${product.status == 1}">Active</c:when>
                                            <c:otherwise>Inactive</c:otherwise>
                                        </c:choose>
                                    </p>
                                    <a href="ViewProduct?id=${product.productId}" class="btn btn-primary btn-sm">View Details</a>
                                </div>
                            </div>

                            <!-- Modal cho ảnh phóng to -->
                            <div class="modal fade" id="productModal${loop.index}" tabindex="-1" role="dialog" aria-labelledby="modalTitle${loop.index}" aria-hidden="true">
                                <div class="modal-dialog modal-dialog-centered" role="document">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title" id="modalTitle${loop.index}">${product.productName}</h5>
                                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                                <span aria-hidden="true">×</span>
                                            </button>
                                        </div>
                                        <div class="modal-body">
                                            <img src="${product.image}" alt="Product Image" class="img-fluid" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </main>
            </div>
        </div>

        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
        <script src="https://unpkg.com/feather-icons"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-zoom/1.7.21/jquery.zoom.min.js"></script>
        <script>
            feather.replace();
            $(document).ready(function () {
                $('.product-img').zoom();
            });
        </script>
    </body>
</html>
