<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Address - FMSOS</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>

    <%@ include file="header.jsp" %>

    <div class="container mt-5">
        <h2>Update Address</h2>

        <!-- Hiển thị thông báo lỗi nếu có -->
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger text-center">
                ${errorMessage}
            </div>
        </c:if>

        <!-- Form cập nhật địa chỉ -->
        <form action="UpdateAddressServlet" method="POST">
            <!-- Truyền id địa chỉ để nhận diện -->
            <input type="hidden" name="addressId" value="${param.addressId}">

            <div class="mb-3">
                <label for="fullName" class="form-label">Full Name</label>
                <input type="text" class="form-control" id="fullName" name="fullName" value="${param.fullName}" required>
            </div>

            <div class="mb-3">
                <label for="phone" class="form-label">Phone Number</label>
                <input type="text" class="form-control" id="phone" name="phone" value="${param.phone}" required>
            </div>

            <div class="mb-3">
                <label for="city" class="form-label">City</label>
                <input type="text" class="form-control" id="city" name="city" value="${param.city}" required>
            </div>

            <div class="mb-3">
                <label for="district" class="form-label">District</label>
                <input type="text" class="form-control" id="district" name="district" value="${param.district}" required>
            </div>

            <div class="mb-3">
                <label for="ward" class="form-label">Ward</label>
                <input type="text" class="form-control" id="ward" name="ward" value="${param.ward}" required>
            </div>

            <div class="mb-3">
                <label for="specificAddress" class="form-label">Specific Address</label>
                <input type="text" class="form-control" id="specificAddress" name="specificAddress" value="${param.specificAddress}" required>
            </div>

            <div class="mb-3">
                <label for="addressType" class="form-label">Address Type</label>
                <select class="form-select" id="addressType" name="addressType" required>
                    <option value="Home" ${param.addressType == 'Home' ? 'selected' : ''}>Home</option>
                    <option value="Work" ${param.addressType == 'Work' ? 'selected' : ''}>Work</option>
                    <option value="Other" ${param.addressType == 'Other' ? 'selected' : ''}>Other</option>
                </select>
            </div>

            <button type="submit" class="btn btn-primary">Save Address</button>
        </form>
    </div>

    <%@ include file="footer.jsp" %>

</body>
</html>
