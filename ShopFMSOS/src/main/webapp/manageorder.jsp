<%-- 
    Document   : manageorder
    Created on : Feb 24, 2025, 10:58:44 PM
    Author     : Dang Chi Vi CE182507
--%>
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Manage Orders</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
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
            .table-responsive {
                background: #fff;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                padding: 20px;
            }
            .btn-sm {
                padding: 5px 10px;
                border-radius: 5px;
            }
            .sort-container {
                margin-bottom: 20px;
                display: flex;
                justify-content: flex-end;
            }
            .form-select {
                width: 200px;
                padding: 8px;
                border-radius: 5px;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            }
            main {
                margin-left: 250px; /* Đẩy nội dung chính sang phải để không bị che bởi sidebar */
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
                <!-- Sidebar -->
                <nav class="col-md-3 col-lg-2 d-md-block sidebar">
                    <div class="sidebar-sticky">
                        <jsp:include page="sidebar.jsp" />
                    </div>
                </nav>

                <!-- Main content area -->
                <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">
                    <div class="pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">Manage Orders</h1>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb breadcrumb-custom">
                                <li class="breadcrumb-item active" aria-current="page">Order Management</li>
                            </ol>
                        </nav>
                    </div>

                    <!-- Buttons to navigate -->
                    <div class="mb-3">
                        <a href="TrackOrder" class="btn btn-info mr-2">Go to Track Orders</a>
                        <a href="Pending" class="btn btn-warning mr-2">Go to Pending</a>
                        <a href="CancelOrder" class="btn btn-danger">Go to Cancel</a>
                    </div>

                    <!-- Filter Section -->
                    <form action="ManageOrder" method="get" class="form-inline mb-3">
                        <label class="mr-2">Filter by:</label>
                        <div class="form-check mr-2">
                            <input class="form-check-input" type="radio" name="filterType" id="byDate" value="byDate">
                            <label class="form-check-label" for="byDate">Date</label>
                            <input type="text" name="filterValue" id="filterDate" placeholder="Choose a date" class="form-control ml-2" readonly />
                        </div>
                        <div class="form-check ml-3">
                            <input class="form-check-input" type="radio" name="filterType" id="byCustomerId" value="byCustomerId" checked>
                            <label class="form-check-label" for="byCustomerId">Customer ID</label>
                            <input type="number" name="filterValue" id="filterCustomerId" placeholder="Choose an ID" class="form-control ml-2" />
                        </div>
                        <button type="submit" class="btn btn-primary ml-3">Apply Filter</button>
                    </form>

                    <!-- Sorting Section -->
                    <div class="sort-container">
                        <form method="GET" action="ManageOrder">
                            <c:if test="${not empty param.filterType}">
                                <input type="hidden" name="filterType" value="${param.filterType}">
                                <input type="hidden" name="filterValue" value="${param.filterValue}">
                            </c:if>
                            <select name="sortOption" class="form-select" onchange="this.form.submit()">
                                <option value="total-asc" ${sortOption == 'total-asc' ? 'selected' : ''}>Total (Ascending)</option>
                                <option value="total-desc" ${sortOption == 'total-desc' ? 'selected' : ''}>Total (Descending)</option>
                            </select>
                        </form>
                    </div>

                    <!-- Orders Table -->
                    <div class="table-responsive">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>Total Price</th>
                                    <th>Order Date</th>
                                    <th>Status</th>
                                    <th>Receiver Name</th>
                                    <th>Receiver Address</th>
                                    <th>Receiver Phone</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="order" items="${orders}">
                                    <tr>
                                        <td>$${order.totalPrice}</td>
                                        <td>${order.orderDate}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${order.status == 0}">Pending</c:when>
                                                <c:when test="${order.status == 1}">Confirmed</c:when>
                                                <c:otherwise>Completed</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${order.receiverName}</td>
                                        <td>${order.receiverAddress}</td>
                                        <td>${order.receiverPhone}</td>
                                        <td>
                                            <a href="AdminViewOrderDetail?orderId=${order.orderId}" class="btn btn-primary btn-sm">View Order Detail</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </main>
            </div>
        </div>

        <!-- jQuery và jQuery UI -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
        <!-- Bootstrap và Popper -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
        <!-- Feather Icons -->
        <script src="https://unpkg.com/feather-icons"></script>
        <script>
            $(document).ready(function () {
                feather.replace();
                $("#filterDate").datepicker({
                    dateFormat: "yy-mm-dd",
                    changeMonth: true,
                    changeYear: true,
                    showButtonPanel: true
                }).prop("disabled", true);

                $("input[name='filterType']").change(function () {
                    let selectedFilter = $("input[name='filterType']:checked").val();
                    if (selectedFilter === "byDate") {
                        $("#filterDate").prop("disabled", false).focus();
                        $("#filterCustomerId").prop("disabled", true);
                    } else {
                        $("#filterCustomerId").prop("disabled", false).focus();
                        $("#filterDate").prop("disabled", true);
                    }
                });

                $("#filterCustomerId").prop("disabled", false);
                $("#filterDate").prop("disabled", true);
            });
        </script>
    </body>
</html>