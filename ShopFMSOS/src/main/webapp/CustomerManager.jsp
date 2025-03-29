<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Customer Management</title>
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
                    <h1 class="h2">Customer Management</h1>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item active" aria-current="page">Customer Management</li>
                        </ol>
                    </nav>
                    <p>Manage customer information and view customer details below.</p>

                    <div class="modal fade" id="addCustomerModal" tabindex="-1" role="dialog" aria-labelledby="addCustomerModalLabel" aria-hidden="true">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="addCustomerModalLabel">Add Customer</h5>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                                <div class="modal-body">
                                    Please choose one of the options below:
                                </div>
                                <div class="modal-footer">
                                    <a href="SelectCustomer" class="btn btn-primary">Select from the list</a>
                                    <a href="CreateCustomer" class="btn btn-success">Create new Customer</a>
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Search Section -->
                <div class="search-container">
                    <form action="CustomerManager" method="get" class="form-inline">
                        <label for="searchQuery" class="mr-2">Search:</label>
                        <input type="text" name="searchQuery" id="searchQuery" class="form-control mr-2" placeholder="Enter name" value="${param.searchQuery}">
                        <input type="hidden" name="searchBy" value="name">
                        <c:if test="${not empty param.sortOption}">
                            <input type="hidden" name="sortOption" value="${param.sortOption}">
                        </c:if>
                        <button type="submit" class="btn btn-primary">Search</button>
                    </form>
                </div>

                <!-- Sort Section -->
                <div class="sort-container">
                    <form action="CustomerManager" method="get" class="form-inline">
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
                    <c:when test="${empty customerList}">
                        <div class="alert alert-warning" role="alert">
                            No customers found matching your search criteria.
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
                                        <th>Actions</th>
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
                                                <a href="DetailCustomer?id=${customer.userId}" class="btn btn-sm btn-info">View</a>
                                                <a href="EditCustomer?id=${customer.userId}" class="btn btn-sm btn-primary">Edit</a>
                                                <c:choose>
                                                    <c:when test="${customer.status == 1}">
                                                        <a href="ChangeStatusCustomer?id=${customer.userId}" 
                                                           class="btn btn-sm btn-danger"
                                                           onclick="return confirm('Are you sure you want to disable this account?');">
                                                            Disable
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="ChangeStatusCustomer?id=${customer.userId}" 
                                                           class="btn btn-sm btn-success"
                                                           onclick="return confirm('Are you sure you want to restore this account?');">
                                                            Restore
                                                        </a>
                                                    </c:otherwise>
                                                </c:choose>
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