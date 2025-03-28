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
            </main>
            <%@ include file="footer.jsp" %>
        </div>
    </body>

</html>
