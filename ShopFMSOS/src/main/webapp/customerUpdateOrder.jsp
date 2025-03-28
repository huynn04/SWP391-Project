<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="model.Order, model.OrderDetail" %>
<%@ page import="java.util.List" %>
<jsp:useBean id="order" type="model.Order" scope="request" />
<jsp:useBean id="orderDetails" type="java.util.List<model.OrderDetail>" scope="request" />
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Update Order</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
        <style>
            html, body {
                height: 100%;
                margin: 0;
            }

            #wrapper {
                min-height: 100vh;
                display: flex;
                flex-direction: column;
            }

            main {
                flex: 1;
                padding-bottom: 50px;
            }

            .custom-wrapper {
                max-width: 1200px;
                margin-left: auto;
                margin-right: auto;
                padding-left: 15px;
                padding-right: 15px;
            }

            .card {
                border: none;
                border-radius: 10px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                overflow: hidden;
                transition: transform 0.3s ease-in-out;
            }

            .card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
            }

            .card-body {
                padding: 15px;
            }

            .form-control:disabled {
                background-color: #f8f9fa;
                color: #6c757d;
            }

            .btn-primary {
                background-color: #007bff;
                border: none;
                border-radius: 5px;
                padding: 10px 20px;
                transition: background-color 0.3s;
            }

            .btn-primary:hover {
                background-color: #0056b3;
            }

            .table {
                margin-top: 20px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                border-radius: 10px;
                overflow: hidden;
            }

            .table thead th {
                background-color: #007bff;
                color: white;
            }

            .table-striped tbody tr:nth-of-type(odd) {
                background-color: #f8f9fa;
            }

            h2 {
                font-weight: bold;
                margin-bottom: 30px;
            }

            h3 {
                font-size: 1.5rem;
                margin-top: 20px;
                margin-bottom: 15px;
            }
        </style>
    </head>
    <body>
        <div id="wrapper">
            <%@ include file="header.jsp" %>

            <main>
                <div class="custom-wrapper mt-5">
                    <h2>Update Order #<%= order.getOrderId() %></h2>

                    <form action="CustomerUpdateOrder" method="post">
                        <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">

                        <div class="card mb-4">
                            <div class="card-body">
                                <!-- Receiver Name -->
                                <div class="mb-3">
                                    <label for="receiverName" class="form-label">Receiver Name</label>
                                    <input type="text" class="form-control" id="receiverName" name="receiverName" value="<%= order.getReceiverName() %>">
                                </div>

                                <!-- Receiver Address -->
                                <div class="mb-3">
                                    <label for="receiverAddress" class="form-label">Receiver Address</label>
                                    <input type="text" class="form-control" id="receiverAddress" name="receiverAddress" value="<%= order.getReceiverAddress() %>">
                                </div>

                                <!-- Receiver Phone -->
                                <div class="mb-3">
                                    <label for="receiverPhone" class="form-label">Receiver Phone</label>
                                    <input type="text" class="form-control" id="receiverPhone" name="receiverPhone" value="<%= order.getReceiverPhone() %>">
                                </div>

                                <!-- Payment Method -->
                                <div class="mb-3">
                                    <label for="paymentMethod" class="form-label">Payment Method</label>
                                    <select class="form-control" id="paymentMethod" name="paymentMethod" disabled>
                                        <option value="COD" <%= order.getPaymentMethod().equals("COD") ? "selected" : "" %>>Cash on Delivery</option>
                                        <option value="Online" <%= order.getPaymentMethod().equals("Online") ? "selected" : "" %>>Online Payment</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <h3>Order Details</h3>
                        <table class="table table-striped">
                            <h4>Total Price: <span id="totalPrice"><%= request.getAttribute("totalPrice") %> VND</span></h4>
                            <thead>
                                <tr>
                                    <th>Product</th>
                                    <th>Quantity</th>
                                    <th>Price</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (OrderDetail detail : orderDetails) { %>
                                <tr>
                                    <td><%= detail.getProduct().getProductName() %></td>
                                    <td>
                                        <input type="number" class="form-control update-quantity "
                                               data-order-detail-id="<%= detail.getOrderDetailId() %>" 
                                               data-order-id="<%= order.getOrderId() %>"
                                               data-original-quantity="<%= detail.getQuantity() %>"
                                               name="quantity" value="<%= detail.getQuantity() %>" disabled>
                                        <input type="hidden" name="orderDetailId" value="<%= detail.getOrderDetailId() %>">
                                    </td>
                                    <td><%= detail.getPrice() %></td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>

                        <button type="submit" class="btn btn-primary">Update</button>
                    </form>
                </div>
            </main>

            <%@ include file="footer.jsp" %>
        </div>

        <script>
            $(document).ready(function () {
            $(".update-quantity").on("change", function () {
            let $input = $(this);
                    let orderDetailId = $input.data("order-detail-id");
                    let newQuantity = parseInt($input.val());
                    // Kiểm tra số lượng
                    if (newQuantity <= 0) {
            alert("Quantity must be greater than 0!");
                    return;
            }

            $.ajax({
            type: "POST",
                    url: "UpdateOrderDetail", // Đảm bảo rằng URL này đúng
                    data: {
                    orderDetailId: orderDetailId,
                            quantity: newQuantity
                    },
                    dataType: "json",
                    success: function (response) {
                    if (response.success) {
                    // Cập nhật subtotal và total price
                    $("#totalPrice").text(response.newTotal + " VND");
                    } else {
                    alert("Update failed!");
                            $input.val($input.data("original-quantity")); // Khôi phục số lượng ban đầu
                    }
                    },
                    error: function () {
                    alert("An error occurred. Please try again.");
                            $input.val($input.data("original-quantity")); // Khôi phục số lượng ban đầu
                    }
            });
            });
        </script>
    </body>
</html>