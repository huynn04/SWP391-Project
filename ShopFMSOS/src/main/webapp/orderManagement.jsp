<%-- 
    Document   : orderManagement
    Created on : Feb 18, 2025, 11:18:50 PM
    Author     : Nguyễn Ngoc Huy CE180178
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Order Management</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <h2 class="mb-4">Order Management</h2>
        
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Order ID</th>
                    <th>User</th>
                    <th>Total Price</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="order" items="${orders}">
                    <tr>
                        <td>${order.orderId}</td>
                        <td>${order.userId}</td>
                        <td>$<fmt:formatNumber value="${order.totalPrice}" type="currency" currencySymbol=""/></td>
                        <td>${order.status == 0 ? 'Pending' : 'Completed'}</td>
                        <td>
                            <a href="OrderDetail?orderId=${order.orderId}" class="btn btn-info btn-sm">View</a>
                            <a href="UpdateOrderStatus?orderId=${order.orderId}&status=1" class="btn btn-success btn-sm">Mark as Completed</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
