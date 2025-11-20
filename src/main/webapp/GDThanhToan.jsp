<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.*, DAO.*" %>
<%@ page import="java.sql.Date" %>
<%
    KhachHang kh = (KhachHang) session.getAttribute("khachhang");
    GioHang gh = (GioHang) session.getAttribute("giohang");

    List<GioHangChiTiet> gioHang = gh.getGioHangChiTiet();
    List<DonHangChiTiet> donHangChiTiets = new ArrayList<>();
    double tongTien = 0;
    for (GioHangChiTiet item : gioHang) {
        donHangChiTiets.add(new DonHangChiTiet("DHCT_" + UUID.randomUUID(),"",item.getGiaban(),0,item.getTongtien(),item.getSoluong(),item.getSanPham()));
        tongTien += item.getSanPham().getGiaban() * item.getSoluong();
    }

    double phiShip = 15000;
    double tongThanhToan = tongTien + phiShip;

    // Lấy các thông tin từ parameter
    String sdtGiaoHang = request.getParameter("sdt") != null ? request.getParameter("sdt") :  kh.getSdt();
    String tenGiaoHang = request.getParameter("ten") != null ? request.getParameter("ten") : kh.getTen();
    String emailGiaoHang = request.getParameter("email") != null ? request.getParameter("email") : kh.getEmail();
    String hinhThucNhanHang = request.getParameter("hinhThucNhanHang") != null ? request.getParameter("hinhThucNhanHang") : "Giao tới nhà";
    String hinhThucThanhToan = request.getParameter("hinhThucThanhToan") != null ? request.getParameter("hinhThucThanhToan") : "Chuyển khoản qua ngân hàng";
    String diaChiMoi = request.getParameter("diaChiMoi") != null ? request.getParameter("diaChiMoi") : "";

    // Lấy ID địa chỉ mới nếu vừa được thêm từ doThemDiaChi.jsp
    String newAddressId = request.getParameter("newAddressId");

    // Lấy địa chỉ đang được chọn (nếu có)
    String diaChiGiaoHang = request.getParameter("diaChi") != null ? request.getParameter("diaChi") : "";

    // Tự động chọn địa chỉ mới
    if (newAddressId != null && !newAddressId.isEmpty()) {
        if (kh.getDiachiList() != null) {
            for (Diachi dc : kh.getDiachiList()) {
                if (dc.getId().equals(newAddressId)) {
                    diaChiGiaoHang = dc.getDiachichitiet();
                    break;
                }
            }
        }
    }
    // Nếu vẫn rỗng, lấy địa chỉ đầu tiên
    else if (diaChiGiaoHang.isEmpty() && kh.getDiachiList() != null && !kh.getDiachiList().isEmpty()) {
        diaChiGiaoHang = kh.getDiachiList().get(0).getDiachichitiet();
    }
    // Cập nhật lại hidden input (quan trọng)
    request.setAttribute("diaChiGiaoHang", diaChiGiaoHang);

    // Tạo đối tượng DonHang và lưu vào session
    KhachHang kh1 = new KhachHang();
    kh1.setId(kh.getId());
    kh1.setSdt(sdtGiaoHang);
    kh1.setTen(tenGiaoHang);
    kh1.setEmail(emailGiaoHang);

    // xử lí thời gian giao dự kiến
    // 1. Lấy ngày giờ đặt hàng (hiện tại)
    java.util.Date currentDate_util = new java.util.Date(); // Đây là java.util.Date
    java.sql.Date currentDate_sql = new java.sql.Date(currentDate_util.getTime()); // Đây là java.sql.Date

    java.util.Calendar c = java.util.Calendar.getInstance();
    c.setTime(currentDate_util);

    // 2. TÍNH THỜI GIAN GIAO HÀNG DỰ KIẾN (Logic mới)
    int currentHour = c.get(java.util.Calendar.HOUR_OF_DAY); // Lấy giờ 24H

    // Kiểm tra giờ cao điểm (16h và 17h, tức là 16:00 đến 17:59)
    if (currentHour >= 16 && currentHour < 18) {
        c.add(java.util.Calendar.HOUR_OF_DAY, 2);
    } else {
        c.add(java.util.Calendar.HOUR_OF_DAY, 1);
    }

    // Lấy thời gian giao hàng dự kiến (vẫn là java.util.Date)
    java.util.Date estimatedDeliveryTime_util = c.getTime();

    // CHUYỂN ĐỔI sang java.sql.Date
    java.sql.Date estimatedDeliveryTime_sql = new java.sql.Date(estimatedDeliveryTime_util.getTime());

    // 3. Tạo đối tượng NhanVien giao hàng (theo yêu cầu)
    NhanVien nvGiaoHang = new NhanVien();
    nvGiaoHang.setId("U008"); // ID Nhân viên giao hàng cứng chỉ dùng trong demo

    DonHang donHang = new DonHang();
    donHang.setId("DH_" + UUID.randomUUID());
    donHang.setKhachHang(kh1);
    donHang.setListdonhang(donHangChiTiets);
    donHang.setTongtien((float) tongTien);
    donHang.setNhanVien(nvGiaoHang);
    donHang.setShip((float) phiShip);
    donHang.setTongkhuyenmai(0);
    donHang.setTrangthai("Chờ thanh toán");
    donHang.setNgaydat(new java.sql.Date(new java.util.Date().getTime()));
    donHang.setThoigiandukiengiao((Date) estimatedDeliveryTime_sql);
    donHang.setDiaChiGiaoHang(diaChiGiaoHang);
    donHang.setGhichu("Hình thức nhận: " + hinhThucNhanHang + ", Hình thức thanh toán: " + hinhThucThanhToan);

    session.setAttribute("donhang", donHang);

    // Tạo ThanhToan và lưu vào session
    ThanhToan thanhToan = new ThanhToan();
    thanhToan.setId("TT_" + UUID.randomUUID());
    thanhToan.setPhuongthuc(hinhThucThanhToan);
    thanhToan.setTrangthai("Chờ thanh toán");
    thanhToan.setTongtien((float) tongThanhToan);
    session.setAttribute("thanhtoan", thanhToan);

    // Tạo HoaDon và lưu vào session
    HoaDon hoaDon = new HoaDon();
    hoaDon.setId("HD_" + UUID.randomUUID());
    hoaDon.setDonHang(donHang);
    hoaDon.setThanhtoan(thanhToan);
    session.setAttribute("hoadon", hoaDon);

%>
<html>
<head>
    <title>Thanh Toán</title>
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f3f4f6;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 900px;
            margin: 0 auto;
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .layout {
            display: flex;
            gap: 40px;
        }
        .left-column {
            flex: 1;
        }
        .right-column {
            flex: 1;
        }
        .section {
            margin-bottom: 25px;
        }
        .info-field {
            margin-bottom: 15px;
        }
        .info-label {
            display: block;
            font-weight: bold;
            color: #374151;
            margin-bottom: 5px;
        }
        .info-input {
            width: 100%;
            padding: 10px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 1em;
            box-sizing: border-box;
        }
        .delivery-options {
            display: flex;
            gap: 10px;
            margin: 10px 0;
        }
        .delivery-option {
            flex: 1;
            padding: 12px;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
            font-weight: bold;
        }
        .delivery-option.selected {
            border-color: #3b82f6;
            background-color: #eff6ff;
            color: #3b82f6;
        }
        .payment-options {
            margin: 15px 0;
        }
        .payment-option {
            padding: 12px;
            border: 1px solid #e5e7eb;
            border-radius: 6px;
            margin-bottom: 8px;
            cursor: pointer;
            transition: all 0.3s;
        }
        .payment-option.selected {
            border-color: #3b82f6;
            background-color: #eff6ff;
            color: #3b82f6;
            font-weight: bold;
        }
        .product-item {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid #f3f4f6;
        }
        .product-name {
            font-weight: 500;
        }
        .product-details {
            font-size: 0.9em;
            color: #6b7280;
            margin-top: 3px;
        }
        .price-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #e5e7eb;
        }
        .final-total {
            font-size: 1.3em;
            font-weight: bold;
            color: #ef4444;
            text-align: right;
            margin-top: 15px;
            padding-top: 15px;
            border-top: 2px solid #e5e7eb;
        }
        .btn-payment {
            width: 100%;
            padding: 15px;
            background: #059669;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 1.2em;
            font-weight: bold;
            margin-top: 20px;
        }
        .btn-payment:hover {
            background: #047857;
        }
        .btn-apply {
            padding: 8px 15px;
            background: #3b82f6;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.9em;
            margin-left: 10px;
        }
        .btn-apply:hover {
            background: #2563eb;
        }
        .btn-add-address {
            padding: 8px 15px;
            background: #10b981;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.9em;
            margin-top: 10px;
        }
        .btn-add-address:hover {
            background: #059669;
        }
        .address-select {
            width: 100%;
            padding: 10px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            margin: 10px 0;
        }
        .voucher-section {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .voucher-input {
            flex: 1;
            padding: 10px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
        }
        .new-address-section {
            margin-top: 10px;
            padding: 15px;
            background: #f9fafb;
            border-radius: 8px;
            border: 1px solid #e5e7eb;
        }
        h3 {
            color: #1f2937;
            border-bottom: 2px solid #e5e7eb;
            padding-bottom: 8px;
            margin-bottom: 15px;
        }
        .discount-row {
            color: #059669;
            font-weight: bold;
        }
        .no-address-message {
            color: #ef4444;
            font-style: italic;
            margin: 10px 0;
        }
    </style>
    <script>
        var selectedDelivery = '<%= hinhThucNhanHang %>';
        var selectedPayment = '<%= hinhThucThanhToan %>';
        var selectedAddress = '<%= diaChiGiaoHang %>';
        var showNewAddressForm = false;

        function selectDeliveryOption(element, value) {
            document.querySelectorAll('.delivery-option').forEach(opt => {
                opt.classList.remove('selected');
            });
            element.classList.add('selected');
            selectedDelivery = value;
            document.getElementById('hiddenDelivery').value = value;
        }

        function selectPaymentOption(element, value) {
            document.querySelectorAll('.payment-option').forEach(opt => {
                opt.classList.remove('selected');
            });
            element.classList.add('selected');
            selectedPayment = value;
            document.getElementById('hiddenPayment').value = value;
        }

        function updateAddress() {
            var addressSelect = document.getElementById('addressSelect');

            if (addressSelect.value === 'new') {
                // Logic Mới: Chuyển hướng sang trang thêm địa chỉ
                window.location.href = 'GDThemDiaChi.jsp';
            } else {
                // Logic Cũ: Cập nhật hidden input
                selectedAddress = addressSelect.options[addressSelect.selectedIndex].text;
                document.getElementById('hiddenAddress').value = selectedAddress;

                // (Tùy chọn) Tự động submit form để cập nhật địa chỉ hiển thị
                // document.getElementById('mainForm').submit();
            }
        }

        function toggleNewAddressForm() {
            showNewAddressForm = !showNewAddressForm;
            document.getElementById('newAddressSection').style.display = showNewAddressForm ? 'block' : 'none';
            if (showNewAddressForm) {
                document.getElementById('addressSelect').value = 'new';
            }
        }

        function applyVoucher() {
            var voucherCode = document.getElementById('voucherCode').value;
            if (voucherCode.trim() === '') {
                alert('Vui lòng nhập mã giảm giá');
                return;
            }

            var xhr = new XMLHttpRequest();
            xhr.open('POST', 'doCheckVoucher.jsp', true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    var response = JSON.parse(xhr.responseText);
                    if (response.success) {
                        document.getElementById('tongThanhToan').textContent =
                            formatCurrency(response.newTotal) + ' VNĐ';
                        document.getElementById('discountRow').style.display = 'flex';
                        document.getElementById('discountAmount').textContent =
                            '-' + formatCurrency(response.discountAmount) + ' VNĐ';
                        alert('Áp dụng mã giảm giá thành công!');
                    } else {
                        alert(response.message);
                    }
                }
            };
            xhr.send('voucherCode=' + encodeURIComponent(voucherCode) +
                '&tongTien=' + <%= tongTien %>);
        }

        function formatCurrency(amount) {
            return new Intl.NumberFormat('vi-VN').format(amount);
        }

        window.onload = function() {
            document.querySelectorAll('.delivery-option').forEach(opt => {
                if (opt.textContent.trim() === selectedDelivery) {
                    opt.classList.add('selected');
                }
            });

            document.querySelectorAll('.payment-option').forEach(opt => {
                if (opt.textContent.trim() === selectedPayment) {
                    opt.classList.add('selected');
                }
            });

            // Hiển thị form thêm địa chỉ nếu không có địa chỉ nào
            <% if ((kh.getDiachiList() == null || kh.getDiachiList().isEmpty()) && diaChiMoi.isEmpty()) { %>
            showNewAddressForm = true;
            document.getElementById('newAddressSection').style.display = 'block';
            <% } %>
        }
    </script>
</head>
<body>
<div class="container">
    <h2 style="color: #3b82f6; text-align: center; margin-bottom: 30px;">Thanh Toán Đơn Hàng</h2>

    <form method="post" action="GDThanhToan.jsp" id="mainForm">
        <input type="hidden" id="hiddenDelivery" name="hinhThucNhanHang" value="<%= hinhThucNhanHang %>">
        <input type="hidden" id="hiddenPayment" name="hinhThucThanhToan" value="<%= hinhThucThanhToan %>">
        <input type="hidden" id="hiddenAddress" name="diaChi" value="<%= diaChiGiaoHang %>">
        <input type="hidden" name="themDiaChi" value="true">

        <div class="layout">
            <div class="left-column">
                <!-- Thông tin khách hàng -->
                <div class="section">
                    <h3>Thông tin khách hàng</h3>
                    <div class="info-field">
                        <label class="info-label">Số điện thoại</label>
                        <input type="text" class="info-input" name="sdt" value="<%= sdtGiaoHang %>" placeholder="Nhập số điện thoại">
                    </div>
                    <div class="info-field">
                        <label class="info-label">Tên khách hàng</label>
                        <input type="text" class="info-input" name="ten" value="<%= tenGiaoHang %>" placeholder="Nhập họ tên">
                    </div>
                    <div class="info-field">
                        <label class="info-label">Email</label>
                        <input type="email" class="info-input" name="email" value="<%= emailGiaoHang %>" placeholder="Nhập email">
                    </div>
                </div>

                <!-- Hình thức nhận hàng -->
                <div class="section">
                    <h3>Hình thức nhận hàng</h3>
                    <div class="delivery-options">
                        <div class="delivery-option <%= "Giao tới nhà".equals(hinhThucNhanHang) ? "selected" : "" %>"
                             onclick="selectDeliveryOption(this, 'Giao tới nhà')">
                            Giao tới nhà
                        </div>
                        <div class="delivery-option <%= "Lấy tại siêu thị".equals(hinhThucNhanHang) ? "selected" : "" %>"
                             onclick="selectDeliveryOption(this, 'Lấy tại siêu thị')">
                            Lấy tại siêu thị
                        </div>
                    </div>

                    <div class="info-field">
                        <label class="info-label">Địa chỉ giao hàng</label>

                        <% if (kh.getDiachiList() != null && !kh.getDiachiList().isEmpty()) { %>

                        <!-- Hiển thị địa chỉ đang được chọn -->
                        <div style="padding: 10px; background: #f9fafb; border-radius: 6px; margin-bottom: 10px;">
                            <%= diaChiGiaoHang.isEmpty() ? "Chưa chọn địa chỉ" : diaChiGiaoHang %>
                        </div>

                        <!-- Dropdown chọn địa chỉ -->
                        <select id="addressSelect" class="address-select" onchange="updateAddress()">
                            <option value="">Chọn địa chỉ</option>
                            <%
                                String selectedId = "";

                                // Tìm ID của địa chỉ đang được chọn (ưu tiên newAddressId)
                                if (newAddressId != null) {
                                    selectedId = newAddressId;
                                } else if (!diaChiGiaoHang.isEmpty()) {
                                    for (Diachi dc_check : kh.getDiachiList()) {
                                        if (dc_check.getDiachichitiet().equals(diaChiGiaoHang)) {
                                            selectedId = dc_check.getId();
                                            break;
                                        }
                                    }
                                }

                                // Hiển thị danh sách địa chỉ
                                for (Diachi dc : kh.getDiachiList()) {
                                    boolean selected = dc.getId().equals(selectedId);
                            %>
                            <option value="<%= dc.getId() %>" <%= selected ? "selected" : "" %>>
                                <%= dc.getDiachichitiet() %>
                            </option>
                            <% } %>

                            <!-- Tùy chọn để chuyển hướng sang trang thêm mới -->
                            <option value="new">+ Thêm địa chỉ mới</option>
                        </select>

                        <% } else { %>
                        <!-- Thông báo nếu chưa có địa chỉ nào -->
                        <div class="no-address-message">
                            Bạn chưa có địa chỉ nào.
                        </div>
                        <% } %>
                        <a href="GDThemDiaChi.jsp" class="btn-add-address" style="text-decoration: none; display: inline-block; margin-top: 10px;">
                            + Thêm Địa Chỉ Mới
                        </a>

                    </div>
                </div>

                <div class="section">
                    <h3>Hình thức thanh toán</h3>
                    <div class="payment-options">
                        <div class="payment-option <%= "Tiền mặt".equals(hinhThucThanhToan) ? "selected" : "" %>"
                             onclick="selectPaymentOption(this, 'Tiền mặt')">
                            Tiền mặt
                        </div>
                        <div class="payment-option <%= "Chuyển khoản qua ngân hàng".equals(hinhThucThanhToan) ? "selected" : "" %>"
                             onclick="selectPaymentOption(this, 'Chuyển khoản qua ngân hàng')">
                            Chuyển khoản qua ngân hàng
                        </div>
                        <div class="payment-option <%= "Thanh toán qua Momo/ZaloPay".equals(hinhThucThanhToan) ? "selected" : "" %>"
                             onclick="selectPaymentOption(this, 'Thanh toán qua Momo/ZaloPay')">
                            Thanh toán qua Momo/ZaloPay
                        </div>
                    </div>
                </div>

                <button type="submit" style="width: 100%; padding: 12px; background: #3b82f6; color: white; border: none; border-radius: 8px; cursor: pointer;">
                    Cập nhật thông tin
                </button>
            </div>

            <div class="right-column">
                <div class="section">
                    <h3>Thông tin đơn hàng</h3>

                    <% for (GioHangChiTiet item : gioHang) { %>
                    <div class="product-item">
                        <div>
                            <div class="product-name"><%= item.getSanPham().getTen() %> : <%= String.format("%,.0f", item.getSanPham().getGiaban()) %> VNĐ</div>
                            <div class="product-details">
                                [ <%= item.getSanPham().getDonvi() %> ] [<%= item.getSoluong() %>]
                            </div>
                        </div>
                    </div>
                    <% } %>

                    <div class="price-row">
                        <div>Tổng giá trị:</div>
                        <div><%= String.format("%,.0f", tongTien) %> VNĐ</div>
                    </div>

                    <div class="price-row">
                        <div>Mã giảm giá:</div>
                        <div class="voucher-section">
                            <input type="text" id="voucherCode" class="voucher-input" placeholder="Nhập mã giảm giá">
                            <button type="button" class="btn-apply" onclick="applyVoucher()">Áp dụng</button>
                        </div>
                    </div>

                    <div class="price-row discount-row" id="discountRow" style="display: none;">
                        <div>Giảm giá:</div>
                        <div id="discountAmount">-0 VNĐ</div>
                    </div>

                    <div class="price-row">
                        <div>Vận chuyển:</div>
                        <div><%= String.format("%,.0f", phiShip) %> VNĐ</div>
                    </div>

                    <div class="final-total">
                        Tổng thanh toán: <span id="tongThanhToan"><%= String.format("%,.0f", tongThanhToan) %></span> VNĐ
                    </div>

                    <button type="button" class="btn-payment" onclick="proceedToPayment()">Thanh Toán</button>
                </div>
            </div>
        </div>
    </form>
</div>

<script>
    function proceedToPayment() {
        // Kiểm tra địa chỉ giao hàng
        if (!selectedAddress || selectedAddress.trim() === '') {
            alert('Vui lòng chọn hoặc thêm địa chỉ giao hàng');
            return;
        }
        document.getElementById('mainForm').action = 'GDMaQR.jsp';
        document.getElementById('mainForm').submit();
    }
</script>
</body>
</html>