<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Discount Management</title>
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
            .modal-header, .modal-footer {
                text-align: center;
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
                        <h1 class="h2">Discount Management</h1>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item active" aria-current="page">Discount Management</li>
                            </ol>
                        </nav>
                        <p>Manage your discounts below.</p>
                        <div class="mb-3">
                            <button type="button" class="btn btn-success" data-toggle="modal" data-target="#addDiscountModal">
                                <span class="plus-icon">+</span> Add Discount
                            </button>
                        </div>

                        <!-- Add Discount Modal -->
                        <div class="modal fade" id="addDiscountModal" tabindex="-1" role="dialog" aria-labelledby="addDiscountModalLabel" aria-hidden="true">
                            <div class="modal-dialog" role="document">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="addDiscountModalLabel">Add Discount</h5>
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">×</span>
                                        </button>
                                    </div>
                                    <div class="modal-body">
                                        Please choose one of the options below:
                                    </div>
                                    <div class="modal-footer">
                                        <a href="AddDiscount" class="btn btn-primary">Create New Discount</a>
                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Search Section -->
                    <div class="search-container">
                        <form action="ManageDiscount" method="get" class="form-inline">
                            <label for="searchQuery" class="mr-2">Search:</label>
                            <input type="text" name="searchQuery" id="searchQuery" class="form-control mr-2" placeholder="Enter code or discount value" value="${param.searchQuery}">
                            <select name="searchBy" id="searchBy" class="form-control mr-2">
                                <option value="code" ${param.searchBy == 'code' ? 'selected' : ''}>Code</option>
                                <option value="discountValue" ${param.searchBy == 'discountValue' ? 'selected' : ''}>Discount Value</option>
                                <option value="expiryDate" ${param.searchBy == 'expiryDate' ? 'selected' : ''}>Expiry Date</option>
                            </select>
                            <button type="submit" class="btn btn-primary">Search</button>
                        </form>
                    </div>

                    <!-- Sort Section -->
                    <div class="sort-container">
                        <form action="ManageDiscount" method="get" class="form-inline">
                            <label for="sortBy" class="mr-2">Sort by:</label>
                            <select name="sortBy" id="sortBy" class="form-select" onchange="this.form.submit()">
                                <option value="code-asc" ${param.sortBy == 'code-asc' ? 'selected' : ''}>Code A-Z</option>
                                <option value="code-desc" ${param.sortBy == 'code-desc' ? 'selected' : ''}>Code Z-A</option>
                                <option value="discountValue-asc" ${param.sortBy == 'discountValue-asc' ? 'selected' : ''}>Discount Value Descending</option>
                                <option value="discountValue-desc" ${param.sortBy == 'discountValue-desc' ? 'selected' : ''}>Discount Value Ascending</option>
                                <option value="expiryDate-asc" ${param.sortBy == 'expiryDate-asc' ? 'selected' : ''}>Short Expiry Date</option>
                                <option value="expiryDate-desc" ${param.sortBy == 'expiryDate-desc' ? 'selected' : ''}>Long Expiry Date</option>
                            </select>
                        </form>
                    </div>

                    <c:choose>
                        <c:when test="${empty discountList}">
                            <div class="alert alert-warning" role="alert">
                                No discounts found matching your search criteria.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-striped table-sm">
                                    <thead>
                                        <tr>
                                            <th>Code</th>
                                            <th>Discount Value</th>
                                            <th>Discount Type</th>
                                            <th>Minimum Order Value</th>
                                            <th>Expiry Date</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="discount" items="${discountList}">
                                            <tr>
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
                                                    <a href="EditDiscount?id=${discount.discountId}" class="btn btn-sm btn-primary">Edit</a>
                                                    <a href="DeleteDiscount?id=${discount.discountId}" 
                                                       class="btn btn-sm btn-danger"
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

        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
