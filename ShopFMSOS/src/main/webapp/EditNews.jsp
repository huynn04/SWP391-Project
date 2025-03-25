<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit News</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
    <!-- CKEditor CDN -->
    <script src="https://cdn.ckeditor.com/ckeditor5/34.0.0/classic/ckeditor.js"></script>
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
            border: 1px solid #ccc;
            border-radius: 8px;
            padding: 20px;
            background-color: #fff;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
            max-width: 800px;
            margin-left: auto;
            margin-right: auto;
        }
        .form-container h2 {
            font-size: 1.5rem;
            color: #333;
            margin-bottom: 15px;
        }
        .form-group {
            margin-bottom: 20px;
            position: relative;
        }
        .form-group label {
            font-size: 1.1rem;
            font-weight: bold;
            color: #333;
            margin-bottom: 8px;
            display: block;
        }
        .form-group input[type="text"],
        .form-group textarea,
        .form-group select {
            font-size: 1rem;
            padding: 8px;
            border-radius: 4px;
            border: 1px solid #ddd;
            width: 100%;
        }
        .form-group textarea {
            height: 150px;
        }
        .form-group input[type="file"] {
            font-size: 1rem;
            padding: 5px 0;
        }
        .form-group select {
            height: 40px;
            z-index: 10;
        }
        .form-group img {
            max-width: 150px; /* Giảm kích thước ảnh preview */
            margin-top: 10px;
            border-radius: 4px;
        }
        .btn {
            font-size: 1rem;
            padding: 8px 16px;
            border-radius: 4px;
            margin-right: 8px;
        }
        .button-group {
            margin-top: 40px;
            text-align: center;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
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
                    <h1 class="h2">Edit News</h1>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="ManageNews">Manage News</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Edit News</li>
                        </ol>
                    </nav>
                </div>

                <!-- Form -->
                <div class="form-container">
                    <h2 class="text-center">Edit News</h2>
                    <form action="EditNews" method="post" enctype="multipart/form-data">
                        <!-- Hidden input to store newsId -->
                        <input type="hidden" name="newsId" value="${news.newsId}">

                        <div class="form-group">
                            <label for="title">Title:</label>
                            <input type="text" class="form-control" id="title" name="title" value="${news.title}" required>
                        </div>

                        <div class="form-group">
                            <label for="content">Content:</label>
                            <textarea name="content" id="content" class="form-control" rows="10" required>${news.content}</textarea>
                        </div>

                        <div class="form-group">
                            <label for="image">Choose Image:</label>
                            <input type="file" class="form-control-file" id="image" name="image" accept="image/*">
                            <img src="${news.image}" alt="Current Image" class="img-preview">
                        </div>

                        <div class="form-group">
                            <label for="status">Status:</label>
                            <select class="form-control" id="status" name="status">
                                <option value="1" ${news.status == 1 ? 'selected' : ''}>Active</option>
                                <option value="0" ${news.status == 0 ? 'selected' : ''}>Inactive</option>
                            </select>
                        </div>

                        <div class="button-group">
                            <button type="submit" class="btn btn-success">Update News</button>
                            <a href="ManageNews" class="btn btn-secondary">Cancel</a>
                        </div>
                    </form>
                </div>
            </main>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
    <script src="https://unpkg.com/feather-icons"></script>
    <script>
        feather.replace();

        // Initialize CKEditor for content field
        ClassicEditor
            .create(document.querySelector('#content'))
            .catch(error => {
                console.error(error);
            });
    </script>
</body>
</html>