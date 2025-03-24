<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List, model.Order, model.OrderDetail" %>

<%
    List<Order> orders = (List<Order>) request.getAttribute("orders");
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Lịch sử đơn hàng</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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

            <% if (orders != null && !orders.isEmpty()) { %>
            <table class="table table-striped table-bordered">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Order Date</th>
                            <%--<th>Tổng tiền</th>--%>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Order order : orders) {%>
                    <tr>
                        <td><%= order.getOrderId()%></td>
                        <td><%= order.getOrderDate()%></td>
                        <%--<td class="total-price" data-order-id="<%= order.getOrderId()%>"><%= order.getTotalPrice()%> VNĐ</td>--%>
                        <td>
                            <% if (order.getStatus() == 0) { %>
                            <span class="badge bg-warning">Pending</span>
                            <% } else if (order.getStatus() == 1) { %>
                            <span class="badge bg-primary">Shipping</span>
                            <% } else if (order.getStatus() == 2) { %>
                            <span class="badge bg-success">Completed</span>
                            <% } else { %>
                            <span class="badge bg-danger">Cancelled</span>
                            <% }%>
                        </td>
                        <td>
                            <a href="ViewOrderDetail?orderId=<%= order.getOrderId()%>" class="btn btn-sm btn-info" data-bs-toggle="tooltip" title="View Order Detail">
                                <i class="fas fa-eye"></i> View Order Detail
                            </a>
                            <% if (order.getStatus() == 0) {%>
                            <a href="CustomerCancelOrder?orderId=<%= order.getOrderId() %>" class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc chắn muốn huỷ đơn hàng này?')">Cancel</a>
                            <a href="CustomerUpdateOrder?orderId=<%= order.getOrderId()%>" class="btn btn-sm btn-primary">Update</a>
                            <% } else if (order.getStatus() == 1) {%>
                            <a href="CustomerReceivedOrder?orderId=<%= order.getOrderId() %>"  class="btn btn-sm btn-success">Received</a>
                            <%
                            } else if (order.getStatus() == 2) {%>
                            <a href="ReviewForm" class="btn btn-sm btn-warning">Feedback</a>
                            <% } %>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            <% } else { %>
            <div class="alert alert-warning text-center" role="alert">
                Bạn chưa có đơn hàng nào.
            </div>
            <% }%>

            <div class="text-center mt-4">
                <a href="home.jsp" class="btn btn-secondary">Quay lại trang chủ</a>
            </div>
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
                                $(".total-price[data-order-id='" + orderId + "']").text(response.newTotal + " VNĐ");
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
