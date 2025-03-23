<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Category Management</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            padding-top: 60px;
        }
        .navbar {
            background-color: #343a40;
        }
        .navbar a {
            color: white;
        }
        .container {
            margin-top: 30px;
        }
        .alert {
            margin-top: 20px;
        }
    </style>
</head>
<body>

    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark fixed-top">
        <a class="navbar-brand" href="#">Admin Dashboard</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
    </nav>

    <div class="container">
        <!-- Search and Add Category -->
        <div class="row">
            <div class="col-md-12">
                <form action="CategoryServlet" method="get" class="form-inline mb-4">
                    <input type="text" class="form-control mr-2" name="searchQuery" placeholder="Search categories..." value="${param.searchQuery}">
                    <button type="submit" class="btn btn-primary">Search</button>
                    <a href="AddCategory" class="btn btn-success ml-3">Add New Category</a>
                </form>
            </div>
        </div>

        <!-- Category List -->
        <div class="row">
            <div class="col-md-12">
                <c:choose>
                    <c:when test="${empty categoryList}">
                        <div class="alert alert-warning">No categories found.</div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="table table-bordered">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Name</th>
                                        <th>Description</th>
                                        <th>Status</th>
                                        <th>Created At</th>
                                        <th>Updated At</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="category" items="${categoryList}">
                                        <tr>
                                            <td>${category.categoryId}</td>
                                            <td>${category.categoryName}</td>
                                            <td>${category.description}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${category.status == 1}">Active</c:when>
                                                    <c:otherwise>Inactive</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${category.createdAt}</td>
                                            <td>${category.updatedAt}</td>
                                            <td>
                                                <a href="ViewCategory?id=${category.categoryId}" class="btn btn-info btn-sm">View</a>
                                                <a href="EditCategory?id=${category.categoryId}" class="btn btn-primary btn-sm">Edit</a>
                                                <a href="DeleteCategory?id=${category.categoryId}" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this category?');">Delete</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- Footer (Optional) -->
    <footer class="text-center mt-5 mb-3">
        <p>&copy; 2025 My Shop - All rights reserved</p>
    </footer>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.3/dist/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
