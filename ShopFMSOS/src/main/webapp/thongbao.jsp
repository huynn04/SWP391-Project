<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thanh toán thành công</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        /* CSS cho phần chữ */
        .success-container h1 {
            color: #007bff; /* Màu xanh cho tiêu đề */
            font-size: 2.5rem;
            font-weight: bold;
            margin-bottom: 20px;
        }
        .success-container p {
            color: #555;
            font-size: 1.125rem;
            margin-bottom: 30px;
        }
        /* CSS cho nút quay lại */
        .btn-home {
            background-color: #28a745;
            color: #fff;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }
        .btn-home:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>
    
    <!-- Vùng chứa nội dung chính có chiều cao trừ đi chiều cao header -->
    <div class="container d-flex justify-content-center align-items-center" style="min-height: calc(100vh - 70px);">
        <div class="success-container text-center">
            <h1>Thanh toán thành công!</h1>
            <p>Cảm ơn bạn đã mua hàng. Đơn hàng của bạn đang được xử lý.</p>
            <a href="home" class="btn-home">Quay về trang chủ</a>
        </div>
    </div>
    
    <%@ include file="footer.jsp" %>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
