<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Notification</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <style>
            /* Đảm bảo rằng body và html chiếm 100% chiều cao */
            html, body {
                height: 100%;
                margin: 0;
            }

            /* Container chính chứa tất cả phần tử */
            #wrapper {
                min-height: 100vh; /* Đảm bảo chiều cao đầy đủ */
                display: flex;
                flex-direction: column;
            }

            /* Phần nội dung chính */
            main {
                flex: 1; /* Chiếm không gian còn lại giữa header và footer */
                padding-bottom: 50px;
                padding-top:50px;/* Đảm bảo có khoảng trống dưới cùng để footer không đè lên */
            }

            /* Đảm bảo container trong main không có padding-top quá lớn */
            .container {
                padding-top: 0;
            }
            h2 {
                margin-top: 30px; /* Thêm khoảng cách phía trên cho thẻ h2 */
            }
        </style>
    </head>
    <body>
        <div id="wrapper">
            <%@ include file="header.jsp" %>
            <main>

                <div class="container mt-5 text-center">
                    <h2 class="text-success">🎉 Order Placed Successfully! 🎉</h2>
                    <p>Thank you for shopping with us.</p>
                    <a href="home.jsp" class="btn btn-primary">Continue Shopping</a>
                    <a href="CustomerOrderHistory" class="btn btn-secondary">View Your Orders</a>
                </div>
                </main>
                    <%@ include file="footer.jsp" %>
                    </div>
                    </body>
                    </html>
