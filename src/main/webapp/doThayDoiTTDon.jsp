<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.DonHangDAO" %>
<%@ page import="model.DonHang" %>
<%@ page import="model.NhanVien" %>
<%@ page import="model.KhachHang" %>
<%@ page import="java.net.URLEncoder" %>

<%
  NhanVien nvSession = (NhanVien)session.getAttribute("nhanvien");
  if (nvSession == null) {
    response.sendRedirect("GDDangNhapNV.jsp");
    return;
  }
  request.setCharacterEncoding("UTF-8");
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
    if (ghiChu != null) d.setGhichu(ghiChu);
    if (thaoTac.equals("DaGiao")) {
      KhachHang kh = new KhachHang();
      kh.setId(khachHangId);
      d.setKhachHang(kh);
      d.setTrangthai("Đã giao");
      d.setGhichu("Giao hàng thành công");
      isSuccess = dao.daGiaoDon(d);
      if (isSuccess) {
        String msg = URLEncoder.encode("Cảm ơn sự phục vụ của bạn!", "UTF-8");
        response.sendRedirect("GDThongBao.jsp?message=" + msg);
      } else {
        out.println("<script>alert('Lỗi cập nhật.'); window.history.back();</script>");
      }
      return;
    }
    if (thaoTac.equals("XacNhan")) {
      d.setTrangthai("Đang giao");
      isSuccess = dao.xacNhanDon(d);
      message = isSuccess ? "Đã nhận đơn." : "Lỗi xác nhận.";
    }
    else if (thaoTac.equals("TraDon")) {
      d.setTrangthai("Chờ xử lí");
      isSuccess = dao.huyNhanDon(d);
      message = isSuccess ? "Đã trả đơn." : "Lỗi trả đơn.";
    }
    else if (thaoTac.equals("Huy")) {
      isSuccess = dao.huyDonHang(d);
      message = isSuccess ? "Đã hủy đơn." : "Lỗi hủy đơn.";
    }
    else if (thaoTac.equals("ThatBai")) {
      isSuccess = dao.giaoThatBai(d);
      message = isSuccess ? "Đã báo cáo giao thất bại." : "Lỗi cập nhật.";
    }
  } else {
    message = "Thiếu thông tin.";
  }

  out.println("<script type='text/javascript'>");
  out.println("alert('" + message + "');");
  out.println("window.location.href = 'GDGiaoHangChoKhach.jsp';");
  out.println("</script>");
%>