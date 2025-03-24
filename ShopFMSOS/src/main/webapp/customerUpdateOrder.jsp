<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="model.Order, model.OrderDetail" %>
<%@ page import="java.util.List" %>
<jsp:useBean id="order" type="model.Order" scope="request" />
<jsp:useBean id="orderDetails" type="java.util.List<model.OrderDetail>" scope="request" />
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Cập nhật đơn hàng</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    </head>
    <body>

        <div class="container mt-4">
            <h2 class="mb-4">Cập nhật đơn hàng #<%= order.getOrderId()%></h2>

            <form action="CustomerUpdateOrder" method="post">
                <input type="hidden" name="orderId" value="<%= order.getOrderId()%>">

                <!-- Tên người nhận -->
                <div class="mb-3">
                    <label for="receiverName" class="form-label">Tên người nhận</label>
                    <input type="text" class="form-control" id="receiverName" name="receiverName" value="<%= order.getReceiverName()%>" required>
                </div>

                <!-- Địa chỉ người nhận -->
                <div class="mb-3">
                    <label for="receiverAddress" class="form-label">Địa chỉ người nhận</label>
                    <input type="text" class="form-control" id="receiverAddress" name="receiverAddress" value="<%= order.getReceiverAddress()%>" required>
                </div>

                <!-- Số điện thoại người nhận -->
                <div class="mb-3">
                    <label for="receiverPhone" class="form-label">Số điện thoại người nhận</label>
                    <input type="text" class="form-control" id="receiverPhone" name="receiverPhone" value="<%= order.getReceiverPhone()%>" required>
                </div>

                <!-- Hình thức thanh toán -->
                <div class="mb-3">
                    <label for="paymentMethod" class="form-label">Hình thức thanh toán</label>
                    <select class="form-control" id="paymentMethod" name="paymentMethod" required>
                        <option value="COD" <%= order.getPaymentMethod().equals("COD") ? "selected" : ""%>>Thanh toán khi nhận hàng</option>
                        <option value="Online" <%= order.getPaymentMethod().equals("Online") ? "selected" : ""%>>Thanh toán online</option>
                    </select>
                </div>

                <h3>Chi tiết đơn hàng</h3>
                <table class="table table-striped">
                    <h4>Tổng tiền: <span id="totalPrice"><%= order.getTotalPrice()%> VNĐ</span></h4>
                    <thead>
                        <tr>
                            <th>Sản phẩm</th>
                            <th>Số lượng</th>
                            <th>Giá</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (OrderDetail detail : orderDetails) {%>
                        <tr>
                            <td><%= detail.getProduct().getProductName()%></td>
                            <td>
                                <input type="number" class="form-control update-quantity"
                                       data-order-detail-id="<%= detail.getOrderDetailId()%>" 
                                       data-order-id="<%= order.getOrderId()%>"
                                       name="quantity" value="<%= detail.getQuantity()%>" required>
                                <input type="hidden" name="orderDetailId" value="<%= detail.getOrderDetailId()%>">
                            </td>

                            <td><%= detail.getPrice()%></td>
                        </tr>
                        <% }%>
                    </tbody>
                </table>

                <button type="submit" class="btn btn-primary">Cập nhật</button>
            </form>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            $(document).ready(function () {
                $(".update-quantity").on("change", function () {
                    let orderDetailId = $(this).data("order-detail-id");
                    let orderId = $(this).data("order-id");
                    let newQuantity = $(this).val();
                    let row = $(this).closest("tr");

                    $.ajax({
                        type: "POST",
                        url: "UpdateOrderDetail",
                        data: {
                            orderDetailId: orderDetailId,
                            quantity: newQuantity
                        },
                        dataType: "json",
                        success: function (response) {
                            if (response.success) {
                                row.find(".subtotal").text(response.newSubtotal + " VNĐ");
                                $("#totalPrice").text(response.newTotal + " VNĐ");
                            } else {
                                alert("Cập nhật không thành công!");
                            }
                        },
                        error: function () {
                            alert("Có lỗi xảy ra, vui lòng thử lại.");
                        }
                    });
                });
            });
        </script>

    </body>
</html>
