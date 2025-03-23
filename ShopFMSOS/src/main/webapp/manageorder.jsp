<%-- 
    Document   : manageorder
    Created on : Feb 24, 2025, 10:58:44 PM
    Author     : Dang Chi Vi CE182507
--%>
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Manage Orders</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
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
                        <h1 class="h2">Manage Orders</h1>
                        <!-- Breadcrumb hiển thị đường dẫn -->
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb breadcrumb-custom">
                                <li class="breadcrumb-item active" aria-current="page">Order Management</li>
                            </ol>
                        </nav>
                    </div>

                    <!-- Buttons to navigate to Track Orders, Pending, and Cancel -->
                    <div class="mb-3">
                        <a href="TrackOrder" class="btn btn-info mr-2">Go to Track Orders</a>
                        <a href="Pending" class="btn btn-warning mr-2">Go to Pending</a>
                        <a href="CancelOrder" class="btn btn-danger">Go to Cancel</a>
                    </div>

                    <!-- Filter Section -->
                    <form action="ManageOrder" method="get" class="form-inline mb-3">
                        <label class="mr-2">Filter by:</label>

                        <!-- Radio for Date -->
                        <div class="form-check mr-2">
                            <input class="form-check-input" type="radio" name="filterType" id="byDate" value="byDate">
                            <label class="form-check-label" for="byDate">Date</label>
                            <input type="text" name="filterValue" id="filterDate" placeholder="Choose a date" class="form-control ml-2" readonly />
                        </div>

                        <!-- Radio for Customer ID -->
                        <div class="form-check ml-3">
                            <input class="form-check-input" type="radio" name="filterType" id="byCustomerId" value="byCustomerId" checked>
                            <label class="form-check-label" for="byCustomerId">Customer ID</label>
                            <input type="number" name="filterValue" id="filterCustomerId" placeholder="Choose an ID" class="form-control ml-2" />
                        </div>

                        <button type="submit" class="btn btn-primary ml-3">Apply Filter</button>
                    </form>

                    <!-- Orders Table -->
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>Customer ID</th>
                                <th>Total Price</th>
                                <th>Order Date</th>
                                <th>Status</th>
                                <th>Receiver Name</th>
                                <th>Receiver Address</th>
                                <th>Receiver Phone</th>
                                <th>Action</th> <!-- Thêm cột Action -->
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="order" items="${orders}">
                                <tr>
                                    <td>${order.orderId}</td>
                                    <td>${order.userId}</td>
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
                                        <!-- Nút View Order Detail -->
                                        <a href="ViewOrderDetail?orderId=${order.orderId}" class="btn btn-primary btn-sm">View Order Detail</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
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
                feather.replace(); // Khởi tạo icon

                // Initialize Datepicker
                $("#filterDate").datepicker({
                    dateFormat: "yy-mm-dd",
                    changeMonth: true,
                    changeYear: true,
                    showButtonPanel: true
                }).prop("disabled", true);

                // Handle radio button change
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

                // Initialize with Customer ID enabled and Date disabled
                $("#filterCustomerId").prop("disabled", false);
                $("#filterDate").prop("disabled", true);
            });
        </script>

    </body>

</html>
