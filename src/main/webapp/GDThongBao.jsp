<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  request.setCharacterEncoding("UTF-8");
  response.setCharacterEncoding("UTF-8");
%>
<html>
<head>
  <title>Thông báo</title>
  <style>
    body { font-family: Arial; background: #f2f2f2; margin: 50px; }
    .box {
      background: white; padding: 30px;
      margin: auto; width: 400px;
      border-radius: 8px; box-shadow: 0 0 10px #ccc;
      text-align: center;
    }
    a { display: inline-block; margin-top: 10px; text-decoration: none; color: #2196F3; }
  </style>
</head>
<body>
<div class="box">
  <h2>Thông báo</h2>
  <p><%= request.getAttribute("thongbao") %></p>

  <a href="login.jsp">Quay lại đăng nhập</a> |
  <a href="GDDangKi.jsp">Đăng ký lại</a> |
  <a href="giaodienchinh.jsp">Trang chủ</a>
</div>
</body>
</html>
