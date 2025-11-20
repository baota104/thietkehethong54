<%@ page import="model.*, DAO.*, java.util.Date" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
    KhachHang kh = (KhachHang) session.getAttribute("khachhang");
    DonHang donHang = (DonHang) session.getAttribute("donhang");
    HoaDon hoaDon = (HoaDon) session.getAttribute("hoadon");
    ThanhToan thanhToan = (ThanhToan) session.getAttribute("thanhtoan");
    if (kh == null || donHang == null || hoaDon == null || thanhToan == null) {
        response.sendRedirect("GDThanhToan.jsp?msg=Phiên làm việc hết hạn, vui lòng thử lại.");
        return;
    }

    thanhToan.setTrangthai("Đã thanh toán");
    thanhToan.setNgaythanhtoan(new java.sql.Date(new java.util.Date().getTime()));

    donHang.setTrangthai("Đã xác nhận");

    hoaDon.setDonHang(donHang);
    hoaDon.setThanhtoan(thanhToan);

    hoaDon.setThanhtoan(thanhToan);
    hoaDon.setDonHang(donHang);

    HoaDonDAO hoaDonDAO = new HoaDonDAO();
    boolean success = hoaDonDAO.TaoHoaDon(hoaDon);

    if (success) {
//        // Nếu thành công, xóa giỏ hàng và các đối tượng checkout khỏi session
//        session.removeAttribute("giohang");
//        session.removeAttribute("donhang");
//        session.removeAttribute("thanhtoan");
        response.sendRedirect("GDDatHangThanhCong.jsp?status=success&mahoadon=" + hoaDon.getId());
    } else {

        response.sendRedirect("GDDatHangThatBai.jsp?msg=Lỗi: Không thể xử lý đơn hàng. Vui lòng kiểm tra lại (ví dụ: Tồn kho không đủ).");
    }
%>