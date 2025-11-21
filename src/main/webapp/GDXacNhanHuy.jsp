<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.NhanVien" %>
<%
    String maDon = request.getParameter("maDon");
    String thaoTac = request.getParameter("thaoTac"); // "Huy" hoặc "ThatBai"

    // 3. Thiết lập Tiêu đề và Nhãn hiển thị dựa trên thao tác
    String tieuDe = "";
    String nhanGhiChu = "";

    if ("Huy".equals(thaoTac)) {
        tieuDe = "XÁC NHẬN HỦY ĐƠN HÀNG";
        nhanGhiChu = "Nhập lý do hủy đơn (VD: Khách boom hàng, Sai giá...):";
    } else if ("ThatBai".equals(thaoTac)) {
        tieuDe = "XÁC NHẬN GIAO THẤT BẠI";
        nhanGhiChu = "Nhập lý do giao không được (VD: Gọi ko nghe, Vắng nhà...):";
    } else {
        tieuDe = "XÁC NHẬN THÔNG TIN";
        nhanGhiChu = "Ghi chú:";
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= tieuDe %></title>
    <style>
        /* Style đơn giản khung viền đen */
        * { box-sizing: border-box; font-family: Arial, sans-serif; }
        body { display: flex; justify-content: center; margin-top: 50px; }

        .container {
            width: 500px;
            border: 2px solid black;
            padding: 20px;
        }

        h2 { text-align: center; margin-top: 0; border-bottom: 1px solid #ccc; padding-bottom: 10px; }

        .info-line { margin-bottom: 15px; font-size: 1.1em; text-align: center; }

        .form-group { margin-bottom: 20px; }

        label { display: block; font-weight: bold; margin-bottom: 5px; }

        textarea {
            width: 100%;
            height: 100px;
            padding: 10px;
            border: 1px solid black;
            font-family: sans-serif;
        }

        .btn-group {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }

        button {
            padding: 10px 25px;
            cursor: pointer;
            background: #fff;
            border: 1px solid black;
            font-weight: bold;
        }

        button:hover { background-color: #eee; }
    </style>
</head>
<body>

<div class="container">
    <h2><%= tieuDe %></h2>

    <div class="info-line">
        Mã đơn hàng: <strong>#<%= maDon %></strong>
    </div>

    <form action="doThayDoiTTDon.jsp" method="POST">
        <input type="hidden" name="maDon" value="<%= maDon %>">
        <input type="hidden" name="thaoTac" value="<%= thaoTac %>">

        <div class="form-group">
            <label><%= nhanGhiChu %></label>
            <textarea name="ghiChu" required placeholder="Nhập thông tin chi tiết tại đây..."></textarea>
        </div>

        <div class="btn-group">
            <a href="GDChiTietDonHang.jsp?maDon=<%= maDon %>" style="text-decoration: none;">
                <button type="button">Quay lại</button>
            </a>

            <button type="submit">Xác nhận</button>
        </div>
    </form>

</div>

</body>
</html>