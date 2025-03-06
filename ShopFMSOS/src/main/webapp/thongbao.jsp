<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thông báo</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
    <%@ include file="header.jsp" %>

    <div class="container mt-5 text-center">
        
            <h2 class="text-success">🎉 Đặt hàng thành công! 🎉</h2>
            <p>Cảm ơn bạn đã mua sắm tại cửa hàng của chúng tôi.</p>
            <a href="home.jsp" class="btn btn-primary">Tiếp tục mua sắm</a>
            <a href="orderHistory.jsp" class="btn btn-secondary">Xem đơn hàng</a>
        
    </div>

    <%@ include file="footer.jsp" %>
</body>
</html>
