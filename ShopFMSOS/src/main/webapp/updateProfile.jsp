<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="model.User" %>

<%
    User user = (User) session.getAttribute("loggedInUser");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Update Profile</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
    <%@ include file="header.jsp" %>

    <div class="container mt-5">
        <h2 class="mb-4">Update Profile</h2>

        <form action="UpdateProfileServlet" method="post">
            <table class="table table-bordered">
                <tr>
                    <th>Avatar URL</th>
                    <td>
                        <input type="text" class="form-control" name="avatar" value="<%= user.getAvatar() != null ? user.getAvatar() : "" %>">
                        <% if (user.getAvatar() != null && !user.getAvatar().isEmpty()) { %>
                            <img src="<%= user.getAvatar() %>" alt="Avatar" width="100" class="rounded mt-2">
                        <% } %>
                    </td>
                </tr>
                <tr>
                    <th>Full Name</th>
                    <td><input type="text" class="form-control" name="fullName" value="<%= user.getFullName() %>" required></td>
                </tr>
                <tr>
                    <th>Email</th>
                    <td>
                        <input type="email" class="form-control" name="email" value="<%= user.getEmail() %>" readonly>
                    </td>
                </tr>
                <tr>
                    <th>Phone Number</th>
                    <td><input type="text" class="form-control" name="phoneNumber" value="<%= user.getPhoneNumber() != null ? user.getPhoneNumber() : "" %>"></td>
                </tr>
                <tr>
                    <th>Address</th>
            <td><input type="text" class="form-control" name="address" value="<%= user.getAddress() != null ? user.getAddress() : "" %>"></td>
                </tr>
            </table>

            <div class="mt-4 d-flex gap-2">
                <button type="submit" class="btn btn-success">Save Changes</button>
                <a href="viewProfile.jsp" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>

    <%@ include file="footer.jsp" %>
</body>
</html>
