<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <title>Đăng ký tài khoản</title>
  <style>
    body { font-family: Arial; margin: 30px; background: #fafafa; }
    .container { width: 400px; margin: auto; background: white; padding: 20px; border: 1px solid #ccc; border-radius: 6px; }
    input { width: 100%; padding: 6px; margin: 5px 0; }
    button { width: 100%; padding: 8px; background: #4CAF50; color: white; border: none; cursor: pointer; }
    button:hover { background: #45a049; }
  </style>
</head>
<body>
<div class="container">
  <h2>Đăng ký tài khoản</h2>
  <form action="doDangKi.jsp" method="post">
    <label>Tên:</label>
    <input type="text" name="ten" required>

    <label>Số điện thoại:</label>
    <input type="text" name="sdt" required>

    <label>Email:</label>
    <input type="email" name="email" required>

    <label>Mật khẩu:</label>
    <input type="password" name="matkhau" required>

    <label>Nhập lại mật khẩu:</label>
    <input type="password" name="matkhau2" required>
    <label>Ngày sinh </label>
    <input type="date" name = "ngaysinh">
    <label>
      <input type="checkbox" name="dongy" required> Tôi đồng ý với điều khoản
    </label><br><br>

    <button type="submit">Đăng ký</button>
  </form>
</div>
</body>
</html>
