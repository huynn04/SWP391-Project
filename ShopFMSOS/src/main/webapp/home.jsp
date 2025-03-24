<%-- 
    Document   : home
    Created on : Feb 12, 2025, 3:39:48 PM
    Author     : Nguyễn Ngoc Huy CE180178
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List, model.Product" %>
<%@ page import="model.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Home - FMSOS</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
        <link rel="stylesheet" href="css/style.css">
        <style>
            /* Đảm bảo toàn bộ trang có chiều cao tối thiểu */
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

            /* Định dạng cho các bài viết carousel */
            .carousel-inner {
                border-radius: 10px;
                overflow: hidden;
            }

            .carousel-item {
                display: flex;
                justify-content: space-between;
                flex-wrap: nowrap; /* Đảm bảo các phần tử không xuống dòng */
            }

            .col-md-4 {
                flex: 1 1 30%;  /* Đảm bảo mỗi ô chiếm khoảng 30% chiều rộng */
                max-width: 30%;  /* Giới hạn chiều rộng tối đa của mỗi ô */
                margin-bottom: 20px;  /* Đảm bảo có khoảng cách giữa các bài viết */
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

            .card-img-top {
                height: 200px;  /* Giảm chiều cao của ảnh */
                object-fit: cover;
                width: 100%;
            }

            .card-body {
                padding: 10px;  /* Giảm padding trong card */
            }

            .card-title {
                font-size: 1rem;  /* Giảm kích thước font */
                font-weight: 600;
                margin-bottom: 10px;
            }

            .card-text {
                font-size: 0.85rem;  /* Giảm kích thước chữ trong phần mô tả */
                margin-bottom: 15px;
            }

            .card-footer {
                background-color: #f8f9fa;
                border-top: 1px solid #e9ecef;
                padding: 8px;
                text-align: center;
            }

            .card-footer .btn {
                font-size: 0.85rem;
                padding: 5px 10px;
                background-color: #007bff;
                color: white;
                border-radius: 5px;
                transition: background-color 0.3s;
            }

            .card-footer .btn:hover {
                background-color: #0056b3;
            }

            /* Carousel Caption */
            .carousel-caption h5 {
                font-size: 2rem;
                font-weight: bold;
                color: yellow;
                text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.7);
            }

            .carousel-caption p {
                font-size: 1.2rem;
                color: white;
                text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.7);
            }

            .carousel-caption {
                background: rgba(0, 0, 0, 0.5);
                padding: 15px;
                border-radius: 10px;
                display: inline-block;
            }

            #advertisementCarousel {
                margin-top: 50px;
            }

            .container {
                padding-top: 500px;
            }

            /* Đảm bảo nút "Add News" luôn hiển thị */
            .add-news-btn {
                position: fixed;
                top: 100px;
                right: 20px;
                z-index: 1000;
                width: 80px;
                height: 80px;
                border-radius: 50%;
                background-color: #007bff;
                color: white;
                font-size: 24px;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
                transition: transform 0.3s ease-out, background-color 0.3s ease;
            }

            /* Hiệu ứng hover cho nút */
            .add-news-btn:hover {
                transform: scale(1.1);
                background-color: hotpink;
            }

            /* Tooltip khi hover */
            .add-news-tooltip {
                position: absolute;
                top: 23%;
                right: 19px;
                background-color: #333;
                color: #fff;
                padding: 5px 10px;
                border-radius: 5px;
                display: none;
                font-size: 14px;
                white-space: nowrap;
                transform: translateY(-50%);
            }

            /* Hiển thị tooltip khi hover */
            .add-news-btn:hover + .add-news-tooltip {
                display: block;
            }

            /* Định dạng các phần tử trong trang */
            .welcome-section {
                margin-bottom: 30px;
            }

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
            /* Căn chỉnh tiêu đề và nút "Xem tất cả" trong cùng một hàng */
            h2.d-flex {
                display: flex;
                justify-content: space-between; /* Đưa "Recent News" và "Xem tất cả" vào hai đầu */
                align-items: center; /* Căn giữa theo chiều dọc */
            }


        </style>
    </head>
    <body>
        <div id="wrapper">
            <%@ include file="header.jsp" %>

            <!-- Thêm nút "Add News" lên phía trên bên trái -->
            <% if (loggedInUser != null && loggedInUser.getRoleId() == 1) { %>
            <a href="AddNews" class="add-news-btn">
                <i class="fas fa-pencil-alt"></i> <!-- Biểu tượng cây bút -->
            </a>
            <div class="add-news-tooltip">Add News</div>
            <% }
            %>

            <main>
                <div class="container mt-5">
                    <div class="row">
                        <!-- Cột bên trái: Nội dung chính -->
                        <div class="col-md-8">
                            <div class="welcome-section">
                                <h1>Welcome to FMSOS</h1>
                                <p class="lead">Your ultimate destination for Anime, Pokemon, and Gundam collections.</p>
                                <p>
                                    At FMSOS, we provide high-quality products, stay updated with the latest trends, and always alert our customers about the risks of online scams.
                                </p>
                            </div>
                        </div>
                    </div>

                    <!-- Carousel - Trình chiếu quảng cáo -->
                    <div id="advertisementCarousel" class="carousel slide mb-4" data-bs-ride="carousel">
                        <div class="carousel-indicators">
                            <button type="button" data-bs-target="#advertisementCarousel" data-bs-slide-to="0" class="active"></button>
                            <button type="button" data-bs-target="#advertisementCarousel" data-bs-slide-to="1"></button>
                            <button type="button" data-bs-target="#advertisementCarousel" data-bs-slide-to="2"></button>
                            <button type="button" data-bs-target="#advertisementCarousel" data-bs-slide-to="3"></button>
                        </div>

                        <div class="carousel-inner">
                            <div class="carousel-item active">
                                <img src="image/Banner1.png" class="d-block w-100" alt="Banner 1">
                                <div class="carousel-caption d-none d-md-block">
                                    <h5>Khuyến mãi hấp dẫn!</h5>
                                    <p>Giảm giá lên đến 50% cho tất cả sản phẩm Anime.</p>
                                </div>
                            </div>
                            <div class="carousel-item">
                                <img src="image/Banner2.png" class="d-block w-100" alt="Banner 2">
                                <div class="carousel-caption d-none d-md-block">
                                    <h5>Bộ sưu tập Pokemon mới</h5>
                                    <p>Hãy sở hữu ngay các mô hình Pokemon giới hạn!</p>
                                </div>
                            </div>
                            <div class="carousel-item">
                                <img src="image/Banner3.png" class="d-block w-100" alt="Banner 3">
                                <div class="carousel-caption d-none d-md-block">
                                    <h5>Gundam Series</h5>
                                    <p>Khám phá những mẫu Gundam mới nhất với giá cực tốt.</p>
                                </div>
                            </div>
                            <div class="carousel-item">
                                <img src="image/Banner4.png" class="d-block w-100" alt="Banner 4">
                                <div class="carousel-caption d-none d-md-block">
                                    <h5>Hàng mới về!</h5>
                                    <p>Đón chờ những sản phẩm hot nhất sắp ra mắt.</p>
                                </div>
                            </div>
                        </div>

                        <button class="carousel-control-prev" type="button" data-bs-target="#advertisementCarousel" data-bs-slide="prev">
                            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                            <span class="visually-hidden">Previous</span>
                        </button>
                        <button class="carousel-control-next" type="button" data-bs-target="#advertisementCarousel" data-bs-slide="next">
                            <span class="carousel-control-next-icon" aria-hidden="true"></span>
                            <span class="visually-hidden">Next</span>
                        </button>
                    </div>
                    <h2 class="d-flex justify-content-between mb-4">
                        Recent News
                        <!-- Hiển thị liên kết Xem tất cả nếu có nhiều bài -->
                        <a href="AllNews" class="btn btn-secondary">Xem tất cả</a>
                    </h2>

                    <div class="row">
                        <c:forEach var="newsItem" items="${newsList}">
                            <div class="col-md-4 mb-4">
                                <div class="card">
                                    <img src="${newsItem.image}" class="card-img-top" alt="${newsItem.title}">
                                    <div class="card-body">
                                        <h5 class="card-title">${newsItem.title}</h5>
                                        <p class="card-text">
                                            <c:choose>
                                                <c:when test="${fn:length(newsItem.content) > 100}">
                                                    ${fn:substring(newsItem.content, 0, 100)}...
                                                </c:when>
                                                <c:otherwise>
                                                    ${newsItem.content}
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                        <p class="card-text">
                                            <small class="text-muted">
                                                Đăng ngày <fmt:formatDate value="${newsItem.createdAt}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                            </small>
                                        </p>
                                        <a href="ViewNews?id=${newsItem.newsId}" class="btn btn-primary btn-sm">Read More</a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>



                </div>
            </main>

            <%@ include file="footer.jsp" %>
        </div>

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
