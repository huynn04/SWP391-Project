<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Login</title>
        <!-- Liên kết Bootstrap -->
        <link rel="stylesheet" href="https://unpkg.com/bootstrap@5.3.3/dist/css/bootstrap.min.css">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <!-- Style tuỳ chỉnh -->
        <style>
            html, body {
                height: 100%;
                margin: 0;
                padding: 0;
            }
            /* Màu nền nhẹ cho toàn trang */
            body {
                background: #f3f5f7;
            }
            #wrapper {
                min-height: 100vh;
                display: flex;
                flex-direction: column;
            }
            main {
                flex: 1;
                padding-bottom: 50px;
            }
            /* Card chính của form đăng nhập */
            .login-card {
                border: none;
                border-radius: 1rem;
                box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            }
            .login-card .form-floating label {
                color: #666;
            }
            .login-card button {
                border-radius: 0.5rem;
            }
            /* Chỉnh line “or” cho đẹp hơn */
            .divider {
                position: relative;
                text-align: center;
                margin: 2rem 0;
            }
            .divider::before {
                content: "";
                position: absolute;
                top: 50%;
                left: 0;
                width: 45%;
                height: 1px;
                background: rgba(0,0,0,0.1);
            }
            .divider::after {
                content: "";
                position: absolute;
                top: 50%;
                right: 0;
                width: 45%;
                height: 1px;
                background: rgba(0,0,0,0.1);
            }
            .divider span {
                background: #fff;
                padding: 0 1rem;
                color: #999;
                font-weight: 500;
            }
            /* Style cho logo Google */
            .google-logo {
                width: 20px;
                height: 20px;
            }
        </style>
    </head>
    <body>
        <div id="wrapper">
            <%@ include file="header.jsp" %>

            <main>
                <section class="py-3 py-md-5 py-xl-5">
                    <div class="container">
                        <div class="row justify-content-center">
                            <div class="col-12 col-md-10 col-lg-8 col-xl-6">

                                <!-- Khối card Bootstrap -->
                                <div class="card login-card p-4 p-md-5">
                                    <h2 class="display-5 fw-bold text-center mb-2">Log In</h2>
                                    <p class="text-center mb-4">
                                        Don't have an account? 
                                        <a href="register.jsp">Register</a>
                                    </p>

                                    <!-- Form đăng nhập -->
                                    <form action="LoginServlet" method="POST">
                                        <div class="form-floating mb-3">
                                            <input 
                                                type="email" 
                                                class="form-control border-0 border-bottom rounded-0" 
                                                name="email" 
                                                id="email" 
                                                placeholder="name@example.com" 
                                                required
                                            >
                                            <label for="email" class="form-label">Email</label>
                                        </div>
                                        <div class="form-floating mb-3">
                                            <input 
                                                type="password" 
                                                class="form-control border-0 border-bottom rounded-0" 
                                                name="password" 
                                                id="password" 
                                                placeholder="Password" 
                                                required
                                            >
                                            <label for="password" class="form-label">Password</label>
                                        </div>
                                        <!-- Link Quên mật khẩu -->
                                        <div class="text-end mb-4">
                                            <a href="forgotpassword.jsp" class="text-decoration-none">
                                                Forgot password?
                                            </a>
                                        </div>
                                        <!-- Nút Đăng nhập -->
                                        <div class="d-grid">
                                            <button class="btn btn-primary btn-lg" type="submit">
                                                Log in
                                            </button>
                                        </div>

                                        <!-- Thông báo lỗi nếu có -->
                                        <% if (request.getAttribute("errorMessage") != null) { %>
                                            <div class="alert alert-danger mt-3" role="alert">
                                                <%= request.getAttribute("errorMessage") %>
                                            </div>
                                        <% } %>
                                    </form>

                                    <!-- Đường kẻ “or” -->
                                    <div class="divider">
                                        <span>OR</span>
                                    </div>

                                    <!-- Đăng nhập qua Google với nền trắng -->
                                    <div class="d-grid">
                                        <a href="googleLogin" class="btn btn-light btn-lg d-flex align-items-center justify-content-center">
                                            <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRlvdLI5zD4GmMr_SgWbtV8G5EJI0u_VSmFUA&s" alt="Google logo" class="google-logo">
                                            <span class="ms-2 fs-6">Sign in with Google</span>
                                        </a>
                                    </div>
                                </div>
                                <!-- Kết thúc card -->
                            </div>
                        </div>
                    </div>
                </section>
            </main>

            <%@ include file="footer.jsp" %>
        </div>
    </body>
</html>
