<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<nav>
    <ul>
        <li><a href="index.jsp">Trang Chủ</a></li>
        <li><a href="categories.jsp">Danh Mục</a></li>
        <li><a href="products.jsp">Sản Phẩm</a></li>
        <li><a href="cart.jsp">Giỏ Hàng</a></li>
        <li><a href="login.jsp">Đăng Nhập</a></li>
    </ul>
</nav>

<style>
    nav {
        background-color: #333;
        padding: 10px;
    }
    nav ul {
        list-style-type: none;
        margin: 0;
        padding: 0;
        display: flex;
    }
    nav ul li {
        margin: 0 10px;
    }
    nav ul li a {
        color: white;
        text-decoration: none;
        font-size: 16px;
        padding: 8px 12px;
        display: block;
    }
    nav ul li a:hover {
        background-color: #555;
        border-radius: 5px;
    }
</style>
