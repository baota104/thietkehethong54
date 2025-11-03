<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, model." %>
<html>
<head>
    <title>Danh sách người dùng</title>
</head>
<body>
<h2>Danh sách người dùng</h2>

<table border="1" cellpadding="5" cellspacing="0">
    <tr>
        <th>ID</th>
        <th>Tên</th>
        <th>Email</th>
    </tr>

    <%
        List<User> users = (List<User>) request.getAttribute("usersList");
        if (users != null) {
            for (User u : users) {
    %>
    <tr>
        <td><%= u.getId() %></td>
        <td><%= u.getName() %></td>
        <td><%= u.getEmail() %></td>
    </tr>
    <%
            }
        }
    %>
</table>

<br>
<a href="GDChinhKhachHang.jsp">Quay lại trang chủ</a>

</body>
</html>
