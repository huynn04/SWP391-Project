<%@ include file="header.jsp" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Lucky Spin</title>
        <style>

            body {
                display: flex;
                flex-direction: column;
                height: 100vh; /* Chi?u cao toàn b? trang */
                margin: 0;
            }

            .main-content {
                flex: 1; /* Ph?n chính chi?m toàn b? không gian còn l?i */
                display: flex;
                justify-content: center;
                align-items: center;
                flex-direction: column;
                padding-top: 100px; /* ?i?u ch?nh ?? vòng quay xu?ng th?p h?n */
            }

            .spin-container {
                position: relative;
                width: 300px;
                height: 300px;
                border-radius: 50%;
                background-color: #f5f5f5;
                display: flex;
                align-items: center;
                justify-content: center;
                border: 5px solid #333;
                background: conic-gradient(
                    #4db8ff 0deg 45deg,
                    #ff4d4d 45deg 90deg,
                    #ffcc00 90deg 135deg,
                    #66ff66 135deg 180deg,
                    #ff3399 180deg 225deg,
                    #66ccff 225deg 270deg,
                    #ff9933 270deg 315deg,
                    #9966ff 315deg 360deg
                    );
            }

            .spin-btn {
                position: absolute;
                width: 60px;
                height: 60px;
                background-color: #007bff;
                border-radius: 50%;
                color: white;
                border: none;
                font-size: 20px;
                cursor: pointer;
                font-weight: bold;
                z-index: 1;
            }

            .result {
                margin-top: 20px;
                font-size: 18px;
                font-weight: bold;
                color: #333;
            }

        </style>
    </head>

    <body>
        <div class="main-content">
            <div class="spin-container">
                <button class="spin-btn" onclick="spinWheel()">SPIN</button>
            </div>
            <div class="result" id="result"></div>
        </div>

        <%@ include file="footer.jsp" %>

        <script>
            // D? li?u c?a các mã gi?m giá
            const discountCodes = ['SALE10', 'FIXED50', 'FREESHIP', 'GIAM10', 'NEWDISCOUNT'];

            // Hàm quay vòng
            function spinWheel() {
                let deg = Math.floor(Math.random() * 360);
                document.querySelector(".spin-container").style.transition = "transform 3s ease-out";
                document.querySelector(".spin-container").style.transform = "rotate(" + deg + "deg)";

                // Sau khi vòng quay k?t thúc, tính k?t qu?
                setTimeout(() => {
                    const resultIndex = Math.floor(deg / 45) % discountCodes.length; // Tính mã gi?m giá d?a trên v? trí c?a vòng quay
                    const resultCode = discountCodes[resultIndex];
                    document.getElementById('result').textContent = "Congratulations! You won: " + resultCode;

                    // G?i k?t qu? cho server x? lý
                    sendDiscountToServer(resultCode);
                }, 2000);
            }

            // G?i mã gi?m giá cho server
            function sendDiscountToServer(discountCode) {
                fetch('/applyDiscount', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({discountCode: discountCode})
                })
                        .then(response => response.json())
                        .then(data => {
                            if (data.success) {
                                console.log("Discount applied successfully!");
                            } else {
                                console.log("Error applying discount");
                            }
                        });
            }

            let hasSpun = false;

            function spinWheel() {
                if (hasSpun) {
                    alert("You can only spin once.");
                    return;
                }

                let deg = Math.floor(Math.random() * 360);
                document.querySelector(".spin-container").style.transition = "transform 3s ease-out";
                document.querySelector(".spin-container").style.transform = "rotate(" + deg + "deg)";

                setTimeout(() => {
                    const resultIndex = Math.floor(deg / 45) % discountCodes.length;
                    const resultCode = discountCodes[resultIndex];
                    document.getElementById('result').textContent = "Congratulations! You won: " + resultCode;
                    sendDiscountToServer(resultCode);

                    hasSpun = true;
                }, 2000);
            }
        </script>
    </body>
</html>
