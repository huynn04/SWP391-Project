<%-- 
    Document   : StaffManager.jsp
    Created on : Feb 16, 2025, 10:19:26 PM
    Author     : Nguyễn Ngoc Huy CE180178
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Staff Management</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
        <style>
            body {
                padding-top: 56px;
                background: #f0f2f5;
                font-family: 'Roboto', sans-serif;
            }
            .sidebar {
                height: 100vh;
                padding-top: 20px;
                background-color: #f8f9fa;
                position: fixed;
                width: 250px;
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
            main {
                margin-left: 250px;
            }
            .search-container, .sort-container {
                margin-bottom: 20px;
                display: flex;
                justify-content: flex-start;
                gap: 15px;
            }
            .form-select, .form-control {
                border-radius: 5px;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            }
            .table-responsive {
                background: #fff;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                padding: 20px;
            }
        </style>
    </head>
    <body>
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
            <a class="navbar-brand" href="dashboard">Admin Dashboard</a>
        </nav>
        <div class="container-fluid">
            <div class="row">
                <nav class="col-md-3 col-lg-2 d-md-block sidebar">
                    <div class="sidebar-sticky">
                        <jsp:include page="sidebar.jsp" />
                    </div>
                </nav>

                <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">
                    <div class="pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">Staff Management</h1>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item active" aria-current="page">Staff Management</li>
                            </ol>
                        </nav>
                        <p>Manage staff information and view staff details below.</p>
                        <div class="mb-3">
                            <button type="button" class="btn btn-success" data-toggle="modal" data-target="#addStaffModal">
                                <span class="plus-icon">+</span> Add Staff
                            </button>
                        </div>

                        <div class="modal fade" id="addStaffModal" tabindex="-1" role="dialog" aria-labelledby="addStaffModalLabel" aria-hidden="true">
                            <div class="modal-dialog" role="document">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="addStaffModalLabel">Add Staff</h5>
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">×</span>
                                        </button>
                                    </div>
                                    <div class="modal-body">
                                        Please choose one of the options below:
                                    </div>
                                    <div class="modal-footer">
                                        <a href="SelectStaff" class="btn btn-primary">Select from the list</a>
                                        <a href="CreateStaff" class="btn btn-success">Create new Staff</a>
                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Search Section -->
                    <div class="search-container">
                        <form action="StaffManager" method="get" class="form-inline">
                            <label for="searchQuery" class="mr-2">Search:</label>
                            <input type="text" name="searchQuery" id="searchQuery" class="form-control mr-2" placeholder="Enter name" value="${param.searchQuery}">
                            <input type="hidden" name="searchBy" value="name"> <!-- Always search by name -->
                            <c:if test="${not empty param.sortOption}">
                                <input type="hidden" name="sortOption" value="${param.sortOption}">
                            </c:if>
                            <button type="submit" class="btn btn-primary">Search</button>
                        </form>
                    </div>


                    <!-- Sort Section -->
                    <div class="sort-container">
                        <form action="StaffManager" method="get" class="form-inline">
                            <label for="sortOption" class="mr-2">Sort by:</label>
                            <select name="sortOption" id="sortOption" class="form-select" onchange="this.form.submit()">
                                <option value="name-asc" ${sortOption == 'name-asc' ? 'selected' : ''}>Name (A-Z)</option>
                                <option value="name-desc" ${sortOption == 'name-desc' ? 'selected' : ''}>Name (Z-A)</option>
                                <option value="email-asc" ${sortOption == 'email-asc' ? 'selected' : ''}>Email (A-Z)</option>
                                <option value="email-desc" ${sortOption == 'email-desc' ? 'selected' : ''}>Email (Z-A)</option>
                            </select>
                            <c:if test="${not empty param.searchQuery}">
                                <input type="hidden" name="searchQuery" value="${param.searchQuery}">
                                <input type="hidden" name="searchBy" value="${param.searchBy}">
                            </c:if>
                        </form>
                    </div>

                    <c:choose>
                        <c:when test="${empty staffList}">
                            <div class="alert alert-warning" role="alert">
                                No staff found matching your search criteria.
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
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="staff" items="${staffList}">
                                            <tr>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty staff.avatar}">
                                                            <img src="${staff.avatar}" alt="Avatar" class="avatar-img"/>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <img src="image/avatarnull.jpg" alt="No Avatar" class="avatar-img"/>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>${staff.userId}</td>
                                                <td>${staff.fullName}</td>
                                                <td>${staff.email}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${staff.status == 1}">Active</c:when>
                                                        <c:otherwise>Inactive</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${staff.roleId == 2}">Staff</c:when>
                                                        <c:otherwise>Other</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <a href="DetailStaff?id=${staff.userId}" class="btn btn-sm btn-info">View</a>
                                                    <a href="EditStaff?id=${staff.userId}" class="btn btn-sm btn-primary">Edit</a>
                                                    <a href="DeleteStaff?id=${staff.userId}" 
                                                       class="btn btn-sm btn-warning"
                                                       onclick="return confirm('Are you sure you want to convert this staff member to a regular customer?');">
                                                        Convert to Customer
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

        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
        <script src="https://unpkg.com/feather-icons"></script>
        <script>
                                                           feather.replace();
        </script>
    </body>
</html>