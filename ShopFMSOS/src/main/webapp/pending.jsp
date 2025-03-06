<%-- 
    Document   : pending
    Created on : Feb 24, 2025, 4:39:37 PM
    Author     : Dang Chi Vi CE182507
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Pending Orders - Admin Dashboard</title>
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
    </nav>

    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <jsp:include page="sidebar.jsp" />

            <!-- Main content area -->
            <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">
                <div class="pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Pending Orders</h1>
                </div>

                <!-- Buttons to navigate to Track Orders and Pending -->
                <div class="mb-3">
                    <a href="TrackOrder" class="btn btn-info mr-2">Go to Tracked Orders</a>
                    <a href="CancelOrder" class="btn btn-warning">Go to Cancelled Orders</a>
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
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="order" items="${pendingOrders}">
                            <tr>
                                <td>${order.orderId}</td>
                                <td>${order.receiverName}</td>
                                <td>${order.receiverAddress}</td>
                                <td>${order.receiverPhone}</td>
                                <td>${order.totalPrice}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${order.status == 0}">
                                            <!-- Nút xác nhận đơn hàng -->
                                            <form action="Pending" method="post" style="display:inline;">
                                                <input type="hidden" name="orderId" value="${order.orderId}" />
                                                <button type="submit" name="action" value="confirm" class="btn btn-success btn-sm">Confirm</button>
                                            </form>
                                            <!-- Nút hủy đơn hàng -->
                                            <form action="CancelOrder" method="post" style="display:inline;">
                                                <input type="hidden" name="orderId" value="${order.orderId}" />
                                                <button type="submit" name="action" value="cancel" class="btn btn-danger btn-sm">Cancel</button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <!-- Đơn hàng đã được xác nhận hoặc hủy -->
                                            <c:choose>
                                                <c:when test="${order.status == 1}">Confirmed</c:when>
                                                <c:when test="${order.status == -1}">Cancelled</c:when>
                                                <c:otherwise>Completed</c:otherwise>
                                            </c:choose>
                                        </c:otherwise>
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


