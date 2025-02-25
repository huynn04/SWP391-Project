<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Customer Management</title>
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
            .avatar-img {
                width: 100px;
                height: 100px;
                object-fit: cover;
                border-radius: 50%;
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
                
                <!-- Gắn file sidebar.jsp ở đây -->
                <jsp:include page="sidebar.jsp" />

                <!-- Main content area -->
                <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">
                    <div class="pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">Customer Management</h1>
                        <!-- Breadcrumb hiển thị đường dẫn -->
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb breadcrumb-custom">
                                <li class="breadcrumb-item active" aria-current="page">Customer Management</li>
                            </ol>
                        </nav>
                        <p>Manage customer information and view customer details below.</p>
                        <!-- Phần form tìm kiếm và sắp xếp -->
                        <form action="CustomerManager" method="get" class="form-inline mb-3">
                            <div class="form-group mr-2">
                                <label for="searchQuery" class="mr-2">Search:</label>
                                <input type="text" name="searchQuery" id="searchQuery" class="form-control" placeholder="Enter name or ID">
                            </div>
                            <div class="form-group mr-2">
                                <label for="searchBy" class="mr-2">By:</label>
                                <select name="searchBy" id="searchBy" class="form-control">
                                    <option value="id">ID</option>
                                    <option value="name">Name</option>
                                </select>
                            </div>
                            <div class="form-group mr-2">
                                <label for="sortBy" class="mr-2">Sort by:</label>
                                <select name="sortBy" id="sortBy" class="form-control">
                                    <option value="id">ID</option>
                                    <option value="name">Name</option>
                                </select>
                            </div>
                            <button type="submit" class="btn btn-primary">Search & Sort</button>
                        </form>
                    </div>

                    <!-- Hiển thị thông báo nếu không tìm thấy khách hàng -->
                    <c:choose>
                        <c:when test="${empty customerList}">
                            <div class="alert alert-warning" role="alert">
                                No customers found matching your search criteria.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- Customer table -->
                            <div class="table-responsive">
                                <table class="table table-striped table-sm">
                                    <thead>
                                        <tr>
                                            <th>Avatar</th>
                                            <th>ID</th>
                                            <th>Full Name</th>
                                            <th>Email</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="customer" items="${customerList}">
                                            <tr>
                                                <!-- Hiển thị Avatar -->
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty customer.avatar}">
                                                            <img src="${customer.avatar}" alt="Avatar" class="avatar-img"/>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <img src="image/avatarnull.jpg" alt="No Avatar" class="avatar-img"/>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>${customer.userId}</td>
                                                <td>${customer.fullName}</td>
                                                <td>${customer.email}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${customer.status == 1}">Active</c:when>
                                                        <c:otherwise>Inactive</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <a href="DetailCustomer?id=${customer.userId}" class="btn btn-sm btn-info">View</a>
                                                    <a href="EditCustomer?id=${customer.userId}" class="btn btn-sm btn-primary">Edit</a>
                                                    <a href="DeleteCustomer?id=${customer.userId}" 
                                                       class="btn btn-sm btn-danger"
                                                       onclick="return confirm('Bạn có chắc chắn muốn xóa khách hàng này không?');">
                                                        Delete
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
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
