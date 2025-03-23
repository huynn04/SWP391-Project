<%-- 
    Document   : news
    Created on : 17 thg 3, 2025, 17:00:59
    Author     : Tran Huy Lam CE180899 
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.ArrayList, java.util.List, model.News" %>

<% 
    // Dữ liệu tin tức giả lập
    List<News> newsList = new ArrayList<>();
    newsList.add(new News(1, 1, "Tin tức 1", "Nội dung tin tức 1 ngắn gọn...", "image1.jpg", 1, null, null));
    newsList.add(new News(2, 1, "Tin tức 2", "Nội dung tin tức 2 ngắn gọn...", "image2.jpg", 1, null, null));
    newsList.add(new News(3, 2, "Tin tức 3", "Nội dung tin tức 3 ngắn gọn...", "image3.jpg", 1, null, null));
%>

<div id="news-sidebar">
    <h2 class="mb-3">Latest News</h2>
    <div class="list-group">
        <%
            for (News news : newsList) {
        %>
        <a href="#" class="list-group-item list-group-item-action">
            <h5 class="mb-1"><%= news.getTitle() %></h5>
            <p class="mb-1"><%= news.getContent() %></p>
            <small class="text-muted">Ngày đăng: Chưa có</small>
        </a>
        <% } %>
    </div>
</div>

<style>
    /* Sidebar chỉ chiếm không gian cần thiết */
    #news-sidebar {
        position: fixed;
        top: 0;
        left: 0;
        width: 300px; /* Chiều rộng sidebar */
        max-height: calc(100vh - 50px); /* Đảm bảo footer đè lên */
        background-color: #f8f9fa;
        padding: 20px;
        box-shadow: 2px 0px 5px rgba(0, 0, 0, 0.1);
        overflow-y: auto;
        z-index: 999; /* Đảm bảo không che header */
    }
</style>

