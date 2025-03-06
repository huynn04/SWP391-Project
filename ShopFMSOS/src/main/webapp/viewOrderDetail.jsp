<%-- 
    Document   : viewOrderDetail
    Created on : Mar 6, 2025, 2:11:28 PM
    Author     : Dang Chi Vi CE182507
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="model.Order, java.util.List, model.OrderDetail" %>

<jsp:useBean id="order" type="model.Order" scope="request"/>
<jsp:useBean id="orderDetails" type="java.util.List<model.OrderDetail>" scope="request"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết đơn hàng - FMSOS</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        /* Đảm bảo nội dung không bị header che */
        body {
            padding-top: 80px; /* Điều chỉnh khoảng cách tùy vào chiều cao của header */
        }

        .product-card {
            display: flex;
            width: 100%;
            border: 2px solid #ddd;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 2px 2px 15px rgba(0, 0, 0, 0.2);
            margin-bottom: 25px;
            transition: transform 0.2s ease-in-out;
        }

        .product-card:hover {
            transform: scale(1.02);
        }

        .product-img-container {
            width: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .product-img {
            width: 100%;
            max-width: 450px; /* Giới hạn max nhưng vẫn giữ 50% */
            height: auto;
            border-radius: 10px;
        }

        .product-info {
            width: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            padding: 20px;
        }

        .product-table {
            width: 100%;
        }

        .product-table th {
            text-align: left;
            width: 200px;
            background-color: #f8f9fa;
            font-weight: bold;
            padding: 10px;
        }

        .product-table td {
            text-align: left;
            padding: 10px;
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>

    <div class="container mt-5">
        <h2 class="text-center text-primary">Chi tiết đơn hàng</h2>

        <!-- Hiển thị danh sách sản phẩm (50% ảnh - 50% thông tin) -->
        <% for (OrderDetail detail : orderDetails) { %>
            <div class="product-card">
                <div class="product-img-container">
                    <img src="<%= detail.getProduct().getImage() %>" class="product-img" alt="Sản phẩm">
                </div>
                <div class="product-info">
                    <table class="product-table">
                        <tr>
                            <th>Tên sản phẩm</th>
                            <td><%= detail.getProduct().getProductName() %></td>
                        </tr>
                        <tr>
                            <th>Số lượng</th>
                            <td><%= detail.getQuantity() %></td>
                        </tr>
                        <tr>
                            <th>Giá</th>
                            <td>$<%= detail.getPrice() %></td>
                        </tr>
                        <tr>
                            <th>Tổng cộng</th>
                            <td>$<%= detail.getSubtotal() %></td>
                        </tr>
                        <tr>
                            <th>Thuế</th>
                            <td>$<%= detail.getTax() %></td>
                        </tr>
                    </table>
                </div>
            </div>
        <% } %>

        <!-- Bảng thông tin đơn hàng -->
        <div class="card p-4 mb-4">
            <table class="table">
                <tr><th>Ngày đặt</th><td><%= order.getOrderDate() %></td></tr>
                <tr><th>Người nhận</th><td><%= order.getReceiverName() %></td></tr>
                <tr><th>Địa chỉ giao hàng</th><td><%= order.getReceiverAddress() %></td></tr>
                <tr><th>Số điện thoại</th><td><%= order.getReceiverPhone() %></td></tr>
                <tr><th>Hình thức thanh toán</th><td><%= order.getPaymentMethod() %></td></tr>
                <tr><th>Tổng giá trị đơn hàng</th><td>$<%= order.getTotalPrice() %></td></tr>
                <tr><th>Ghi chú</th><td><%= order.getNote() != null ? order.getNote() : "Không có" %></td></tr>
                <tr>
                    <th>Trạng thái đơn hàng</th>
                    <td>
                        <% if (order.getStatus() == 0) { %> 🟡 Chờ xử lý 
                        <% } else if (order.getStatus() == 1) { %> 🚚 Đang giao 
                        <% } else if (order.getStatus() == 2) { %> ✅ Đã giao 
                        <% } else { %> ❌ Đã hủy <% } %>
                    </td>
                </tr>
            </table>
        </div>

        <div class="text-center mt-4">
            <a href="orderHistory.jsp" class="btn btn-outline-secondary">⬅ Quay lại</a>
        </div>
    </div>

    <%@ include file="footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
