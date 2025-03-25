<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Product, model.ProductReview" %>
<%@ page import="dal.ProductReviewDAO" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Product Detail</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <style>
            /* Styles for product review */
            .review-section {
                margin-top: 50px;
                padding: 20px;
                background-color: #f9f9f9;
                border: 1px solid #ddd;
                border-radius: 5px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            }
            .review-section h3 {
                margin-bottom: 20px;
            }
            .review-content {
                margin-bottom: 15px;
            }
            .review-title {
                font-weight: bold;
            }
            .review-rating {
                color: #ffc700;
            }
        </style>
    </head>
    <body>
        <%@ include file="header.jsp" %>

        <div class="container mt-5">
            <%
                Product product = (Product) request.getAttribute("product");
                if (product != null) {
                    // Fetch reviews for the current product
                    ProductReviewDAO reviewDAO = new ProductReviewDAO();
                    List<ProductReview> reviews = reviewDAO.getReviewsByProductId(product.getProductId());
            %>
            <div class="row">
                <div class="col-md-6">
                    <%-- When clicking on the image, open a modal to view it in a larger size --%>
                    <% if (product.getImage() != null && !product.getImage().trim().isEmpty()) { %>
                    <img src="<%= product.getImage() %>" class="img-fluid clickable-image" alt="<%= product.getProductName() %>" data-bs-toggle="modal" data-bs-target="#imageModal">
                    <% } else { %>
                    <img src="images/no-image.png" class="img-fluid clickable-image" alt="No Image" data-bs-toggle="modal" data-bs-target="#imageModal">
                    <% } %>
                </div>
                <div class="col-md-6">
                    <div class="product-info">
                        <h2><%= product.getProductName() %></h2>
                        <p><strong>Price:</strong> $<%= product.getPrice() %></p>
                        <p><strong>Discount:</strong> $<%= product.getDiscount() %></p>
                        <p><strong>Description:</strong> <%= product.getDetailDesc() %></p>
                        <p><strong>Quantity:</strong> <%= product.getQuantity() %></p>
                        <p><strong>Sold:</strong> <%= product.getSold() %></p>
                        <p><strong>Manufacturer:</strong> <%= product.getFactory() %></p>
                        <p><strong>Status:</strong> 
                            <%= product.getStatus() == 1 ? "In Stock" : "Out of Stock" %>
                        </p>
                        <div class="mt-3">
                            <a href="AddToCart?productId=<%= product.getProductId() %>" class="btn btn-success">Add to Cart</a>
                        </div>
                    </div>
                </div>
            </div>

            <%-- Display Reviews --%>
            <div class="review-section">
                <h3>Product Reviews</h3>
                <% if (reviews != null && !reviews.isEmpty()) { %>
                <div>
                    <% for (ProductReview review : reviews) { %>
                    <div class="review-content">
                        <%-- Hiển thị đánh giá --%>
                        <div class="review-rating">
                            <% for (int i = 0; i < review.getRating(); i++) { %>
                            <span>&#9733;</span> <!-- Hiển thị sao đánh giá -->
                            <% } %>
                        </div>
                        <p><%= review.getReviewContent() %></p>
                        <p><small>Reviewed by <%= review.getUser().getFullName() %> on <%= review.getCreatedAt() %></small></p>
                    </div>
                    <% } %>
                </div>
                <% } else { %>
                <p>No reviews yet for this product.</p>
                <% } %>
            </div>


            <%-- Modal to display enlarged image --%>
            <div class="modal fade" id="imageModal" tabindex="-1" aria-labelledby="imageModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content">
                        <div class="modal-body">
                            <img src="<%= (product.getImage() != null && !product.getImage().trim().isEmpty()) ? product.getImage() : "images/no-image.png" %>" class="img-fluid" alt="<%= product.getProductName() %>">
                        </div>
                    </div>
                </div>
            </div>
            <% 
                } else {
            %>
            <div class="alert alert-danger">
                Product not found.
            </div>
            <% 
                }
            %>
        </div>

        <%@ include file="footer.jsp" %>
    </body>
</html>
