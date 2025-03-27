<%-- 
    Document   : header
    Created on : Feb 12, 2025, 3:00:00 PM
    Author     : Nguyễn Ngọc Huy CE180178
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="model.User" %>

<%
    // Lấy thông tin người dùng từ session
    User loggedInUser = (User) session.getAttribute("loggedInUser");
%>

<link rel="stylesheet" href="css/style.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">

<header id="header">
    <div class="container">
        <!-- Logo -->
        <div class="logo">
            <a href="home">FMSOS</a>
        </div>

        <!-- Navigation (Home, Products, Cart, Categories, News) -->
        <nav>
            <ul>
                <li><a href="home">Home</a></li>
                <li><a href="products">Products</a></li>
                <li><a href="cartDetail.jsp">Cart</a></li>
                <li><a href="LuckyWheelServlet">Lucky Wheel</a></li>
                <li><a href="AllNews">News</a></li>  <!-- Thêm mục News vào đây -->
                <% if (loggedInUser == null) { %>
                    <!-- Chỉ hiển thị nếu người dùng chưa đăng nhập -->
                    <li><a href="login.jsp">Login</a></li>
                <% } %>
            </ul>
        </nav>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <!-- Nếu đã đăng nhập, hiển thị menu cài đặt -->
        <% if (loggedInUser != null) { %>
            <div class="dropdown">
                <button 
                    class="btn btn-outline-light dropdown-toggle" 
                    type="button" 
                    id="settingsDropdown" 
                    data-bs-toggle="dropdown" 
                    aria-expanded="false">
                    👤 <%= loggedInUser.getFullName() %>
                </button>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="settingsDropdown">
                    <% if (loggedInUser.getRoleId() == 1 || loggedInUser.getRoleId() == 2) { %>  
                        <!-- Nếu là Admin, hiển thị Dashboard -->
                        <li><a class="dropdown-item" href="dashboard">Admin Dashboard</a></li>
                    <% } %>
                    <li><a class="dropdown-item" href="updateProfile.jsp">Update Profile</a></li>
                    <li><a class="dropdown-item" href="changePassword.jsp">Change Password</a></li>
                    <li><a class="dropdown-item" href="CustomerOrderHistory">Order History</a></li>
                    <li><a class="dropdown-item" href="managePayment.jsp">Manage Payment</a></li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item text-danger" href="LogoutServlet">Logout</a></li>
                </ul>
            </div>
        <% } %>
    </div>
</header>
