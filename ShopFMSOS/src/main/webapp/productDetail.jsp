<%-- 
    Document   : productDetail
    Created on : Feb 17, 2025, 1:34:39 PM
    Author     : Nguyễn Ngoc Huy CE180178
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Product" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Product Detail</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <style>
            /* Hiệu ứng hover cho ảnh */
            .clickable-image {
                cursor: pointer;
                transition: transform 0.3s ease;
            }
            .clickable-image:hover {
                transform: scale(1.05);
            }
            /* Tùy chỉnh giao diện modal */
            .modal-body {
                padding: 0;
                background-color: #000;
            }
            .modal-body img {
                width: 100%;
                height: auto;
                display: block;
            }
            /* Tùy chỉnh giao diện bản thông tin sản phẩm */
            .product-info {
                padding: 20px;
                background-color: #f9f9f9;
                border: 1px solid #ddd;
                border-radius: 5px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            }
            .product-info h2 {
                margin-bottom: 15px;
            }
            .product-info p {
                margin-bottom: 10px;
                font-size: 1.1em;
            }
            .product-info p strong {
                color: #333;
            }
            /* CSS cho phần đánh giá sao và feedback */
            .feedback-section {
                margin-top: 50px;
                padding: 20px;
                background-color: #fff;
                border: 1px solid #ddd;
                border-radius: 5px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            }
            .feedback-section h3 {
                margin-bottom: 20px;
            }
            .star-rating {
                direction: rtl;
                display: inline-flex;
            }
            .star-rating input[type="radio"] {
                display: none;
            }
            .star-rating label {
                font-size: 2em;
                color: #ccc;
                cursor: pointer;
                transition: color 0.2s;
            }
            .star-rating input[type="radio"]:checked ~ label {
                color: #ffc700;
            }
            .star-rating label:hover,
            .star-rating label:hover ~ label {
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
            %>
            <div class="row">
                <div class="col-md-6">
                    <%-- Khi nhấp vào ảnh sẽ mở modal phóng to --%>
                    <% if (product.getImage() != null && !product.getImage().trim().isEmpty()) { %>
                        <img src="<%= product.getImage() %>" class="img-fluid clickable-image" alt="<%= product.getProductName() %>" data-bs-toggle="modal" data-bs-target="#imageModal">
                    <% } else { %>
                        <img src="images/no-image.png" class="img-fluid clickable-image" alt="No Image" data-bs-toggle="modal" data-bs-target="#imageModal">
                    <% } %>
                </div>
                <div class="col-md-6">
                    <div class="product-info">
                        <h2><%= product.getProductName() %></h2>
                        <p><strong>Giá:</strong> $<%= product.getPrice() %></p>
                        <p><strong>Giảm giá:</strong> $<%= product.getDiscount() %></p>
                        <p><strong>Mô tả:</strong> <%= product.getDetailDesc() %></p>
                        <p><strong>Số lượng:</strong> <%= product.getQuantity() %></p>
                        <p><strong>Đã bán:</strong> <%= product.getSold() %></p>
                        <p><strong>Nhà sản xuất:</strong> <%= product.getFactory() %></p>
                        <p>
                            <strong>Tình trạng:</strong> 
                            <%= product.getStatus() == 1 ? "Còn hàng" : "Hết hàng" %>
                        </p>
                        <div class="mt-3">
                            <a href="AddToCart?productId=<%= product.getProductId() %>" class="btn btn-success">Thêm giỏ hàng</a>
                        </div>
                    </div>
                </div>
            </div>

            <%-- Phần đánh giá sao và feedback --%>
            <div class="feedback-section">
                <h3>Đánh giá sản phẩm</h3>
                <form action="SubmitFeedback" method="post">
                    <input type="hidden" name="productId" value="<%= product.getProductId() %>">
                    <div class="mb-3">
                        <label class="form-label">Chọn số sao:</label>
                        <div class="star-rating">
                            <input type="radio" id="star5" name="rating" value="5">
                            <label for="star5" title="5 sao">&#9733;</label>
                            <input type="radio" id="star4" name="rating" value="4">
                            <label for="star4" title="4 sao">&#9733;</label>
                            <input type="radio" id="star3" name="rating" value="3">
                            <label for="star3" title="3 sao">&#9733;</label>
                            <input type="radio" id="star2" name="rating" value="2">
                            <label for="star2" title="2 sao">&#9733;</label>
                            <input type="radio" id="star1" name="rating" value="1">
                            <label for="star1" title="1 sao">&#9733;</label>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="feedback" class="form-label">Ý kiến đánh giá:</label>
                        <textarea class="form-control" id="feedback" name="feedback" rows="4" placeholder="Hãy để lại ý kiến của bạn về sản phẩm..."></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary">Gửi đánh giá</button>
                </form>
            </div>

            <%-- Modal hiển thị ảnh phóng to --%>
            <div class="modal fade" id="imageModal" tabindex="-1" aria-labelledby="imageModalLabel" aria-hidden="true">
              <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                  <div class="modal-body">
                    <%-- Hiển thị ảnh trong modal (nếu không có ảnh thì hiển thị ảnh mặc định) --%>
                    <img src="<%= (product.getImage() != null && !product.getImage().trim().isEmpty()) ? product.getImage() : "images/no-image.png" %>" class="img-fluid" alt="<%= product.getProductName() %>">
                  </div>
                </div>
              </div>
            </div>
            <%
                } else {
            %>
            <div class="alert alert-danger">
                Sản phẩm không tồn tại.
            </div>
            <%
                }
            %>
        </div>
        <%@ include file="footer.jsp" %>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
