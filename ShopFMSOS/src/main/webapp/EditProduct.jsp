<%-- 
    Document   : EditProduct
    Created on : 25 thg 2, 2025, 17:36:15
    Author     : Tran Huy Lam CE180899 
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Edit Product</title>
        <!-- Bootstrap CSS -->
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
            .edit-card {
                background: #fff;
                padding: 20px;
                border-radius: 15px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
                margin-bottom: 30px;
            }
            .edit-card h3 {
                margin-bottom: 20px;
                border-bottom: 1px solid #e5e5e5;
                padding-bottom: 10px;
            }
            .current-avatar {
                max-width: 150px;
                margin-bottom: 10px;
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
                        <h1 class="h2">Edit Product</h1>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item">
                                    <a href="ManageProduct">Product Management</a>
                                </li>
                                <li class="breadcrumb-item active" aria-current="page">Edit Product</li>
                            </ol>
                        </nav>
                    </div>

                    <div class="edit-card">
                        <h3>Edit Product Information</h3>
                        <!-- Form to edit product: include enctype to upload file -->
                        <form action="EditProduct" method="post" enctype="multipart/form-data">
                            <input type="hidden" name="productId" value="${product.productId}"/>
                            <div class="form-group">
                                <label for="productName">Product Name:</label>
                                <input type="text" class="form-control" id="productName" name="productName" value="${product.productName}" required>
                            </div>

                            <div class="form-group">
                                <label for="categoryId">Category:</label>
                                <select class="form-control" id="categoryId" name="categoryId" required>
                                    <c:forEach var="category" items="${categoryList}">
                                        <option value="${category.categoryId}" <c:if test="${category.categoryId == product.categoryId}">selected</c:if>>${category.categoryName}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="detailDesc">Description:</label>
                                <textarea class="form-control" id="detailDesc" name="detailDesc" maxlength="200" required>${product.detailDesc}</textarea>
                            </div>

                            <div class="form-group">
                                <label for="price">Price:</label>
                                <input type="number" step="0.01" class="form-control" id="price" name="price" value="${product.price}" required>
                            </div>

                            <div class="form-group">
                                <label for="discount">Discount (%):</label>
                                <input type="number" step="0.01" class="form-control" id="discount" name="discount" value="${product.discount}" required>
                            </div>

                            <div class="form-group">
                                <label for="quantity">Quantity:</label>
                                <input type="number" class="form-control" id="quantity" name="quantity" value="${product.quantity}" required>
                            </div>

                            <!-- Display current avatar (product image) -->
                            <div class="form-group">
                                <label>Current Image:</label><br>
                                <c:choose>
                                    <c:when test="${not empty product.image}">
                                        <img src="${product.image}" alt="Product Image" class="current-avatar"/>
                                    </c:when>
                                    <c:otherwise>
                                        <img src="image/noimage.jpg" alt="No Image" class="current-avatar"/>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Upload a new image for product (if required) -->
                            <div class="form-group">
                                <label for="imageFile">Choose new image (if any):</label>
                                <input type="file" class="form-control" id="imageFile" name="image">
                            </div>

                            <div class="form-group">
                                <label for="status">Status:</label>
                                <select class="form-control" id="status" name="status">
                                    <option value="1" <c:if test="${product.status == 1}">selected</c:if>>Active</option>
                                    <option value="0" <c:if test="${product.status == 0}">selected</c:if>>Inactive</option>
                                </select>
                            </div>

                            <button type="submit" class="btn btn-primary">Save Changes</button>
                            <a href="ManageProduct" class="btn btn-secondary">Cancel</a>
                        </form>
                    </div>
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
