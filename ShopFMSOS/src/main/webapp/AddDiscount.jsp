<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>

<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Add New Discount</title>
        <!-- Bootstrap -->
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
            .form-container {
                background: #fff;
                padding: 20px;
                border-radius: 15px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }
            .error {
                color: red;
            }
        </style>
    </head>
    <body>
        <!-- Navigation -->
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
            <a class="navbar-brand" href="dashboard">Admin Dashboard</a>
        </nav>

        <div class="container-fluid">
            <div class="row">
                <jsp:include page="sidebar.jsp" />

                <!-- Main Content -->
                <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">
                    <div class="pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">Add New Discount</h1>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="ManageDiscount">Discount Management</a></li>
                                <li class="breadcrumb-item active" aria-current="page">Add Discount</li>
                            </ol>
                        </nav>
                    </div>

                    <!-- Display success or error messages if set -->
                    <c:if test="${not empty success}">
                        <div class="alert alert-success">
                            ${success}
                        </div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">
                            ${error}
                        </div>
                    </c:if>

                    <div class="form-container">
                        <!-- Form to send request to Servlet (POST) -->
                        <!-- Remove 'required' attributes, rely on JavaScript validateForm() only -->
                        <form id="addDiscountForm" action="AddDiscount" method="post" onsubmit="return validateForm()">
                            <!-- input ẩn để servlet biết form này đến từ nút Add Discount -->
                            <input type="hidden" name="action" value="submitForm" />

                            <!-- 1. Code -->
                            <div class="form-group">
                                <label for="code">Discount Code:</label>
                                <input type="text" class="form-control" id="code" name="code">
                                <div id="codeError" class="error"></div>
                            </div>

                            <!-- 2. Discount Value (%): integer 1..100 -->
                            <div class="form-group">
                                <label for="discountValue">Discount Value (%):</label>
                                <input type="number" step="1" class="form-control" id="discountValue" name="discountValue">
                                <div id="discountValueError" class="error"></div>
                            </div>

                            <!-- 3. Discount Type -->
                            <div class="form-group">
                                <label for="discountType">Discount Type:</label>
                                <select class="form-control" id="discountType" name="discountType">
                                    <option value="" disabled selected>Select Type</option>
                                    <option value="percent">Percent</option>
                                    <option value="fixed">Fixed</option>
                                </select>
                            </div>

                            <!-- 4. Minimum Order Value (positive integer) -->
                            <div class="form-group">
                                <label for="minOrderValue">Minimum Order Value:</label>
                                <input type="number" step="1" class="form-control" id="minOrderValue" name="minOrderValue">
                                <div id="minOrderValueError" class="error"></div>
                            </div>

                            <!-- 5. Expiry Date -->
                            <div class="form-group">
                                <label for="expiryDate">Expiry Date:</label>
                                <input type="date" class="form-control" id="expiryDate" name="expiryDate">
                                <div id="expiryDateError" class="error"></div>
                            </div>

                            <!-- 6. Status -->
                            <div class="form-group">
                                <label for="status">Status:</label>
                                <select class="form-control" id="status" name="status">
                                    <option value="1" selected>Active</option>
                                    <option value="0">Inactive</option>
                                </select>
                            </div>

                            <button type="submit" class="btn btn-success">
                                Add Discount
                            </button>
                            <a href="ManageDiscount" class="btn btn-secondary">Cancel</a>
                        </form>
                    </div>
                </main>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>

        <!-- Client-side Validation -->
        <script>
            function validateForm() {
                // Xóa các thông báo lỗi trước đó
                document.querySelectorAll('.error').forEach(element => {
                    element.innerHTML = '';
                });

                let isValid = true;

                // 1) Discount Code
                const code = document.getElementById('code').value.trim();
                if (code === '') {
                    isValid = false;
                    document.getElementById('codeError').innerText = 'Discount code is required.';
                }

                // 2) Discount Value => integer from 1 to 100
                const discountValue = parseInt(document.getElementById('discountValue').value);
                if (isNaN(discountValue)) {
                    isValid = false;
                    document.getElementById('discountValueError').innerText = 'Discount value is required.';
                } else if (discountValue < 1 || discountValue > 100) {
                    isValid = false;
                    document.getElementById('discountValueError').innerText = 'Discount value must be an integer between 1 and 100.';
                }

                // 3) Discount Type
                const discountType = document.getElementById('discountType').value;
                if (!discountType) {
                    isValid = false;
                    // Nếu cần hiển thị lỗi: document.getElementById('...').innerText = 'Discount type is required.';
                }

                // 4) Minimum Order Value => integer > 0
                const minOrderValue = parseInt(document.getElementById('minOrderValue').value);
                if (isNaN(minOrderValue)) {
                    isValid = false;
                    document.getElementById('minOrderValueError').innerText = 'Minimum order value is required.';
                } else if (minOrderValue <= 0) {
                    isValid = false;
                    document.getElementById('minOrderValueError').innerText = 'Minimum order value must be a positive integer.';
                }

                // 5) Expiry Date
                const expiryDate = document.getElementById('expiryDate').value;
                if (expiryDate === '') {
                    isValid = false;
                    document.getElementById('expiryDateError').innerText = 'Expiry date is required.';
                }

                return isValid;
            }
        </script>
    </body>
</html>
