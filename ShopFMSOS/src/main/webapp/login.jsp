<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
    <link rel="stylesheet" href="https://unpkg.com/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        html, body {
            height: 100%;
            margin: 0;
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
    </style>
</head>
<body>
    <div id="wrapper">
        <%@ include file="header.jsp" %>

        <main>
            <section class="py-3 py-md-5 py-xl-8">
                <div class="container">
                    <div class="row">
                        <div class="col-12">
                            <div class="mb-5">
                                <h2 class="display-5 fw-bold text-center">Log In</h2>
                                <p class="text-center m-0">Don't have an account? <a href="register.jsp">Register</a></p>
                            </div>
                        </div>
                    </div>
                    <div class="row justify-content-center">
                        <div class="col-12 col-lg-10 col-xl-8">
                            <div class="row gy-5 justify-content-center">
                                <div class="col-12 col-lg-5">
                                    <!-- Form đăng nhập gửi đến LoginServlet -->
                                    <form action="LoginServlet" method="POST">
                                        <div class="row gy-3 overflow-hidden">
                                            <div class="col-12">
                                                <div class="form-floating mb-3">
                                                    <input type="email" class="form-control border-0 border-bottom rounded-0" name="email" id="email" placeholder="name@example.com" required>
                                                    <label for="email" class="form-label">Email</label>
                                                </div>
                                            </div>
                                            <div class="col-12">
                                                <div class="form-floating mb-3">
                                                    <input type="password" class="form-control border-0 border-bottom rounded-0" name="password" id="password" placeholder="Password" required>
                                                    <label for="password" class="form-label">Password</label>
                                                </div>
                                                <!-- Thêm liên kết Forgot Password -->
                                                <div class="text-end">
                                                    <a href="forgotpassword.jsp" class="text-decoration-none">Forgot password?</a>
                                                </div>
                                            </div>
                                            <div class="col-12">
                                                <div class="d-grid">
                                                    <button class="btn btn-primary btn-lg" type="submit">Log in</button>
                                                </div>
                                            </div>
                                        </div>
                                    </form>

                                    <!-- Hiển thị thông báo lỗi nếu có -->
                                    <% if (request.getAttribute("errorMessage") != null) { %>
                                        <div class="alert alert-danger mt-3" role="alert">
                                            <%= request.getAttribute("errorMessage") %>
                                        </div>
                                    <% } %>
                                </div>

                                <!-- Chia cách phần đăng nhập thông thường và mạng xã hội -->
                                <div class="col-12 col-lg-2 d-flex align-items-center justify-content-center gap-3 flex-lg-column">
                                    <div class="bg-dark h-100 d-none d-lg-block" style="width: 1px; --bs-bg-opacity: .1;"></div>
                                    <div class="bg-dark w-100 d-lg-none" style="height: 1px; --bs-bg-opacity: .1;"></div>
                                    <div>or</div>
                                    <div class="bg-dark h-100 d-none d-lg-block" style="width: 1px; --bs-bg-opacity: .1;"></div>
                                    <div class="bg-dark w-100 d-lg-none" style="height: 1px; --bs-bg-opacity: .1;"></div>
                                </div>

                                <!-- Đăng nhập bằng mạng xã hội -->
                                <div class="col-12 col-lg-5 d-flex align-items-center">
                                    <div class="d-flex gap-3 flex-column w-100">
                                        <a href="#!" class="btn btn-lg btn-danger">
                                            <i class="bi bi-google"></i>
                                            <span class="ms-2 fs-6">Sign in with Google</span>
                                        </a>
                                        <a href="#!" class="btn btn-lg btn-primary">
                                            <i class="bi bi-facebook"></i>
                                            <span class="ms-2 fs-6">Sign in with Facebook</span>
                                        </a>
                                        <a href="#!" class="btn btn-lg btn-dark">
                                            <i class="bi bi-apple"></i>
                                            <span class="ms-2 fs-6">Sign in with Apple</span>
                                        </a>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </main>

        <%@ include file="footer.jsp" %>
    </div>
</body>
</html>
