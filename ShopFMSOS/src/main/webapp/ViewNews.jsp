<%-- 
    Document   : ViewNews
    Created on : 17 thg 3, 2025, 20:20:36
    Author     : Tran Huy Lam CE180899
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${news.title}</title>
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css">
        <!-- Font Awesome for icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
        <style>
            body {
                background-color: #f0f2f5;
                font-family: 'Roboto', sans-serif;
                color: #1c1e21;
            }
            .container {
                max-width: 1200px;
                margin: 20px;
                padding-top: 50px;
                margin-top: 500px;  /* Tạo thêm khoảng cách nếu cần thiết */
            }

            .article-container {
                background-color: #fff;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                padding-top: 40px;      /* Khoảng cách trên */
                padding-left: 30px;     /* Khoảng cách bên trái */
                padding-right: 30px;    /* Khoảng cách bên phải */
                padding-bottom: 30px;   /* Khoảng cách dưới */
                margin-top: 80px;      /* Khoảng cách giữa container và các phần tử xung quanh */
                position: relative;
                max-width: 1200px;
                width: 100%;
            }
            .article-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding-bottom: 10px;
                border-bottom: 1px solid #dadde1;
                margin-bottom: 20px; /* Thêm khoảng cách dưới header */
            }
            .article-header h1 {
                font-size: 50px;
                font-weight: 600;
                margin: 0;
                margin-right: 20px; /* Thêm khoảng cách cho tiêu đề */
            }
            .article-content {
                display: grid;
                grid-template-columns: 1fr 3fr;
                gap: 20px;
            }
            .left-column {
                background-color: #f9f9f9;
                padding: 15px;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            }
            .main-column {
                background-color: #fff;
                border-radius: 8px;
                padding: 20px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            }
            .article-content img {
                width: 100%;
                max-width: 100%;
                height: auto;
                border-radius: 8px;
                margin: 10px 0;
            }
            .article-content p {
                font-size: 15px;
                line-height: 1.5;
            }
            .article-header p {
                font-size: 16px;
                color: #777;
            }
            .comment {
                background-color: #ffffff;
                border-radius: 12px;
                padding: 20px;
                margin-bottom: 20px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                transition: all 0.3s ease-in-out;
            }

            .comment:hover {
                box-shadow: 0 6px 12px rgba(0, 0, 0, 0.2);
                transform: translateY(-5px);
            }

            .comment p {
                margin: 0;
                font-size: 14px;
                color: #333;
            }

            .comment-content {
                font-size: 20px !important;  /* Dùng !important để đảm bảo không bị ghi đè */
                line-height: 1.8;
                margin: 15px 0;
                color: #555;
                transition: all 0.3s ease-in-out;
                font-weight: normal;
            }

            .comment-content:hover {
                color: #007bff;  /* Hiệu ứng hover khi di chuột vào nội dung */
                cursor: pointer;
            }

            .comment-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                font-weight: bold;
                color: #333;
                font-size: 16px;
            }

            .comment-date {
                font-size: 12px;
                color: #777;
            }

            .comment-actions {
                margin-top: 15px;
                display: flex;
                justify-content: flex-end;
                gap: 10px;
            }

            .comment-actions .btn {
                font-size: 14px;
                padding: 6px 12px;
                border-radius: 20px;
                transition: background-color 0.3s ease-in-out;
            }

            /* Hover effects for buttons */
            .comment-actions .btn:hover {
                background-color: #0056b3;
                color: white;
            }

            .dropdown {
                margin-left: 20px;  /* Thêm khoảng cách cho dropdown */
            }

            /* Cải thiện vị trí của nút 3 chấm */
            .comment-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                font-weight: bold;
                color: #333;
                font-size: 16px;
                margin-bottom: 15px;  /* Tăng khoảng cách dưới comment header */
            }

            .comment-header .dropdown-toggle {
                background-color: transparent;
                border: none;
                font-size: 16px;
                color: #007bff;
                margin-left: 10px; /* Đảm bảo khoảng cách với các phần tử khác */
            }

            .comment-header .dropdown-toggle:hover {
                color: #0056b3;
                cursor: pointer;
            }

            .comment .dropdown-menu {
                min-width: 150px;
                border-radius: 8px;
                padding: 10px 0;
            }

            .comment .dropdown-menu .dropdown-item {
                font-size: 14px;
                padding: 8px 20px;
                color: #333;
            }

            .comment .dropdown-menu .dropdown-item:hover {
                background-color: #f1f1f1;
                cursor: pointer;
            }

            .comment .dropdown-menu .dropdown-item:active {
                background-color: #d3d3d3;
            }

        </style>
    </head>
    <body>
        <div>
            <%@ include file="header.jsp" %>
        </div>
        <div class="container">
            <!-- Article Content -->
            <div class="article-container">
                <div class="article-header">
                    <a href="home" class="btn btn-primary"><i class="fas fa-arrow-left"></i> Home</a>
                    <h1>${news.title}</h1>
                    <p>${fn:substring(news.createdAt, 0, 19)}</p>
                    <% if (loggedInUser != null && (loggedInUser.getRoleId() == 1 || loggedInUser.getRoleId() == 2)) { %>
                    <div class="dropdown">
                        <button class="btn btn-secondary dropdown-toggle" type="button" id="dropdownMenuButton" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-ellipsis-v"></i>
                        </button>
                        <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                            <li><a class="dropdown-item" href="EditNews?newsId=${news.newsId}"><i class="fas fa-edit"></i> Edit</a></li>
                            <li><a class="dropdown-item" href="DeleteNews?newsId=${news.newsId}" onclick="return confirm('Are you sure you want to delete this news?')"><i class="fas fa-trash"></i> Delete</a></li>
                        </ul>
                    </div>
                    <% }%>
                </div>

                <div class="article-content">
                    <div class="left-column">
                        <h4>Other News</h4>
                        <c:forEach var="newsItem" items="${relatedPosts}">
                            <div class="related-post">
                                <c:if test="${not empty newsItem.image}">
                                    <img src="${newsItem.image}" alt="${newsItem.title}" class="related-post-image" />
                                </c:if>
                                <h5><a href="ViewNews?id=${newsItem.newsId}">${newsItem.title}</a></h5>
                                <p>
                                    <c:choose>
                                        <c:when test="${fn:length(newsItem.content) > 100}">
                                            ${newsItem.content.substring(0, 100)}...
                                        </c:when>
                                        <c:otherwise>
                                            ${newsItem.content}
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                            <hr>
                        </c:forEach>
                    </div>

                    <div class="main-column">
                        <p>${news.content}</p>
                        <img src="${news.image}" alt="Article Image">
                    </div>
                </div>

                <!-- Phần bình luận -->
                <div class="comments-section mt-5">
                    <h3>Bình luận</h3>

                    <!-- Form để thêm bình luận -->
                    <form action="AddComment" method="POST">
                        <input type="hidden" name="newsId" value="${news.newsId}">
                        <div class="form-group">
                            <label for="commentContent">Viết bình luận</label>
                            <textarea name="content" id="commentContent" class="form-control" rows="3" required></textarea>
                        </div>
                        <button type="submit" class="btn btn-primary mt-3">Gửi bình luận</button>
                    </form>

                    <h4 class="mt-4">Các bình luận khác</h4>
                    <c:if test="${empty newsComments}">
                        <p class="alert alert-warning">Chưa có bình luận nào.</p>
                    </c:if>

                    <c:forEach var="comment" items="${newsComments}">
                        <div class="comment">
                            <!-- Header của bình luận -->
                            <div class="comment-header d-flex justify-content-between align-items-center">
                                <div>
                                    <p><strong>${comment.user.email}</strong></p>
                                    <p class="comment-date">${fn:substring(comment.createdAt, 0, 19)}</p>
                                </div>

                                <!-- Nút 3 chấm chỉ hiển thị nếu có quyền -->
                                <c:if test="${comment.userId == loggedInUser.userId || loggedInUser.roleId == 1 || loggedInUser.roleId == 2}">
                                    <div class="dropdown">
                                        <button class="btn btn-link dropdown-toggle" type="button" id="dropdownMenuButton-${comment.commentId}" data-bs-toggle="dropdown" aria-expanded="false">
                                            <i class="fas fa-ellipsis-v"></i>
                                        </button>
                                        <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton-${comment.commentId}">
                                            <c:if test="${comment.userId == loggedInUser.userId}">
                                                <!-- Hiển thị Sửa và Xóa cho chủ bình luận -->
                                                <li><a class="dropdown-item" href="javascript:void(0);" onclick="showEditCommentForm(${comment.commentId}, '${comment.content}')">Sửa</a></li>
                                                <li><a class="dropdown-item" href="DeleteComment?commentId=${comment.commentId}&newsId=${news.newsId}" onclick="return confirm('Bạn có chắc chắn muốn xóa bình luận này?')">Xóa</a></li>
                                                </c:if>
                                                <c:if test="${loggedInUser.roleId == 1 || loggedInUser.roleId == 2}">
                                                <!-- Hiển thị chỉ Xóa cho Admin và Staff -->
                                                <li><a class="dropdown-item" href="DeleteComment?commentId=${comment.commentId}&newsId=${news.newsId}" onclick="return confirm('Bạn có chắc chắn muốn xóa bình luận này?')">Xóa</a></li>
                                                </c:if>
                                        </ul>
                                    </div>
                                </c:if>

                            </div>

                            <!-- Nội dung bình luận -->
                            <p class="comment-content" id="content-${comment.commentId}">${comment.content}</p>

                            <!-- Form chỉnh sửa bình luận -->
                            <div id="edit-form-${comment.commentId}" class="edit-comment-form" style="display:none;">
                                <form action="EditComment" method="POST">
                                    <input type="hidden" name="commentId" value="${comment.commentId}">
                                    <input type="hidden" name="newsId" value="${news.newsId}">
                                    <textarea name="content" class="form-control" rows="3">${comment.content}</textarea>
                                    <button type="submit" class="btn btn-success btn-sm mt-2">Cập nhật</button>
                                    <button type="button" class="btn btn-secondary btn-sm mt-2" onclick="hideEditCommentForm(${comment.commentId})">Hủy</button>
                                </form>
                            </div>

                            <hr>
                        </div>
                    </c:forEach>
                </div>

            </div>
        </div>

        <script>
            function showEditCommentForm(commentId, content) {
                document.getElementById("content-" + commentId).style.display = "none";
                document.getElementById("edit-form-" + commentId).style.display = "block";
            }

            function hideEditCommentForm(commentId) {
                document.getElementById("content-" + commentId).style.display = "block";
                document.getElementById("edit-form-" + commentId).style.display = "none";
            }
        </script>

        <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.2/dist/umd/popper.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.min.js"></script>
    </body>
</html>
