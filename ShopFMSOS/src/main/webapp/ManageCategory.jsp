<%@ page import="dal.CategoryDAO, model.Category, java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    CategoryDAO categoryDAO = new CategoryDAO();
    List<Category> categories = categoryDAO.getAllCategories();

    String action = request.getParameter("action");
    if ("add".equals(action)) {
        String name = request.getParameter("name");
        String desc = request.getParameter("description");
        String image = request.getParameter("image");
        int status = Integer.parseInt(request.getParameter("status"));
        categoryDAO.addCategory(new Category(0, name, desc, image, status, null, null));
        response.sendRedirect("ManageCategory.jsp");
    } else if ("update".equals(action)) {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String desc = request.getParameter("description");
        String image = request.getParameter("image");
        int status = Integer.parseInt(request.getParameter("status"));
        categoryDAO.updateCategory(new Category(id, name, desc, image, status, null, null));
        response.sendRedirect("ManageCategory.jsp");
    } else if ("delete".equals(action)) {
        int id = Integer.parseInt(request.getParameter("id"));
        categoryDAO.deleteCategory(id);
        response.sendRedirect("ManageCategory.jsp");
    }
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Category Management</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
        <style>
            body { padding-top: 56px; }
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
            .sidebar a:hover { background-color: #ddd; }
            .category-img {
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
        </nav>

        <div class="container-fluid">
            <div class="row">
                <jsp:include page="sidebar.jsp" />

                <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">
                    <div class="pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">Category Management</h1>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item active" aria-current="page">Category Management</li>
                            </ol>
                        </nav>

                        <a href="#" class="btn btn-success mb-3" data-toggle="modal" data-target="#addCategoryModal">Add New Category</a>

                        <form action="ManageCategory.jsp" method="get" class="form-inline mb-3">
                            <div class="form-group mr-2">
                                <label for="searchQuery" class="mr-2">Search:</label>
                                <input type="text" name="searchQuery" id="searchQuery" class="form-control" placeholder="Enter name or ID" value="${param.searchQuery}">
                            </div>
                            <button type="submit" class="btn btn-primary">Search</button>
                        </form>
                    </div>

                    <!-- Hiển thị danh sách danh mục -->
                    <c:choose>
                        <c:when test="${empty categories}">
                            <div class="alert alert-warning">No category found.</div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th>Image</th>
                                            <th>ID</th>
                                            <th>Category Name</th>
                                            <th>Describe</th>
                                            <th>Status</th>
                                            <th>Create Date</th>
                                            <th>Update Date</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="c" items="${categories}">
                                            <tr>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty c.image}">
                                                            <img src="${c.image}" alt="Category Image" class="category-img"/>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <img src="image/noimage.jpg" alt="No Image" class="category-img"/>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>${c.categoryId}</td>
                                                <td>${c.categoryName}</td>
                                                <td>${c.description}</td> 
                                                <td>${c.status == 1 ? "Active" : "Inactive"}</td>
                                                <td>${c.createdAt}</td>
                                                <td>${c.updatedAt}</td>
                                                <td>
                                                    <a href="EditCategory.jsp?id=${c.categoryId}" class="btn btn-primary btn-sm">Edit</a>
                                                    <a href="ManageCategory.jsp?action=delete&id=${c.categoryId}" class="btn btn-danger btn-sm" onclick="return confirm('Bạn có chắc muốn xóa danh mục này?');">Delete</a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </main>
            </div>
        </div>

        <!-- Modal thêm danh mục -->
        <div class="modal fade" id="addCategoryModal" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Add New Category</h5>
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                    </div>
                    <form action="ManageCategory.jsp" method="post">
                        <div class="modal-body">
                            <input type="hidden" name="action" value="add">
                            <div class="form-group">
                                <label>Category Name</label>
                                <input type="text" name="name" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label>Description</label>
                                <input type="text" name="description" class="form-control">
                            </div>
                            <div class="form-group">
                                <label>Image URL</label>
                                <input type="text" name="image" class="form-control">
                            </div>
                            <div class="form-group">
                                <label>Status</label>
                                <select name="status" class="form-control">
                                    <option value="1">Active</option>
                                    <option value="0">Inactive</option>
                                </select>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="submit" class="btn btn-primary">Save</button>
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
    </body>
</html>
