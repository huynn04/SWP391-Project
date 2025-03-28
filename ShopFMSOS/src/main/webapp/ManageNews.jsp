<%-- 
    Document   : ManageNews
    Created on : 17 thg 3, 2025, 19:24:24
    Author     : Tran Huy Lam CE180899 
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>News Management</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
        <style>
            body {
                padding-top: 56px;
            }
            .sidebar {
                height: 100vh;
                padding-top: 20px;
                background-color: #f8f9fa;
            }
            .sidebar a {
                color: #333;
                display: block;
                padding: 10px 15px;
                text-decoration: none;
            }
            .sidebar a:hover {
                background-color: #ddd;
            }
            .news-img {
                width: 100px;
                height: 100px;
                object-fit: cover;
            }
        </style>
    </head>
    <body>
        <!-- Top Navigation Bar -->
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
            <a class="navbar-brand" href="dashboard">Admin Dashboard</a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarResponsive"
                    aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
        </nav>

        <div class="container-fluid">
            <div class="row">
                <jsp:include page="sidebar.jsp" />

                <!-- Main content -->
                <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">
                    <div class="pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">News Management</h1>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item active" aria-current="page">News Management</li>
                            </ol>
                        </nav>

                        <a href="AddNews" class="btn btn-success mb-3">Add New News</a>
                        <form action="ManageNews" method="get" class="form-inline mb-3">
                            <div class="form-group mr-2">
                                <label for="searchQuery" class="mr-2">Search:</label>
                                <input type="text" name="searchQuery" id="searchQuery" class="form-control" placeholder="Enter title or ID" value="${param.searchQuery}">
                            </div>
                            <div class="form-group mr-2">
                                <label for="searchBy" class="mr-2">Search By:</label>
                                <select name="searchBy" id="searchBy" class="form-control">
                                    <option value="id" ${param.searchBy == 'id' ? 'selected' : ''}>ID</option>
                                    <option value="title" ${param.searchBy == 'title' ? 'selected' : ''}>Title</option>
                                </select>
                            </div>
                            <div class="form-group mr-2">
                                <label for="sortBy" class="mr-2">Sort By:</label>
                                <select name="sortBy" id="sortBy" class="form-control">
                                    <option value="id" ${param.sortBy == 'id' ? 'selected' : ''}>ID</option>
                                    <option value="date" ${param.sortBy == 'date' ? 'selected' : ''}>Date</option>
                                </select>
                            </div>
                            <button type="submit" class="btn btn-primary">Search & Sort</button>
                        </form>
                    </div>

                    <!-- Hiển thị danh sách tin tức -->
                    <c:choose>
                        <c:when test="${empty newsList}">
                            <div class="alert alert-warning">No news found.</div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th>Image</th>
                                            <th>ID</th>
                                            <th>Title</th>
                                            <th>Status</th>
                                            <th>Created At</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="news" items="${newsList}">
                                            <tr>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty news.image}">
                                                            <img src="${news.image}" alt="News Image" class="news-img"/>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <img src="image/noimage.jpg" alt="No Image" class="news-img"/>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>${news.newsId}</td>
                                                <td>${news.title}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${news.status == 1}">Active</c:when>
                                                        <c:otherwise>Inactive</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <!-- Formater la date pour afficher jour, mois, année, heure, minute, seconde -->
                                                    <fmt:formatDate value="${news.createdAt}" pattern="yyyy-MM-dd HH:mm:ss" />
                                                </td>
                                                <td>
                                                    <a href="ViewNews?id=${news.newsId}" class="btn btn-info btn-sm">View</a>
                                                    <a href="EditNews?newsId=${news.newsId}" class="btn btn-primary btn-sm">Edit</a>
                                                    <a href="DeleteNews?id=${news.newsId}" class="btn btn-danger btn-sm" onclick="return confirm('Bạn có chắc muốn xóa tin tức này?');">Delete</a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <!-- Phân trang -->
                            <div class="d-flex justify-content-between">
                                <c:if test="${currentPage > 1}">
                                    <a href="ManageNews?page=${currentPage - 1}&searchQuery=${param.searchQuery}&searchBy=${param.searchBy}&sortBy=${param.sortBy}" class="btn btn-secondary">Previous</a>
                                </c:if>

                                <span>Page ${currentPage} of ${totalPages}</span>

                                <c:if test="${currentPage < totalPages}">
                                    <a href="ManageNews?page=${currentPage + 1}&searchQuery=${param.searchQuery}&searchBy=${param.searchBy}&sortBy=${param.sortBy}" class="btn btn-secondary">Next</a>
                                </c:if>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </main>
            </div>
        </div>
    </body>
</html>
