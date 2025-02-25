<%-- 
    Document   : salesStatistics
    Created on : Feb 18, 2025, 11:10:17 PM
    Author     : Nguyễn Ngoc Huy CE180178
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Sales Statistics Dashboard</title>
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
                <!-- Sidebar with menu options -->
                <nav class="col-md-2 d-none d-md-block sidebar">
                    <div class="sidebar-sticky">
                        <ul class="nav flex-column">
                            <li class="nav-item">
                                <a class="nav-link active" href="home.jsp">
                                    <span data-feather="home"></span>
                                    Home
                                </a>
                            </li>
                            <!-- Các menu khác -->
                            <li class="nav-item">
                                <a class="nav-link" href="CustomerManager">
                                    <span data-feather="users"></span>
                                    Manage Customers
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="StaffManager">
                                    <span data-feather="user"></span>
                                    Manage Staff
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#">
                                    <span data-feather="shopping-cart"></span>
                                    Manage Products
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#">
                                    <span data-feather="file-text"></span>
                                    Manage News
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#">
                                    <span data-feather="bar-chart-2"></span>
                                    Sales Statistics
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="#">
                                    <span data-feather="log-out"></span>
                                    Log Out
                                </a>
                            </li>
                        </ul>
                    </div>
                </nav>

            <!-- Main content area -->
            <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">
                <div class="pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Sales Statistics</h1>
                    <p>Below are the latest statistics and sales data.</p>
                </div>

                <!-- Statistics cards -->
                <div class="row">
                    <!-- Card "Total Revenue" -->
                    <div class="col-md-3">
                        <div class="card text-white bg-success mb-3">
                            <div class="card-header">Total Revenue</div>
                            <div class="card-body">
                                <h5 class="card-title">
                                    $<fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol=""/>
                                </h5>
                            </div>
                        </div>
                    </div>

                    <!-- Card "Recent Orders" -->
                    <div class="col-md-3">
                        <div class="card text-white bg-info mb-3">
                            <div class="card-header">Recent Orders</div>
                            <div class="card-body">
                                <h5 class="card-title">Orders in Last Week</h5>
                                <p>10 Orders</p>
                            </div>
                        </div>
                    </div>

                    <!-- Card "Pending Orders" -->
                    <div class="col-md-3">
                        <div class="card text-white bg-warning mb-3">
                            <div class="card-header">Pending Orders</div>
                            <div class="card-body">
                                <h5 class="card-title">5 Pending</h5>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Orders Table -->
                <h3 class="mt-5">Recent Orders</h3>
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>Total Price</th>
                            <th>Order Date</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="order" items="${orders}">
                            <tr>
                                <td>${order.orderId}</td>
                                <td>$<fmt:formatNumber value="${order.totalPrice}" type="currency" currencySymbol=""/></td>
                                <td><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                <td>${order.status == 0 ? 'Pending' : 'Completed'}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </main>
        </div>
    </div>

    <!-- Bootstrap and required scripts -->
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
</body>
</html>
