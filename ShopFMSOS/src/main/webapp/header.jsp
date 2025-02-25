<%-- 
    Document   : header
    Created on : Feb 12, 2025, 3:00:00 PM
    Author     : Nguyễn Ngọc Huy CE180178
--%>
<%@ page contentType="text/html; charset=UTF-8" %>

<link rel="stylesheet" href="css/style.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">

<header id="header">
    <div class="container">
        <!-- Logo -->
        <div class="logo">
            <a href="home">FMSOS</a>
        </div>

        <!-- Navigation (Home, Products, Cart, Login, Categories) -->
        <nav>
            <ul>
                <li><a href="home">Home</a></li>
                <li><a href="products">Products</a></li>
                <li><a href="cartDetail.jsp">Cart</a></li>
                <li><a href="#">Categories</a></li>
                <li><a href="login.jsp">Login</a></li>

            </ul>
        </nav>
        <!-- Thay vì có 2 dropdown (Categories + Settings), bây gi? ch? còn Settings -->
        <div class="dropdown">
            <button 
                class="btn btn-outline-light dropdown-toggle" 
                type="button" 
                id="settingsDropdown" 
                data-bs-toggle="dropdown" 
                aria-expanded="false"
                >
                ⚙️ Settings
            </button>
            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="settingsDropdown">
                <li><a class="dropdown-item" href="dashboard">Admin Dashboard</a></li>
                <li><a class="dropdown-item" href="updateProfile.jsp">Update Profile</a></li>
                <li><a class="dropdown-item" href="changePassword.jsp">Change Password</a></li>
                <li><a class="dropdown-item" href="orderHistory.jsp">Order History</a></li>
                <li><a class="dropdown-item" href="managePayment.jsp">Manage Payment</a></li>
                <li><hr class="dropdown-divider"></li>
                <li><a class="dropdown-item text-danger" href="logout.jsp">Logout</a></li>
            </ul>
        </div>
    </div>
</header>
