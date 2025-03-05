<%-- 
    Document   : dashboard
    Created on : Feb 16, 2025, 8:03:09 PM
    Author     : Nguyen Ngoc Huy CE180178
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="model.User" %>
<%
User loggedInUser = (User) session.getAttribute("loggedInUser");
if (loggedInUser == null || loggedInUser.getRoleId() != 1 && loggedInUser.getRoleId() != 2) {
    response.sendRedirect("home.jsp"); // Chuyển hướng nếu không phải admin
    return;
}
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Admin Dashboard</title>
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
                        <h1 class="h2">Admin Dashboard</h1>
                        <!-- Breadcrumb hiển thị đường dẫn -->
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb breadcrumb-custom">
                                <li class="breadcrumb-item active" aria-current="page">Dashboard</li>
                            </ol>
                        </nav>
                        <p>Welcome to the admin dashboard. Please select an option from the left menu to manage the system.</p>
                    </div>

                    <!-- Statistics cards -->
                    <div class="row">
                        <!-- Thẻ "Total Users" -->
                        <div class="col-md-3">
                            <div class="card text-white bg-primary mb-3">
                                <div class="card-header">Total Users</div>
                                <div class="card-body">
                                    <h5 class="card-title">${totalUsers}</h5>
                                </div>
                            </div>
                        </div>
                        <!-- Thẻ "Total Products" -->
                        <div class="col-md-3">
                            <div class="card text-white bg-warning mb-3">
                                <div class="card-header">Total Products</div>
                                <div class="card-body">
                                    <h5 class="card-title">${totalProducts}</h5>
                                </div>
                            </div>
                        </div>
                        <!-- Thẻ "Revenue" -->
                        <div class="col-md-3">
                            <div class="card text-white bg-danger mb-3">
                                <div class="card-header">Revenue</div>
                                <div class="card-body">
                                    <h5 class="card-title">
                                        $<fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol=""/>
                                    </h5>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>


        <!-- Bootstrap and required scripts -->
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
        <!-- Feather icons (optional) -->
        <script src="https://unpkg.com/feather-icons"></script>
        <script>
            feather.replace()
        </script>
    </body>
</html>
