<%-- 
    Document   : detailCustomer
    Created on : Feb 16, 2025, 10:49:54 PM
    Author     : Nguyễn Ngoc Huy CE180178
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Customer Detail</title>
        <!-- Using Bootstrap CDN for UI -->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
        <style>
            body {
                padding-top: 56px;
                background-color: #f2f2f2;
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
            .avatar-img {
                width: 300px;
                height: 300px;
                object-fit: cover;
                border-radius: 15px;
                margin-bottom: 20px;
            }
            .detail-section {
                margin-bottom: 30px;
            }
            /* Thêm style cho card hiển thị thông tin khách hàng */
            .customer-card {
                background: #fff;
                padding: 20px;
                border-radius: 15px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
                margin-bottom: 30px;
            }
            .customer-card h3 {
                margin-bottom: 20px;
                border-bottom: 1px solid #e5e5e5;
                padding-bottom: 10px;
            }
            .customer-info p {
                margin: 0 0 10px;
                font-size: 16px;
            }
            .customer-info p strong {
                width: 130px;
                display: inline-block;
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
                        <h1 class="h2">Customer Detail</h1>
                        <!-- Breadcrumb hiển thị đường dẫn -->
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb breadcrumb-custom">
                                <li class="breadcrumb-item">
                                    <a href="CustomerManager">Customer Management</a>
                                </li>
                                <li class="breadcrumb-item active" aria-current="page">Customer Detail</li>
                            </ol>
                        </nav>
                    </div>

                    <!-- Thông tin khách hàng được hiển thị ở giữa bằng thẻ card -->
                    <div class="customer-card">
                        <h3>Thông tin cá nhân</h3>
                        <div class="row">
                            <div class="col-md-4 text-center">
                                <c:choose>
                                    <c:when test="${not empty customer.avatar}">
                                        <img src="${customer.avatar}" alt="Avatar" class="avatar-img"/>
                                    </c:when>
                                    <c:otherwise>
                                        <img src="image/avatarnull.jpg" alt="No Avatar" class="avatar-img"/>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="col-md-8 customer-info">
                                <p><strong>ID:</strong> ${customer.userId}</p>
                                <p><strong>Họ và tên:</strong> ${customer.fullName}</p>
                                <p><strong>Email:</strong> ${customer.email}</p>
                                <p><strong>Số điện thoại:</strong> ${customer.phoneNumber}</p>
                                <p><strong>Địa chỉ:</strong> ${customer.address}</p>
                                <p>
                                    <strong>Trạng thái:</strong>
                                    <c:choose>
                                        <c:when test="${customer.status == 1}">Active</c:when>
                                        <c:otherwise>Inactive</c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                        </div>
                    </div>

                    <!-- Lịch sử mua hàng -->
                    <div class="detail-section">
                        <h3>Lịch sử mua hàng</h3>
                        <c:if test="${not empty orderList}">
                            <table class="table table-striped table-sm">
                                <thead>
                                    <tr>
                                        <th>Mã đơn hàng</th>
                                        <th>Ngày đặt</th>
                                        <th>Tổng tiền</th>
                                        <th>Trạng thái</th>
                                        <th>Phương thức thanh toán</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="order" items="${orderList}">
                                        <tr>
                                            <td>${order.orderId}</td>
                                            <td><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                            <td>$<fmt:formatNumber value="${order.totalPrice}" type="number" minFractionDigits="2"/></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${order.status == 0}">Chưa xử lý</c:when>
                                                    <c:when test="${order.status == 1}">Đã xử lý</c:when>
                                                    <c:otherwise>Khác</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${order.paymentMethod}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:if>
                        <c:if test="${empty orderList}">
                            <p>Khách hàng chưa có đơn hàng nào.</p>
                        </c:if>
                    </div>
                </main>
            </div>
        </div>

        <!-- Bootstrap and required scripts -->
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
        <script src="https://unpkg.com/feather-icons"></script>
        <script>
            feather.replace();
        </script>
    </body>
</html>
