<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>

<%
    // Lấy thông tin người dùng từ session
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    int userRole = (loggedInUser != null) ? loggedInUser.getRoleId() : -1; // Nếu chưa đăng nhập, gán -1
%>

<!-- Sidebar with menu options -->
<nav class="col-md-2 d-none d-md-block sidebar">
    <div class="sidebar-sticky">
        <ul class="nav flex-column">
            <li class="nav-item">
                <a class="nav-link active" href="home.jsp">
                    <span data-feather="home"></span>
                    Home
                </a>
            </li>
            <!-- Các menu khác -->
            <li class="nav-item">
                <a class="nav-link" href="CustomerManager">
                    <span data-feather="users"></span>
                    Manage Customers
                </a>
            </li>

            <% if (userRole == 1) { %>
                <li class="nav-item">
                    <a class="nav-link" href="StaffManager">
                        <span data-feather="user"></span>
                        Manage Staff
                    </a>
                </li>
            <% } %>

            <li class="nav-item">
                <a class="nav-link" href="ManageProduct">
                    <span data-feather="shopping-cart"></span>
                    Manage Products
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link active" href="ManageOrder">
                    <span data-feather="clipboard"></span>
                    Manage Orders
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="ManageNews">
                    <span data-feather="file-text"></span>
                    Manage News
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="SalesStatistics">
                    <span data-feather="bar-chart-2"></span>
                    Sales Statistics
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="LogoutServlet">
                    <span data-feather="log-out"></span>
                    Log Out
                </a>
            </li>
        </ul>
    </div>
</nav>

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
<script src="https://unpkg.com/feather-icons"></script>
<script>
    feather.replace();
</script>
