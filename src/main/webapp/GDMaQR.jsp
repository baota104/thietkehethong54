<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.*, DAO.*" %>
<%
    // 1. KIỂM TRA SESSION (Chỉ để hiển thị)
    KhachHang kh = (KhachHang) session.getAttribute("khachhang");
    DonHang donHang = (DonHang) session.getAttribute("donhang");
    HoaDon hoaDon = (HoaDon) session.getAttribute("hoadon");
    ThanhToan thanhToan = (ThanhToan) session.getAttribute("thanhtoan");

    if (kh == null || donHang == null || hoaDon == null || thanhToan == null) {
        response.sendRedirect("GDThanhToan.jsp?msg=Phiên làm việc hết hạn.");
        return;
    }

    // 2. XÓA BỎ LOGIC XỬ LÝ POST
    // (Toàn bộ khối "if ('true'.equals(request.getParameter...))" đã được xóa
    // và chuyển sang doLuuHoaDon.jsp)
%>
<html>
<head>
    <title>Thanh Toán QR Code</title>
    <!-- (Toàn bộ CSS giữ nguyên) -->
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            margin: 0;
            padding: 20px;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .container {
            max-width: 500px;
            width: 100%;
            background: #fff;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            text-align: center;
        }
        .header {
            margin-bottom: 30px;
        }
        .header h1 {
            color: #1f2937;
            margin: 0 0 10px 0;
            font-size: 1.8em;
        }
        .header p {
            color: #6b7280;
            margin: 0;
            font-size: 1.1em;
        }
        .qr-section {
            background: #f8fafc;
            padding: 30px;
            border-radius: 15px;
            margin: 25px 0;
            border: 2px dashed #e5e7eb;
        }
        .qr-code {
            width: 200px;
            height: 200px;
            margin: 0 auto 20px;
            background: #fff;
            border-radius: 12px;
            padding: 15px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.8em;
            color: #6b7280;
            border: 1px solid #e5e7eb;
        }
        .amount {
            font-size: 2em;
            font-weight: bold;
            color: #ef4444;
            margin: 15px 0;
        }
        .order-info {
            background: #f0f9ff;
            padding: 20px;
            border-radius: 12px;
            margin: 20px 0;
            text-align: left;
            border-left: 4px solid #3b82f6;
        }
        .info-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 8px;
            padding: 5px 0;
        }
        .info-label {
            color: #374151;
            font-weight: 500;
        }
        .info-value {
            color: #1f2937;
            font-weight: 600;
        }
        .timer {
            font-size: 1.1em;
            color: #ef4444;
            font-weight: bold;
            margin: 15px 0;
            padding: 10px;
            background: #fef2f2;
            border-radius: 8px;
            border: 1px solid #fecaca;
        }
        .btn-group {
            display: flex;
            gap: 15px;
            margin-top: 25px;
        }
        .btn {
            flex: 1;
            padding: 15px;
            border: none;
            border-radius: 10px;
            font-size: 1.1em;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .btn-success {
            background: #059669;
            color: white;
        }
        .btn-success:hover {
            background: #047857;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(5, 150, 105, 0.3);
        }
        .btn-cancel {
            background: #6b7280;
            color: white;
        }
        .btn-cancel:hover {
            background: #4b5563;
            transform: translateY(-2px);
        }
        .instructions {
            background: #fffbeb;
            padding: 15px;
            border-radius: 10px;
            margin: 20px 0;
            text-align: left;
            border-left: 4px solid #f59e0b;
        }
        .instructions h4 {
            color: #d97706;
            margin: 0 0 10px 0;
            font-size: 1em;
        }
        .instructions ol {
            margin: 0;
            padding-left: 20px;
            color: #92400e;
        }
        .instructions li {
            margin-bottom: 5px;
            font-size: 0.9em;
        }
        .bank-info {
            background: #f0fdf4;
            padding: 15px;
            border-radius: 10px;
            margin: 15px 0;
            text-align: left;
            border-left: 4px solid #10b981;
        }
        .bank-info h4 {
            color: #059669;
            margin: 0 0 8px 0;
            font-size: 1em;
        }
        .bank-details {
            font-size: 0.9em;
            color: #065f46;
        }
        .loading {
            display: none;
            margin: 20px 0;
        }
        .spinner {
            border: 4px solid #f3f3f3;
            border-top: 4px solid #3b82f6;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            animation: spin 2s linear infinite;
            margin: 0 auto;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1> Thanh Toán QR Code</h1>
        <p>Quét mã QR để hoàn tất thanh toán</p>
    </div>

    <!-- Thông tin đơn hàng (Hiển thị) -->
    <div class="order-info">
        <div class="info-row">
            <span class="info-label">Mã đơn hàng:</span>
            <span class="info-value"><%= donHang.getId() %></span>
        </div>
        <div class="info-row">
            <span class="info-label">Khách hàng:</span>
            <span class="info-value"><%= kh.getTen() %></span>
        </div>
        <div class="info-row">
            <span class="info-label">Số điện thoại:</span>
            <span class="info-value"><%= kh.getSdt() %></span>
        </div>
        <div class="info-row">
            <span class="info-label">Địa chỉ giao hàng:</span>
            <span class="info-value" style="text-align: right; max-width: 200px;"><%= donHang.getDiaChiGiaoHang() %></span>
        </div>
    </div>

    <!-- Số tiền thanh toán (Hiển thị) -->
    <div class="amount">
        <%= String.format("%,.0f", thanhToan.getTongtien()) %> VNĐ
    </div>

    <!-- Mã QR Code (Hiển thị) -->
    <div class="qr-section">
        <div class="qr-code">
            <div style="text-align: center;">
                <div style="font-size: 14px; color: #374151; margin-bottom: 10px;">QUÉT MÃ QR</div>
                <div style="font-size: 11px; color: #6b7280; line-height: 1.4;">
                    Ngân hàng: Vietcombank<br>
                    Số tiền: <%= String.format("%,.0f", thanhToan.getTongtien()) %> VNĐ<br>
                    Nội dung: <%= donHang.getId() %>
                </div>
            </div>
        </div>
        <div style="color: #6b7280; font-size: 0.9em;">
            Mã QR sẽ hết hạn sau: <span id="countdown">05:00</span>
        </div>
    </div>

    <!-- Hướng dẫn thanh toán (Hiển thị) -->
    <div class="instructions">
        <h4>📱 Hướng dẫn thanh toán:</h4>
        <ol>
            <li>Mở ứng dụng ngân hàng trên điện thoại</li>
            <li>Chọn tính năng "Quét mã QR"</li>
            <li>Quét mã QR ở trên</li>
            <li>Kiểm tra thông tin và xác nhận thanh toán</li>
            <li>Chờ hệ thống xác nhận giao dịch</li>
        </ol>
    </div>

    <!-- Thông tin ngân hàng (Hiển thị) -->
    <div class="bank-info">
        <h4> Thông tin chuyển khoản thủ công:</h4>
        <div class="bank-details">
            <strong>Ngân hàng:</strong> Vietcombank<br>
            <strong>Số tài khoản:</strong> 123456789012<br>
            <strong>Chủ tài khoản:</strong> CÔNG TY TNHH SIÊU THỊ ABC<br>
            <strong>Số tiền:</strong> <%= String.format("%,.0f", thanhToan.getTongtien()) %> VNĐ<br>
            <strong>Nội dung:</strong> <%= donHang.getId() %> - <%= kh.getSdt() %>
        </div>
    </div>

    <!-- Loading indicator (Hiển thị) -->
    <div class="loading" id="loading">
        <div class="spinner"></div>
        <p style="color: #6b7280; margin-top: 10px;">Đang xử lý thanh toán...</p>
    </div>

    <!-- Nút hành động (ĐÃ SỬA LẠI LOGIC) -->
    <div class="btn-group">
        <!--
          SỬA LỖI LOGIC:
          1. action trỏ đến "doLuuHoaDon.jsp" (Controller xử lý).
          2. Xóa bỏ input "thanhToanThanhCong" (vì không cần nữa).
        -->
        <form method="post" action="doLuuHoaDon.jsp" style="flex: 1;" onsubmit="showLoading()">
            <button type="submit" class="btn btn-success"> Đã Thanh Toán</button>
        </form>
        <a href="GDThanhToan.jsp" class="btn btn-cancel" style="text-decoration: none; display: block;">
            Hủy Thanh Toán
        </a>
    </div>
</div>

<!-- (Toàn bộ JavaScript giữ nguyên) -->
<script>
    // Đếm ngược thời gian
    let timeLeft = 5 * 60; // 5 phút
    const countdownElement = document.getElementById('countdown');

    function updateCountdown() {
        const minutes = Math.floor(timeLeft / 60);
        const seconds = timeLeft % 60;
        countdownElement.textContent = `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;

        if (timeLeft > 0) {
            timeLeft--;
            setTimeout(updateCountdown, 1000);
        } else {
            countdownElement.textContent = "00:00";
            countdownElement.style.color = "#ef4444";
            alert('Mã QR đã hết hạn. Vui lòng quay lại trang thanh toán.');
            window.location.href = 'GDThanhToan.jsp';
        }
    }

    // Bắt đầu đếm ngược
    updateCountdown();

    // Hiển thị loading khi submit
    function showLoading() {
        document.getElementById('loading').style.display = 'block';
        document.querySelector('.btn-success').disabled = true;
        document.querySelector('.btn-cancel').style.opacity = '0.5';
        document.querySelector('.btn-cancel').style.pointerEvents = 'none';
    }

    // Tự động giả lập thanh toán sau 10 giây (cho demo)
    setTimeout(() => {
        if (timeLeft > 0) {
            const confirmPayment = confirm('Bạn có muốn giả lập thanh toán tự động? (Tính năng demo)');
            if (confirmPayment) {
                showLoading();
                setTimeout(() => {
                    // Sửa lại để submit đúng form
                    document.querySelector('form[action="doLuuHoaDon.jsp"]').submit();
                }, 2000);
            }
        }
    }, 10000);
</script>
</body>
</html>