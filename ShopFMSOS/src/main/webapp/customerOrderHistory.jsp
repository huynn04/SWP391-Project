<%-- 
    Document   : customerOrderHistory
<<<<<<< Updated upstream
    Created on : Mar 6, 2025, 2:40:22 AM
=======
    Created on : Mar 6, 2025, 3:52:18 AM
>>>>>>> Stashed changes
    Author     : Dang Chi Vi CE182507
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List, model.Order" %>

<jsp:useBean id="orders" type="java.util.List<model.Order>" scope="request"/>

<html>
<head>
    <title>Lịch sử đơn hàng</title>
</head>
<body>
    <h2>Lịch sử đơn hàng của bạn</h2>

    <% if (orders.isEmpty()) { %>
        <p>Bạn chưa có đơn hàng nào.</p>
    <% } else { %>
        <table border="1">
            <tr>
                <th>ID</th><th>Ngày đặt</th><th>Tổng tiền</th><th>Trạng thái</th><th>Chi tiết</th>
            </tr>
            <% for (Order order : orders) { %>
                <tr>
                    <td><%= order.getOrderId() %></td>
                    <td><%= order.getOrderDate() %></td>
                    <td><%= order.getTotalPrice() %> VNĐ</td>
                    <td>
                        <% if (order.getStatus() == 0) { %> Chờ xử lý 
                        <% } else if (order.getStatus() == 1) { %> Đang giao 
                        <% } else if (order.getStatus() == 2) { %> Đã giao 
                        <% } else { %> Đã hủy <% } %>
                    </td>
                    <td><a href="OrderDetail?orderId=<%= order.getOrderId() %>">Xem chi tiết</a></td>
                </tr>
            <% } %>
        </table>
    <% } %>

    <br>
    <a href="home.jsp">Quay lại trang chủ</a>
</body>
</html>

