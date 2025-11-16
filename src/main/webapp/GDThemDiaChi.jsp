<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.KhachHang" %>
<%
  // Bảo vệ trang: Phải đăng nhập mới được vào đây
  KhachHang kh = (KhachHang) session.getAttribute("khachhang");
  if (kh == null) {
    response.sendRedirect("GDDangNhap.jsp");
    return;
  }
%>
<html>
<head>
  <title>Thêm Địa chỉ mới</title>
  <style>
    /* (Sử dụng CSS tương tự như trang GDThanhToan.jsp) */
    body { font-family: 'Inter', sans-serif; background-color: #f3f4f6; padding: 20px; }
    .container { max-width: 600px; margin: 40px auto; background: #fff; padding: 30px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
    h2 { color: #3b82f6; text-align: center; }
    .info-field { margin-bottom: 20px; }
    .info-label { display: block; font-weight: bold; color: #374151; margin-bottom: 5px; }
    .info-input { width: 100%; padding: 12px; border: 1px solid #d1d5db; border-radius: 6px; font-size: 1em; box-sizing: border-box; }
    .btn-submit {
      width: 100%; padding: 15px; background: #10b981; color: white; border: none;
      border-radius: 8px; cursor: pointer; font-size: 1.1em; font-weight: bold;
    }
  </style>
</head>
<body>
<div class="container">
  <h2>Thêm Địa Chỉ Giao Hàng Mới</h2>

  <form method="post" action="doThemDiaChi.jsp">
    <div class="info-field">
      <label class="info-label" for="diaChiMoi">Địa chỉ mới</label>
      <input type="text" id="diaChiMoi" class="info-input" name="diaChiMoi"
             placeholder="Ví dụ: 123 Nguyễn Văn Linh, P. Bình Thuận, Q. 7, TP.HCM" required>
    </div>
    <button type="submit" class="btn-submit">Lưu Địa Chỉ</button>
  </form>
</div>
</body>
</html>