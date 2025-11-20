<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  String maDon = request.getParameter("maDon");
  String thaoTac = request.getParameter("thaoTac"); // "DaGiao" hoặc "ThatBai"
  String khachHangId = request.getParameter("khachHangId");

  String tieuDe = "Thông báo";
  String noiDung = "";
  String placeholder = "Ghi chú...";

  // Tùy chỉnh nội dung hiển thị dựa trên thao tác
  if ("DaGiao".equals(thaoTac)) {
    tieuDe = "Xác nhận GIAO THÀNH CÔNG";
    noiDung = "Đơn hàng đã được giao thành công?";
    placeholder = "Ghi chú (VD: Người nhà nhận hộ...)";
  } else if ("ThatBai".equals(thaoTac)) {
    tieuDe = "Xác nhận GIAO THẤT BẠI";
    noiDung = "Đơn hàng giao không thành công?";
    placeholder = "Lý do (VD: Khách vắng nhà...)";
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
    button { padding: 10px 20px; border: 1px solid black; background: white; cursor: pointer; font-weight: bold; }
    button:hover { background-color: #eee; }
  </style>
</head>
<body>

<div class="box">
  <h3><%= tieuDe %></h3>

  <div class="message"><%= noiDung %></div>

  <form action="doThayDoiTTDon.jsp" method="POST">
    <input type="hidden" name="maDon" value="<%= maDon %>">
    <input type="hidden" name="thaoTac" value="<%= thaoTac %>">

    <input type="hidden" name="khachHangId" value="<%= (khachHangId != null) ? khachHangId : "" %>">

    <input type="text" name="ghiChu" placeholder="<%= placeholder %>" required>

    <br>

    <button type="submit">Quay về trang chủ</button>
  </form>
</div>

</body>
</html>