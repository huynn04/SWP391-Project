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
            /* Ensure the whole page has a minimum height */
            html, body {
                height: 100%;
                margin: 0;
            }

            /* Container chính chứa tất cả phần tử */
            #wrapper {
                min-height: 100vh; /* Đảm bảo chiều cao đầy đủ */
                display: flex;
                flex-direction: column;
            }

            /* Phần nội dung chính */
            main {
                flex: 1; /* Chiếm không gian còn lại giữa header và footer */
                padding-bottom: 50px;
                padding-top:50px;/* Đảm bảo có khoảng trống dưới cùng để footer không đè lên */
            }

            /* Stretch the container to full width */
            .custom-wrapper {
                max-width: 1200px; /* Adjust the maximum width as needed */
                margin-left: auto;
                margin-right: auto; /* Center the wrapper horizontally */
                padding-left: 15px; /* Adjust the padding on the left side */
                padding-right: 15px; /* Adjust the padding on the right side */
            }



            .carousel {
                width: 100vw; /* Ensure the carousel takes up the full width of the screen */
                margin-right: 0; /* Remove right margin */
            }
            /* Formatting for carousel items */
            .carousel-inner {
                width: 100%; /* Ensure the carousel items fill the available space */
                overflow: hidden;
            }

            .carousel-item {
                display: flex;
                justify-content: space-between;
                flex-wrap: nowrap;
                width: 100%; /* Ensure each item is full-width */
            }

            .carousel-item img {
                width: 100vw; /* Make sure the image stretches across the full screen */
                height: auto; /* Maintain aspect ratio */
                object-fit: cover; /* Cover the entire area */
            }

            .col-md-4 {
                flex: 1 1 30%;
                max-width: 30%;
                margin-bottom: 20px;
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
                height: 200px;
                object-fit: cover;
                width: 100%;
            }

            .card-body {
                padding: 10px;
            }

            .card-title {
                font-size: 1rem;
                font-weight: 600;
                margin-bottom: 10px;
            }

            .card-text {
                font-size: 0.85rem;
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

            /* Add News Button */
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

            /* Hover effect for button */
            .add-news-btn:hover {
                transform: scale(1.1);
                background-color: hotpink;
            }

            /* Tooltip when hovering */
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

            /* Show tooltip on hover */
            .add-news-btn:hover + .add-news-tooltip {
                display: block;
            }

            /* General page element formatting */
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

            /* Align title and "See All" button in the same row */
            h2.d-flex {
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .center-content {
                display: flex;
                justify-content: center;
                align-items: center;
                height: 40vh;
                margin: 0;
                padding: 0 0px;
                text-align: center;
            }
            #scrollToTopBtn {
                position: fixed;
                bottom: 60px; /* Tăng giá trị này để nút xuất hiện cao hơn */
                right: 20px;
                background-color: #007bff;
                color: white;
                border: none;
                border-radius: 50%;
                padding: 15px;
                font-size: 18px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
                cursor: pointer;
                z-index: 1000;
                display: none; /* Initially hidden */
                transition: background-color 0.3s ease;
            }

            #scrollToTopBtn:hover {
                background-color: #0056b3;
            }


        </style>
    </head>
    <body>
        <div id="wrapper">
            <%@ include file="header.jsp" %>

            <!-- Add "Add News" button -->
            <% if (loggedInUser != null && loggedInUser.getRoleId() == 1) { %>
            <a href="AddNews" class="add-news-btn">
                <i class="fas fa-pencil-alt"></i> <!-- Pen icon -->
            </a>
            <div class="add-news-tooltip">Add News</div>
            <% }
            %>

            <main>
                <div class="row center-content">
                    <!-- Left column: Main content -->
                    <div class="col-md-12">
                        <div class="welcome-section">
                            <h1>Welcome to FMSOS</h1>
                            <p class="lead">Your ultimate destination for Anime, Pokemon, and Gundam collections.</p>
                            <p>
                                At FMSOS, we provide high-quality products, stay updated with the latest trends, and always alert our customers about the risks of online scams.
                            </p>
                        </div>
                    </div>
                </div>


                <!-- Carousel - Advertising -->
                <div id="advertisementCarousel" class="carousel slide mb-4" data-bs-ride="carousel">
                    <div class="carousel-indicators">
                        <button type="button" data-bs-target="#advertisementCarousel" data-bs-slide-to="0" class="active"></button>
                        <button type="button" data-bs-target="#advertisementCarousel" data-bs-slide-to="1"></button>
                        <button type="button" data-bs-target="#advertisementCarousel" data-bs-slide-to="2"></button>
                        <button type="button" data-bs-target="#advertisementCarousel" data-bs-slide-to="3"></button>
                    </div>

                    <div class="carousel-inner">
                        <div class="carousel-item active">
                            <img src="image/banner1.webp" class="d-block w-100" alt="Banner 1">
                            <div class="carousel-caption d-none d-md-block">
                                <h5>Exciting Promotions!</h5>
                                <p>Up to 50% off on all Anime products.</p>
                            </div>
                        </div>
                        <div class="carousel-item">
                            <img src="image/banner2.webp" class="d-block w-100" alt="Banner 2">
                            <div class="carousel-caption d-none d-md-block">
                                <h5>New Pokemon Collection</h5>
                                <p>Own the limited edition Pokemon figures now!</p>
                            </div>
                        </div>
                        <div class="carousel-item">
                            <img src="image/banner3.webp" class="d-block w-100" alt="Banner 3">
                            <div class="carousel-caption d-none d-md-block">
                                <h5>Gundam Series</h5>
                                <p>Discover the latest Gundam models at great prices.</p>
                            </div>
                        </div>
                        <div class="carousel-item">
                            <img src="image/banner4.webp" class="d-block w-100" alt="Banner 4">
                            <div class="carousel-caption d-none d-md-block">
                                <h5>New Arrivals!</h5>
                                <p>Get ready for the hottest products launching soon.</p>
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

                <div class="container mt-5">
                    <h2 class="d-flex justify-content-between mb-4">
                        Recent News

                        <a href="AllNews" class="btn btn-secondary">See All</a>
                    </h2>

                    <div class="row">
                        <c:forEach var="newsItem" items="${newsList}">
                            <c:if test="${newsItem.status == 1}">
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
                                                    Posted on <fmt:formatDate value="${newsItem.createdAt}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                                </small>
                                            </p>
                                            <a href="ViewNews?id=${newsItem.newsId}" class="btn btn-primary btn-sm">Read More</a>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                </div>
                <!-- Back to Top Button -->
                <button id="scrollToTopBtn" title="Go to top">
                    <i class="fas fa-arrow-up"></i>
                </button>
            </main>

            <%@ include file="footer.jsp" %>
        </div>
        <script>
            // Get the button
            var mybutton = document.getElementById("scrollToTopBtn");

            // When the user scrolls down 20px from the top of the document, show the button
            window.onscroll = function () {
                if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
                    mybutton.style.display = "block";
                } else {
                    mybutton.style.display = "none";
                }
            };

            // When the user clicks the button, scroll to the top of the document
            mybutton.onclick = function () {
                document.body.scrollTop = 0; // For Safari
                document.documentElement.scrollTop = 0; // For Chrome, Firefox, IE, and Opera
            };
        </script>

    </body>
</html>
