<%-- 
    Document   : checkoutConfirmation
    Created on : Feb 18, 2025, 9:47:06 PM
    Author     : Nguyễn Ngoc Huy CE180178
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thanh toán thành công</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
    <%@ include file="header.jsp" %>
    <div class="container mt-5">
        <div class="alert alert-success">
            <h3>Thanh toán thành công!</h3>
            <p>Cảm ơn bạn đã mua hàng. Đơn hàng của bạn sẽ được giao đến địa chỉ sau: <%= request.getAttribute("address") %></p>
        </div>
    </div>
    <%@ include file="footer.jsp" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
