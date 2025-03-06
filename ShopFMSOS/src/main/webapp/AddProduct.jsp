<%-- 
    Document   : AddProduct
    Created on : 25 thg 2, 2025, 14:19:21
    Author     : Tran Huy Lam CE180899 
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Add New Product</title>
        <!-- Bootstrap CDN -->
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
            .form-container {
                background: #fff;
                padding: 20px;
                border-radius: 15px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }
        </style>
    </head>
    <body>
        <!-- Navigation -->
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
            <a class="navbar-brand" href="dashboard">Admin Dashboard</a>
        </nav>

        <div class="container-fluid">
            <div class="row">
                <jsp:include page="sidebar.jsp" />

                <!-- Main Content -->
                <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">
                    <div class="pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">Add New Product</h1>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="ManageProduct">Product Management</a></li>
                                <li class="breadcrumb-item active" aria-current="page">Add Product</li>
                            </ol>
                        </nav>
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">${error}</div>
                        </c:if>
                        <c:if test="${not empty success}">
                            <div class="alert alert-success">${success}</div>
                        </c:if>
                    </div>

                    <div class="form-container">
                        <form action="AddProduct" method="post" enctype="multipart/form-data">
                            <div class="form-group">
                                <label for="productName">Product Name:</label>
                                <input type="text" class="form-control" id="productName" name="productName" required>
                            </div>

                            <div class="form-group">
                                <label for="categoryId">Category:</label>
                                <select class="form-control" id="categoryId" name="categoryId" required>
                                    <option value="" disabled selected>Select Category</option>
                                    <!-- Hiển thị danh sách category từ categoryList -->
                                    <c:forEach var="category" items="${categoryList}">
                                        <option value="${category.categoryId}">
                                            ${category.categoryName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="detailDesc">Description:</label>
                                <textarea class="form-control" id="detailDesc" name="detailDesc" maxlength="200" required></textarea>
                            </div>

                            <div class="form-group">
                                <label for="price">Price:</label>
                                <input type="number" step="0.01" class="form-control" id="price" name="price" required>
                            </div>

                            <div class="form-group">
                                <label for="discount">Discount (%):</label>
                                <input type="number" step="0.01" class="form-control" id="discount" name="discount" value="0">
                            </div>

                            <div class="form-group">
                                <label for="quantity">Quantity:</label>
                                <input type="number" class="form-control" id="quantity" name="quantity" required>
                            </div>

                            <div class="form-group">
                                <label for="target">Target Audience:</label>
                                <input type="text" class="form-control" id="target" name="target">
                            </div>

                            <div class="form-group">
                                <label for="factory">Factory:</label>
                                <input type="text" class="form-control" id="factory" name="factory">
                            </div>

                            <div class="form-group">
                                <label for="image">Product Image:</label>
                                <input type="file" class="form-control" id="image" name="image" accept="image/png, image/jpeg">
                            </div>

                            <div class="form-group">
                                <label for="status">Status:</label>
                                <select class="form-control" id="status" name="status">
                                    <option value="1" selected>Active</option>
                                    <option value="0">Inactive</option>
                                </select>
                            </div>

                            <button type="submit" class="btn btn-success">Add Product</button>
                            <a href="ManageProduct" class="btn btn-secondary">Cancel</a>
                        </form>
                    </div>
                </main>
            </div>
        </div>

        <!-- Success Modal (Bootstrap) -->
        <div class="modal fade" id="successModal" tabindex="-1" role="dialog" aria-labelledby="successModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="successModalLabel">Success</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <p>Your product has been added successfully!</p>
                    </div>
                    <div class="modal-footer">
                        <a href="ManageProduct" class="btn btn-secondary">Back to Product List</a>
                        <button type="button" class="btn btn-primary" onclick="window.location.href='AddProduct'">Add Another Product</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Scripts -->
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
        <script src="https://unpkg.com/feather-icons"></script>
        <script>
            feather.replace();
            // Show success modal if success message exists
            <c:if test="${not empty success}">
                window.onload = function() {
                    $('#successModal').modal('show');
                };
            </c:if>
        </script>
    </body>
</html>
