<%-- 
    Document   : viewDiscount
    Created on : Mar 28, 2025, 4:03:21 AM
    Author     : hdat2
--%>

<%@ page import="model.Discount" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Discount List</title>
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
                        <h1 class="h2">Discount List</h1>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item active" aria-current="page">Discount List</li>
                            </ol>
                        </nav>

                        <a href="AddDiscount" class="btn btn-success mb-3">Add New Discount</a>
                        <form action="ViewDiscount" method="get" class="form-inline mb-3">



                            <!-- Hi?n th? danh sách gi?m giá -->
                            <c:choose>
                                <c:when test="${empty discountList}">
                                    <div class="alert alert-warning">No discounts found.</div>
                                </c:when>
                                <c:otherwise>
                                    <table class="table table-striped">
                                        <thead>
                                            <tr>
                                                <th>Discount Code</th>
                                                <th>Discount Value</th>
                                                <th>Discount Type</th>
                                                <th>Min Order Value</th>
                                                <th>Expiry Date</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        <c:forEach var="discount" items="${discountList}">
                                            <tr>
                                                <td>${discount.code}</td>
                                                <td>${discount.discountValue}</td>
                                                <td>${discount.discountType}</td>
                                                <td>${discount.minOrderValue}</td>
                                                <td>${discount.expiryDate}</td>
                                                <td>${discount.status == 1 ? 'Active' : 'Inactive'}</td>
                                                <td>
                                                    <a href="ViewDiscount?id=${discount.discountId}" class="btn btn-info btn-sm">View</a>
                                                    <a href="EditDiscount?id=${discount.discountId}" class="btn btn-primary btn-sm">Edit</a>
                                                    <a href="DeleteDiscount?id=${discount.discountId}" class="btn btn-danger btn-sm">Delete</a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        </tbody>
                                    </table>
                                </c:otherwise>
                            </c:choose>


                            </main>
                    </div>
            </div>

            <!-- Bootstrap JS -->
            <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
            <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
            <script src="https://unpkg.com/feather-icons"></script>
            <script>
                feather.replace();
            </script>
    </body>
</html>

