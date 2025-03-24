<%-- 
    Document   : EditCustomer
    Created on : Feb 16, 2025, 11:04:59 PM
    Author     : Nguyễn Ngoc Huy CE180178
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Edit Customer</title>
        <!-- Using Bootstrap CDN for quick UI development -->
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
        </style>
    </head>
    <body>
        <!-- Top Navigation Bar -->
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
            <a class="navbar-brand" href="dashboard.jsp">Admin Dashboard</a>
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
                        <h1 class="h2">Edit Customer</h1>
                        <!-- Breadcrumb định hướng -->
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item">
                                    <a href="CustomerManager">Customer Management</a>
                                </li>
                                <li class="breadcrumb-item active" aria-current="page">Edit Customer</li>
                            </ol>
                        </nav>
                    </div>

                    <!-- Form chỉnh sửa thông tin khách hàng -->
                    <div class="container">
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger" role="alert">
                                ${error}
                            </div>
                        </c:if>
                        <form action="EditCustomer" method="post" enctype="multipart/form-data">
                            <!-- Ẩn id của khách hàng -->
                            <input type="hidden" name="userId" value="${customer.userId}" />

                            <div class="form-group">
                                <label for="fullName">Full Name</label>
                                <input type="text" class="form-control" id="fullName" name="fullName" 
                                       value="${customer.fullName}" required>
                            </div>

                            <div class="form-group">
                                <label for="email">Email</label>
                                <input type="email" class="form-control" id="email" name="email" 
                                       value="${customer.email}" required>
                            </div>

                            <div class="form-group">
                                <label for="phoneNumber">Phone Number</label>
                                <input type="text" class="form-control" id="phoneNumber" name="phoneNumber" 
                                       value="${customer.phoneNumber}">
                            </div>

                            <div class="form-group">
                                <label for="address">Address</label>
                                <textarea class="form-control" id="address" name="address" rows="3">${customer.address}</textarea>
                            </div>

                            <div class="form-group">
                                <label>Avatar</label>
                                <div class="mb-2">
                                    <c:choose>
                                        <c:when test="${not empty customer.avatar}">
                                            <img src="${customer.avatar}" alt="Avatar" class="img-thumbnail" style="width:100px; height:100px;">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="image/avatarnull.jpg" alt="No Avatar" class="img-thumbnail" style="width:100px; height:100px;">
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <input type="file" class="form-control-file" name="avatar" id="avatar">

                            <div class="form-group">
                                <label for="status">Status</label>
                                <select class="form-control" id="status" name="status">
                                    <option value="1" <c:if test="${customer.status == 1}">selected</c:if>>Active</option>
                                    <option value="0" <c:if test="${customer.status == 0}">selected</c:if>>Inactive</option>
                                </select>
                            </div>

                            <button type="submit" class="btn btn-primary">Save Changes</button>
                            <a href="CustomerManager" class="btn btn-secondary">Cancel</a>
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

