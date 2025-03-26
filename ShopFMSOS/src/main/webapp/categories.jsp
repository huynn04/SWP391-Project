<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Categories</title>
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
        .category-img {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 5px;
        }
        .table-responsive {
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
        }
        .btn-sm {
            padding: 5px 10px;
            border-radius: 5px;
        }
        .sort-container {
            margin-bottom: 20px;
            display: flex;
            justify-content: flex-end;
        }
        .form-select {
            width: 200px;
            padding: 8px;
            border-radius: 5px;
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
                    <h1 class="h2">Categories List</h1>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item active" aria-current="page">Categories List</li>
                        </ol>
                    </nav>
                    <a href="AddCategory" class="btn btn-success mb-3">Add New Category</a>
                </div>

                <!-- Sorting Section -->
                <div class="sort-container">
                    <form method="GET" action="CategoryServlet">
                        <select name="sortOption" class="form-select" onchange="this.form.submit()">
                            <option value="name-asc" ${sortOption == 'name-asc' ? 'selected' : ''}>Category Name (A-Z)</option>
                            <option value="name-desc" ${sortOption == 'name-desc' ? 'selected' : ''}>Category Name (Z-A)</option>
                        </select>
                    </form>
                </div>

                <!-- Hiển thị danh sách danh mục -->
                <div class="table-responsive">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>Image</th>
                                <th>Category Name</th>
                                <th>Description</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="category" items="${categories}">
                                <tr>
                                    <td>
                                        <c:choose>
                                            <c:when test="${category.image != null}">
                                                <img src="${category.image}" alt="${category.categoryName}" class="category-img">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="images/no-image.png" alt="No image" class="category-img">
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${category.categoryName}</td>
                                    <td>${category.description}</td>
                                    <td>${category.status == 1 ? 'Active' : 'Inactive'}</td>
                                    <td>
                                        <a href="UpdateCategory?categoryId=${category.categoryId}" class="btn btn-warning btn-sm">Update</a>
                                        <a href="ViewProductByCate?categoryId=${category.categoryId}" class="btn btn-info btn-sm">View Products</a>
                                        <c:if test="${category.categoryId != 13}">
                                            <a href="DeleteCategory?categoryId=${category.categoryId}" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this category?')">Delete</a>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
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