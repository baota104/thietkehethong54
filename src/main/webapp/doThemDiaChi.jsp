<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.*, DAO.*" %>
<%
  request.setCharacterEncoding("UTF-8");

  // 1. Kiểm tra Session
  KhachHang kh = (KhachHang) session.getAttribute("khachhang");
  if (kh == null) {
    response.sendRedirect("GDDangNhap.jsp");
    return;
  }

  // 2. Lấy dữ liệu từ form
  String diaChiMoi = request.getParameter("diaChiMoi");
  String newAddressId = null;

  if (diaChiMoi != null && !diaChiMoi.trim().isEmpty()) {

    DiaChiDAO diaChiDAO = new DiaChiDAO();
    Diachi diaChiMoiObj = new Diachi();

    // 3. Đóng gói đối tượng Diachi
    newAddressId = "DC_" + UUID.randomUUID().toString(); // Tạo ID mới
    diaChiMoiObj.setId(newAddressId);
    diaChiMoiObj.setIdkh(kh.getId()); // Dùng kh.getId() (là NguoiDungid)
    diaChiMoiObj.setDiachichitiet(diaChiMoi);

    // 4. Gọi DAO để lưu vào CSDL
    boolean themThanhCong = diaChiDAO.themDiaChi(diaChiMoiObj);

    if (themThanhCong) {
      // 5. Cập nhật lại danh sách địa chỉ trong session
      // Lấy danh sách địa chỉ MỚI NHẤT từ CSDL
      List<Diachi> danhSachDiaChiMoi = diaChiDAO.getDiaChi(kh.getId());

      // Cập nhật đối tượng KhachHang trong session
      kh.setDiachiList(danhSachDiaChiMoi);
      session.setAttribute("khachhang", kh);
    }
  }

  // 6. Chuyển hướng quay lại trang Thanh Toán
  // Truyền ID của địa chỉ mới về để tự động chọn
  String redirectUrl = "GDThanhToan.jsp";
  if (newAddressId != null) {
    redirectUrl += "?newAddressId=" + newAddressId;
  }
  response.sendRedirect(redirectUrl);
%>