<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register</title>
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
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        /* Particles Background */
        #particles-js {
            position: absolute;
            width: 100%;
            height: 100%;
            z-index: 0; /* Đặt phía sau header và form */
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
            z-index: 10;
        }

        /* Register Container with Glass Effect */
        .register-container {
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
        .register-container input[type="text"],
        .register-container input[type="email"],
        .register-container input[type="password"],
        .register-container input[type="number"] {
            width: 100%;
            padding: 12px;
            margin: 12px 0;
            border: none;
            border-radius: 5px;
            outline: none;
        }

        .register-container input:focus {
            outline: 2px solid #00BFFF;
        }

        /* Submit Button */
        .register-container button {
            width: 100%;
            padding: 12px;
            background-color: #32CD32;
            border: none;
            color: white;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .register-container button:hover {
            background-color: #228B22;
        }

        /* Email & Send Button Row */
        .email-otp-row {
            display: flex;
            align-items: center;
            gap: 5px;
        }

        /* Email Input */
        .email-container {
            flex: 2;
        }

        .email-container input[type="email"] {
            width: 100%;
            padding: 12px;
            border-radius: 5px;
        }

        /* Send OTP Button */
        .send-otp-btn {
            flex: 0 0 80px;
            padding: 10px;
            font-size: 12px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .send-otp-btn:hover {
            background-color: #218838;
        }

        /* Link Styling */
        .register-container p {
            margin-top: 15px;
        }

        .register-container a {
            color: #FFD700;
            text-decoration: none;
        }

        .register-container a:hover {
            text-decoration: underline;
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
            .register-container {
                width: 90%;
                padding: 20px;
            }

            .email-otp-row {
                flex-direction: column;
            }

            .send-otp-btn {
                width: 100%;
                margin-top: 5px;
            }
        }
    </style>
</head>
<body>

    <%@ include file="header.jsp" %>

    <!-- Particles Background -->
    <div id="particles-js"></div>

    <div class="register-container">
        <h2>Register</h2>
        <form id="registerForm" action="<%= request.getContextPath() %>/auth" method="post">
            <input type="hidden" name="action" value="register">
            <input type="text" name="fullName" placeholder="Full Name" required>

            <!-- Email and Send Button on Same Row -->
            <div class="email-otp-row">
                <div class="email-container">
                    <input type="email" id="email" name="email" placeholder="Email" required>
                </div>
                <button type="button" class="send-otp-btn" onclick="sendOTP()">Send</button>
            </div>

            <!-- OTP Input -->
            <input type="number" id="otp" name="otp" placeholder="Enter OTP" required>

            <input type="text" name="phoneNumber" placeholder="Phone Number" required>
            <input type="text" name="address" placeholder="Address" required>
            <input type="password" name="password" placeholder="Password" required>

            <button type="submit">Register</button>
        </form>
        <p>Already have an account? <a href="login.jsp">Login here</a></p>
    </div>

    <%@ include file="footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/js/all.min.js"></script>

    <!-- Particles.js Configuration -->
    <script>
        particlesJS("particles-js", {
            "particles": {
                "number": {
                    "value": 20,
                    "density": {
                        "enable": true,
                        "value_area": 800
                    }
                },
                "shape": {
                    "type": "image",
                    "image": [
                        {
                            "src": "https://cdn-icons-png.flaticon.com/512/616/616430.png", // Chim
                            "width": 40,
                            "height": 40
                        },
                        {
                            "src": "https://cdn-icons-png.flaticon.com/512/616/616523.png", // Cá
                            "width": 40,
                            "height": 40
                        }
                    ]
                },
                "opacity": {
                    "value": 0.9,
                    "random": true
                },
                "size": {
                    "value": 30,
                    "random": true
                },
                "move": {
                    "enable": true,
                    "speed": 2,
                    "direction": "none",
                    "out_mode": "out"
                }
            },
            "interactivity": {
                "events": {
                    "onhover": {
                        "enable": true,
                        "mode": "repulse"
                    },
                    "onclick": {
                        "enable": true,
                        "mode": "push"
                    }
                }
            },
            "retina_detect": true
        });

        // Send OTP Function
        function sendOTP() {
            const email = document.getElementById('email').value;

            if (!email) {
                alert("Please enter your email first.");
                return;
            }

            fetch('<%= request.getContextPath() %>/sendOTP?email=' + email)
                .then(response => response.text())
                .then(data => {
                    alert(data); // Notify user if OTP was sent successfully
                })
                .catch(error => {
                    alert("Error sending OTP. Please try again.");
                });
        }
    </script>

</body>
</html>
