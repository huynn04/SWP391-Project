<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Products in Category</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        .product-card {
            border: 1px solid #ddd;
            border-radius: 10px;
            margin-bottom: 20px;
            padding: 15px;
            text-align: center;
        }
        .product-card img {
            width: 100%;
            height: auto;
            border-radius: 8px;
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>
    <div class="container mt-5">
        <h2>Products in Category</h2>
        <div class="row">
            <c:forEach var="product" items="${products}">
                <div class="col-md-4">
                    <div class="product-card">
                        <img src="<c:choose>
                                    <c:when test="${product.image != null}">
                                        ${product.image}
                                    </c:when>
                                    <c:otherwise>
                                        images/no-image.png
                                    </c:otherwise>
                                </c:choose>" alt="${product.productName}">
                        <h5>${product.productName}</h5>
                        <p>${product.detailDesc}</p>
                        <p>Price: $${product.price}</p>
                        <p>Status: ${product.status == 1 ? 'Active' : 'Inactive'}</p>
                        <a href="ProductDetail?productId=${product.productId}" class="btn btn-primary btn-sm">View Details</a>
                    </div>
                </div>
            </c:forEach>
        </div>
        <a href="CategoryServlet" class="btn btn-secondary mt-3">Back to Categories</a>
    </div>
    <%@ include file="footer.jsp" %>
</body>
</html>
