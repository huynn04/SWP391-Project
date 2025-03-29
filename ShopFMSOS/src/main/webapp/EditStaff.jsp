<%-- 
    Document   : EditStaff.jsp
    Created on : Feb 17, 2025, 10:30:32 AM
    Author     : Nguyễn Ngoc Huy CE180178
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Edit Staff</title>
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
                        <h1 class="h2">Edit Staff</h1>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item">
                                    <a href="StaffManager">Staff Management</a>
                                </li>
                                <li class="breadcrumb-item active" aria-current="page">Edit Staff</li>
                            </ol>
                        </nav>
                    </div>

                    <div class="edit-card">
                        <h3>Edit Staff Information</h3>
                        <!-- Edit staff form: added enctype for file upload -->
                        <form action="EditStaff" method="post" enctype="multipart/form-data">
                            <!-- Hidden input for userId -->
                            <input type="hidden" name="userId" value="${staff.userId}"/>

                            <div class="form-group">
                                <label for="fullName">Full Name:</label>
                                <input type="text" class="form-control" id="fullName" name="fullName" value="${staff.fullName}" required>
                            </div>

                            <div class="form-group">
                                <label for="email">Email:</label>
                                <input type="email" class="form-control" id="email" name="email" value="${staff.email}" required>
                            </div>

                            <div class="form-group">
                                <label for="phoneNumber">Phone Number:</label>
                                <input type="text" class="form-control" id="phoneNumber" name="phoneNumber" value="${staff.phoneNumber}" required>
                            </div>

                            <div class="form-group">
                                <label for="address">Address:</label>
                                <input type="text" class="form-control" id="address" name="address" value="${staff.address}" required>
                            </div>

                            <!-- Display current avatar -->
                            <div class="form-group">
                                <label>Current Avatar:</label><br>
                                <c:choose>
                                    <c:when test="${not empty staff.avatar}">
                                        <img src="${staff.avatar}" alt="Avatar" class="current-avatar"/>
                                    </c:when>
                                    <c:otherwise>
                                        <img src="image/avatarnull.jpg" alt="No Avatar" class="current-avatar"/>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Allow user to upload a new avatar (if changing) -->
                            <div class="form-group">
                                <label for="avatarFile">Choose a new avatar file (if any):</label>
                                <input type="file" class="form-control" id="avatarFile" name="avatar">
                            </div>

                            <div class="form-group">
                                <label for="status">Status:</label>
                                <select class="form-control" id="status" name="status">
                                    <option value="1" <c:if test="${staff.status == 1}">selected</c:if>>Active</option>
                                    <option value="0" <c:if test="${staff.status == 0}">selected</c:if>>Inactive</option>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label for="roleId">Role:</label>
                                    <select class="form-control" id="roleId" name="roleId">
                                        <!-- Assuming: 2 is Staff, other values based on your design -->
                                        <option value="2" <c:if test="${staff.roleId == 2}">selected</c:if>>Staff</option>
                                    <option value="3" <c:if test="${staff.roleId == 3}">selected</c:if>>Customer</option>
                                </select>
                            </div>

                            <button type="submit" class="btn btn-primary">Save Changes</button>
                            <a href="StaffManager" class="btn btn-secondary">Cancel</a>
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
