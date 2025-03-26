<%-- 
    Document   : reviewProduct
    Created on : 24 thg 3, 2025, 11:52:08
    Author     : Tran Huy Lam CE180899 
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Review</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
    <style>
        .star-rating {
            font-size: 2em;
            color: #ffcc00;
        }
        .star-rating input[type="radio"] {
            display: none;
        }
        .star-rating label {
            cursor: pointer;
        }
        .star-rating input[type="radio"]:checked ~ label {
            color: #ffcc00;
        }
    </style>
</head>
<body>

    <div class="container mt-5">
        <!-- Order Information -->
        <div class="card">
            <div class="card-header">
                <h3>Order Information</h3>
            </div>
            <div class="card-body">
                <h5>Product Name: ${product.name}</h5>
                <p>Quantity: ${order.quantity}</p>
                <p>Total Price: ${order.totalPrice} USD</p>
            </div>
        </div>

        <!-- Review Form -->
        <div class="mt-4">
            <h4>Leave a Review</h4>
            <form action="submitReview" method="post">
                <!-- Rating (Star Rating) -->
                <div class="form-group">
                    <label for="rating">Rating:</label>
                    <div class="star-rating">
                        <input type="radio" id="star5" name="rating" value="5"><label for="star5">★</label>
                        <input type="radio" id="star4" name="rating" value="4"><label for="star4">★</label>
                        <input type="radio" id="star3" name="rating" value="3"><label for="star3">★</label>
                        <input type="radio" id="star2" name="rating" value="2"><label for="star2">★</label>
                        <input type="radio" id="star1" name="rating" value="1" checked><label for="star1">★</label>
                    </div>
                </div>

                <!-- Review Content -->
                <div class="form-group">
                    <label for="reviewContent">Your Review:</label>
                    <textarea id="reviewContent" name="reviewContent" class="form-control" rows="4" required></textarea>
                </div>

                <button type="submit" class="btn btn-primary">Submit Review</button>
            </form>
        </div>
    </div>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
</body>
</html>