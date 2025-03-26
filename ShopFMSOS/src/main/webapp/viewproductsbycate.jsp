<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Products in Category</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
    <style>
        body {
            padding-top: 56px;
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
        .product-box {
            display: flex;
            border: 2px solid #ccc;
            border-radius: 10px;
            margin-bottom: 30px;
            padding: 20px;
            background-color: #fff;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            transition: transform 0.2s;
        }
        .product-box:hover {
            transform: scale(1.02);
        }
        .product-img {
            width: 350px;
            height: 350px;
            object-fit: cover;
            margin-right: 30px;
            border-radius: 10px;
            border: 1px solid #eee;
        }
        .product-info {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            padding: 10px 0;
        }
        .product-info h5 {
            font-size: 1.5rem;
            margin-bottom: 15px;
            color: #333;
        }
        .product-info p {
            font-size: 1.1rem;
            margin: 10px 0;
            color: #555;
        }
        .product-info .btn {
            align-self: flex-start;
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

            <!-- Main content -->
            <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">
                <div class="pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Products in Category</h1>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="CategoryServlet">Categories</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Products in Category</li>
                        </ol>
                    </nav>
                </div>

                <!-- Hiển thị danh sách sản phẩm -->
                <div class="product-list">
                    <c:forEach var="product" items="${products}">
                        <div class="product-box">
                            <img src="<c:choose>
                                        <c:when test="${product.image != null}">
                                            ${product.image}
                                        </c:when>
                                        <c:otherwise>
                                            images/no-image.png
                                        </c:otherwise>
                                    </c:choose>" alt="${product.productName}" class="product-img">
                            <div class="product-info">
                                <div>
                                    <h5>${product.productName}</h5>
                                    <p>${product.detailDesc}</p>
                                    <p><strong>Price:</strong> $${product.price}</p>
                                    <p><strong>Status:</strong> ${product.status == 1 ? 'Active' : 'Inactive'}</p>
                                </div>
                                <div>
                                    <a href="ProductDetail?productId=${product.productId}" class="btn btn-primary btn-sm">View Details</a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Back to Categories Button -->
                <div class="mt-3">
                    <a href="CategoryServlet" class="btn btn-secondary">Back to Categories</a>
                </div>
            </main>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
    <script src="https://unpkg.com/feather-icons"></script>
    <script>
        feather.replace();
    </script>
</body>
</html>