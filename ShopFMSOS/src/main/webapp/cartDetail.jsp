<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, model.Product, java.math.BigDecimal" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Giỏ hàng của bạn</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
//        function updateQuantity(productId, quantity, maxQuantity) {
//            if (quantity > maxQuantity || quantity < 1) {
//                alert("Số lượng không hợp lệ!");
//                return;
//            }
//            $.ajax({
//                url: 'UpdateCart',
//                method: 'POST',
//                data: { productId: productId, quantity: quantity },
//                success: function(response) {
//                    if (response === "success") {
//                        recalculateTotal();
//                    } else {
//                        alert("Không thể cập nhật giỏ hàng.");
//                    }
//                },
//                error: function() {
//                    alert("Có lỗi xảy ra khi cập nhật giỏ hàng.");
//                }
//            });
//        }
//
//        function recalculateTotal() {
//            let total = 0;
//            $(".cart-item").each(function() {
//                let price = parseFloat($(this).find(".item-price").text().replace("$", ""));
//                let quantity = parseInt($(this).find(".quantity-input").val());
//                let subtotal = price * quantity;
//                $(this).find(".item-total").text(`$${subtotal.toFixed(3)}`);
//                total += subtotal;
//            });
//
//            $("#cart-total").text(`$${total.toFixed(3)}`);
//        }
//
//        $(document).ready(function() {
//            $(".quantity-input").on("change", function() {
//                let productId = $(this).data("product-id");
//                let quantity = $(this).val();
//                let maxQuantity = $(this).data("max-quantity");
//                updateQuantity(productId, quantity, maxQuantity);
//            });
//        });
    </script>
</head>
<body>
    <%@ include file="header.jsp" %>

    <div class="container mt-5">
        <h2 class="mb-4">Giỏ hàng của bạn</h2>

        <%
            List<Product> cart = (List<Product>) session.getAttribute("cart");
            Object totalPriceObj = session.getAttribute("totalPrice");
            BigDecimal totalPrice = (totalPriceObj != null) ? (BigDecimal) totalPriceObj : BigDecimal.ZERO;

            if (cart != null && !cart.isEmpty()) {
        %>
        <table class="table table-bordered">
            <thead class="table-dark">
                <tr>
                    <th>Ảnh</th>
                    <th>Tên sản phẩm</th>
                    <th>Giá</th>
                    <th>Số lượng</th>
                    <th>Thành tiền</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <%
                    for (Product p : cart) {
                %>
                <tr class="cart-item">
                    <td class="text-center">
                        <% if (p.getImage() != null && !p.getImage().trim().isEmpty()) { %>
                            <img src="<%= p.getImage() %>" alt="<%= p.getProductName() %>" width="100">
                        <% } else { %>
                            <img src="images/no-image.png" alt="No Image" width="100">
                        <% } %>
                    </td>
                    <td><%= p.getProductName() %></td>
                    <td class="item-price">$<%= String.format("%.3f", p.getPrice().doubleValue()) %></td>
                    <td>
                        <input onchange="changeQuantity(this)" type="number" class="quantity-input form-control text-center" data-product-id="<%= p.getProductId() %>" 
                               data-max-quantity="<%= p.getQuantity() %>" value="<%= p.getQuantity() %>" min="1" style="width: 80px;">
                    </td>
                    <td class="item-total">$<%= String.format("%.3f", p.getPrice().doubleValue() * p.getQuantity()) %></td>
                    <td class="text-center">
                        <a href="RemoveFromCart?productId=<%= p.getProductId() %>" class="btn btn-danger btn-sm">Xóa</a>
                    </td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>

        <!-- Form nhập mã giảm giá -->
        <form action="ApplyDiscount" method="post" class="mb-3">
            <label for="discountCode">Nhập mã giảm giá:</label>
            <input type="text" name="discountCode" id="discountCode" class="form-control w-50 d-inline">
            <button onclick="doDiscount(event)" type="submit" class="btn btn-primary">Áp dụng</button>
        </form>

        <!-- Hiển thị thông báo lỗi hoặc thành công -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>
        <c:if test="${not empty success}">
            <div class="alert alert-success">${success}</div>
        </c:if>

        <!-- Hiển thị tổng giá trị giỏ hàng -->
        <div class="mt-3 p-3 bg-light border text-end">
            <h4>Tổng giá trị giỏ hàng: <strong id="cart-total" class="text-danger">$<%= String.format("%.3f", totalPrice) %></strong></h4>
        </div>

        <!-- Nút "Mua hàng" chuyển tới CheckoutInfo.jsp -->
        <div class="mt-3 text-end">
            <a href="CheckoutInfo" class="btn btn-success btn-lg">Mua hàng</a>
        </div>
        <%
            } else {
        %>
        <div class="alert alert-warning text-center">
            Giỏ hàng của bạn đang trống.
        </div>
        <%
            }
        %>
    </div>

    <%@ include file="footer.jsp" %>
    
    <script>
        function doDiscount(e) {
            e.preventDefault();
            const input = document.querySelector('#discountCode');
            let url = "ApplyDiscount?" + "data=" + input.value;
            fetch(url, {
                method: 'post'
            }).then(response => response.text()).then(data => {
                const discountVal = Number(data);
                const itemTotal = document.querySelector('.item-total');
                let currentVal = Number(itemTotal.textContent.replace(/[^0-9]/g, ''));
                currentVal = (currentVal - (currentVal * discountVal / 100)).toLocaleString('vi-VN');
                itemTotal.innerHTML = `$\${currentVal}`;
                
            }).catch(err => console.log(err));
        }
        
        function changeQuantity(input) {
            const cart_total = document.querySelector('#cart-total');
            const itemPrice = input.parentElement.parentElement.querySelector('.item-price');
            const currPrice = input.parentElement.parentElement.querySelector('.item-total');
            let initPriceVal = Number(itemPrice.textContent.replace(/[^0-9]/g, ''));
            let currPriceVal = Number(currPrice.textContent.replace(/[^0-9]/g, ''));
            let cart_totalVal = Number(cart_total.textContent.replace(/[^0-9]/g, ''));
            
            let quantity = Number(input.value);
            let newPrice = initPriceVal * quantity;
          
            newPrice = newPrice.toLocaleString('vi-VN');
            currPrice.innerHTML = `$\${newPrice}`;
            
            updateTotalPrice();
        }
        
        function updateTotalPrice() {
            const getAllInputs = document.querySelectorAll('.item-total');
            const cart_total = document.querySelector('#cart-total');
            let totalPrice = 0;
            if(getAllInputs) {
                
                Array.from(getAllInputs).forEach(input => {
                    let currentVal = Number(input.textContent.replace(/[^0-9]/g, ''));
                    totalPrice += currentVal;
                });
                totalPrice = totalPrice.toLocaleString('vi-VN');
                cart_total.innerHTML = `$\${totalPrice}`;
            }
        }
        
        updateTotalPrice();
    </script>
</body>
</html>
