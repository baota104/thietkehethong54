<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head><title>Đăng nhập</title></head>
<body>
<h2>Đăng nhập</h2>
<form action="dologin.jsp" method="post">
    <label>Số điện thoại:</label>
    <input type="text" name="sdt" required><br><br>

    <label>Mật khẩu:</label>
    <input type="password" name="matkhau" required><br><br>

    <button type="submit">Đăng nhập</button>
</form>
<br>
<a href="GDDangKi.jsp">Chưa có tài khoản? Đăng ký ngay</a>
</body>
</html>
