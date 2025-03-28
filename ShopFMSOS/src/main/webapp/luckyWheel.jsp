<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lucky Spin</title>
    <style>
        /* Style cho v�ng quay */
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
        // D? li?u c?a c�c m� gi?m gi�
        const discountCodes = ['SALE10', 'DISCOUNT20', 'FREESHIP', 'GIAM50', 'SALE15', 'FREESHIP20', 'DISCOUNT25', 'SPECIAL30'];

        // H�m quay v�ng
        function spinWheel() {
            // T?o m?t g�c quay ng?u nhi�n (t? 0 ??n 360 ??)
            let deg = Math.floor(Math.random() * 360);
            document.querySelector(".spin-container").style.transition = "transform 3s ease-out";
            document.querySelector(".spin-container").style.transform = "rotate(" + deg + "deg)";
            
            // Ch? khi v�ng quay k?t th�c, sau ?� t�nh k?t qu?
            setTimeout(() => {
                const resultIndex = Math.floor(deg / 45) % discountCodes.length; // T�nh m� gi?m gi� d?a tr�n v? tr� c?a v�ng quay
                const resultCode = discountCodes[resultIndex];
                document.getElementById('result').textContent = "Congratulations! You won: " + resultCode;
                
                // G?i k?t qu? v? server ?? x? l� (g?i m� gi?m gi� cho ng??i d�ng)
                sendDiscountToServer(resultCode);
            }, 3000);
        }

        // G?i m� gi?m gi� cho server
        function sendDiscountToServer(discountCode) {
            // B?n c� th? thay ??i URL API v� g?i m� gi?m gi� ? ?�y
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
