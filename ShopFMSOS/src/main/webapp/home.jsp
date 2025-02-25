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
        <style> 
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
        <%@ include file="header.jsp" %>

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

        <%@ include file="footer.jsp" %>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
