<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Login</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <!-- Particles.js -->
        <script src="https://cdn.jsdelivr.net/npm/particles.js@2.0.0/particles.min.js"></script>

        <style>
            /* Reset CSS */
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            /* Body Styling with Animated Background */
            body {
                font-family: Arial, sans-serif;
                background: linear-gradient(-45deg, #32CD32, #00BFFF, #2E8B57, #1E90FF); /* Xanh lá và xanh lam */
                background-size: 400% 400%;
                animation: gradientBG 10s ease infinite;
                min-height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
                overflow: hidden;
                position: relative;
            }

            /* Keyframes for Background Animation */
            @keyframes gradientBG {
                0% {
                    background-position: 0% 50%;
                }
                50% {
                    background-position: 100% 50%;
                }
                100% {
                    background-position: 0% 50%;
                }
            }

            /* Particles Background */
            #particles-js {
                position: absolute;
                width: 100%;
                height: 100%;
                z-index: 0; /* Đặt phía sau header và login container */
            }

            /* Header Fixed */
            #header {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                background-color: rgba(0, 0, 0, 0.8);
                color: #fff;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
                z-index: 10; /* Header nổi trên background */
            }

            /* Login Container with Glass Effect */
            .login-container {
                width: 400px;
                padding: 30px;
                background: rgba(255, 255, 255, 0.15); /* Semi-transparent */
                border-radius: 10px;
                box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
                backdrop-filter: blur(10px); /* Glassmorphism effect */
                -webkit-backdrop-filter: blur(10px);
                border: 1px solid rgba(255, 255, 255, 0.18);
                text-align: center;
                color: #fff;
                z-index: 1;
            }

            /* Input Fields */
            .login-container input[type="email"],
            .login-container input[type="password"] {
                width: 100%;
                padding: 12px;
                margin: 12px 0;
                border: none;
                border-radius: 5px;
                outline: none;
            }

            .login-container input:focus {
                outline: 2px solid #00BFFF; /* Xanh lam */
            }

            /* Submit Button */
            .login-container button {
                width: 100%;
                padding: 12px;
                background-color: #32CD32; /* Xanh lá */
                border: none;
                color: white;
                border-radius: 5px;
                cursor: pointer;
                transition: background-color 0.3s ease;
            }

            .login-container button:hover {
                background-color: #228B22; /* Đậm hơn */
            }

            /* Link Styling */
            .login-container p {
                margin-top: 15px;
            }

            .login-container a {
                color: #FFD700;
                text-decoration: none;
            }

            .login-container a:hover {
                text-decoration: underline;
            }

            /* Social Login Buttons */
            .social-login {
                margin-top: 20px;
            }

            .social-login button {
                width: 100%;
                padding: 12px;
                border: none;
                border-radius: 5px;
                margin-bottom: 10px;
                color: white;
                font-weight: bold;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
                cursor: pointer;
                transition: background-color 0.3s ease;
            }

            .google-login {
                background-color: #db4437;
            }

            .google-login:hover {
                background-color: #c1351d;
            }

            .facebook-login {
                background-color: #4267B2;
            }

            .facebook-login:hover {
                background-color: #365899;
            }

            /* Logo Styling */
            .social-login img {
                width: 24px;
                height: 24px;
                border-radius: 50%;
                background-color: white;
                padding: 2px;
            }

            /* Footer */
            #footer {
                background-color: rgba(0, 0, 0, 0.8);
                color: #fff;
                text-align: center;
                padding: 15px 0;
                margin-top: auto;
                z-index: 10;
            }

            /* Responsive */
            @media (max-width: 576px) {
                .login-container {
                    width: 90%;
                    padding: 20px;
                }

            }
            .login-container {
                width: 400px;
                padding: 30px;
                background: rgba(255, 255, 255, 0.15);
                border-radius: 10px;
                box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
                backdrop-filter: blur(10px);
                -webkit-backdrop-filter: blur(10px);
                border: 1px solid rgba(255, 255, 255, 0.18);
                text-align: center;
                color: #fff;
                z-index: 1;
                transition: opacity 0.5s ease-out;  /* Thêm chuyển tiếp */
            }

            .fade-out {
                opacity: 0;  /* Khi lớp này được thêm vào, khối sẽ mờ dần */
            }

        </style>
    </head>
    <body>

        <%@ include file="header.jsp" %>

        <!-- Particles Background -->
        <div id="particles-js"></div>

        <div class="login-container">
            <h2>Login</h2>
            <form action="home.jsp" method="post">
                <input type="hidden" name="action" value="login">
                <input type="email" name="email" placeholder="Email" required>
                <input type="password" name="password" placeholder="Password" required>
                <button type="submit">Login</button>
            </form>

            <div class="social-login">
                <p>Or login with</p>
                <!-- Google Login -->
                <button class="google-login" onclick="location.href = 'https://accounts.google.com/o/oauth2/v2/auth'">
                    <img src="https://cdn-icons-png.flaticon.com/512/281/281764.png" alt="Google Logo">
                    Login with Google
                </button>

                <!-- Facebook Login -->
                <button class="facebook-login" onclick="location.href = 'https://www.facebook.com/v12.0/dialog/oauth'">
                    <img src="https://cdn-icons-png.flaticon.com/512/733/733547.png" alt="Facebook Logo">
                    Login with Facebook
                </button>
            </div>

            <p>Don't have an account? <a href="register.jsp">Register here</a></p>
        </div>

        <%@ include file="footer.jsp" %>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/js/all.min.js"></script>


    </body>
</html>
<script>
    // Lắng nghe sự kiện submit của form
    document.querySelector('.login-container form').addEventListener('submit', function(event) {
        event.preventDefault(); // Ngăn submit mặc định để chạy hiệu ứng trước

        const container = document.querySelector('.login-container');
        container.classList.add('fade-out'); // Thêm lớp để kích hoạt hiệu ứng fade-out

        // Sau khi hiệu ứng hoàn tất (0.5s), tiếp tục submit form
        setTimeout(() => {
            event.target.submit();
        }, 500); // Thời gian delay phù hợp với transition
    });
</script>
