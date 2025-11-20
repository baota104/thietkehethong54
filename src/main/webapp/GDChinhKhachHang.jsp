<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.SanPham" %>
<%@ page import="model.NguoiDung" %>
<%@ page import="DAO.SanPhamDAO" %>
<%@ page import="model.KhachHang" %>
<%@ page import="model.TheLoai" %>

<%
    // Lấy user từ session
    KhachHang khachHangSession = (KhachHang) session.getAttribute("khachhang");
    boolean loggedIn = (khachHangSession != null);
    if (loggedIn) {
        System.out.println("DEBUG: Khách hàng đang đăng nhập: " + khachHangSession.getGioHang().getId());
    }
    List<SanPham> products = Collections.emptyList();
    SanPhamDAO sanPhamDAO = new SanPhamDAO();

    // Lấy tham số từ URL
    String action = request.getParameter("action");
    String keyword = request.getParameter("keyword");
    String category = request.getParameter("category");

    try {
        if ("search".equals(action) && keyword != null && !keyword.trim().isEmpty()) {
            // Trường hợp 1: Tìm kiếm theo từ khóa
            products = sanPhamDAO.searchByName(keyword.trim());
            System.out.println("DEBUG: Đã thực hiện tìm kiếm với từ khóa: " + keyword);

        } else if ("filter".equals(action) && category != null) {
            // Trường hợp 2: Lọc theo thể loại
            if ("Tất cả".equals(category)) {
                // Lấy tất cả hoặc Gợi ý nếu chọn 'Tất cả'
                products = sanPhamDAO.getSPGoiY();
            } else {
                products = sanPhamDAO.filterByCategory(category);
            }
            System.out.println("DEBUG: Đã thực hiện lọc theo thể loại: " + category);

        } else {
            // Trường hợp 3: Tải trang lần đầu / Gợi ý mặc định
            products = sanPhamDAO.getSPGoiY();
            System.out.println("DEBUG: Đã tải " + products.size() + " sản phẩm gợi ý.");
        }

    } catch (Exception e) {
        e.printStackTrace();
        products = Collections.emptyList();
        System.out.println("ERROR: Lỗi khi tải/tìm kiếm sản phẩm.");
    }

%>

<html>
<head>
    <title>Giao diện chính Khách Hàng</title>
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f3f4f6; margin: 0; padding: 20px; }
        .container {
            max-width: 1200px; margin: 0 auto; background: #fff; padding: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); border-radius: 12px;
        }

        .header {
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }
        button {
            padding: 10px 18px; cursor: pointer; border: none; border-radius: 8px;
            transition: background-color 0.3s; font-weight: bold;
            background-color: #3b82f6; color: white;
        }
        button:hover { background-color: #2563eb; }
        .disabled {
            background: #d1d5db;
            color: #6b7280;
            cursor: not-allowed;
            pointer-events: none; /* Vô hiệu hóa click */
        }

        .layout {
            display: flex;
            gap: 20px;
        }
        .sidebar {
            width: 250px;
            padding-right: 20px;
            border-right: 1px solid #ccc;
            flex-shrink: 0;
        }
        .sidebar h3 { color: #1f2937; margin-top: 0; }
        .sidebar button {
            width: 100%;
            margin-bottom: 10px;
            background-color: #f9fafb;
            color: #1f2937;
            border: 1px solid #e5e7eb;
        }
        .sidebar button:hover { background-color: #f0f4f7; }

        .content { flex-grow: 1; }

        .search-box { display: flex; margin-bottom: 20px; }
        .search-box input[type=text] {
            flex: 1; padding: 10px; margin-right: 10px; border: 1px solid #ccc; border-radius: 6px;
        }
        .search-box button {
            background-color: #10b981;
        }
        .search-box button:hover {
            background-color: #059669;
        }

        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 20px;
        }
        .product {
            border: 1px solid #e5e7eb;
            padding: 15px;
            background: #ffffff;
            text-align: center;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
        }
        .product img {
            width: 150px; height: 150px; object-fit: cover;
            border-radius: 4px; margin-bottom: 10px;
        }
        .product h4 { margin: 5px 0; color: #1f2937; }
        .product p { margin: 3px 0; color: #4b5563; font-size: 0.9em; }
    </style>
</head>

<body>
<div class="container">
    <h2 style="color: #3b82f6;">Hệ thống bán hàng trực tuyến</h2>

    <!-- Thanh trên cùng -->
    <div class="header">
        <% if (!loggedIn) { %>
            <a href="GDDangNhap.jsp">
                <button style="background-color: #059669;">Đăng Nhập</button>
            </a>
        <% } else { %>
        <span style="align-self: center; font-weight: 500;">Xin chào, <%= khachHangSession.getTen() %></span>

        <a href="profile.jsp">
            <button style="background-color: #059669;">Profile</button>
        </a>

        <a href="yeuthich.jsp">
            <button>Sản phẩm yêu thích</button>
        </a>

        <a href="GDGioHang.jsp">
            <button>Giỏ hàng</button>
        </a>

        <a href="dologout.jsp">
            <button style="background-color: #ef4444;">Đăng xuất</button>
        </a>
        <% } %>
    </div>

    <div class="layout">
        <!-- Cột trái: thể loại (Lọc) - Luôn hoạt động -->
        <div class="sidebar">
            <h3>Lọc theo Thể loại</h3>
            <!-- Hành động SUBMIT trở lại chính GDChinhKhachHang.jsp -->
            <form method="get" action="GDChinhKhachHang.jsp">
                <input type="hidden" name="action" value="filter">
                <button name="category" value="Đồ ăn">Đồ ăn</button>
                <button name="category" value="Nước uống">Nước uống</button>
                <button name="category" value="Gia dụng">Gia dụng</button>
                <button name="category" value="Tất cả">Tất cả sản phẩm</button>
            </form>
        </div>

        <!-- Phần chính: Tìm kiếm và Hiển thị Sản phẩm - Luôn hoạt động -->
        <div class="content">
            <!-- Tìm kiếm: SUBMIT trở lại chính GDChinhKhachHang.jsp -->
            <form class="search-box" method="get" action="GDChinhKhachHang.jsp">
                <input type="hidden" name="action" value="search">
                <input type="text" name="keyword" placeholder="Tìm kiếm sản phẩm theo tên...">
                <button type="submit">Tìm kiếm</button>
            </form>

            <h3>Danh sách Sản phẩm:</h3>
            <div class="product-grid">
                <%
                    if (products != null && !products.isEmpty()) {
                        for (SanPham sp : products) {
                            String disabledClass = !loggedIn ? "disabled" : "";
                %>
                <div class="product">
                    <img src="https://placehold.co/150x150/1e40af/FFFFFF?text=<%= sp.getTen().replace(" ", "+") %>" alt="<%= sp.getTen() %>">
                    <h4><%= sp.getTen() %></h4>
                    <p>Đơn vị: <%= sp.getDonvi() %></p>
                    <p style="color:#ef4444; font-weight:bold;">
                        Giá: <%= String.format("%,.0f", sp.getGiaban()) %> VNĐ
                    </p>
                    <p>Tồn kho: <%= sp.getTonkho() %></p>

                    <form method="post" action="doLuuSPVaoGio.jsp" style="margin-top:10px;">
                        <input type="hidden" name="productId" value="<%= sp.getId() %>">
                        <input type="number" name="soluong" value="1" min="1" max="<%= sp.getTonkho() %>" style="width:60px;">
                        <button type="submit"
                                <%= (!loggedIn || sp.getTonkho() <= 0) ? "disabled" : "" %>
                                title="<%= !loggedIn ? "Vui lòng đăng nhập để thêm sản phẩm" : (sp.getTonkho() <= 0 ? "Sản phẩm đã hết hàng" : "Thêm vào giỏ") %>">
                            Thêm vào giỏ
                        </button>
                    </form>
                </div>

                <%
                    }
                } else {
                %>
                <p>Không tìm thấy sản phẩm phù hợp. Vui lòng thử từ khóa khác hoặc kiểm tra dữ liệu mẫu (đã có 10 sản phẩm mẫu được insert).</p>
                <% } %>
            </div>
        </div>
    </div>
</div>
</body>
</html>