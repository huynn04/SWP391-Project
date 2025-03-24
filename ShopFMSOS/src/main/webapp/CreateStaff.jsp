<%-- 
    Document   : CreateStaff.jsp
    Created on : Feb 17, 2025
    Author     : Nguyễn Ngoc Huy CE180178
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Create New Staff</title>
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
                        <h1 class="h2">Create New Staff</h1>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="StaffManager">Staff Management</a></li>
                                <li class="breadcrumb-item active" aria-current="page">Create Staff</li>
                            </ol>
                        </nav>
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">${error}</div>
                        </c:if>
                    </div>
                    <div class="form-container">
                        <!-- Form có enctype để upload file -->
                        <form action="CreateStaff" method="post" enctype="multipart/form-data">
                            <!-- Role mặc định là 2 (Staff) -->
                            <input type="hidden" name="roleId" value="2"/>
                            
                            <div class="form-group">
                                <label for="fullName">Full Name:</label>
                                <input type="text" class="form-control" id="fullName" name="fullName" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="email">Email:</label>
                                <input type="email" class="form-control" id="email" name="email" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="phoneNumber">Phone Number:</label>
                                <input type="text" class="form-control" id="phoneNumber" name="phoneNumber" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="address">Address:</label>
                                <input type="text" class="form-control" id="address" name="address" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="password">Password:</label>
                                <input type="password" class="form-control" id="password" name="password" required>
                            </div>
                            
                            <!-- Sửa phần chọn avatar thành input file -->
                            <div class="form-group">
                                <label for="avatar">Avatar:</label>
                                <input type="file" class="form-control" id="avatar" name="avatar">
                            </div>
                            
                            <div class="form-group">
                                <label for="status">Status:</label>
                                <select class="form-control" id="status" name="status">
                                    <option value="1" selected>Active</option>
                                    <option value="0">Inactive</option>
                                </select>
                            </div>
                            
                            <button type="submit" class="btn btn-success">Create Staff</button>
                            <a href="StaffManager" class="btn btn-secondary">Cancel</a>
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
        </script>
    </body>
</html>
