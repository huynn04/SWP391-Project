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
    <title>Order History - FMSOS</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        /* Ensure the whole page has a minimum height */
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

        /* Stretch the container to full width */
        .custom-wrapper {
            max-width: 1200px; /* Adjust the maximum width as needed */
            margin-left: auto;
            margin-right: auto; /* Center the wrapper horizontally */
            padding-left: 15px; /* Adjust the padding on the left side */
            padding-right: 15px; /* Adjust the padding on the right side */
        }

        /* Center content */
        .center-content {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 40vh;
            margin: 0;
            padding: 0 15px;
            text-align: center;
        }

        /* Card for the table container */
        .order-history-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-bottom: 20px;
        }

        /* Table styling */
        .table {
            margin-bottom: 0;
        }

        .table thead th {
            background-color: #007bff;
            color: white;
            border: none;
        }

        .table tbody tr {
            transition: background-color 0.3s ease;
        }

        .table tbody tr:hover {
            background-color: #f1f1f1;
        }

        .table td, .table th {
            vertical-align: middle;
        }

        /* Button styling */
        .btn-sm {
            font-size: 0.85rem;
            padding: 5px 10px;
            border-radius: 5px;
            transition: background-color 0.3s;
        }

        .btn-info {
            background-color: #007bff;
            border-color: #007bff;
        }

        .btn-info:hover {
            background-color: #0056b3;
            border-color: #0056b3;
        }

        .btn-danger {
            background-color: #dc3545;
            border-color: #dc3545;
        }

        .btn-danger:hover {
            background-color: #c82333;
            border-color: #c82333;
        }

        .btn-primary {
            background-color: #007bff;
            border-color: #007bff;
        }

        .btn-primary:hover {
            background-color: #0056b3;
            border-color: #0056b3;
        }

        .btn-success {
            background-color: #28a745;
            border-color: #28a745;
        }

        .btn-success:hover {
            background-color: #218838;
            border-color: #218838;
        }

        .btn-warning {
            background-color: #ffc107;
            border-color: #ffc107;
            color: #212529;
        }

        .btn-warning:hover {
            background-color: #e0a800;
            border-color: #e0a800;
        }

        .btn-secondary {
            background-color: #6c757d;
            border-color: #6c757d;
        }

        .btn-secondary:hover {
            background-color: #5a6268;
            border-color: #5a6268;
        }

        /* Badge styling */
        .badge {
            font-size: 0.9rem;
            padding: 5px 10px;
        }

        /* Alert styling */
        .alert {
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body>
    <div id="wrapper">
        <%@ include file="header.jsp" %>

        <main>
            <div class="row center-content">
                <div class="col-md-12">
                    <div class="welcome-section">
                        <h1>Your Order History</h1>
                        <p class="lead">View and manage all your past orders here.</p>
                    </div>
                </div>
            </div>

            <div class="custom-wrapper">
                <div class="order-history-card">
                    <% if (orders != null && !orders.isEmpty()) { %>
                    <table class="table table-striped table-bordered">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Order Date</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Order order : orders) { %>
                            <tr>
                                <td><%= order.getOrderId() %></td>
                                <td><%= order.getOrderDate() %></td>
                                <td>
                                    <% if (order.getStatus() == 0) { %>
                                    <span class="badge bg-warning">Pending</span>
                                    <% } else if (order.getStatus() == 1) { %>
                                    <span class="badge bg-primary">Shipping</span>
                                    <% } else if (order.getStatus() == 2) { %>
                                    <span class="badge bg-success">Completed</span>
                                    <% } else { %>
                                    <span class="badge bg-danger">Cancelled</span>
                                    <% } %>
                                </td>
                                <td>
                                    <a href="ViewOrderDetail?orderId=<%= order.getOrderId() %>" class="btn btn-sm btn-info" data-bs-toggle="tooltip" title="View Order Detail">
                                        <i class="fas fa-eye"></i> View Order Detail
                                    </a>
                                    <% if (order.getStatus() == 0) { %>
                                    <a href="CustomerCancelOrder?orderId=<%= order.getOrderId() %>" class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc chắn muốn huỷ đơn hàng này?')">Cancel</a>
                                    <a href="CustomerUpdateOrder?orderId=<%= order.getOrderId() %>" class="btn btn-sm btn-primary">Update</a>
                                    <% } else if (order.getStatus() == 1) { %>
                                    <a href="CustomerReceivedOrder?orderId=<%= order.getOrderId() %>" class="btn btn-sm btn-success">Received</a>
                                    <% } else if (order.getStatus() == 2) { %>
                                    <% } %>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                    <% } else { %>
                    <div class="alert alert-warning text-center" role="alert">
                        You have no orders yet.
                    </div>
                    <% } %>
                </div>

                <div class="text-center mt-4">
                    <a href="home.jsp" class="btn btn-secondary">Back to Home Page</a>
                </div>
            </div>
        </main>

        <%@ include file="footer.jsp" %>
    </div>

    <script>
        $(document).ready(function () {
            // Enable tooltips
            var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
            var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                return new bootstrap.Tooltip(tooltipTriggerEl);
            });

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
                            alert("Update fail");
                        }
                    },
                    error: function () {
                        alert("Error, try again");
                    }
                });
            });
        });
    </script>

    <!-- Chatra {literal} -->
    <script>
        (function (d, w, c) {
            w.ChatraID = '6ttM7t2hWx4ta8j2Z';
            var s = d.createElement('script');
            w[c] = w[c] || function () {
                (w[c].q = w[c].q || []).push(arguments);
            };
            s.async = true;
            s.src = 'https://call.chatra.io/chatra.js';
            if (d.head)
                d.head.appendChild(s);
        })(document, window, 'Chatra');
    </script>
    <!-- /Chatra {/literal} -->
</body>
</html>