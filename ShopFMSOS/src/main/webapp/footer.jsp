<%-- 
    Document   : footer
    Created on : Feb 26, 2025
    Author     : Nguyễn Ngọc Huy CE180178
--%>
<%@ page contentType="text/html; charset=UTF-8" %>

<link rel="stylesheet" href="css/style.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">

<footer id="footer">
    <div class="container">
        <nav>
            <ul class="footer-nav">
                <li><a href="home">Home</a></li>
                <li><a href="products">Products</a></li>
                <li><a href="cartDetail.jsp">Cart</a></li>
                <li><a href="#">Categories</a></li>

                <% if (loggedInUser == null) { %>
                    <li><a href="login.jsp">Login</a></li>
                <% } else { %>
                    <% if (loggedInUser.getRoleId() == 1 || loggedInUser.getRoleId() == 2) { %>
                        <li><a href="dashboard">Dashboard</a></li>
                    <% } %>
                    <li><a href="LogoutServlet" class="text-danger">Logout</a></li>
                <% } %>
            </ul>
        </nav>
        <div class="footer-text">
            <p>&copy; 2025 FMSOS. All rights reserved.</p>
        </div>
    </div>
</footer>

<style>
    /* Đảm bảo footer nằm dưới cùng trang */
    html, body {
        height: 100%;
        margin: 0;
    }

    #wrapper {
        min-height: 100%;
        display: flex;
        flex-direction: column;
    }

    main {
        flex: 1; /* Phần chính sẽ mở rộng để đẩy footer xuống dưới */
    }

    #footer {
        background-color: #f8f9fa;
        padding: 20px 0;
        border-top: 1px solid #e7e7e7;
        text-align: center;
    }

    .footer-nav {
        list-style: none;
        padding: 0;
        margin: 0 0 10px 0;
        display: flex;
        justify-content: center;
        gap: 20px; /* Khoảng cách giữa các mục */
    }

    .footer-nav li {
        display: inline;
    }

    .footer-nav a {
        text-decoration: none;
        color: #333;
        font-size: 14px;
    }

    .footer-nav a:hover {
        color: #007bff;
    }

    .footer-text {
        font-size: 12px;
        color: #666;
    }
</style>
