<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Category</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <h2>Update Category</h2>
        <form action="UpdateCategory" method="POST">
            <input type="hidden" name="categoryId" value="${category.categoryId}">
            
            <div class="mb-3">
                <label for="categoryName" class="form-label">Category Name</label>
                <input type="text" class="form-control" id="categoryName" name="categoryName" value="${category.categoryName}" required>
            </div>

            <div class="mb-3">
                <label for="description" class="form-label">Description</label>
                <textarea class="form-control" id="description" name="description" rows="3">${category.description}</textarea>
            </div>

            <div class="mb-3">
                <label for="image" class="form-label">Image URL (Optional)</label>
                <input type="text" class="form-control" id="image" name="image" value="${category.image}">
            </div>

            <div class="mb-3">
                <label for="status" class="form-label">Status</label>
                <select class="form-select" id="status" name="status">
                    <option value="1" ${category.status == 1 ? 'selected' : ''}>Active</option>
                    <option value="0" ${category.status == 0 ? 'selected' : ''}>Inactive</option>
                </select>
            </div>

            <button type="submit" class="btn btn-primary">Update Category</button>
        </form>
    </div>
</body>
</html>
