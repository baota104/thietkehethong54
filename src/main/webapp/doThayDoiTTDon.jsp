<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.DonHangDAO" %>
<%@ page import="model.DonHang" %>
<%@ page import="model.NhanVien" %>
<%@ page import="model.KhachHang" %>
<%@ page import="java.net.URLEncoder" %>

<%
  // 1. Kiểm tra đăng nhập
  NhanVien nvSession = (NhanVien)session.getAttribute("nhanvien");
  if (nvSession == null) {
    response.sendRedirect("GDDangNhapNV.jsp");
    return;
  }

  request.setCharacterEncoding("UTF-8");

  // 2. Lấy tham số
  String maDon = request.getParameter("maDon");
  String thaoTac = request.getParameter("thaoTac");
  String ghiChu = request.getParameter("ghiChu");
  String khachHangId = request.getParameter("khachHangId");

  DonHangDAO dao = new DonHangDAO();
  boolean isSuccess = false;
  String message = "";

  if (maDon != null && thaoTac != null) {
    DonHang d = new DonHang();
    d.setId(maDon);

    // --- CASE 1: XÁC NHẬN (Xử lý xong return ngay) ---
    if (thaoTac.equals("XacNhan")) {
      d.setTrangthai("Đang giao");
      isSuccess = dao.xacNhanDon(d);
      message = isSuccess ? "Xác nhận thành công! Vui lòng đi giao hàng." : "Lỗi xác nhận đơn hàng.";

      out.println("<script type='text/javascript'>");
      out.println("alert('" + message + "');");
      out.println("window.location.href = 'GDGiaoHangChoKhach.jsp';");
      out.println("</script>");
      return;
    }

    // --- CASE 2: TRẢ ĐƠN (Xử lý xong return ngay) ---
    else if (thaoTac.equals("TraDon")) {
      d.setTrangthai("Chờ xử lí");
      isSuccess = dao.huyNhanDon(d);
      message = isSuccess ? "Đã trả đơn lại hệ thống thành công." : "Lỗi trả đơn.";

      out.println("<script type='text/javascript'>");
      out.println("alert('" + message + "');");
      out.println("window.location.href = 'GDGiaoHangChoKhach.jsp';");
      out.println("</script>");
      return;
    }

    // --- CÁC CASE DƯỚI ĐÂY SẼ CHẠY XUỐNG CUỐI FILE ĐỂ IN SCRIPT ---

    // --- CASE 3: HỦY ĐƠN ---
    else if (thaoTac.equals("Huy")) {
      if(ghiChu == null || ghiChu.trim().isEmpty()) ghiChu = "Hủy không lý do";
      d.setGhichu(ghiChu);
      isSuccess = dao.huyDonHang(d);
      message = isSuccess ? "Đã hủy đơn hàng thành công." : "Lỗi khi hủy đơn.";
    }

    // --- CASE 4: GIAO THẤT BẠI (Từ GDThongBao) ---
    else if (thaoTac.equals("ThatBai")) {
      d.setGhichu(ghiChu); // Ghi chú lấy từ GDThongBao
      isSuccess = dao.giaoThatBai(d);
      message = isSuccess ? "Đã cập nhật trạng thái: Giao thất bại." : "Lỗi cập nhật.";
    }

    // --- CASE 5: ĐÃ GIAO (Từ GDThongBao) ---
    else if (thaoTac.equals("DaGiao")) {
      KhachHang kh = new KhachHang();
      kh.setId(khachHangId);
      d.setKhachHang(kh);
      d.setGhichu(ghiChu); // Ghi chú lấy từ GDThongBao
      d.setTrangthai("Đã giao");

      isSuccess = dao.daGiaoDon(d);
      message = isSuccess ? "Giao thành công! Cập nhật dữ liệu xong." : "Lỗi cập nhật.";
    }
  } else {
    message = "Thiếu thông tin xử lý.";
  }

  // --- QUAN TRỌNG: ĐOẠN CODE ĐIỀU HƯỚNG CHO CÁC CASE CÒN LẠI ---
  // Đoạn này xử lý cho Hủy, Thất Bại, Đã Giao sau khi chạy xong logic ở trên
  out.println("<script type='text/javascript'>");
  out.println("alert('" + message + "');");
  out.println("window.location.href = 'GDGiaoHangChoKhach.jsp';"); // Quay về danh sách
  out.println("</script>");
%>