<%-- 
    Document   : AllNews
    Created on : 20 thg 3, 2025, 00:33:56
    Author     : Tran Huy Lam CE180899 
--%>


<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List, model.News" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>All News - FMSOS</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
        <link rel="stylesheet" href="css/style.css">
        <style>
            /* Thiết lập Flexbox để căn chỉnh các phần tử */
            .news-item {
                display: flex;
                align-items: center; /* Căn giữa theo chiều dọc */
                border-bottom: 1px solid #ddd; /* Đường viền dưới bài viết */
                padding: 20px 0;
                gap: 20px; /* Khoảng cách giữa ảnh và nội dung */
            }

            .news-item img {
                width: 200px; /* Đặt chiều rộng cho hình ảnh */
                height: 150px;
                object-fit: cover;
                border-radius: 8px; /* Bo góc hình ảnh */
            }

            .news-content {
                flex: 1; /* Chiếm không gian còn lại */
            }

            .news-title {
                font-size: 1.25rem;
                font-weight: bold;
                color: #333;
                margin-bottom: 10px;
            }

            .news-description {
                font-size: 0.95rem;
                color: #555;
                margin-bottom: 10px;
            }

            .news-date {
                font-size: 0.85rem;
                color: #777;
                margin-bottom: 10px;
            }

            .read-more {
                text-decoration: none;
                font-weight: bold;
                color: #007bff;
            }

            .read-more:hover {
                text-decoration: underline;
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
                    <h2 class="mb-4">All News</h2>

                    <!-- Tìm kiếm tin tức -->
                    <form method="GET" action="AllNews" class="mb-4">
                        <div class="input-group">
                            <input type="text" name="search" class="form-control" placeholder="Search for news..." value="${param.search}">
                            <button class="btn btn-primary" type="submit">Search</button>
                        </div>
                    </form>

                    <div class="row">
                        <!-- Hiển thị tin tức -->
                        <c:forEach var="newsItem" items="${newsList}">
                            <div class="col-12 mb-4">
                                <div class="news-item">
                                    <!-- Hình ảnh -->
                                    <img src="${newsItem.image}" alt="${newsItem.title}">

                                    <!-- Nội dung -->
                                    <div class="news-content">
                                        <h5 class="news-title">${newsItem.title}</h5>
                                        <p class="news-description">
                                            <c:choose>
                                                <c:when test="${fn:length(newsItem.content) > 100}">
                                                    ${fn:substring(newsItem.content, 0, 100)}...
                                                </c:when>
                                                <c:otherwise>
                                                    ${newsItem.content}
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                        <p class="news-date">
                                            <small class="text-muted">
                                                Đăng ngày <fmt:formatDate value="${newsItem.createdAt}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                            </small>
                                        </p>
                                        <a href="ViewNews?id=${newsItem.newsId}" class="btn btn-primary btn-sm read-more">Read More</a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Phân trang -->
                    <div class="text-center mt-4">
                        <c:if test="${currentPage > 1}">
                            <a href="AllNews?page=${currentPage - 1}&search=${param.search}" class="btn btn-secondary">Previous</a>
                        </c:if>

                        <span>Page ${currentPage} of ${totalPages}</span>

                        <c:if test="${currentPage < totalPages}">
                            <a href="AllNews?page=${currentPage + 1}&search=${param.search}" class="btn btn-secondary">Next</a>
                        </c:if>
                    </div>

                </div>
            </main>

            <%@ include file="footer.jsp" %>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>


</html>