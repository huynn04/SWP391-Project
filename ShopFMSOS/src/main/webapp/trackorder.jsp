<%-- 
    Document   : trackorder
    Created on : Feb 24, 2025, 4:44:21 PM
    Author     : Dang Chi Vi CE182507
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Tracked Orders - Admin Dashboard</title>
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
            .switch-btn {
                margin-bottom: 15px;
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
                <nav class="col-md-2 d-none d-md-block sidebar">
                    <div class="sidebar-sticky">
                        <ul class="nav flex-column">
                            <li class="nav-item"><a class="nav-link" href="home.jsp"><span data-feather="home"></span> Home</a></li>
                            <li class="nav-item"><a class="nav-link" href="CustomerManager"><span data-feather="users"></span> Manage Customers</a></li>
                            <li class="nav-item"><a class="nav-link" href="StaffManager"><span data-feather="user"></span> Manage Staff</a></li>
                            <li class="nav-item"><a class="nav-link" href="#"><span data-feather="shopping-cart"></span> Manage Products</a></li>
                            <li class="nav-item"><a class="nav-link active" href="/TrackOrder"><span data-feather="clipboard"></span> Manage Orders</a></li>
                            <li class="nav-item"><a class="nav-link" href="#"><span data-feather="file-text"></span> Manage News</a></li>
                            <li class="nav-item"><a class="nav-link" href="SalesStatistics"><span data-feather="bar-chart-2"></span> Sales Statistics</a></li>
                            <li class="nav-item"><a class="nav-link" href="#"><span data-feather="log-out"></span> Log Out</a></li>
                        </ul>
                    </div>
                </nav>

                <!-- Main content -->
                <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">
                    <div class="pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">Tracked Orders</h1>
                    </div>

                    <!-- Switch Button -->
                    <a href="Pending" class="btn btn-secondary switch-btn">Go to Pending Orders</a>

                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>Receiver Name</th>
                                <th>Receiver Address</th>
                                <th>Receiver Phone</th>
                                <th>Total Price</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="order" items="${trackedOrders}">
                                <tr>
                                    <td>${order.orderId}</td>
                                    <td>${order.receiverName}</td>
                                    <td>${order.receiverAddress}</td>
                                    <td>${order.receiverPhone}</td>
                                    <td>${order.totalPrice}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${order.status == 1}">Confirmed</c:when>
                                            <c:otherwise>Pending</c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </main>
            </div>
        </div>

        <!-- Bootstrap and Feather icons -->
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
        <script src="https://unpkg.com/feather-icons"></script>
        <script>feather.replace()</script>
    </body>
</html>
