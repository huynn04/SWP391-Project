<%@page import="java.util.List, model.Product, model.Category, java.util.Arrays"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Product List</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
        <style>
    html, body {
        height: 100%;
        margin: 0;
        padding-top: 80px;
        display: flex;
        flex-direction: column;
        min-height: 100vh;
        background: linear-gradient(120deg, #e0eafc 0%, #cfdef3 100%);
        font-family: 'Poppins', sans-serif;
        overflow-x: hidden;
    }

    .content-wrapper {
        flex: 1 0 auto;
        padding-bottom: 60px;
    }

    /* Product Cards */
    .products-col {
        padding-top: 25px;
        animation: fadeInUp 0.8s ease-out;
    }

    @keyframes fadeInUp {
        from { transform: translateY(50px); opacity: 0; }
        to { transform: translateY(0); opacity: 1; }
    }

    .product-card {
        margin-bottom: 30px;
        transition: all 0.4s ease;
        height: 100%;
        border: none;
        border-radius: 15px;
        background: white;
        overflow: hidden;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        position: relative;
        animation: cardPop 0.5s ease-out forwards;
    }

    @keyframes cardPop {
        0% { transform: scale(0.95); opacity: 0; }
        100% { transform: scale(1); opacity: 1; }
    }

    .product-card:hover {
        transform: translateY(-10px) rotate(1deg);
        box-shadow: 0 15px 40px rgba(0, 0, 0, 0.2);
    }

    /* Hiệu ứng ảnh nâng cao */
    .card-img-top {
        max-height: 230px;
        width: 100%;
        object-fit: contain;
        padding: 25px;
        background: linear-gradient(135deg, #f8f9fa 0%, #e5e7eb 100%);
        transition: all 0.5s ease;
        border-radius: 15px 15px 0 0;
        position: relative;
        transform-style: preserve-3d;
        perspective: 1000px;
    }

    .product-card:hover .card-img-top {
        transform: scale(1.1) rotate(3deg) translateZ(20px);
        filter: brightness(1.15) saturate(1.2);
        background: linear-gradient(135deg, #e5e7eb 0%, #d1d5db 100%);
    }

    /* Thêm overlay hiệu ứng */
    .card-img-top::after {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0);
        transition: all 0.5s ease;
        border-radius: 15px 15px 0 0;
        pointer-events: none;
    }

    .product-card:hover .card-img-top::after {
        background: rgba(0, 0, 0, 0.05);
        box-shadow: inset 0 0 20px rgba(0, 0, 0, 0.1);
    }

    /* Hiệu ứng zoom-in khi load */
    @keyframes imageZoomIn {
        0% { transform: scale(0.8); opacity: 0; }
        100% { transform: scale(1); opacity: 1; }
    }

    .card-img-top {
        animation: imageZoomIn 0.6s ease-out forwards;
    }

    /* Hiệu ứng phản chiếu nhẹ */
    .product-card:hover .card-img-top {
        box-shadow: 0 20px 30px -10px rgba(0, 0, 0, 0.2);
    }

    .product-title {
        color: #1e3a8a;
        padding: 15px;
        text-align: center;
        font-weight: 700;
        min-height: 65px;
        font-size: 1.2rem;
        display: flex;
        align-items: center;
        justify-content: center;
        background: linear-gradient(90deg, #f8fafc, #eff6ff);
        margin: 0;
        transition: all 0.3s ease;
    }

    .product-card:hover .product-title {
        background: linear-gradient(90deg, #dbeafe, #bfdbfe);
    }

    .card-body {
        padding: 25px;
        background: white;
        position: relative;
    }

    .product-price {
        color: #16a34a;
        font-weight: 700;
        font-size: 1.25rem;
        margin-bottom: 20px;
        animation: pricePulse 2s infinite;
    }

    @keyframes pricePulse {
        0%, 100% { transform: scale(1); }
        50% { transform: scale(1.03); }
    }

    .btn {
        border-radius: 30px;
        padding: 10px 25px;
        font-weight: 600;
        transition: all 0.3s ease;
        position: relative;
        overflow: hidden;
    }

    .btn::after {
        content: '';
        position: absolute;
        top: 50%;
        left: 50%;
        width: 0;
        height: 0;
        background: rgba(255, 255, 255, 0.3);
        border-radius: 50%;
        transform: translate(-50%, -50%);
        transition: all 0.5s ease;
    }

    .btn:hover::after {
        width: 200px;
        height: 200px;
    }

    .btn-primary {
        background: #3b82f6;
        border: none;
    }

    .btn-primary:hover {
        background: #1d4ed8;
        transform: translateY(-3px) scale(1.05);
    }

    .btn-success {
        background: #16a34a;
        border: none;
    }

    .btn-success:hover {
        background: #15803d;
        transform: translateY(-3px) scale(1.05);
    }

    /* Giữ nguyên các phần khác như filter-section, pagination nếu không cần thay đổi */
    /* Responsive */
    @media (max-width: 992px) {
        .card-img-top {
            max-height: 190px;
        }

        .product-card {
            margin-bottom: 25px;
        }

        .product-title {
            font-size: 1.1rem;
            min-height: 55px;
        }
    }

    @media (max-width: 576px) {
        .card-img-top {
            max-height: 160px;
        }
    }
</style>
        <script>
            function debounce(func, wait) {
                let timeout;
                return function (...args) {
                    const context = this;
                    clearTimeout(timeout);
                    timeout = setTimeout(() => func.apply(context, args), wait);
                };
            }
            const filterProducts = debounce(function () {
                document.getElementById('filterForm').submit();
            }, 300); // Adjusted to 300ms for better responsiveness

            function clearAllFilters() {
                document.querySelectorAll('.form-check-input').forEach(checkbox => checkbox.checked = false);
                document.getElementById('searchQuery').value = '';
                document.getElementById('filterForm').submit();
            }
            function clearSearch() {
                document.getElementById('searchQuery').value = '';
                document.getElementById('filterForm').submit();
            }

            window.addEventListener('load', function () {
                const checkboxes = document.querySelectorAll('.form-check-input');
                checkboxes.forEach(checkbox => {
                    checkbox.style.visibility = 'visible';
                    checkbox.style.opacity = '1';
                    checkbox.disabled = false;
                });
                const searchInput = document.getElementById('searchQuery');
                if (searchInput && searchInput.value) {
                    searchInput.focus();
                    searchInput.setSelectionRange(searchInput.value.length, searchInput.value.length);
                }
                const productsCol = document.querySelector('.products-col');
                if (productsCol) {
                    setTimeout(() => {
                        window.scrollTo({
                            top: productsCol.offsetTop - 100,
                            behavior: 'smooth'
                        });
                    }, 100);
                }
                // Uncomment if you want to fetch categories on load, but ensure no infinite loop
                // document.getElementById('filterForm').submit();
            });
        </script>
    </head>
    <body>
        <%@ include file="header.jsp" %>
        <div class="container content-wrapper">
            <div class="row">
                <div class="col-md-3">
                    <div class="filter-section">
                        <h5>🔍 Search Product</h5>
                        <form id="filterForm" action="ProductController" method="GET">
                            <div class="input-group mb-3">
                                <input type="text" id="searchQuery" name="searchQuery" class="form-control"
                                       placeholder="Search products..."
                                       value="<%= request.getAttribute("searchQuery") != null ? request.getAttribute("searchQuery") : ""%>"
                                       oninput="filterProducts()">
                                <button type="button" class="clear-search" onclick="clearSearch()">×</button>
                                <span class="input-group-text">🔎</span>
                            </div>
                            <h6>🎯 Categories:</h6>
                            <button type="button" class="btn btn-danger btn-sm mb-2" onclick="clearAllFilters()">Show All</button>
                            <%
                                List<Category> categories = (List<Category>) request.getAttribute("categories");
                                String[] selectedCategories = (String[]) request.getAttribute("selectedCategories");
                                if (categories != null && !categories.isEmpty()) {
                                    for (Category category : categories) {
                                        String categoryId = String.valueOf(category.getCategoryId());
                                        boolean isChecked = selectedCategories != null && Arrays.asList(selectedCategories).contains(categoryId);
                            %>
                            <div class="form-check">
                                <input type="checkbox" class="form-check-input"
                                       name="categoryId" value="<%= categoryId%>"
                                       onchange="filterProducts()"
                                       <%= isChecked ? "checked" : ""%> />
                                <label class="form-check-label"><%= category.getCategoryName()%></label>
                            </div>
                            <%
                                }
                            } else {
                            %>
                            <%
                                }
                            %>
                            <input type="hidden" name="page" id="pageInput"
                                   value="<%= request.getParameter("page") != null ? request.getParameter("page") : "1"%>">
                        </form>
                    </div>
                </div>
                <div class="col-md-9 products-col">
                    <div class="row">
                        <%
                            List<Product> products = (List<Product>) request.getAttribute("products");
                            Integer totalCount = (Integer) request.getAttribute("totalCount"); // Add this attribute from controller
                            int currentPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
                            int pageSize = 6;
                            int totalProducts = totalCount != null ? totalCount : (products != null ? products.size() : 0);
                            int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
                            int start = (currentPage - 1) * pageSize;
                            int end = products != null ? Math.min(start + pageSize, products.size()) : 0;

                            if (products != null && !products.isEmpty()) {
                                for (int i = start; i < end; i++) {
                                    Product product = products.get(i);
                        %>
                        <div class="col-md-4 col-sm-6">
                            <div class="card product-card shadow-sm">
                                <a href="ProductDetail?productId=<%= product.getProductId()%>">
                                    <img src="<%= product.getImage() != null ? product.getImage() : "images/no-image.png"%>"
                                         class="card-img-top" alt="<%= product.getProductName()%>">
                                </a>
                                <div class="product-title text-truncate"><%= product.getProductName()%></div>
                                <div class="card-body">
                                    <h6 class="product-price text-success">$<%= product.getPrice()%></h6>
                                    <div class="d-flex justify-content-between">
                                        <a href="ProductDetail?productId=<%= product.getProductId()%>" class="btn btn-primary btn-sm">Buy Now</a>
                                        <a href="AddToCart?productId=<%= product.getProductId()%>" class="btn btn-success btn-sm">🛒</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <%
                            }
                        } else {
                        %>
                        <div class="col-12 text-center"><p>No products found.</p></div>
                        <%
                            }
                        %>
                    </div>
                    <%
                        if (totalPages > 1) {
                            StringBuilder queryParams = new StringBuilder();
                            if (request.getAttribute("searchQuery") != null) {
                                queryParams.append("&searchQuery=").append(request.getAttribute("searchQuery"));
                            }
                            if (selectedCategories != null) {
                                for (String catId : selectedCategories) {
                                    queryParams.append("&categoryId=").append(catId);
                                }
                            }
                    %>
                    <nav aria-label="Page navigation">
                        <ul class="pagination">
                            <li class="page-item <%= currentPage <= 1 ? "disabled" : ""%>">
                                <a class="page-link" href="ProductController?page=<%= currentPage - 1%><%= queryParams%>">Previous</a>
                            </li>
                            <%
                                for (int i = 1; i <= totalPages; i++) {
                            %>
                            <li class="page-item <%= i == currentPage ? "active" : ""%>">
                                <a class="page-link" href="ProductController?page=<%= i%><%= queryParams%>"><%= i%></a>
                            </li>
                            <%
                                }
                            %>
                            <li class="page-item <%= currentPage >= totalPages ? "disabled" : ""%>">
                                <a class="page-link" href="ProductController?page=<%= currentPage + 1%><%= queryParams%>">Next</a>
                            </li>
                        </ul>
                    </nav>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>
        <%@ include file="footer.jsp" %>
    </body>
</html>