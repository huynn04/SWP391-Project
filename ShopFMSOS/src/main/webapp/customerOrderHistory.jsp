<%-- 
    Document   : customerOrderHistory
    Created on : Mar 6, 2025, 3:52:18 AM
    Author     : Dang Chi Vi CE182507
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List, model.Order" %>

<jsp:useBean id="orders" type="java.util.List<model.Order>" scope="request"/>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Lịch sử đơn hàng</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                background-color: #f8f9fa;
                padding: 20px;
            }
            .container {
                max-width: 900px;
                background: white;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            }
        </style>
    </head>
    <body>
        <div class="container mt-4">
            <h2 class="mb-4 text-center">Lịch sử đơn hàng của bạn</h2>

            <% if (orders.isEmpty()) { %>
            <div class="alert alert-warning text-center" role="alert">
                Bạn chưa có đơn hàng nào.
            </div>
            <% } else { %>
            <table class="table table-striped table-bordered">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Ngày đặt</th>
                        <th>Tổng tiền</th>
                        <th>Trạng thái</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Order order : orders) {%>
                    <tr>
                        <td><%= order.getOrderId()%></td>
                        <td><%= order.getOrderDate()%></td>
                        <td><%= order.getTotalPrice()%> VNĐ</td>
                        <td>
                            <% if (order.getStatus() == 0) { %>
                            <span class="badge bg-warning">Chờ xử lý</span>
                            <% } else if (order.getStatus() == 1) { %>
                            <span class="badge bg-primary">Đang giao</span>
                            <% } else if (order.getStatus() == 2) { %>
                            <span class="badge bg-success">Đã giao</span>
                            <% } else { %>
                            <span class="badge bg-danger">Đã hủy</span>
                            <% }%>
                        </td>
                        <td>
                            <a href="ViewOrderDetail?orderId=<%= order.getOrderId()%>">Xem chi tiết</a>
                            <% if (order.getStatus() == 0) {%>
                            <a href="CancelOrder?orderId=<%= order.getOrderId()%>" class="btn btn-sm btn-danger">Cancel</a>
                            <a href="UpdateOrder?orderId=<%= order.getOrderId()%>" class="btn btn-sm btn-warning">Update</a>
                            <% } %>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            <% }%>

            <div class="text-center mt-4">
                <a href="home.jsp" class="btn btn-secondary">Quay lại trang chủ</a>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>