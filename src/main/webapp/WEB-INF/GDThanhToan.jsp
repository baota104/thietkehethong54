<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.*, DAO.*" %>
<%
    KhachHang kh = (KhachHang) session.getAttribute("khachhang");
    if (kh == null) {
        response.sendRedirect("GDDangNhap.jsp");
        return;
    }

    // Lấy giỏ hàng từ session hoặc database
    GioHangDAO gioHangDAO = new GioHangDAO();
    List<GioHangChiTiet> gioHang = gioHangDAO.getGioHangByKhachHang(kh.getGhid());

    double tongTien = 0;
    for (GioHangChiTiet item : gioHang) {
        tongTien += item.getSanPham().getGiaban() * item.getSoluong();
    }

    double phiShip = 15000; // Phí ship cố định
    double tongThanhToan = tongTien + phiShip;

    // Tạo đối tượng DonHang và lưu vào session
    DonHang donHang = new DonHang();
    donHang.setId("DH_" + System.currentTimeMillis());
    donHang.setKhachHang(kh);
    donHang.setTongTien(tongTien);
    donHang.setPhiShip(phiShip);
    donHang.setTongThanhToan(tongThanhToan);
    donHang.setNgayDatHang(new java.util.Date());
    donHang.setTrangThai("Chờ thanh toán");

    session.setAttribute("donhang", donHang);

    // Tạo HoaDon và lưu vào session
    HoaDon hoaDon = new HoaDon();
    hoaDon.setDonHang(donHang);
    hoaDon.setTongThanhToan(tongThanhToan);
    hoaDon.setPhuongThucThanhToan("QR");

    session.setAttribute("hoadon", hoaDon);
%>
<html>
<head>
    <title>Thanh Toán</title>
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f3f4f6; margin: 0; padding: 20px; }
        .container { max-width: 800px; margin: 0 auto; background: #fff; padding: 20px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        .section { margin-bottom: 20px; padding: 15px; border: 1px solid #e5e7eb; border-radius: 8px; }
        .product-item { display: flex; justify-content: space-between; padding: 10px 0; border-bottom: 1px solid #f3f4f6; }
        .total { font-size: 1.2em; font-weight: bold; color: #ef4444; text-align: right; }
        button { padding: 12px 24px; background: #059669; color: white; border: none; border-radius: 8px; cursor: pointer; font-size: 1.1em; }
        button:hover { background: #047857; }
    </style>
</head>
<body>
<div class="container">
    <h2>Thanh Toán Đơn Hàng</h2>

    <!-- Thông tin khách hàng -->
    <div class="section">
        <h3>Thông tin khách hàng</h3>
        <p><strong>Họ tên:</strong> <%= kh.getTen() %></p>
        <p><strong>Email:</strong> <%= kh.getEmail() %></p>
        <p><strong>SĐT:</strong> <%= kh.getSdt() %></p>
    </div>

    <!-- Danh sách sản phẩm -->
    <div class="section">
        <h3>Sản phẩm đặt mua</h3>
        <% for (GioHangChiTiet item : gioHang) { %>
        <div class="product-item">
            <span><%= item.getSanPham().getTen() %> x <%= item.getSoluong() %></span>
            <span><%= String.format("%,.0f", item.getSanPham().getGiaban() * item.getSoluong()) %> VNĐ</span>
        </div>
        <% } %>
    </div>

    <!-- Tổng thanh toán -->
    <div class="section">
        <div class="product-item">
            <span>Tổng tiền hàng:</span>
            <span><%= String.format("%,.0f", tongTien) %> VNĐ</span>
        </div>
        <div class="product-item">
            <span>Phí vận chuyển:</span>
            <span><%= String.format("%,.0f", phiShip) %> VNĐ</span>
        </div>
        <div class="total">
            Tổng thanh toán: <%= String.format("%,.0f", tongThanhToan) %> VNĐ
        </div>
    </div>

    <!-- Nút thanh toán -->
    <form method="post" action="GDMaQR.jsp">
        <button type="submit">Thanh Toán với QR Code</button>
    </form>
</div>
</body>
</html>