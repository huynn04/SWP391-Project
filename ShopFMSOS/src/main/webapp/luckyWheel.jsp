<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lucky Spin</title>
    <style>
        /* Style cho vòng quay */
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
    <div class="spin-container">
        <button class="spin-btn" onclick="spinWheel()">SPIN</button>
    </div>
    <div class="result" id="result"></div>

    <script>
        // D? li?u c?a các mã gi?m giá
        const discountCodes = ['SALE10', 'DISCOUNT20', 'FREESHIP', 'GIAM50', 'SALE15', 'FREESHIP20', 'DISCOUNT25', 'SPECIAL30'];

        // Hàm quay vòng
        function spinWheel() {
            // T?o m?t góc quay ng?u nhiên (t? 0 ??n 360 ??)
            let deg = Math.floor(Math.random() * 360);
            document.querySelector(".spin-container").style.transition = "transform 3s ease-out";
            document.querySelector(".spin-container").style.transform = "rotate(" + deg + "deg)";
            
            // Ch? khi vòng quay k?t thúc, sau ?ó tính k?t qu?
            setTimeout(() => {
                const resultIndex = Math.floor(deg / 45) % discountCodes.length; // Tính mã gi?m giá d?a trên v? trí c?a vòng quay
                const resultCode = discountCodes[resultIndex];
                document.getElementById('result').textContent = "Congratulations! You won: " + resultCode;
                
                // G?i k?t qu? v? server ?? x? lý (g?i mã gi?m giá cho ng??i dùng)
                sendDiscountToServer(resultCode);
            }, 3000);
        }

        // G?i mã gi?m giá cho server
        function sendDiscountToServer(discountCode) {
            // B?n có th? thay ??i URL API và g?i mã gi?m giá ? ?ây
            fetch('/applyDiscount', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ discountCode: discountCode })
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
    </script>
</body>
</html>
