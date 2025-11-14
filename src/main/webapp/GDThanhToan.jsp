<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.*, DAO.*" %>
<%
    KhachHang kh = (KhachHang) session.getAttribute("khachhang");
    if (kh == null) {
        response.sendRedirect("GDDangNhap.jsp");
        return;
    }

    // Lấy giỏ hàng từ session hoặc database
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
    String sdtGiaoHang = request.getParameter("sdt") != null ? request.getParameter("sdt") : (kh.getSdt() != null ? kh.getSdt() : "");
    String tenGiaoHang = request.getParameter("ten") != null ? request.getParameter("ten") : kh.getTen();
    String emailGiaoHang = request.getParameter("email") != null ? request.getParameter("email") : kh.getEmail();
    String hinhThucNhanHang = request.getParameter("hinhThucNhanHang") != null ? request.getParameter("hinhThucNhanHang") : "Giao tới nhà";
    String diaChiGiaoHang = request.getParameter("diaChi") != null ? request.getParameter("diaChi") : "";
    String hinhThucThanhToan = request.getParameter("hinhThucThanhToan") != null ? request.getParameter("hinhThucThanhToan") : "Chuyển khoản qua ngân hàng";
    String diaChiMoi = request.getParameter("diaChiMoi") != null ? request.getParameter("diaChiMoi") : "";

    // Xử lý thêm địa chỉ mới nếu có
    if (request.getParameter("themDiaChi") != null && !diaChiMoi.isEmpty()) {
        // Gọi DAO để thêm địa chỉ mới
        DiaChiDAO diaChiDAO = new DiaChiDAO();
        Diachi diaChiMoiObj = new Diachi();

        diaChiMoiObj.setIdkh(kh.getId());
        diaChiMoiObj.setId("DC_"+UUID.randomUUID());
        diaChiMoiObj.setDiachichitiet(diaChiMoi);
        boolean themThanhCong = diaChiDAO.themDiaChi(diaChiMoiObj);

        if (themThanhCong) {
            // Cập nhật lại danh sách địa chỉ
            kh.setDiachiList(diaChiDAO.getDiaChi(kh.getGhid()));
            session.setAttribute("khachhang", kh);
            diaChiGiaoHang = diaChiMoi; // Set địa chỉ mới làm địa chỉ giao hàng
        }
    }

    // Nếu chưa có địa chỉ từ parameter, lấy từ danh sách địa chỉ của khách hàng
    if (diaChiGiaoHang.isEmpty() && kh.getDiachiList() != null && !kh.getDiachiList().isEmpty()) {
        diaChiGiaoHang = kh.getDiachiList().get(0).getDiachichitiet();
    }

    // Tạo đối tượng DonHang và lưu vào session
    KhachHang kh1 = new KhachHang();
    kh1.setSdt(sdtGiaoHang);
    kh1.setTen(tenGiaoHang);
    kh1.setEmail(emailGiaoHang);
    DonHang donHang = new DonHang();
    donHang.setId("DH_" + UUID.randomUUID());
    donHang.setKhachHang(kh1);
    donHang.setListdonhang(donHangChiTiets);
    donHang.setTongtien((float) tongTien);
    donHang.setShip((float) phiShip);
    donHang.setTongkhuyenmai(0);
    donHang.setTrangthai("Chờ thanh toán");
    donHang.setNgaydat(new java.sql.Date(new java.util.Date().getTime()));
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
        /* CSS giữ nguyên như trước... */
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
            if (addressSelect.value !== 'new') {
                selectedAddress = addressSelect.options[addressSelect.selectedIndex].text;
                document.getElementById('hiddenAddress').value = selectedAddress;
                showNewAddressForm = false;
                document.getElementById('newAddressSection').style.display = 'none';
            } else {
                // Người dùng chọn "Thêm địa chỉ mới"
                showNewAddressForm = true;
                document.getElementById('newAddressSection').style.display = 'block';
                document.getElementById('hiddenAddress').value = '';
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
                        <div style="padding: 10px; background: #f9fafb; border-radius: 6px; margin-bottom: 10px;">
                            <%= diaChiGiaoHang.isEmpty() ? "Chưa chọn địa chỉ" : diaChiGiaoHang %>
                        </div>
                        <select id="addressSelect" class="address-select" onchange="updateAddress()">
                            <option value="">Chọn địa chỉ</option>
                            <% for (Diachi dc : kh.getDiachiList()) {
                                boolean selected = dc.getDiachichitiet().equals(diaChiGiaoHang);
                            %>
                            <option value="<%= dc.getId() %>" <%= selected ? "selected" : "" %>>
                                <%= dc.getDiachichitiet() %>
                            </option>
                            <% } %>
                            <option value="new">+ Thêm địa chỉ mới</option>
                        </select>
                        <% } else { %>
                        <div class="no-address-message">
                            Bạn chưa có địa chỉ nào. Vui lòng thêm địa chỉ mới.
                        </div>
                        <% } %>

                        <!-- Nút thêm địa chỉ mới (luôn hiển thị) -->
                        <button type="button" class="btn-add-address" onclick="toggleNewAddressForm()">
                            + Thêm Địa Chỉ Mới
                        </button>

                        <!-- Form thêm địa chỉ mới -->
                        <div id="newAddressSection" class="new-address-section" style="display: none;">
                            <label class="info-label">Địa chỉ mới</label>
                            <input type="text" class="info-input" name="diaChiMoi" value="<%= diaChiMoi %>"
                                   placeholder="Nhập địa chỉ mới (số nhà, đường, phường, quận, thành phố)">
                            <div style="margin-top: 10px; font-size: 0.9em; color: #6b7280;">
                                Ví dụ: 123 Nguyễn Văn Linh, Phường Bình Thuận, Quận 7, TP.HCM
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Hình thức thanh toán -->
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

            <!-- Cột phải: Thông tin đơn hàng -->
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