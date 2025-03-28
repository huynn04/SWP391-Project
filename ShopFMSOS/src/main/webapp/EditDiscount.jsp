<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Edit Discount</title>
        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
        <style>
            body {
                padding-top: 56px;
                background-color: #f2f2f2;
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
            .edit-card {
                background: #fff;
                padding: 20px;
                border-radius: 15px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
                margin-bottom: 30px;
            }
            .edit-card h3 {
                margin-bottom: 20px;
                border-bottom: 1px solid #e5e5e5;
                padding-bottom: 10px;
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
                <!-- Include sidebar -->
                <jsp:include page="sidebar.jsp" />

                <!-- Main content area -->
                <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">
                    <!-- Tiêu đề & breadcrumb -->
                    <div class="pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">Edit Discount</h1>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item">
                                    <a href="ManageDiscount">Discount Management</a>
                                </li>
                                <li class="breadcrumb-item active" aria-current="page">Edit Discount</li>
                            </ol>
                        </nav>
                    </div>

                    <!-- Thẻ chứa form -->
                    <div class="edit-card">
                        <h3>Edit Discount Information</h3>

                        <!-- Hiển thị lỗi nếu có (có thể truyền từ Servlet) -->
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">
                                ${error}
                            </div>
                        </c:if>

                        <!-- Form edit discount -->
                        <form action="EditDiscount" method="post">
                            <!-- Input ẩn discountId -->
                            <input type="hidden" name="discountId" value="${discount.discountId}"/>

                            <!-- Code -->
                            <div class="form-group">
                                <label for="code">Discount Code:</label>
                                <input type="text" class="form-control" id="code" name="code"
                                       value="${discount.code}" required>
                            </div>

                            <!-- Discount Value -->
                            <div class="form-group">
                                <label for="discountValue">Discount Value (%):</label>
                                <input type="number" step="0.1" class="form-control" id="discountValue" name="discountValue"
                                       value="${discount.discountValue}" required>
                            </div>

                            <!-- Discount Type -->
                            <div class="form-group">
                                <label for="discountType">Discount Type:</label>
                                <select class="form-control" id="discountType" name="discountType" required>
                                    <option value="percent" 
                                        <c:if test="${discount.discountType == 'percent'}">selected</c:if>>
                                        Percent
                                    </option>
                                    <option value="fixed"
                                        <c:if test="${discount.discountType == 'fixed'}">selected</c:if>>
                                        Fixed
                                    </option>
                                </select>
                            </div>

                            <!-- Minimum Order Value -->
                            <div class="form-group">
                                <label for="minOrderValue">Minimum Order Value:</label>
                                <input type="number" step="0.1" class="form-control" id="minOrderValue" name="minOrderValue"
                                       value="${discount.minOrderValue}" required>
                            </div>

                            <!-- Expiry Date -->
                            <div class="form-group">
                                <label for="expiryDate">Expiry Date:</label>
                                <input type="date" class="form-control" id="expiryDate" name="expiryDate"
                                       value="${discount.expiryDate}" required>
                            </div>

                            <!-- Status -->
                            <div class="form-group">
                                <label for="status">Status:</label>
                                <select class="form-control" id="status" name="status">
                                    <option value="1" <c:if test="${discount.status == 1}">selected</c:if>>Active</option>
                                    <option value="0" <c:if test="${discount.status == 0}">selected</c:if>>Inactive</option>
                                </select>
                            </div>

                            <button type="submit" class="btn btn-primary">Save Changes</button>
                            <a href="ManageDiscount" class="btn btn-secondary">Cancel</a>
                        </form>
                    </div>
                </main>
            </div>
        </div>

        <!-- Bootstrap and required scripts -->
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
    </body>
</html>
