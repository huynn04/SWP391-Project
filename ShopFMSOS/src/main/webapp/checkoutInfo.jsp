<%-- 
    Document   : checkoutInfo
    Created on : Feb 18, 2025, 9:46:50 PM
    Author     : Nguyễn Ngoc Huy CE180178
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, model.Product" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Thông tin thanh toán</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <script>
            // Hàm để hiển thị các phương thức thanh toán chi tiết khi chọn "Thanh toán trực tuyến"
            function togglePaymentDetails() {
                var paymentMethod = document.getElementById("paymentMethod").value;
                if (paymentMethod === "Online") {
                    document.getElementById("onlinePaymentDetails").style.display = "block"; // Hiển thị chi tiết thanh toán trực tuyến
                } else {
                    document.getElementById("onlinePaymentDetails").style.display = "none"; // Ẩn chi tiết thanh toán
                }
            }
        </script>
    </head>
    <body>
        <%@ include file="header.jsp" %>

        <div class="container mt-5">
            <h2 class="mb-4">Thông tin thanh toán</h2>
            <form action="Checkout" method="post">
                <!-- Hiển thị sản phẩm trong giỏ hàng -->
                <h4 class="mb-3">Sản phẩm trong giỏ hàng</h4>
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th>Ảnh</th>
                            <th>Tên sản phẩm</th>
                            <th>Giá</th>
                            <th>Số lượng</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<Product> cart = (List<Product>) request.getAttribute("cart");
                            for (Product p : cart) {
                        %>
                        <tr>
                            <td><img src="<%= p.getImage()%>" width="50"></td>
                            <td><%= p.getProductName()%></td>
                            <td>$<%= p.getPrice()%></td>
                            <td><input type="number" name="quantity_<%= p.getProductId()%>" value="<%= p.getQuantity()%>" min="1" class="form-control"></td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>

                <!-- Địa chỉ nhận hàng -->
                <div class="form-group">
                    <label for="address">Địa chỉ nhận hàng</label>
                    <input type="text" id="address" name="address" class="form-control" required>
                </div>

                <!-- Thông tin nhận hàng -->
                <div class="form-group">
                    <label for="phone">Số điện thoại</label>
                    <input type="text" id="phone" name="phone" class="form-control" required>
                </div>

                <!-- Phương thức thanh toán -->
                <div class="form-group">
                    <label for="paymentMethod">Phương thức thanh toán</label>
                    <select id="paymentMethod" name="paymentMethod" class="form-control" required onchange="togglePaymentDetails()">
                        <option value="Choose">== None ==</option>
                        <option value="COD">Thanh toán khi nhận hàng</option>
                        <option value="Online">Thanh toán trực tuyến</option>
                        <option value="Ghino">Thanh toán ghi nợ</option>

                    </select>
                </div>

                <!-- Chi tiết phương thức thanh toán trực tuyến (hiển thị khi chọn "Thanh toán trực tuyến") -->
                <div id="onlinePaymentDetails" style="display: none;">
                    <div class="form-group">
                        <label for="onlinePaymentMethod">Chọn phương thức thanh toán trực tuyến</label>
                        <select id="onlinePaymentMethod" name="onlinePaymentMethod" class="form-control">
                            <option value="Momo">Momo</option>
                            <option value="Visa">Thẻ Visa</option>
                            <option value="BankTransfer">Chuyển khoản ngân hàng</option>
                            <option value="PayLater">Thanh toán trả sau</option>
                        </select>
                    </div>
                </div>

                <!-- Nút xác nhận -->
                <button type="submit" class="btn btn-primary">Xác nhận mua hàng</button>
            </form>
        </div>

        <%@ include file="footer.jsp" %>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
