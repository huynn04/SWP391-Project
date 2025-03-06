<%-- 
    Document   : SelectStaff.jsp
    Created on : Feb 17, 2025, 10:54:31 AM
    Author     : Nguyễn Ngoc Huy CE180178
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Select Customer for Promotion</title>
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
            .avatar-img {
                width: 100px;
                height: 100px;
                object-fit: cover;
                border-radius: 50%;
            }
        </style>
    </head>
    <body>
        <!-- Navigation, Sidebar ... (có thể tái sử dụng chung với các trang khác) -->
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
            <a class="navbar-brand" href="dashboard">Admin Dashboard</a>
        </nav>
        <div class="container-fluid">
            <div class="row">
                <jsp:include page="sidebar.jsp" />
                
                <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">
                    <div class="pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">Select Customer for Promotion</h1>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="StaffManager">Staff Management</a></li>
                                <li class="breadcrumb-item active" aria-current="page">Select Customer</li>
                            </ol>
                        </nav>
                        <!-- Form tìm kiếm & sắp xếp -->
                        <form action="SelectStaff" method="get" class="form-inline mb-3">
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
                    <c:choose>
                        <c:when test="${empty customerList}">
                            <div class="alert alert-warning" role="alert">
                                No customer found.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-striped table-sm">
                                    <thead>
                                        <tr>
                                            <th>Avatar</th>
                                            <th>ID</th>
                                            <th>Full Name</th>
                                            <th>Email</th>
                                            <th>Status</th>
                                            <th>Role</th>
                                            <th>Select</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="customer" items="${customerList}">
                                            <tr>
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
                                                    <c:choose>
                                                        <c:when test="${customer.roleId == 3}">Customer</c:when>
                                                        <c:otherwise>Other</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <!-- Khi chọn, chuyển đến SelectStaff servlet với tham số selectedId -->
                                                    <a href="SelectStaff?selectedId=${customer.userId}" class="btn btn-sm btn-primary">Select</a>
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
    </body>
</html>
