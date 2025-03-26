<%-- 
    Document   : AddNews
    Created on : 17 thg 3, 2025, 19:40:11
    Author     : Tran Huy Lam CE180899 
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.2">
        <title>Add News</title>
        <!-- Bootstrap CDN -->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
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
                <h2 class="text-center" style="font-size: 28px;">Add New News</h2>

                <form action="AddNews" method="post" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="title">Title:</label>
                        <input type="text" class="form-control" id="title" name="title" required>
                    </div>

                    <div class="form-group">
                        <label for="content">Content:</label>
                        <!-- Textarea với cỡ chữ lớn hơn -->
                        <textarea class="form-control" id="content" name="content" rows="10" required></textarea>
                    </div>

                    <!-- Image upload -->
                    <div class="form-group">
                        <label for="image">Choose Image:</label>
                        <input type="file" class="form-control-file" id="image" name="image" accept="image/*" required>
                    </div>

                    <div class="form-group">
                        <label for="status">Status:</label>
                        <select class="form-control" id="status" name="status">
                            <option value="1" selected>Active</option>
                            <option value="0">Inactive</option>
                        </select>
                    </div>

                    <button type="submit" class="btn btn-success">Add News</button>
                    <a href="ManageNews" class="btn btn-secondary">Cancel</a>
                </form>
            </div>
        </div>

        <!-- Scripts -->
        <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
        
    </body>
</html>
