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
        <title>View Profile</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    </head>
    <body>
        <%@ include file="header.jsp" %>

        <div class="container mt-5">
            <h2 class="mb-4">View Profile</h2>
            <table class="table table-bordered">
                <tr>
                    <th>Avatar</th>
                    <td>
                        <% if (user.getAvatar() != null && !user.getAvatar().isEmpty()) { %>
                        <img src="<%= user.getAvatar() %>" alt="Avatar" width="100" class="rounded">
                        <% } else { %>
                        No avatar available.
                        <% } %>
                    </td>
                </tr>
                <tr>
                    <th>Full Name</th>
                    <td><%= user.getFullName() %></td>
                </tr>
                <tr>
                    <th>Email</th>
                    <td><%= user.getEmail() %></td>
                </tr>
                <tr>
                    <th>Phone Number</th>
                    <td><%= user.getPhoneNumber() != null ? user.getPhoneNumber() : "N/A" %></td>
                </tr>
                <tr>
                    <th>Address</th>
                    <td><%= user.getAddress() != null ? user.getAddress() : "N/A" %></td>
                </tr>
                <tr>
                    <th>Role</th>
                    <td><%= user.getRoleId() == 1 ? "Admin" : (user.getRoleId() == 2 ? "Staff" : "Customer") %></td>
                </tr>
            </table>

            <div class="mt-4 d-flex gap-2">
                <a href="updateProfile.jsp" class="btn btn-primary">Update Profile</a>
                <a href="home.jsp" class="btn btn-secondary">Back to Home</a>
            </div>
        </div>

    </body>
    <%@ include file="footer.jsp" %>
</html>
