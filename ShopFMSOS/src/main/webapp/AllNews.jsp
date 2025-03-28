<%-- 
    Document   : AllNews
    Created on : 20 Mar 2025, 00:33:56
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
            body {
                background: linear-gradient(135deg, #f0f4f8, #d9e2ec);
                font-family: 'Roboto', sans-serif;
            }
            .container-fluid {
                padding: 80px 50px 30px 50px; /* Tăng padding-top để tránh bị header che */
            }
            .news-header {
                text-align: center;
                margin-bottom: 40px;
                color: #2c3e50;
                text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.1);
                position: relative;
                z-index: 10; /* Đảm bảo tiêu đề nằm trên các phần tử khác */
            }
            .news-item {
                display: flex;
                align-items: center;
                background: #fff;
                border-radius: 15px;
                padding: 20px;
                margin-bottom: 20px;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }
            .news-item:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
            }
            .news-item img {
                width: 220px;
                height: 160px;
                object-fit: cover;
                border-radius: 10px;
                margin-right: 20px;
            }
            .news-content {
                flex: 1;
            }
            .news-title {
                font-size: 1.4rem;
                font-weight: 600;
                color: #34495e;
                margin-bottom: 10px;
                transition: color 0.3s ease;
            }
            .news-title:hover {
                color: #007bff;
            }
            .news-description {
                font-size: 1rem;
                color: #7f8c8d;
                line-height: 1.5;
                margin-bottom: 10px;
            }
            .news-date {
                font-size: 0.9rem;
                color: #95a5a6;
                margin-bottom: 15px;
            }
            .read-more {
                text-decoration: none;
                font-weight: 600;
                color: #fff;
                background: #007bff;
                padding: 8px 16px;
                border-radius: 20px;
                transition: background 0.3s ease;
            }
            .read-more:hover {
                background: #0056b3;
                text-decoration: none;
            }
            .add-news-btn {
                position: fixed;
                top: 120px; /* Đẩy xuống dưới để không che tiêu đề */
                right: 30px;
                z-index: 1000;
                width: 70px;
                height: 70px;
                border-radius: 50%;
                background: linear-gradient(45deg, #007bff, #00c4ff);
                color: white;
                font-size: 28px;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
                transition: transform 0.3s ease, background 0.3s ease;
            }
            .add-news-btn:hover {
                transform: scale(1.15);
                background: linear-gradient(45deg, #ff007a, #ff00cc);
            }
            .add-news-tooltip {
                position: absolute;
                top: 50%;
                right: 80px;
                background: #2c3e50;
                color: #fff;
                padding: 5px 12px;
                border-radius: 5px;
                display: none;
                font-size: 14px;
                white-space: nowrap;
                transform: translateY(-50%);
            }
            .add-news-btn:hover + .add-news-tooltip {
                display: block;
            }
            .search-sort-container {
                display: flex;
                gap: 20px;
                margin-bottom: 40px;
                justify-content: center;
            }
            .input-group, .sort-group {
                max-width: 400px;
            }
            .btn-primary {
                background: #007bff;
                border: none;
                border-radius: 20px;
                padding: 10px 20px;
                transition: background 0.3s ease;
            }
            .btn-primary:hover {
                background: #0056b3;
            }
            .form-select {
                border-radius: 20px;
                padding: 10px;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            }
            .pagination {
                justify-content: center;
                margin-top: 40px;
            }
            .page-item .page-link {
                border-radius: 50%;
                margin: 0 5px;
                color: #007bff;
                transition: background 0.3s ease;
            }
            .page-item.active .page-link {
                background: #007bff;
                color: #fff;
                border: none;
            }
            .page-item .page-link:hover {
                background: #e9ecef;
            }
        </style>
    </head>
    <body>
        <div id="wrapper">
            <%@ include file="header.jsp" %>
            <% if (loggedInUser != null && loggedInUser.getRoleId() == 1) { %>
            <a href="AddNews" class="add-news-btn">
                <i class="fas fa-pencil-alt"></i>
            </a>
            <div class="add-news-tooltip">Add News</div>
            <% } %>

            <main>
                <div class="container-fluid">
                    <h2 class="news-header">All News</h2>

                    <!-- Search and Sort -->
                    <div class="search-sort-container">
                        <form method="GET" action="AllNewsServlet" class="input-group">
                            <input type="text" name="search" class="form-control" placeholder="Search for news..." value="${param.search}">
                            <button class="btn btn-primary" type="submit">Search</button>
                        </form>

                        <form method="GET" action="AllNewsServlet" class="sort-group">
                            <c:if test="${not empty param.search}">
                                <input type="hidden" name="search" value="${param.search}">
                            </c:if>
                            <input type="hidden" name="page" value="${currentPage}">
                            <select name="sortOption" class="form-select" onchange="this.form.submit()">
                                <option value="name-asc" ${sortOption == 'name-asc' ? 'selected' : ''}>Title (A-Z)</option>
                                <option value="name-desc" ${sortOption == 'name-desc' ? 'selected' : ''}>Title (Z-A)</option>
                                <option value="created-asc" ${sortOption == 'created-asc' ? 'selected' : ''}>Date (Oldest First)</option>
                                <option value="created-desc" ${sortOption == 'created-desc' ? 'selected' : ''}>Date (Newest First)</option>
                                <option value="title-length-asc" ${sortOption == 'title-length-asc' ? 'selected' : ''}>Title Length (Shortest)</option>
                                <option value="title-length-desc" ${sortOption == 'title-length-desc' ? 'selected' : ''}>Title Length (Longest)</option>
                                <option value="user-asc" ${sortOption == 'user-asc' ? 'selected' : ''}>Author (A-Z)</option>
                                <option value="user-desc" ${sortOption == 'user-desc' ? 'selected' : ''}>Author (Z-A)</option>
                            </select>
                        </form>
                    </div>

                    <div class="row">
                        <!-- Display News -->
                        <c:forEach var="newsItem" items="${newsList}">
                            <c:if test="${newsItem.status == 1}">
                                <div class="col-12">
                                    <div class="news-item">
                                        <img src="${newsItem.image}" alt="${newsItem.title}">
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
                                                    Posted on <fmt:formatDate value="${newsItem.createdAt}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                                </small>
                                            </p>
                                            <a href="ViewNews?id=${newsItem.newsId}" class="read-more">Read More</a>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>

                    <!-- Pagination -->
                    <nav aria-label="Page navigation" class="pagination">
                        <ul class="pagination">
                            <c:if test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="AllNewsServlet?page=${currentPage - 1}&search=${param.search}&sortOption=${sortOption}">Previous</a>
                                </li>
                            </c:if>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="AllNewsServlet?page=${i}&search=${param.search}&sortOption=${sortOption}">${i}</a>
                                </li>
                            </c:forEach>
                            <c:if test="${currentPage < totalPages}">
                                <li class="page-item">
                                    <a class="page-link" href="AllNewsServlet?page=${currentPage + 1}&search=${param.search}&sortOption=${sortOption}">Next</a>
                                </li>
                            </c:if>
                        </ul>
                    </nav>
                </div>
            </main>

            <%@ include file="footer.jsp" %>
        </div>
        
    </body>
</html>