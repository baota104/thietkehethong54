<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // 1. KIỂM TRA TÍNH HỢP LỆ CỦA TRANG
    String status = request.getParameter("status");
    HoaDon hoaDon = (HoaDon) session.getAttribute("hoadon");

    if (!"success".equals(status) || hoaDon == null) {
        response.sendRedirect("GDChinhKhachHang.jsp");
        return;
    }

    DonHang donHang = hoaDon.getDonHang();
    ThanhToan thanhToan = hoaDon.getThanhtoan();
    List<DonHangChiTiet> chiTietList = donHang.getListdonhang();
%>
<html>
<head>
    <title>Đặt hàng Thành công</title>
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f3f4f6;
            margin: 0;
            padding: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
        }
        .container {
            max-width: 700px;
            margin: 0 auto;
            background: #fff;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            text-align: center;
        }
        .success-icon {
            color: #059669;
            font-size: 60px;
            font-weight: bold;
            line-height: 1;
        }
        h1 {
            color: #1f2937;
            margin: 15px 0 10px 0;
        }
        .message {
            color: #4b5563;
            font-size: 1.1em;
            margin-bottom: 25px;
        }
        .order-details {
            text-align: left;
            border-top: 2px dashed #e5e7eb;
            border-bottom: 2px dashed #e5e7eb;
            padding: 20px 0;
            margin-bottom: 25px;
        }
        h3 {
            color: #1f2937;
            border-bottom: 1px solid #e5e7eb;
            padding-bottom: 8px;
            margin: 0 0 15px 0;
            font-size: 1.2em;
        }
        .detail-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            font-size: 0.95em;
        }
        .detail-label {
            color: #6b7280;
        }
        .detail-value {
            color: #1f2937;
            font-weight: 500;
        }
        .product-item {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #f3f4f6;
        }
        .product-name {
            font-weight: 500;
        }
        .product-details {
            font-size: 0.9em;
            color: #6b7280;
        }

        /* CSS CHO NHÓM NÚT */
        .btn-group {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 20px;
        }
        .btn {
            padding: 15px 30px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 1.1em;
            font-weight: bold;
            text-decoration: none;
            transition: background-color 0.3s;
        }
        .btn-home {
            background: #3b82f6;
            color: white;
        }
        .btn-home:hover {
            background: #2563eb;
        }
        .btn-cancel {
            background: #ef4444; /* Màu đỏ */
            color: white;
        }
        .btn-cancel:hover {
            background: #dc2626;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="success-icon">✓</div>
    <h1>Đặt Hàng Thành Công!</h1>
    <p class="message">
        Cảm ơn bạn đã mua sắm! Đơn hàng của bạn đã được xác nhận.
    </p>

    <div class="order-details">
        <!-- Thông tin thanh toán -->
        <h3>Chi tiết Thanh toán</h3>
        <div class="detail-row">
            <span class="detail-label">Mã hóa đơn:</span>
            <span class="detail-value"><%= hoaDon.getId() %></span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Mã đơn hàng:</span>
            <span class="detail-value"><%= donHang.getId() %></span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Tổng tiền thanh toán:</span>
            <span class="detail-value" style="color: #ef4444; font-weight: bold;">
                <%= String.format("%,.0f", thanhToan.getTongtien()) %> VNĐ
            </span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Phương thức:</span>
            <span class="detail-value"><%= thanhToan.getPhuongthuc() %></span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Ngày thanh toán:</span>
            <span class="detail-value"><%= thanhToan.getNgaythanhtoan().toString() %></span>
        </div>

        <!-- Thông tin sản phẩm -->
        <h3 style="margin-top: 20px;">Sản phẩm đã đặt</h3>
        <%
            for (DonHangChiTiet item : chiTietList) {
                SanPham sp = item.getSanpham();
        %>
        <div class="product-item">
            <div>
                <div class="product-name"><%= sp.getTen() %></div>
                <div class="product-details">
                    Số lượng: <%= item.getSoluong() %> x <%= String.format("%,.0f", item.getDongia()) %> VNĐ
                </div>
            </div>
            <div class="product-name">
                <%= String.format("%,.0f", (item.getSoluong() * item.getDongia())) %> VNĐ
            </div>
        </div>
        <% } %>

        <!-- Thông tin giao hàng -->
        <h3 style="margin-top: 20px;">Thông tin Giao hàng</h3>
        <div class="detail-row">
            <span class="detail-label">Khách hàng:</span>
            <span class="detail-value"><%= donHang.getKhachHang().getTen() %></span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Địa chỉ giao hàng:</span>
            <span class="detail-value" style="text-align: right; max-width: 300px;">
                <%= donHang.getDiaChiGiaoHang() %>
            </span>
        </div>
        <%
            SimpleDateFormat sdf = new SimpleDateFormat("HH:mm 'ngày' dd/MM/yyyy");
            String thoiGianGiaoDuKien = sdf.format(donHang.getThoigiandukiengiao());
        %>
        <div class="detail-row">
            <span class="detail-label">Thời gian giao dự kiến:</span>
            <span class="detail-value" style="color: #059669; font-weight: bold;">
                <%= thoiGianGiaoDuKien %>
            </span>
        </div>
    </div>

    <!-- KHỐI NÚT ĐÃ SỬA THEO YÊU CẦU CỦA BẠN -->
    <div class="btn-group">
        <!-- Nút Quay về (Trỏ trực tiếp, không cần 'do' file) -->
        <a href="GDChinhKhachHang.jsp" class="btn btn-home">Quay về Trang chủ</a>

        <!-- Nút Hủy Đơn Hàng (Gọi doHuyDon.jsp) -->
        <form method="post" action="doHuyDon.jsp" onsubmit="return confirm('Bạn có chắc chắn muốn hủy đơn hàng này? Tồn kho sẽ được hoàn trả.');">
            <button type="submit" class="btn btn-cancel">Hủy Đơn Hàng</button>
        </form>
    </div>
</div>

</body>
</html>