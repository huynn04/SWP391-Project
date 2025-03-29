<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Product Management</title>
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
        .product-img {
            width: 100px;
            height: 100px;
            object-fit: cover;
        }
        main {
            margin-left: 250px;
        }
        .search-container, .sort-container {
            margin-bottom: 20px;
            display: flex;
            justify-content: flex-start;
            gap: 15px;
        }
        .form-select, .form-control {
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        .table-responsive {
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
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
        <!-- Sidebar -->
        <nav class="col-md-3 col-lg-2 d-md-block sidebar">
            <div class="sidebar-sticky">
                <jsp:include page="sidebar.jsp" />
            </div>
        </nav>

        <!-- Main content area -->
        <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">
            <div class="pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">Product Management</h1>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb breadcrumb-custom">
                        <li class="breadcrumb-item active" aria-current="page">Product Management</li>
                    </ol>
                </nav>
                <p>Manage product information and view product details below.</p>
            </div>

            <!-- Search Section -->
            <div class="search-container">
                <form action="ManageProduct" method="get" class="form-inline">
                    <label for="searchQuery" class="mr-2">Search:</label>
                    <input type="text" name="searchQuery" id="searchQuery" class="form-control mr-2" placeholder="Enter keyword" value="${param.searchQuery}">
                    <input type="hidden" name="searchBy" value="name"> <!-- Always search by name -->
                    <button type="submit" class="btn btn-primary">Search</button>
                </form>
            </div>

            <!-- Sort Section -->
            <div class="sort-container">
                <form action="ManageProduct" method="get" class="form-inline">
                    <label for="sortBy" class="mr-2">Sort by:</label>
                    <select name="sortBy" id="sortBy" class="form-select" onchange="this.form.submit()">
                        <option value="name-asc" ${param.sortBy == 'name-asc' ? 'selected' : ''}>Name (A-Z)</option>
                        <option value="name-desc" ${param.sortBy == 'name-desc' ? 'selected' : ''}>Name (Z-A)</option>
                        <option value="price-asc" ${param.sortBy == 'price-asc' ? 'selected' : ''}>Price (Ascending)</option>
                        <option value="price-desc" ${param.sortBy == 'price-desc' ? 'selected' : ''}>Price (Descending)</option>
                        <option value="quantity-asc" ${param.sortBy == 'quantity-asc' ? 'selected' : ''}>Quantity (Ascending)</option>
                        <option value="quantity-desc" ${param.sortBy == 'quantity-desc' ? 'selected' : ''}>Quantity (Descending)</option>
                        <option value="sold-asc" ${param.sortBy == 'sold-asc' ? 'selected' : ''}>Sold (Ascending)</option>
                        <option value="sold-desc" ${param.sortBy == 'sold-desc' ? 'selected' : ''}>Sold (Descending)</option>
                    </select>
                </form>
            </div>

            <!-- Display product list -->
            <c:choose>
                <c:when test="${empty productList}">
                    <div class="alert alert-warning" role="alert">
                        No products found matching your search criteria.
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table table-striped table-sm">
                            <thead>
                                <tr>
                                    <th>Image</th>
                                    <th>Name</th>
                                    <th>Category Name</th>
                                    <th>Price</th>
                                    <th>Quantity</th>
                                    <th>Sold</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="product" items="${productList}">
                                    <tr>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty product.image}">
                                                    <img src="${product.image}" alt="Product Image" class="product-img"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="image/no-image.png" alt="No Image" class="product-img"/>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${product.productName}</td>
                                        <td>${categoryNames[product.productId]}</td>
                                        <td>${product.price}</td>
                                        <td>${product.quantity}</td>
                                        <td>${product.sold}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${product.status == 1}">Active</c:when>
                                                <c:otherwise>Inactive</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <a href="ViewProduct?id=${product.productId}" class="btn btn-sm btn-info">View</a>
                                            <a href="EditProduct?id=${product.productId}" class="btn btn-sm btn-primary">Edit</a>
                                            <a href="DeleteProduct?id=${product.productId}" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure you want to delete this product?');">Delete</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
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
