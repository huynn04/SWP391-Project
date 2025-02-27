<%-- 
    Document   : home
    Created on : Feb 12, 2025, 3:39:48 PM
    Author     : Nguyễn Ngoc Huy CE180178
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List, model.Product" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Home - FMSOS</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="css/style.css">
        <style> 
            /* Đảm bảo toàn bộ trang có chiều cao tối thiểu */
            html, body {
                height: 100%;
                margin: 0;
            }

            #wrapper {
                min-height: 100vh; /* Chiều cao tối thiểu bằng toàn bộ viewport */
                display: flex;
                flex-direction: column;
            }

            main {
                flex: 1; /* Phần main sẽ mở rộng để đẩy footer xuống dưới */
                padding-bottom: 50px; /* Khoảng cách dưới để tránh nội dung sát footer */
            }

            /* CSS cho phần nội dung bên trái */
            .welcome-section {
                margin-bottom: 30px;
            }

            /* CSS cho phần bài viết sản phẩm bên phải */
            .product-post {
                margin-bottom: 20px;
            }
            .product-post img {
                height: 150px;
                object-fit: cover;
                width: 100%;
            }
            .card-title {
                font-size: 1.1rem;
                font-weight: bold;
                margin-bottom: 0.5rem;
            }
            .card-text {
                font-size: 0.95rem;
            }
            .read-more {
                text-decoration: none;
                font-weight: bold;
                color: #28a745;
            }
            .read-more:hover {
                text-decoration: underline;
            }
        </style>
    </head>
    <body>
        <div id="wrapper">
            <%@ include file="header.jsp" %>

            <main>
                <div class="container mt-5">
                    <div class="row">
                        <!-- Cột bên trái: Nội dung chính -->
                        <div class="col-md-8">
                            <div class="welcome-section">
                                <h1>Welcome to FMSOS</h1>
                                <p class="lead">Your ultimate destination for Anime, Pokemon, and Gundam collections.</p>
                                <p>
                                    Tại FMSOS, chúng tôi cung cấp những sản phẩm chất lượng cao, cập nhật những xu hướng mới nhất và luôn cảnh báo cho quý khách hàng về những rủi ro lừa đảo trong giao dịch trực tuyến.
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </main>

            <%@ include file="footer.jsp" %>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>