<%-- 
    Document   : cartDetail
    Created on : Feb 17, 2025, 1:41:58 PM
    Author     : Nguyễn Ngoc Huy CE180178
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, model.Product" %>
<!-- chỉ có account mới vào đc -->
<%@ page import="model.User" %>
<% User loggedInUser = (User) session.getAttribute("loggedInUser"); if (loggedInUser == null) { response.sendRedirect("login.jsp"); // Nếu chưa đăng nhập, chuyển hướng return; } %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Giỏ hàng của bạn</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        // Hàm AJAX gửi yêu cầu cập nhật số lượng sản phẩm
        function updateQuantity(productId, quantity, maxQuantity) {
            if (quantity > maxQuantity) {
                // Nếu số lượng vượt quá, không làm gì và không hiển thị thông báo
                return;
            }

            $.ajax({
                url: 'UpdateCart',  // Gửi yêu cầu tới UpdateCart servlet
                method: 'POST',
                data: {
                    productId: productId,
                    quantity: quantity
                },
                success: function(response) {
                    if (response === "success") {
                        location.reload();  // Tải lại trang để hiển thị giỏ hàng mới
                    }
                },
                error: function(xhr, status, error) {
                    alert("Có lỗi khi cập nhật giỏ hàng.");
                }
            });
        }

        // Hàm xử lý thay đổi số lượng sản phẩm
        $(document).ready(function() {
            $(".quantity-input").on("change", function() {
                var productId = $(this).data("productId");
                var quantity = $(this).val();
                var maxQuantity = $(this).data("maxQuantity");  // Lấy số lượng tối đa từ thuộc tính data-maxQuantity
                if (quantity >= 1) {
                    updateQuantity(productId, quantity, maxQuantity);  // Gọi AJAX để cập nhật giỏ hàng
                }
            });
        });
    </script>
</head>
<body>
    <%@ include file="header.jsp" %>

    <div class="container mt-5">
        <h2 class="mb-4">Giỏ hàng của bạn</h2>

        <%
            List<Product> cart = (List<Product>) session.getAttribute("cart");
            if (cart != null && !cart.isEmpty()) {
        %>
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Ảnh</th>
                    <th>Tên sản phẩm</th>
                    <th>Giá</th>
                    <th>Số lượng</th>
                    <th>Thành tiền</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <%
                    for (Product p : cart) {
                %>
                <tr>
                    <td>
                        <% if (p.getImage() != null && !p.getImage().trim().isEmpty()) { %>
                            <img src="<%= p.getImage() %>" alt="<%= p.getProductName() %>" width="100">
                        <% } else { %>
                            <img src="images/no-image.png" alt="No Image" width="100">
                        <% } %>
                    </td>
                    <td><%= p.getProductName() %></td>
                    <td>$<%= String.format("%.3f", p.getPrice().doubleValue()) %></td>
                    <td>
                        <!-- Cho phép người dùng thay đổi số lượng và gọi AJAX -->
                        <input type="number" class="quantity-input form-control" data-product-id="<%= p.getProductId() %>" 
                               data-max-quantity="<%= p.getQuantity() %>" value="<%= p.getQuantity() %>" min="1" style="width: 80px;">
                    </td>
                    <td>$<%= String.format("%.3f", p.getPrice().doubleValue() * p.getQuantity()) %></td>
                    <td>
                        <a href="RemoveFromCart?productId=<%= p.getProductId() %>" class="btn btn-danger btn-sm">Xóa</a>
                    </td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>

        <!-- Nút "Mua hàng" chuyển tới CheckoutInfo.jsp -->
        <div class="mt-3">
            <a href="CheckoutInfo" class="btn btn-success btn-lg">Mua hàng</a>
        </div>
        <%
            } else {
        %>
        <div class="alert alert-warning">
            Giỏ hàng của bạn đang trống.
        </div>
        <%
            }
        %>
    </div>

    <%@ include file="footer.jsp" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
