<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  request.setCharacterEncoding("UTF-8");
  response.setCharacterEncoding("UTF-8");
%>

<%@ page import="DAO.NguoiDungDAO, model.NguoiDung" %>
<%@ page import="java.util.UUID, java.sql.Date" %>
<%@ page import="java.time.LocalDate, java.time.format.DateTimeFormatter, java.time.format.DateTimeParseException" %>

<%
  request.setCharacterEncoding("UTF-8");

  String ten = request.getParameter("ten");
  String sdt = request.getParameter("sdt");
  String email = request.getParameter("email");
  String matkhau = request.getParameter("matkhau");
  String matkhau2 = request.getParameter("matkhau2");
  String ngaySinhStr = request.getParameter("ngaysinh"); // mong là input type="date"

  NguoiDungDAO dao = new NguoiDungDAO();
  String message;

  if (ten == null || ten.trim().isEmpty()) {
    message = "Tên không được để trống!";
  } else if (!matkhau.equals(matkhau2)) {
    message = "Mật khẩu nhập lại không khớp!";
  } else if (dao.tonTaiNguoiDung(email, sdt)) {
    message = "Email hoặc số điện thoại đã tồn tại!";
  } else {
    // parse ngày sinh an toàn
    java.sql.Date sqlNgaySinh = null;
    if (ngaySinhStr != null && !ngaySinhStr.trim().isEmpty()) {
      try {
        // Nếu form dùng input type="date", định dạng thường là "yyyy-MM-dd"
        LocalDate ld = LocalDate.parse(ngaySinhStr, DateTimeFormatter.ISO_LOCAL_DATE);
        sqlNgaySinh = java.sql.Date.valueOf(ld);
      } catch (DateTimeParseException ex) {
        // nếu parse lỗi, bạn có thể gán null hoặc đặt thông báo lỗi
        // ở đây ta gán null và tiếp tục; nếu muốn, set message và không tạo user
        sqlNgaySinh = null;
      }
    }

    // tạo đối tượng NguoiDung phù hợp với constructor trong model
    NguoiDung n = new NguoiDung();
    n.setId(UUID.randomUUID().toString());
    n.setVaitro("KhachHang");
    n.setTen(ten);
    n.setSdt(sdt);
    n.setEmail(email);
    n.setPassword(matkhau);
    n.setGhichu("nguoi dung moi");
    n.setNgaysinh(sqlNgaySinh);

    boolean ok = dao.DangKiMoi(n);
    message = ok ? "Đăng ký thành công!" : "Đăng ký thất bại!";
  }

  request.setAttribute("thongbao", message);
  request.getRequestDispatcher("GDThongBao.jsp").forward(request, response);
%>
