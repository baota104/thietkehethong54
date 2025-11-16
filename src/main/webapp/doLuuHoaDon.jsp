<%@ page import="model.*, DAO.*, java.util.Date" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
    // 1. LẤY CÁC ĐỐI TƯỢNG TỪ SESSION
    // Đây là các đối tượng đã được chuẩn bị sẵn ở GDThanhToan.jsp
    KhachHang kh = (KhachHang) session.getAttribute("khachhang");
    DonHang donHang = (DonHang) session.getAttribute("donhang");
    HoaDon hoaDon = (HoaDon) session.getAttribute("hoadon");
    ThanhToan thanhToan = (ThanhToan) session.getAttribute("thanhtoan");

    if (kh == null || donHang == null || hoaDon == null || thanhToan == null) {
        // Nếu session mất (ví dụ: hết hạn), quay về trang thanh toán
        response.sendRedirect("GDThanhToan.jsp?msg=Phiên làm việc hết hạn, vui lòng thử lại.");
        return;
    }

    thanhToan.setTrangthai("Đã thanh toán");
    thanhToan.setNgaythanhtoan(new java.sql.Date(new java.util.Date().getTime()));

    donHang.setTrangthai("Đã xác nhận"); // Trạng thái mới sau khi thanh toán

    hoaDon.setDonHang(donHang);
    hoaDon.setThanhtoan(thanhToan);

    donHang.setKhachHang(kh);

    hoaDon.setThanhtoan(thanhToan);
    hoaDon.setDonHang(donHang);
    HoaDonDAO hoaDonDAO = new HoaDonDAO();
    boolean success = hoaDonDAO.TaoHoaDon(hoaDon);

    if (success) {
        // Nếu thành công, xóa giỏ hàng và các đối tượng checkout khỏi session
        session.removeAttribute("giohang");
        session.removeAttribute("donhang");
        session.removeAttribute("thanhtoan");

        // Chuyển hướng đến trang thông báo thành công
        response.sendRedirect("GDDatHangThanhCong.jsp?status=success&mahoadon=" + hoaDon.getId());
    } else {
        // Nếu thất bại (ví dụ: hết tồn kho, lỗi CSDL)
        // Chuyển hướng về trang thanh toán với thông báo lỗi
        response.sendRedirect("GDDatHangThatBai.jsp?msg=Lỗi: Không thể xử lý đơn hàng. Vui lòng kiểm tra lại (ví dụ: Tồn kho không đủ).");
    }
%>