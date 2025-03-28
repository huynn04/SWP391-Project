<%-- 
    Document   : DetailStaff.jsp
    Created on : Feb 17, 2025
    Author     : Nguyễn Ngoc Huy CE180178
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Staff Detail</title>
        <!-- Using Bootstrap 5 CDN for a more modern UI -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <style>
            body {
                background: linear-gradient(135deg, #f0f4f8 0%, #d9e2ec 100%);
                min-height: 100vh;
                margin: 0;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }
            .navbar {
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            }
            .sidebar {
                height: 100vh;
                padding-top: 20px;
                background: #ffffff;
                box-shadow: 2px 0 10px rgba(0, 0, 0, 0.05);
                position: sticky;
                top: 0;
            }
            .sidebar a {
                color: #495057;
                display: block;
                padding: 12px 20px;
                text-decoration: none;
                font-weight: 500;
                transition: all 0.3s ease;
            }
            .sidebar a:hover {
                background: #e9ecef;
                color: #007bff;
            }
            .main-content {
                padding: 2rem;
            }
            .avatar-img {
                width: 250px;
                height: 250px;
                object-fit: cover;
                border-radius: 15px;
                margin-bottom: 20px;
                border: 3px solid #e9ecef;
                transition: transform 0.3s ease;
            }
            .avatar-img:hover {
                transform: scale(1.05);
            }
            .staff-card {
                background: #ffffff;
                padding: 2rem;
                border-radius: 20px;
                box-shadow: 0 8px 30px rgba(0, 0, 0, 0.1);
                margin-bottom: 2rem;
                animation: fadeIn 0.5s ease-in-out;
            }
            @keyframes fadeIn {
                from { opacity: 0; transform: translateY(20px); }
                to { opacity: 1; transform: translateY(0); }
            }
            .staff-card h3 {
                margin-bottom: 1.5rem;
                border-bottom: 2px solid #e9ecef;
                padding-bottom: 0.75rem;
                font-size: 1.75rem;
                color: #343a40;
            }
            .staff-info p {
                margin: 0 0 12px;
                font-size: 1.1rem;
                color: #495057;
            }
            .staff-info p strong {
                width: 150px;
                display: inline-block;
                font-weight: 600;
                color: #212529;
            }
            .breadcrumb {
                background: transparent;
                padding: 0;
                margin-bottom: 1rem;
            }
            .breadcrumb-item a {
                color: #007bff;
                text-decoration: none;
            }
            .breadcrumb-item a:hover {
                text-decoration: underline;
            }
            h1.h2 {
                font-size: 2rem;
                color: #343a40;
                font-weight: 600;
            }
        </style>
    </head>
    <body>
        <!-- Top Navigation Bar -->
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
            <a class="navbar-brand" href="dashboard">Admin Dashboard</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarResponsive"
                    aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
        </nav>

        <div class="container-fluid">
            <div class="row">
                <jsp:include page="sidebar.jsp" />

                <!-- Main content area -->
                <main role="main" class="col-md-9 ml-sm-auto col-lg-10 main-content">
                    <div class="pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">Staff Detail</h1>
                        <!-- Breadcrumb -->
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item">
                                    <a href="StaffManager">Staff Management</a>
                                </li>
                                <li class="breadcrumb-item active" aria-current="page">Staff Detail</li>
                            </ol>
                        </nav>
                    </div>

                    <!-- Staff Information Card -->
                    <div class="staff-card">
                        <h3>Personal Information</h3>
                        <div class="row">
                            <div class="col-md-4 text-center">
                                <c:choose>
                                    <c:when test="${not empty staff.avatar}">
                                        <img src="${staff.avatar}" alt="Avatar" class="avatar-img"/>
                                    </c:when>
                                    <c:otherwise>
                                        <img src="image/avatarnull.jpg" alt="No Avatar" class="avatar-img"/>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="col-md-8 staff-info">
                                <p><strong>ID:</strong> ${staff.userId}</p>
                                <p><strong>Full Name:</strong> ${staff.fullName}</p>
                                <p><strong>Email:</strong> ${staff.email}</p>
                                <p><strong>Phone Number:</strong> ${staff.phoneNumber}</p>
                                <p><strong>Address:</strong> ${staff.address}</p>
                                <p>
                                    <strong>Status:</strong>
                                    <span class="badge ${staff.status == 1 ? 'bg-success' : 'bg-danger'} text-white">
                                        <c:choose>
                                            <c:when test="${staff.status == 1}">Active</c:when>
                                            <c:otherwise>Inactive</c:otherwise>
                                        </c:choose>
                                    </span>
                                </p>
                                <p>
                                    <strong>Role:</strong>
                                    <span class="badge ${staff.roleId == 2 ? 'bg-primary' : 'bg-secondary'} text-white">
                                        <c:choose>
                                            <c:when test="${staff.roleId == 2}">Staff</c:when>
                                            <c:otherwise>Other</c:otherwise>
                                        </c:choose>
                                    </span>
                                </p>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <!-- Bootstrap 5 scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://unpkg.com/feather-icons"></script>
        <script>
            feather.replace();
        </script>
    </body>
</html>