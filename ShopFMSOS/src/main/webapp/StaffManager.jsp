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
        <!-- Navigation, Sidebar ... (tương tự như CustomerManager.jsp) -->
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
            <a class="navbar-brand" href="dashboard">Admin Dashboard</a>
            <!-- ... -->
        </nav>
        <div class="container-fluid">
            <div class="row">
                <jsp:include page="sidebar.jsp" />

                <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">
                    <div class="pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">Staff Management</h1>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item active" aria-current="page">Staff Management</li>
                            </ol>
                        </nav>
                        <p>Manage staff information and view staff details below.</p>
                        <!-- Nút Add Staff -->
                        <div class="mb-3">
                            <button type="button" class="btn btn-success" data-toggle="modal" data-target="#addStaffModal">
                                <span class="plus-icon">+</span> Add Staff
                            </button>
                        </div>

                        <!-- Modal chọn lựa -->
                        <div class="modal fade" id="addStaffModal" tabindex="-1" role="dialog" aria-labelledby="addStaffModalLabel" aria-hidden="true">
                            <div class="modal-dialog" role="document">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="addStaffModalLabel">Add Staff</h5>
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                    <div class="modal-body">
                                        Vui lòng chọn một trong các lựa chọn bên dưới:
                                    </div>
                                    <div class="modal-footer">
                                        <!-- Nút chọn từ danh sách có sẵn -->
                                        <a href="SelectStaff" class="btn btn-primary">Chọn từ danh sách</a>
                                        <!-- Nút tạo nhân viên mới -->
                                        <a href="CreateStaff" class="btn btn-success">Tạo mới Staff</a>
                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                                    </div>
                                </div>
                            </div>
                        </div>


                        <!-- Form tìm kiếm & sắp xếp -->
                        <!-- CHỈNH SỬA: action đổi thành "StaffManager" -->
                        <form action="StaffManager" method="get" class="form-inline mb-3">
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
    </body>
</html>
