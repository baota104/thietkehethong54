<%@ page import="model.*, DAO.*, java.util.Date" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
  request.setCharacterEncoding("UTF-8");

  // 1. LẤY HÓA ĐƠN TỪ SESSION
  // (Lý do GDDatHangThanhCong.jsp không được xóa session là để file này có thể chạy)
  HoaDon hoaDon = (HoaDon) session.getAttribute("hoadon");

  String redirectURL = "GDChinhKhachHang.jsp";
  String message = "";

  // 2. KIỂM TRA SESSION
  if (hoaDon == null) {
    message = "Lỗi: Không tìm thấy đơn hàng để hủy, hoặc phiên làm việc đã hết hạn.";
    response.sendRedirect(redirectURL + "?msg=" + java.net.URLEncoder.encode(message, "UTF-8"));
    return;
  }

  // 3. GỌI DAO ĐỂ HỦY (Sử dụng Transaction)
  HoaDonDAO hoaDonDAO = new HoaDonDAO();
  // Giả định hàm HuyDonHang() trong DAO đã được code (như file tôi gửi trước)
  boolean success = hoaDonDAO.HuyDonHang(hoaDon);

  // 4. XỬ LÝ KẾT QUẢ VÀ CHUYỂN HƯỚNG
  if (success) {
    message = "Đã hủy đơn hàng " + hoaDon.getDonHang().getId() + " thành công. Tồn kho đã được hoàn trả.";

    // Dọn dẹp TẤT CẢ session liên quan đến đơn hàng
    session.removeAttribute("giohang"); // Đã bị xóa khi thanh toán
    session.removeAttribute("donhang");
    session.removeAttribute("hoadon");
    session.removeAttribute("thanhtoan");

  } else {
    message = "Lỗi: Hủy đơn hàng thất bại. Vui lòng liên hệ quản trị viên.";
  }

  // Chuyển hướng về trang chủ kèm thông báo
  response.sendRedirect(redirectURL + "?msg=" + java.net.URLEncoder.encode(message, "UTF-8"));
%>