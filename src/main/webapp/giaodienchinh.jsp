<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.SanPham" %>
<%@ page import="model.NguoiDung" %>
<%@ page import="DAO.SanPhamDAO" %>

<%
    // Lấy user từ session
    NguoiDung username = (NguoiDung) session.getAttribute("user");
    boolean loggedIn = (username != null);

    // Lấy danh sách sản phẩm (đã set từ dogiaodienchinh.jsp)
    boolean a = (List<SanPham>) request.getAttribute("products") != null;
    List<SanPham> products = (List<SanPham>) request.getAttribute("products");
%>

<html>
<head>
    <title>Giao diện chính Khách Hàng</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #fafafa; margin: 20px; }
        h2 { text-align: center; }
        .container { border: 1px solid #aaa; background: #fff; padding: 15px; }

        .header {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-bottom: 15px;
        }
        button { padding: 6px 12px; cursor: pointer; }
        .disabled { background: #ddd; color: #777; cursor: not-allowed; }

        .sidebar {
            float: left;
            width: 20%;
            border-right: 1px solid #ccc;
            padding-right: 10px;
        }
        .content { margin-left: 22%; padding: 10px; }

        .search-box { display: flex; margin-bottom: 10px; }
        .search-box input[type=text] {
            flex: 1; padding: 6px; margin-right: 5px;
        }

        .product-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 10px;
        }
        .product {
            border: 1px solid #ccc;
            padding: 8px;
            background: #fefefe;
            text-align: center;
        }
        .product img { width: 100px; height: 100px; object-fit: cover; }
        .clear { clear: both; }
    </style>
</head>

<body>
<h2>Giao diện chính Khách Hàng</h2>

<div class="container">
    <!-- Thanh trên cùng -->
    <div class="header">
        <% if (!loggedIn) { %>
        <a href="login.jsp">
            <button>Đăng nhập</button>
        </a>
        <% } else { %>
        <a href="profile.jsp">
            <button <%= !loggedIn ? "disabled class='disabled'" : "" %>>
                Sản phẩm yêu thích
            </button>
        </a>
        <% } %>

        <a href="yeuthich.jsp">
            <button <%= !loggedIn ? "disabled class='disabled'" : "" %>>
                Sản phẩm yêu thích
            </button>
        </a>

        <a href="dogiohang.jsp">
            <button <%= !loggedIn ? "disabled class='disabled'" : "" %>>
                Giỏ hàng
            </button>
        </a>

    </div>

    <!-- Cột trái: thể loại -->
    <div class="sidebar">
        <h3>Thể loại</h3>
        <form method="get" action="dogiaodienchinh.jsp">
            <button name="category" value="Đồ ăn">Đồ ăn</button><br><br>
            <button name="category" value="Nước uống">Nước uống</button><br><br>
            <button name="category" value="Gia dụng">Gia dụng</button>
        </form>
    </div>

    <!-- Phần chính -->
    <div class="content">
        <form class="search-box" method="get" action="dogiaodienchinh.jsp">
            <input type="text" name="search" placeholder="Tìm kiếm sản phẩm...">
            <button type="submit">Tìm</button>
        </form>

        <h3>Sản phẩm:</h3>
        <div class="product-grid">
            <%
                if (products != null && !products.isEmpty()) {
                    for (SanPham sp : products) {
            %>
            <div class="product">
                <img src="<%= sp.getAnh() != null ? sp.getAnh() : "https://via.placeholder.com/100" %>" alt="Ảnh">
                <h4><%= sp.getTen() %></h4>
                <p>Đơn vị: <%= sp.getDonvi() %></p>
                <p>Giá: <%= sp.getGiaban() %> VNĐ</p>
                <form method="post" action="dogiaodienchinh.jsp">
                    <input type="hidden" name="productId" value="<%= sp.getId() %>">
                    <button <%= !loggedIn ? "disabled class='disabled'" : "" %>>
                        Thêm vào giỏ
                    </button>
                </form>
            </div>
            <%
                }
            } else {
            %>
            <p>Không tìm thấy sản phẩm phù hợp.</p>
            <% } %>
        </div>
    </div>

    <div class="clear"></div>
</div>
</body>
</html>
