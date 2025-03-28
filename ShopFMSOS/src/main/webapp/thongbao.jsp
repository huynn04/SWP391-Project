<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Notification</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
    <%@ include file="header.jsp" %>

    <div class="container mt-5 text-center">
        <h2 class="text-success">🎉 Order Placed Successfully! 🎉</h2>
        <p>Thank you for shopping with us.</p>
        <a href="home.jsp" class="btn btn-primary">Continue Shopping</a>
        <a href="CustomerOrderHistory" class="btn btn-secondary">View Your Orders</a>
    </div>

    <%@ include file="footer.jsp" %>
</body>
</html>
