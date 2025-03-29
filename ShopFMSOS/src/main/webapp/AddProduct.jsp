<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Add New Product</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
    <style>
        body {
            padding-top: 56px;
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
        main {
            margin-left: 250px;
        }
        .form-container {
            background: #fff;
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .error {
            color: red;
            font-size: 0.9em;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
        <a class="navbar-brand" href="dashboard">Admin Dashboard</a>
    </nav>

    <div class="container-fluid">
        <div class="row">
            <nav class="col-md-3 col-lg-2 d-md-block sidebar">
                <jsp:include page="sidebar.jsp" />
            </nav>

            <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">
                <div class="pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Add New Product</h1>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="ManageProduct">Product Management</a></li>
                            <li class="breadcrumb-item active" aria-current="page">Add Product</li>
                        </ol>
                    </nav>
                    <c:if test="${not empty errors['generalError']}">
                        <div class="alert alert-danger">${errors['generalError']}</div>
                    </c:if>
                    <c:if test="${not empty success}">
                        <div class="alert alert-success">${success}</div>
                    </c:if>
                </div>

                <div class="form-container">
                    <form id="addProductForm" action="AddProduct" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
                        <div class="form-group">
                            <label for="productName">Product Name:</label>
                            <input type="text" class="form-control" id="productName" name="productName" value="${param.productName}">
                            <div id="productNameError" class="error">${errors['productNameError']}</div>
                        </div>

                        <div class="form-group">
                            <label for="categoryId">Category:</label>
                            <select class="form-control" id="categoryId" name="categoryId">
                                <option value="" disabled ${empty param.categoryId ? 'selected' : ''}>Select Category</option>
                                <c:forEach var="category" items="${categoryList}">
                                    <option value="${category.categoryId}" ${param.categoryId == category.categoryId ? 'selected' : ''}>
                                        ${category.categoryName}
                                    </option>
                                </c:forEach>
                            </select>
                            <div id="categoryIdError" class="error">${errors['categoryIdError']}</div>
                        </div>

                        <div class="form-group">
                            <label for="detailDesc">Description:</label>
                            <textarea class="form-control" id="detailDesc" name="detailDesc" maxlength="200">${param.detailDesc}</textarea>
                            <div id="detailDescError" class="error">${errors['detailDescError']}</div>
                        </div>

                        <div class="form-group">
                            <label for="price">Price:</label>
                            <input type="number" step="0.01" class="form-control" id="price" name="price" value="${param.price}">
                            <div id="priceError" class="error">${errors['priceError']}</div>
                        </div>

                        <div class="form-group">
                            <label for="discount">Discount (%):</label>
                            <input type="number" step="0.01" class="form-control" id="discount" name="discount" value="${param.discount != null ? param.discount : '0'}">
                            <div id="discountError" class="error">${errors['discountError']}</div>
                        </div>

                        <div class="form-group">
                            <label for="quantity">Quantity:</label>
                            <input type="number" class="form-control" id="quantity" name="quantity" value="${param.quantity}">
                            <div id="quantityError" class="error">${errors['quantityError']}</div>
                        </div>

                        <div class="form-group">
                            <label for="target">Target Audience:</label>
                            <input type="text" class="form-control" id="target" name="target" value="${param.target}">
                        </div>

                        <div class="form-group">
                            <label for="factory">Factory:</label>
                            <input type="text" class="form-control" id="factory" name="factory" value="${param.factory}">
                        </div>

                        <div class="form-group">
                            <label for="image">Product Image:</label>
                            <input type="file" class="form-control" id="image" name="image" accept="image/png, image/jpeg">
                            <div id="imageError" class="error">${errors['imageError']}</div>
                        </div>

                        <div class="form-group">
                            <label for="status">Status:</label>
                            <select class="form-control" id="status" name="status">
                                <option value="1" ${param.status == '1' ? 'selected' : ''}>Active</option>
                                <option value="0" ${param.status == '0' ? 'selected' : ''}>Inactive</option>
                            </select>
                            <div id="statusError" class="error">${errors['statusError']}</div>
                        </div>

                        <button type="submit" class="btn btn-success">Add Product</button>
                        <a href="ManageProduct" class="btn btn-secondary">Cancel</a>
                    </form>
                </div>
            </main>
        </div>
    </div>

    <!-- Success Modal -->
    <div class="modal fade" id="successModal" tabindex="-1" role="dialog" aria-labelledby="successModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="successModalLabel">Success</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body">
                    Product has been successfully added!
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" onclick="resetFormAndContinue()">Add Another Product</button>
                    <a href="ManageProduct" class="btn btn-secondary">Return to Product Management</a>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
    <script>
        function validateForm() {
            let isValid = true;
            document.querySelectorAll('.error').forEach(el => el.innerHTML = '');

            const productName = document.getElementById('productName').value;
            if (productName.trim() === '') {
                isValid = false;
                document.getElementById('productNameError').innerText = 'Product name is required.';
            }

            const detailDesc = document.getElementById('detailDesc').value;
            if (detailDesc.trim() === '') {
                isValid = false;
                document.getElementById('detailDescError').innerText = 'Description is required.';
            }

            const price = parseFloat(document.getElementById('price').value);
            if (isNaN(price) || price <= 0) {
                isValid = false;
                document.getElementById('priceError').innerText = 'Price must be a positive number.';
            }

            const quantity = parseInt(document.getElementById('quantity').value);
            if (isNaN(quantity) || quantity < 0) {
                isValid = false;
                document.getElementById('quantityError').innerText = 'Quantity must be a non-negative number.';
            }

            const discount = parseFloat(document.getElementById('discount').value);
            if (isNaN(discount) || discount < 0 || discount > 100) {
                isValid = false;
                document.getElementById('discountError').innerText = 'Discount must be between 0 and 100.';
            }

            const image = document.getElementById('image').files[0];
            if (image) {
                const fileType = image.type;
                if (fileType !== 'image/png' && fileType !== 'image/jpeg') {
                    isValid = false;
                    document.getElementById('imageError').innerText = 'Only PNG and JPEG images are allowed.';
                }
            }

            return isValid;
        }

        function resetFormAndContinue() {
            document.getElementById('addProductForm').reset();
            $('#successModal').modal('hide');
        }

        <c:if test="${not empty success}">
            $(document).ready(function () {
                $('#successModal').modal('show');
            });
        </c:if>
    </script>
</body>
</html>