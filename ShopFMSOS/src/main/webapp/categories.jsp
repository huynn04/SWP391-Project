<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Categories</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
        }

        .content-wrapper {
            padding-top: 60px;
        }

        .table {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .category-img {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 5px;
        }

        .action-btns {
            display: flex;
            gap: 10px;
        }

        .add-btn {
            margin-top: 20px;
            text-align: center;
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>
    <div class="container content-wrapper">
        <h2>Categories List</h2>
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>Category ID</th>
                    <th>Category Name</th>
                    <th>Description</th>
                    <th>Image</th>
                    <th>Status</th>
                    <th>Created At</th>
                    <th>Updated At</th>
                    <th>Action</th> <!-- New Action Column -->
                </tr>
            </thead>
            <tbody>
                <!-- Duyệt qua các danh mục và hiển thị tất cả các thuộc tính -->
                <c:forEach var="category" items="${categories}">
                    <tr>
                        <td>${category.categoryId}</td>
                        <td>${category.categoryName}</td>
                        <td>${category.description}</td>
                        <td>
                            <!-- Kiểm tra và hiển thị ảnh nếu có, nếu không hiển thị ảnh mặc định -->
                            <c:choose>
                                <c:when test="${category.image != null}">
                                    <img src="${category.image}" alt="${category.categoryName}" class="category-img">
                                </c:when>
                                <c:otherwise>
                                    <img src="images/no-image.png" alt="No image" class="category-img">
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>${category.status == 1 ? 'Active' : 'Inactive'}</td>
                        <td>${category.createdAt}</td>
                        <td>${category.updatedAt}</td>
                        <td class="action-btns">
                            <!-- Update button -->
                            <a href="UpdateCategory?categoryId=${category.categoryId}" class="btn btn-warning btn-sm">Update</a>
                            
                            <!-- View Product button -->
                            <a href="ViewProductByCate?categoryId=${category.categoryId}" class="btn btn-info btn-sm">View Products</a>
                            
                            <!-- Delete button, will be hidden if category_id is 13 -->
                            <c:if test="${category.categoryId != 13}">
                                <a href="DeleteCategory?categoryId=${category.categoryId}" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this category?')">Delete</a>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <!-- Nút Add Category dưới bảng -->
        <div class="add-btn">
            <a href="AddCategory" class="btn btn-success">Add New Category</a>
        </div>
    </div>
    <%@ include file="footer.jsp" %>
</body>
</html>
