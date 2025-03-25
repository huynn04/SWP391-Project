<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Update Category</title>
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
        .main-content {
            padding-top: 20px;
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
                    <h1 class="h2">Update Category</h1>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="CategoryServlet">Categories</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Update Category</li>
                        </ol>
                    </nav>
                </div>


                <!-- Update Category Form -->
                <div class="container mt-5">
                    <form action="UpdateCategory" method="POST">
                        <input type="hidden" name="categoryId" value="${category.categoryId}">

                        <div class="mb-3">
                            <label for="categoryName" class="form-label">Category Name</label>
                            <input type="text" class="form-control" id="categoryName" name="categoryName" value="${category.categoryName}" required>
                        </div>

                        <div class="mb-3">
                            <label for="description" class="form-label">Description</label>
                            <textarea class="form-control" id="description" name="description" rows="3">${category.description}</textarea>
                        </div>

                        <div class="mb-3">
                            <label for="image" class="form-label">Image URL (Optional)</label>
                            <input type="text" class="form-control" id="image" name="image" value="${category.image}">
                        </div>

                        <div class="mb-3">
                            <label for="status" class="form-label">Status</label>
                            <select class="form-select" id="status" name="status">
                                <option value="1" ${category.status == 1 ? 'selected' : ''}>Active</option>
                                <option value="0" ${category.status == 0 ? 'selected' : ''}>Inactive</option>
                            </select>
                        </div>

                        <button type="submit" class="btn btn-primary">Update Category</button>
                    </form>
                </div>
            </main>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
</body>
</html>
