<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Lucky Wheel - FMSOS</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
        <style>
            .wheel-container { text-align: center; margin-top: 50px; }
            .spin-btn { padding: 10px 20px; font-size: 18px; }
            .check-btn { padding: 10px 20px; font-size: 18px; margin-left: 10px; }
            .result { margin-top: 20px; font-size: 20px; }
        </style>
    </head>
    <body>
        <div id="wrapper">
            <main>
                <div class="wheel-container">
                    <h1>Lucky Wheel</h1>
                    <p>Spin the wheel for a chance to win a discount coupon!</p>
                    <div id="wheel">
                        <!-- Wheel sections here (có th? thêm hình ?nh ho?c canvas n?u c?n) -->
                    </div>
                    <button class="spin-btn" id="spinButton" onclick="spinWheel()">Spin Now</button>
                    <button class="check-btn" id="checkButton" onclick="checkCouponCode()">Check Coupon Code</button>
                    <div class="result" id="result">
                        <c:choose>
                            <c:when test="${not empty sessionScope.couponCode}">
                                Congratulations! Your coupon code is: <strong>${sessionScope.couponCode}</strong>
                            </c:when>
                            <c:otherwise>
                                Spin to try your luck!
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </main>
        </div>

        <script>
            let isSpinning = false;
            const spinButton = document.getElementById("spinButton");
            const wheel = document.getElementById("wheel");
            let currentRotation = 0;

            function spinWheel() {
                if (isSpinning) return;
                isSpinning = true;
                spinButton.disabled = true;

                const result = document.getElementById("result");

                // Reset vòng quay
                wheel.style.transition = "none";
                wheel.style.transform = `rotate(0deg)`;
                void wheel.offsetWidth;
                wheel.style.transition = "transform 4s ease-out";

                // G?i AJAX
                fetch('LuckyWheelServlet', {
                    method: 'POST',
                    credentials: 'same-origin'
                })
                    .then(response => {
                        if (!response.ok) {
                            throw new Error('Network response was not ok: ' + response.status);
                        }
                        return response.text();
                    })
                    .then(couponCode => {
                        console.log("Coupon code received from servlet: '" + couponCode + "'");
                        console.log("Coupon code length: " + (couponCode ? couponCode.length : "undefined"));
                        console.log("Is couponCode empty or whitespace?: " + (!couponCode || couponCode.trim() === ""));

                        let extraDeg = currentRotation + Math.floor(Math.random() * 360) + 1800;
                        wheel.style.transform = `rotate(${extraDeg}deg)`;
                        currentRotation = extraDeg % 360;

                        setTimeout(() => {
                            isSpinning = false;
                            spinButton.disabled = false;
                            if (couponCode && couponCode.trim() !== "") {
                                console.log("Displaying coupon code: " + couponCode);
                                result.innerHTML = `Congratulations! Your coupon code is: <strong>${couponCode}</strong>`;
                            } else if (couponCode === "Please log in to spin!") {
                                result.innerHTML = couponCode;
                            } else {
                                console.log("No coupon code received or empty, showing 'Better luck next time!'");
                                result.innerHTML = "Better luck next time!";
                            }
                        }, 4200);
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        isSpinning = false;
                        spinButton.disabled = false;
                        result.innerHTML = "Something went wrong! Check console for details.";
                    });
            }

            // Hàm ki?m tra mã gi?m giá trong session
            function checkCouponCode() {
                const couponCode = "${sessionScope.couponCode}";
                console.log("Checking session coupon code...");
                console.log("Coupon code in session (via JSP): '" + couponCode + "'");
                alert("Current coupon code in session: " + (couponCode || "No coupon code found"));
            }
        </script>
    </body>
</html>