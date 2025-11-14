<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, DAO.GioHangDAO, model.SanPham, model.GioHangChiTiet, model.KhachHang" %>

<%
    request.setCharacterEncoding("UTF-8");

    KhachHang kh = (KhachHang) session.getAttribute("khachhang");
    if (kh == null) {
        out.println("<script>alert('Vui lòng đăng nhập để thêm sản phẩm!'); location.href='GDDangNhap.jsp';</script>");
        return;
    }

    String idSP = request.getParameter("productId");
    String slStr = request.getParameter("soluong");

    if (idSP == null || slStr == null || slStr.isEmpty()) {
        out.println("<script>alert('Thiếu thông tin sản phẩm hoặc số lượng!'); history.back();</script>");
        return;
    }

    int soLuong = 1;
    try {
        soLuong = Integer.parseInt(slStr);
    } catch (NumberFormatException e) {
        soLuong = 1;
    }

    SanPham sp = new SanPham();
    sp.setId(idSP);

    GioHangChiTiet ghct = new GioHangChiTiet();
    ghct.setSanPham(sp);
    ghct.setSoluong(soLuong);

    GioHangDAO dao = new GioHangDAO();
    boolean ok = dao.ThemSPvaoGio(ghct, kh.getGhid());

    if (ok) {
        out.println("<script>alert('Thêm sản phẩm thành công!'); location.href='GDGioHang.jsp';</script>");
    } else {
        out.println("<script>alert('Thêm sản phẩm thất bại!'); history.back();</script>");
    }
%>
