<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="DAO.DonHangDAO" %>
<%@ page import="model.DonHang" %>
<%@ page import="model.NhanVien" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%
    // 1. Kiểm tra session đăng nhập
    NhanVien nvSession = (NhanVien)session.getAttribute("nhanvien");
    if (nvSession == null) {
        response.sendRedirect("GDDangNhapNV.jsp");
        return;
    }

    // 2. Lấy danh sách đơn hàng từ DAO
    DonHangDAO donHangDAO = new DonHangDAO();
    List<DonHang> listDonHang = donHangDAO.getDonHangByNV(nvSession.getId());

    // 3. Lưu List vào Session
    session.setAttribute("listDonHangChuaGiao", listDonHang);

    // 4. Phân loại đơn hàng
    List<DonHang> donMoiCanXacNhan = new ArrayList<>();
    List<DonHang> donDangGiao = new ArrayList<>();

    if (listDonHang != null) {
        for (DonHang dh : listDonHang) {
            String trangThai = dh.getTrangthai();
            if (trangThai.equals("Chờ xử lí") || trangThai.equals("Đã xác nhận")) {
                donMoiCanXacNhan.add(dh);
            } else if (trangThai.equals("Đang giao")) {
                donDangGiao.add(dh);
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Giao Diện Giao Hàng</title>
    <style>
        /* Reset cơ bản */
        * { box-sizing: border-box; font-family: Arial, sans-serif; }

        body {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }

        /* Khung chính bao quanh */
        .main-container {
            width: 600px;
            border: 2px solid black;
            padding: 20px;
        }

        h2 { text-align: center; margin-top: 0; margin-bottom: 20px; }

        /* Style cho Label tiêu đề */
        .section-title {
            font-weight: bold;
            margin-bottom: 10px;
            margin-top: 20px;
            display: block; /* Quan trọng: Để label xuống dòng và nhận margin */
        }

        /* Style cho Table */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 10px;
        }

        th, td {
            border: 1px solid black;
            padding: 10px;
            text-align: left;
            font-size: 14px;
        }

        th {
            background-color: #f0f0f0;
        }

        /* Style nút bấm */
        button {
            cursor: pointer;
            padding: 5px 15px;
            background: #fff;
            border: 1px solid black;
            border-radius: 3px;
            font-size: 13px;
        }
        button:hover { background-color: #eee; }

        .empty-text { font-style: italic; color: #666; margin-bottom: 10px; }

        .center-text { text-align: center; }
    </style>
</head>
<body>

<div class="main-container">
    <h2>Giao diện giao hàng</h2>

    <label class="section-title">Đơn chưa giao:</label>

    <% if (donMoiCanXacNhan.isEmpty()) { %>
    <div class="empty-text">(Không có đơn hàng nào)</div>
    <% } else { %>
    <table>
        <thead>
        <tr>
            <th style="width: 40%;">Đơn hàng</th>
            <th style="width: 40%;">Trạng thái</th>
            <th style="width: 20%; text-align: center;">Thao tác</th>
        </tr>
        </thead>
        <tbody>
        <% for (DonHang dh : donMoiCanXacNhan) { %>
        <tr>
            <td><strong>#<%= dh.getId() %></strong></td>
            <td><%= dh.getTrangthai() %></td>
            <td class="center-text">
                <a href="GDChiTietDonHang.jsp?maDon=<%= dh.getId() %>">
                    <button>xem</button>
                </a>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>
    <% } %>

    <label class="section-title">Đơn đang giao:</label>

    <% if (donDangGiao.isEmpty()) { %>
    <div class="empty-text">(Không có đơn hàng nào)</div>
    <% } else { %>
    <table>
        <thead>
        <tr>
            <th style="width: 40%;">Đơn hàng</th>
            <th style="width: 40%;">Trạng thái</th>
            <th style="width: 20%; text-align: center;">Thao tác</th>
        </tr>
        </thead>
        <tbody>
        <% for (DonHang dh : donDangGiao) { %>
        <tr>
            <td><strong>#<%= dh.getId() %></strong></td>
            <td><%= dh.getTrangthai() %></td>
            <td class="center-text">
                <a href="GDChiTietDonHang.jsp?maDon=<%= dh.getId() %>">
                    <button>xem</button>
                </a>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>
    <% } %>

    <div style="text-align: center; margin-top: 30px; border-top: 1px dashed #ccc; padding-top: 10px;">
        <a href="GDChinhNV.jsp" style="text-decoration: none; color: black;">Quay lại trang chính</a>
    </div>

</div>

</body>
</html>