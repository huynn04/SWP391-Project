<%-- 
    Document   : footer
    Created on : Feb 26, 2025
    Author     : Nguy?n Ng?c Huy CE180178
--%>


    <footer id="footer">
        <!-- Chatra {literal} -->
        <script>
            (function (d, w, c) {
                w.ChatraID = '6ttM7t2hWx4ta8j2Z';
                var s = d.createElement('script');
                w[c] = w[c] || function () {
                    (w[c].q = w[c].q || []).push(arguments);
                };
                s.async = true;
                s.src = 'https://call.chatra.io/chatra.js';
                if (d.head)
                    d.head.appendChild(s);
            })(document, window, 'Chatra');
        </script>
        <!-- /Chatra {/literal} -->
        <div class="container">
            <nav>
                <ul class="footer-nav">
                    <li><a href="home">Home</a></li>
                    <li><a href="products">Products</a></li>
                    <li><a href="<%= session.getAttribute("loggedInUser") != null ? "cartDetail.jsp" : "login.jsp" %>">Cart</a></li>
                    <li><a href="AllNews">News</a></li>
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
</div>

<style>
    /* ??m b?o footer n?m d??i cùng trang */
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
    flex: 1;  /* Ph?n chính s? m? r?ng ?? ??y footer xu?ng d??i */
}


.footer-nav {
    list-style: none;
    padding: 0;
    margin: 0 0 10px 0;
    display: flex;
    justify-content: center;
    gap: 15px;  /* Gi?m kho?ng cách gi?a các m?c */
}

.footer-nav li {
    display: inline;
}

.footer-nav a {
    text-decoration: none;
    color: #333;
    font-size: 13px;  /* Gi?m font-size ?? menu trong footer nh? g?n h?n */
}

.footer-nav a:hover {
    color: #007bff;
}

.footer-text {
    font-size: 11px;  /* Gi?m font-size cho text trong footer */
    color: #666;
}

</style>