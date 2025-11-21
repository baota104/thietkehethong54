<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  String message = request.getParameter("message");
  String maDon = request.getParameter("maDon");
  String thaoTac = request.getParameter("thaoTac");

  boolean isResultMode = (message != null);

  String tieuDe = "";
  String noiDung = "";

  if (isResultMode) {
    tieuDe = "THÔNG BÁO";
    noiDung = message;
  } else {
    if ("ThatBai".equals(thaoTac)) {
      tieuDe = "Xác nhận GIAO THẤT BẠI";
      noiDung = "Vui lòng nhập lý do giao không thành công:";
    }
  }
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title><%= tieuDe %></title>
  <style>
    body { display: flex; justify-content: center; align-items: center; height: 100vh; font-family: Arial, sans-serif; }
    .box { width: 400px; border: 1px solid black; padding: 30px; text-align: center; }
    h3 { margin-top: 0; font-weight: bold; }
    .message { margin: 20px 0; font-size: 1.1em; }
    input[type="text"] { width: 90%; padding: 10px; margin-bottom: 20px; border: 1px solid black; }
    button { padding: 10px 30px; border: 1px solid black; background: white; cursor: pointer; font-weight: bold; }
    button:hover { background-color: #eee; }
  </style>
</head>
<body>

<div class="box">
  <h3><%= tieuDe %></h3>

  <% if (isResultMode) { %>
  <div class="message" style="color: green; font-weight: bold;"><%= noiDung %></div>

  <a href="GDChinhNV.jsp">
    <button>OK</button> </a>

  <% } else { %>
  <div class="message"><%= noiDung %></div>

  <form action="doThayDoiTTDon.jsp" method="POST">
    <input type="hidden" name="maDon" value="<%= maDon %>">
    <input type="hidden" name="thaoTac" value="<%= thaoTac %>">

    <input type="text" name="ghiChu" placeholder="Nhập ghi chú..." required>

    <br>
    <button type="submit">Xác nhận</button>
  </form>
  <% } %>
</div>

</body>
</html>