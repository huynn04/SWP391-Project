<%-- 
    Document   : cancelOrder
    Created on : Feb 28, 2025, 7:54:29 AM
    Author     : Dang Chi Vi CE182507
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Cancelled Orders - Admin Dashboard</title>
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
    </nav>

    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <jsp:include page="sidebar.jsp" />

            <!-- Main content area -->
            <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">
                <div class="pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Cancelled Orders</h1>
                </div>

                <!-- Orders Table -->
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>Receiver Name</th>
                            <th>Receiver Address</th>
                            <th>Receiver Phone</th>
                            <th>Total Price</th>
                            <th>Cancelled At</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="order" items="${cancelledOrders}">
                            <tr>
                                <td>${order.orderId}</td>
                                <td>${order.receiverName}</td>
                                <td>${order.receiverAddress}</td>
                                <td>${order.receiverPhone}</td>
                                <td>${order.totalPrice}</td>
                                <td>${order.canceledAt}</td>
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


