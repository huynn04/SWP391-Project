<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>News Management</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
        <style>
            body {
                padding-top: 56px;
                background: #f0f2f5;
                font-family: 'Roboto', sans-serif;
            }
            .sidebar {
                height: 100vh;
                padding-top: 20px;
                background-color: #f8f9fa;
                position: fixed;
                width: 250px;
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
            .avatar-img {
                width: 100px;
                height: 100px;
                object-fit: cover;
                border-radius: 50%;
            }
            main {
                margin-left: 250px;
                padding: 20px;
            }
            .search-container, .sort-container {
                margin-bottom: 20px;
                display: flex;
                justify-content: flex-start;
                gap: 15px;
            }
            .form-select, .form-control {
                border-radius: 5px;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            }
            .table-responsive {
                background: #fff;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                padding: 20px;
            }
            .news-img {
                width: 80px;   /* Adjust the width as needed */
                height: 80px;  /* Adjust the height as needed */
                object-fit: cover;
            }

        </style>
    </head>
    <body>
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
            <a class="navbar-brand" href="dashboard">Admin Dashboard</a>
        </nav>

        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <nav class="col-md-3 col-lg-2 d-md-block sidebar">
                    <div class="sidebar-sticky">
                        <jsp:include page="sidebar.jsp" />
                    </div>
                </nav>

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

                        <!-- Search Section -->
                        <div class="search-container">
                            <form action="ManageNews" method="get" class="form-inline">
                                <label for="searchQuery" class="mr-2">Search:</label>
                                <input type="text" name="searchQuery" id="searchQuery" class="form-control mr-2" placeholder="Enter title" value="${param.searchQuery}">
                                <input type="hidden" name="searchBy" value="title"> <!-- Always search by title -->
                                <button type="submit" class="btn btn-primary">Search</button>
                            </form>
                        </div>


                        <div class="sort-container">
                            <form action="ManageNews" method="get" class="form-inline">
                                <label for="sortBy" class="mr-2">Sort By:</label>
                                <select name="sortBy" id="sortBy" class="form-select" onchange="this.form.submit()">
                                    <option value="id-asc" ${param.sortBy == 'id-asc' ? 'selected' : ''}>ID (Ascending)</option>
                                    <option value="id-desc" ${param.sortBy == 'id-desc' ? 'selected' : ''}>ID (Descending)</option>
                                    <option value="date-asc" ${param.sortBy == 'date-asc' ? 'selected' : ''}>Date (Oldest First)</option>
                                    <option value="date-desc" ${param.sortBy == 'date-desc' ? 'selected' : ''}>Date (Newest First)</option>
                                </select>
                            </form>
                        </div>
                    </div>

                    <!-- Display news list -->
                    <!-- Display news list -->
                    <c:choose>
                        <c:when test="${empty newsList}">
                            <div class="alert alert-warning">No news found.</div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-striped table-sm">
                                    <thead>
                                        <tr>
                                            <th>Image</th>
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
                                                <td>${news.title}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${news.status == 1}">Active</c:when>
                                                        <c:otherwise>Inactive</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <fmt:formatDate value="${news.createdAt}" pattern="yyyy-MM-dd HH:mm:ss" />
                                                </td>
                                                <td>
                                                    <a href="ViewNews?id=${news.newsId}" class="btn btn-info btn-sm">View</a>
                                                    <a href="EditNews?newsId=${news.newsId}" class="btn btn-primary btn-sm">Edit</a>
                                                    <a href="DeleteNews?id=${news.newsId}" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this news?');">Delete</a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <!-- Pagination -->
                            <nav aria-label="Page navigation">
                                <ul class="pagination">
                                    <c:if test="${currentPage > 1}">
                                        <li class="page-item">
                                            <a class="page-link" href="ManageNews?page=${currentPage - 1}&searchQuery=${param.searchQuery}&searchBy=${param.searchBy}&sortBy=${param.sortBy}">Previous</a>
                                        </li>
                                    </c:if>
                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                                            <a class="page-link" href="ManageNews?page=${i}&searchQuery=${param.searchQuery}&searchBy=${param.searchBy}&sortBy=${param.sortBy}">${i}</a>
                                        </li>
                                    </c:forEach>
                                    <c:if test="${currentPage < totalPages}">
                                        <li class="page-item">
                                            <a class="page-link" href="ManageNews?page=${currentPage + 1}&searchQuery=${param.searchQuery}&searchBy=${param.searchBy}&sortBy=${param.sortBy}">Next</a>
                                        </li>
                                    </c:if>
                                </ul>
                            </nav>
                        </c:otherwise>
                    </c:choose>

                </main>
            </div>
        </div>

        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
        <script src="https://unpkg.com/feather-icons"></script>
        <script>
                                    feather.replace();
        </script>
    </body>
</html>
