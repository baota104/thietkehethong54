<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.DonHang" %>
<%@ page import="model.DonHangChiTiet" %>
<%@ page import="model.KhachHang" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>
<%
  String maDon = request.getParameter("maDon");
  List<DonHang> listSession = (List<DonHang>)session.getAttribute("listDonHangChuaGiao");

  DonHang donHang = null;
  if (listSession != null && maDon != null) {
    for (DonHang dh : listSession) {
      if (dh.getId().equals(maDon)) {
        donHang = dh;
        break;
      }
    }
  }

  if (donHang == null) {
    out.print("Không tìm thấy đơn hàng!");
    return;
  }

  NumberFormat currencyVal = NumberFormat.getInstance();
  String strNgayGiao = "Chưa xác định";
  if (donHang.getThoigiandukiengiao() != null) {
    Calendar cal = Calendar.getInstance();
    cal.setTime(donHang.getThoigiandukiengiao());
    int hour = cal.get(Calendar.HOUR_OF_DAY);
    int minute = cal.get(Calendar.MINUTE);
    String timeRange = "";
    if (minute <= 30) {
      timeRange = hour + "h - " + hour + "h30";
    } else {
      timeRange = hour + "h30 - " + (hour + 1) + "h";
    }
    SimpleDateFormat dateOnlyFmt = new SimpleDateFormat("dd/MM/yyyy");
    String datePart = dateOnlyFmt.format(donHang.getThoigiandukiengiao());
    strNgayGiao = timeRange + ", " + datePart;
  }

  String trangThai = donHang.getTrangthai();
  KhachHang kh = donHang.getKhachHang();
  String tenKH = (kh != null) ? kh.getTen() : "---";
  String sdtKH = (kh != null) ? kh.getSdt() : "---";
  String strTongTien = currencyVal.format(donHang.getTongtien() + donHang.getShip()) + "đ";
  String strThanhToan = (donHang.getTtthanhtoan() != null) ? donHang.getTtthanhtoan() : "Chưa rõ";

  boolean isMoi = trangThai.equals("Chờ xử lí") || trangThai.equals("Đã xác nhận");
  boolean isDangGiao = trangThai.equals("Đang giao");
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Chi Tiết Đơn Hàng</title>
  <style>
    * { box-sizing: border-box; }
    body { font-family: Arial, sans-serif; display: flex; justify-content: center; margin-top: 20px; }

    .main-box { width: 700px; border: 2px solid black; display: flex; flex-direction: row; }
    .col-left { width: 50%; border-right: 2px solid black; padding: 10px; }
    .col-right { width: 50%; padding: 10px; display: flex; flex-direction: column; }

    .item-box { border: 1px solid black; padding: 5px; margin-bottom: 10px; }

    /* Style cho Label */
    .info-line { margin: 10px 0; }
    .info-line label { font-weight: bold; display: inline-block; width: 140px; vertical-align: top; }
    .info-line span { display: inline-block; width: calc(100% - 150px); }

    /* Style cho Form Nút Bấm */
    .btn-container { border: 1px solid black; padding: 15px 5px; margin-bottom: 20px; display: flex; justify-content: space-around; }
    .btn-full-container { border: 1px solid black; padding: 15px 5px; text-align: center; margin-top: auto; }

    /* Form nội dòng để các nút nằm ngang */
    .inline-form { display: inline; width: 45%; }

    button {
      width: 100%; /* Button chiếm hết width của form cha */
      height: 40px;
      font-size: 14px; cursor: pointer; background: #eee; border: 1px solid #999;
    }

    .disabled-area { border: 1px solid #ccc; color: #ccc; }
    .disabled-area button { color: #ccc; border-color: #ccc; background: white; cursor: not-allowed; }
  </style>
</head>
<body>

<div>
  <h2 style="text-align: center;">Giao diện đơn hàng chi tiết</h2>

  <div class="main-box">
    <div class="col-left">
      <% if (donHang.getListdonhang() != null && !donHang.getListdonhang().isEmpty()) { %>
      <table>
        <thead>
        <tr>
          <th style="width: 70%;">Sản phẩm</th>
          <th style="width: 30%; text-align: center;">Số lượng</th>
        </tr>
        </thead>
        <tbody>
        <% for (DonHangChiTiet ct : donHang.getListdonhang()) { %>
        <tr>
          <td><%= ct.getSanpham().getTen() %></td>
          <td style="text-align: center;"><%= ct.getSoluong() %></td>
        </tr>
        <% } %>
        </tbody>
      </table>
      <% } else { %>
      <p>Không có sản phẩm</p>
      <% } %>
    </div>

    <div class="col-right">
      <div class="info-line">
        <label>Tổng giá trị :</label> <span><%= strTongTien %></span>
      </div>
      <div class="info-line">
        <label>Địa chỉ :</label> <span>"<%= donHang.getDiaChiGiaoHang() %>"</span>
      </div>
      <div class="info-line">
        <label>Số điện thoại :</label> <span><%= sdtKH %></span>
      </div>
      <div class="info-line">
        <label>Tên khách hàng :</label> <span><%= tenKH %></span>
      </div>
      <div class="info-line">
        <label>Giao dự kiến :</label> <span><%= strNgayGiao %></span>
      </div>
      <div class="info-line">
        <label>Thanh toán :</label> <strong><%= strThanhToan %></strong>
      </div>

      <br>

      <% if (isMoi) { %>
      <div class="btn-container">
        <form action="doThayDoiTTDon.jsp" method="POST" class="inline-form">
          <input type="hidden" name="maDon" value="<%= maDon %>">
          <input type="hidden" name="thaoTac" value="XacNhan">
          <button type="submit">Xác nhận</button>
        </form>

        <form action="doThayDoiTTDon.jsp" method="POST" class="inline-form" onsubmit="return confirm('Bạn muốn trả lại đơn này cho hệ thống?');">
          <input type="hidden" name="maDon" value="<%= maDon %>">
          <input type="hidden" name="thaoTac" value="TraDon">
          <button type="submit">Hủy nhận đơn</button>
        </form>
      </div>

      <div class="btn-full-container">
        <form action="GDXacNhanHuy.jsp" method="GET" style="width: 80%; margin: auto;">
          <input type="hidden" name="maDon" value="<%= maDon %>">
          <input type="hidden" name="thaoTac" value="Huy">
          <button type="submit" style="height: 30px;">Hủy đơn hàng</button>
        </form>
      </div>
      <% } else { %>
      <div style="height: 120px;"></div>
      <% } %>

      <div class="btn-container <%= isDangGiao ? "" : "disabled-area" %>" style="margin-top: 30px;">
        <% if (isDangGiao) { %>

        <form action="doThayDoiTTDon.jsp" method="POST" class="inline-form" onsubmit="return confirm('Xác nhận đơn này đã giao thành công?');">
          <input type="hidden" name="maDon" value="<%= maDon %>">
          <input type="hidden" name="thaoTac" value="DaGiao">
          <input type="hidden" name="khachHangId" value="<%= donHang.getKhachHang().getId() %>">
          <input type="hidden" name="ghiChu" value="Giao hàng thành công">
          <button type="submit">Đã giao</button>
        </form>

        <form action="GDThongBao.jsp" method="GET" class="inline-form">
          <input type="hidden" name="maDon" value="<%= maDon %>">
          <input type="hidden" name="thaoTac" value="ThatBai">
          <button type="submit">Giao thất bại</button>
        </form>

        <% } else { %>
        <div class="inline-form"><button disabled>Đã giao</button></div>
        <div class="inline-form"><button disabled>Giao thất bại</button></div>
        <% } %>
      </div>

    </div>
  </div>

  <p style="text-align: center; margin-top: 20px;">
    <a href="GDGiaoHangChoKhach.jsp">Quay lại danh sách</a>
  </p>
</div>

</body>
</html>