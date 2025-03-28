<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Discount Management</title>
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
        <!-- Navigation Bar -->
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

                <!-- Main Content -->
                <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">
                    <div class="pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">Discount Management</h1>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item active" aria-current="page">Discount Management</li>
                            </ol>
                        </nav>

                        <form action="AddDiscount" method="post">
                            <button type="submit" class="btn btn-success mb-3">Add New Discount</button>
                        </form>

                        <form action="ManageDiscount" method="get" class="form-inline mb-3">
                            <div class="form-group mr-2">
                                <label for="searchQuery" class="mr-2">Search:</label>
                                <input type="text" name="searchQuery" id="searchQuery" class="form-control" placeholder="Enter code or discount value" value="${param.searchQuery}">
                            </div>
                            <div class="form-group mr-2">
                                <label for="searchBy" class="mr-2">Search By:</label>
                                <select name="searchBy" id="searchBy" class="form-control">
                                    <option value="code" ${param.searchBy == 'code' ? 'selected' : ''}>Code</option>
                                    <option value="discountValue" ${param.searchBy == 'discountValue' ? 'selected' : ''}>Discount Value</option>
                                    <option value="expiryDate" ${param.searchBy == 'expiryDate' ? 'selected' : ''}>Expiry Date</option>
                                </select>
                            </div>
                            <div class="form-group mr-2">
                                <label for="sortBy" class="mr-2">Sort By:</label>
                                <select name="sortBy" id="sortBy" class="form-control">
                                    <option value="code" ${param.sortBy == 'code' ? 'selected' : ''}>Code</option>
                                    <option value="discountValue" ${param.sortBy == 'discountValue' ? 'selected' : ''}>Discount Value</option>
                                    <option value="expiryDate" ${param.sortBy == 'expiryDate' ? 'selected' : ''}>Expiry Date</option>
                                </select>
                            </div>
                            <button type="submit" class="btn btn-primary">Search & Sort</button>
                        </form>
                    </div>

                    <!-- Display Discount List -->
                    <c:choose>
                        <c:when test="${empty discountList}">
                            <div class="alert alert-warning">No discounts found.</div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-striped">
                                    <!-- Phần thead của bảng -->
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Code</th>
                                            <th>Discount Value</th>
                                            <th>Discount Type</th>
                                            <th>Minimum Order Value</th>
                                            <th>Expiry Date</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>

                                    <!-- Phần tbody của bảng -->
                                    <tbody>
                                        <c:forEach var="discount" items="${discountList}">
                                            <tr>
                                                <!-- Cột ID hiển thị discountId -->
                                                <td>${discount.discountId}</td>

                                                <!-- Các cột cũ giữ nguyên -->
                                                <td>${discount.code}</td>
                                                <td>${discount.discountValue}</td>
                                                <td>${discount.discountType}</td>
                                                <td>${discount.minOrderValue}</td>
                                                <td>${discount.expiryDate}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${discount.status == 1}">Active</c:when>
                                                        <c:otherwise>Inactive</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <a href="EditDiscount?id=${discount.discountId}" class="btn btn-primary btn-sm">Edit</a>
                                                    <a href="DeleteDiscount?id=${discount.discountId}" 
                                                       class="btn btn-danger btn-sm"
                                                       onclick="return confirm('Are you sure you want to delete this discount?');">
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

        <!-- Bootstrap JS -->
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
    </body>
</html>
