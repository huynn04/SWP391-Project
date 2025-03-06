<%-- 
    Document   : ManageProduct
    Created on : 25 thg 2, 2025, 13:21:45
    Author     : Tran Huy Lam CE180899 
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Product Management</title>
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
            .product-img {
                width: 100px;
                height: 100px;
                object-fit: cover;
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
                        <h1 class="h2">Product Management</h1>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item active" aria-current="page">Product Management</li>
                            </ol>
                        </nav>

                        <a href="AddProduct" class="btn btn-success mb-3">Add New Product</a>
                        <form action="ManageProduct" method="get" class="form-inline mb-3">
                            <div class="form-group mr-2">
                                <label for="searchQuery" class="mr-2">Search:</label>
                                <input type="text" name="searchQuery" id="searchQuery" class="form-control" placeholder="Enter name or ID" value="${param.searchQuery}">
                            </div>
                            <div class="form-group mr-2">
                                <label for="searchBy" class="mr-2">Search By:</label>
                                <select name="searchBy" id="searchBy" class="form-control">
                                    <option value="id" ${param.searchBy == 'id' ? 'selected' : ''}>ID</option>
                                    <option value="name" ${param.searchBy == 'name' ? 'selected' : ''}>Name</option>

                                </select>
                            </div>
                            <div class="form-group mr-2">
                                <label for="sortBy" class="mr-2">Sort By:</label>
                                <select name="sortBy" id="sortBy" class="form-control">
                                    <option value="id" ${param.sortBy == 'id' ? 'selected' : ''}>ID</option>
                                    <option value="name" ${param.sortBy == 'name' ? 'selected' : ''}>Name</option>

                                </select>
                            </div>
                            <button type="submit" class="btn btn-primary">Search & Sort</button>
                        </form>


                    </div>

                    <!-- Hiển thị danh sách sản phẩm -->
                    <c:choose>
                        <c:when test="${empty productList}">
                            <div class="alert alert-warning">No products found.</div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th>Image</th>
                                            <th>ID</th>
                                            <th>Name</th>
                                            <th>Category Name</th> <!-- Cột mới cho tên danh mục -->
                                            <th>Price</th>
                                            <th>Discount</th>
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
                                                            <img src="image/noimage.jpg" alt="No Image" class="product-img"/>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>${product.productId}</td>
                                                <td>${product.productName}</td>
                                                <td>${categoryNames[product.productId]}</td> <!-- Hiển thị tên danh mục từ map -->
                                                <td>${product.price}</td>
                                                <td>${product.discount}%</td>
                                                <td>${product.quantity}</td>
                                                <td>${product.sold}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${product.status == 1}">Active</c:when>
                                                        <c:otherwise>Inactive</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <a href="ViewProduct?id=${product.productId}" class="btn btn-info btn-sm">View</a>
                                                    <a href="EditProduct?id=${product.productId}" class="btn btn-primary btn-sm">Edit</a>
                                                    <a href="DeleteProduct?id=${product.productId}" class="btn btn-danger btn-sm" onclick="return confirm('Bạn có chắc muốn xóa sản phẩm này?');">Delete</a>
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

    </body>
</html>
