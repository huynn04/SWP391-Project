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
        /* Màu chủ đạo */
        :root {
            --primary-color: #007bff;
            --secondary-color: #6c757d;
            --light-bg: #f8f9fa;
            --dark-bg: #343a40;
            --highlight-color: #28a745;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
        }

        /* Đảm bảo nội dung không bị header che */
        body {
            padding-top: 80px;
            background-color: var(--light-bg);
        }

        h2 {
            color: var(--primary-color);
            font-weight: bold;
        }

        .product-card {
            display: flex;
            width: 100%;
            border: 2px solid var(--secondary-color);
            border-radius: 10px;
            padding: 20px;
            background: white;
            box-shadow: 2px 2px 15px rgba(0, 0, 0, 0.2);
            margin-bottom: 25px;
            transition: transform 0.2s ease-in-out, box-shadow 0.3s ease-in-out;
        }

        .product-card:hover {
            transform: scale(1.03);
            box-shadow: 2px 2px 20px rgba(0, 0, 0, 0.3);
        }

        .product-img-container {
            width: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            background: var(--light-bg);
            border-radius: 10px;
            padding: 20px;
        }

        .product-img {
            width: 100%;
            max-width: 450px;
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
            background-color: var(--primary-color);
            color: white;
            font-weight: bold;
            padding: 12px;
            border-radius: 5px;
        }

        .product-table td {
            text-align: left;
            padding: 12px;
            font-size: 16px;
            color: var(--dark-bg);
            background: var(--light-bg);
            border-radius: 5px;
        }

        /* Link xem chi tiết sản phẩm */
        .view-product {
            display: block;
            text-align: right;
            margin-top: 10px;
        }

        .view-product a {
            font-weight: bold;
            color: var(--primary-color);
            text-decoration: none;
            transition: color 0.3s ease-in-out;
        }

        .view-product a:hover {
            color: var(--highlight-color);
            text-decoration: underline;
        }

        /* Bảng thông tin đơn hàng */
        .order-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.15);
        }

        .table th {
            background-color: var(--primary-color);
            color: white;
            padding: 10px;
        }

        .table td {
            padding: 10px;
        }

        .btn-back {
            background: var(--secondary-color);
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            font-weight: bold;
            transition: background 0.3s ease-in-out;
        }

        .btn-back:hover {
            background: var(--dark-bg);
        }

    </style>
</head>
<body>
    <%@ include file="header.jsp" %>

    <div class="container mt-5">
        <h2 class="text-center">Chi tiết đơn hàng</h2>

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
                    <!-- Link xem chi tiết sản phẩm -->
                    <div class="view-product">
                        <a href="ProductDetail?productId=<%= detail.getProductId() %>">🔍 View Product Detail</a>
                    </div>
                </div>
            </div>
        <% } %>

        <!-- Bảng thông tin đơn hàng -->
        <div class="order-card mb-4">
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
                        <% if (order.getStatus() == 0) { %> <span class="text-warning">🟡 Chờ xử lý</span>
                        <% } else if (order.getStatus() == 1) { %> <span class="text-info">🚚 Đang giao</span>
                        <% } else if (order.getStatus() == 2) { %> <span class="text-success">✅ Đã giao</span>
                        <% } else { %> <span class="text-danger">❌ Đã hủy</span> <% } %>
                    </td>
                </tr>
            </table>
        </div>

        <div class="text-center mt-4">
            <a href="orderHistory.jsp" class="btn btn-back">⬅ Quay lại</a>
        </div>
    </div>

    <%@ include file="footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
