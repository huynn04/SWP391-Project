<%-- 
    Document   : product
    Created on : Feb 16, 2025, 9:46:19 PM
    Author     : Nguyễn Ngoc Huy CE180178
--%>
<%@page import="java.util.List, model.Product" %>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Product List</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    </head>
    <body>
        <%@ include file="header.jsp" %>

        <div class="container mt-5">
            <div class="row">
                <%
                    List<Product> products = (List<Product>) request.getAttribute("products");
                    if (products != null) {
                        for (Product p : products) {
                %>
                <div class="col-md-3">
                    <div class="card mb-4 shadow-sm">
                        <%-- Bọc ảnh trong thẻ <a> để chuyển hướng khi nhấp vào ảnh --%>
                        <a href="ProductDetail?productId=<%= p.getProductId() %>">
                            <% if (p.getImage() != null && !p.getImage().trim().isEmpty()) { %>
                                <img src="<%= p.getImage() %>" class="card-img-top" alt="<%= p.getProductName() %>">
                            <% } else { %>
                                <img src="images/no-image.png" class="card-img-top" alt="No Image">
                            <% } %>
                        </a>
                        <div class="card-body text-center">
                            <%-- Hiển thị giá sản phẩm --%>
                            <h5 class="card-title">$<%= p.getPrice() %></h5>
                            <div class="d-flex justify-content-around">
                                <%-- Nút mua ngay chuyển đến trang chi tiết sản phẩm --%>
                                <a href="ProductDetail?productId=<%= p.getProductId() %>" class="btn btn-primary">Mua ngay</a>
                                <%-- Nút thêm giỏ hàng, thay link cho đúng với chức năng của bạn --%>
                                <a href="AddToCart?productId=<%= p.getProductId() %>" class="btn btn-success">Thêm giỏ hàng</a>
                            </div>
                        </div>
                    </div>
                </div>
                <%
                        }
                    }
                %>
            </div>
        </div>

        <%@ include file="footer.jsp" %>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
