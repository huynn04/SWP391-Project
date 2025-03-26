<%-- 
    Document   : EditNews
    Created on : 17 thg 3, 2025, 21:02:56
    Author     : Tran Huy Lam CE180899 
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Edit News</title>
        <!-- Bootstrap CDN -->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
        <!-- CKEditor CDN -->
        <script src="https://cdn.ckeditor.com/ckeditor5/34.0.0/classic/ckeditor.js"></script>
        <style>
            body {
                padding-top: 56px;
                font-size: 18px; /* Tăng cỡ chữ chung */
            }
            .form-container {
                background: #fff;
                padding: 25px;
                border-radius: 15px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }
            label {
                font-size: 20px; /* Tăng cỡ chữ cho nhãn */
                font-weight: bold;
            }
            input[type="text"], textarea, select {
                font-size: 18px; /* Tăng cỡ chữ cho input, textarea */
                padding: 10px;
            }
            .btn {
                font-size: 20px; /* Tăng cỡ chữ cho nút */
                padding: 10px 20px;
            }
        </style>
    </head>
    <body>

        <!-- Navigation -->
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
            <a class="navbar-brand" href="dashboard">Admin Dashboard</a>
        </nav>

        <div class="container">
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
                        <!-- CKEditor Textarea -->
                        <textarea name="content" id="content" class="form-control" rows="10" required>${news.content}</textarea>
                    </div>

                    <!-- Image upload -->
                    <div class="form-group">
                        <label for="image">Choose Image:</label>
                        <input type="file" class="form-control-file" id="image" name="image" accept="image/*">
                        <img src="${news.image}" alt="Current Image" style="max-width: 200px; margin-top: 10px;">
                    </div>

                    <div class="form-group">
                        <label for="status">Status:</label>
                        <select class="form-control" id="status" name="status">
                            <option value="1" ${news.status == 1 ? 'selected' : ''}>Active</option>
                            <option value="0" ${news.status == 0 ? 'selected' : ''}>Inactive</option>
                        </select>
                    </div>

                    <button type="submit" class="btn btn-success">Update News</button>
                    <a href="ManageNews" class="btn btn-secondary">Cancel</a>
                </form>
            </div>
        </div>

        <!-- Scripts -->
        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.2/dist/umd/popper.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

        <script>
            // Initialize CKEditor for content field
            ClassicEditor
                    .create(document.querySelector('#content'))
                    .catch(error => {
                        console.error(error);
                    });
        </script>

    </body>
</html>

