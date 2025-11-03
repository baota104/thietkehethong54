<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.GioHangChiTiet, model.SanPham, model.NguoiDung" %>

<%

    List<GioHangChiTiet> list = (List<GioHangChiTiet>) request.getAttribute("cartItems");
    float tongGiaTri = 0;
    if (list != null) {
        for (GioHangChiTiet item : list) {
            tongGiaTri += item.getGiaban() * item.getSoluong();
        }
    }
%>

<html>
<head>
    <title>Giỏ hàng</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f5f5f5; }
        h2 { text-align: center; }
        .container { display: flex; gap: 20px; }
        .cart-items, .summary { background: #fff; padding: 20px; border: 1px solid #ccc; }
        .cart-items { flex: 3; }
        .summary { flex: 1; height: fit-content; }

        .item { border-bottom: 1px solid #ddd; padding: 10px 0; display: flex; align-items: center; justify-content: space-between; }
        .item img { width: 60px; height: 60px; object-fit: cover; margin-right: 10px; }
        .controls button { padding: 4px 10px; }

        .remove { background-color: #ff6666; color: white; border: none; padding: 5px 10px; cursor: pointer; }
        .checkout { background-color: #4CAF50; color: white; border: none; padding: 10px 20px; cursor: pointer; width: 100%; }
    </style>
</head>

<body>
<h2>Giao diện giỏ hàng</h2>

<div class="container">
    <div class="cart-items">
        <h3>Thông tin đơn hàng:</h3>

        <% if (list != null && !list.isEmpty()) {
            for (GioHangChiTiet item : list) {
                SanPham sp = item.getSanPham();
        %>
        <div class="item">
            <form action="dogiohang.jsp" method="post">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="idChiTiet" value="<%= item.getId() %>">
                <button class="remove">Xóa</button>
            </form>

            <div>
                <img src="<%= sp.getAnh() != null ? sp.getAnh() : "https://via.placeholder.com/60" %>">
                <strong><%= sp.getTen() %></strong><br>
                <span>Giá: <%= sp.getGiaban() %> đ</span><br>
                <span>Đơn vị: <%= sp.getDonvi() %></span>
            </div>

            <form action="dogiohang.jsp" method="post" class="controls">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="idChiTiet" value="<%= item.getId() %>">
                <input type="hidden" name="soluong" value="<%= item.getSoluong() %>">

                <button name="change" value="increase">+</button>
                <span><%= item.getSoluong() %></span>
                <button name="change" value="decrease">-</button>
            </form>

        </div>
        <% } } else { %>
        <p>Giỏ hàng của bạn đang trống.</p>
        <% } %>
    </div>

    <div class="summary">
        <h3>Chi tiết đơn hàng:</h3>
        <p><strong>Tổng giá trị:</strong> <%= tongGiaTri %> đ</p>
        <p><strong>Tổng thanh toán:</strong> <%= tongGiaTri %> đ</p>
        <button class="checkout">Thanh toán</button>
    </div>
</div>
</body>
</html>
