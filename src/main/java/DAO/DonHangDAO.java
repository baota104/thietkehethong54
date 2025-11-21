package DAO;


import model.*;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DonHangDAO extends DAO {
    public DonHangDAO() {
        super();
    }

    public List<DonHang> getDonHangByNV(String maNhanVien) {
        List<DonHang> listDonHang = new ArrayList<>();
        // Query lấy thông tin đơn hàng + thông tin khách hàng + trạng thái thanh toán
        String sqlDonHang = "SELECT dh.*, nd.id AS ID, nd.ten AS tenKH, nd.sdt AS sdtKH, nd.email AS emailKH, hd.ttthanhtoan AS TT_THANHTOAN " +
                "FROM tblDonHang dh " +
                "LEFT JOIN tblKhachHang kh ON dh.KhachHangid = kh.NguoiDungid " +
                "LEFT JOIN NguoiDung nd ON kh.NguoiDungid = nd.id " +
                "LEFT JOIN tblhoadon hd ON hd.DonHangid = dh.id " +
                "WHERE dh.NhanVienid = ? AND dh.trangthai NOT IN ('Đã giao', 'Giao thất bại', 'Đã hủy') " +
                "ORDER BY dh.ngaydathang DESC";

        String sqlChiTiet = "SELECT ctdh.*, sp.ten AS tenSP, sp.giaban FROM tblDonHangChiTiet ctdh " +
                "JOIN tblSanPham sp ON ctdh.SanPhamid = sp.id " +
                "WHERE ctdh.DonHangid = ?";

        try (PreparedStatement psDonHang = con.prepareStatement(sqlDonHang);
             PreparedStatement psChiTiet = con.prepareStatement(sqlChiTiet)) {

            psDonHang.setString(1, maNhanVien);

            try (ResultSet rsDonHang = psDonHang.executeQuery()) {
                while (rsDonHang.next()) {
                    DonHang dh = new DonHang();
                    dh.setId(rsDonHang.getString("id"));
                    dh.setNgaydat(rsDonHang.getDate("ngaydathang"));
                    dh.setShip(rsDonHang.getFloat("phiShip"));
                    dh.setTrangthai(rsDonHang.getString("trangthai"));
                    dh.setDiaChiGiaoHang(rsDonHang.getString("diachigiaohang"));
                    dh.setGhichu(rsDonHang.getString("ghichu"));
                    dh.setThoigiandukiengiao(rsDonHang.getTimestamp("thoigiandukien"));
                    dh.setTtthanhtoan(rsDonHang.getString("TT_THANHTOAN"));

                    // Map thông tin khách hàng
                    KhachHang kh = new KhachHang();
                    kh.setId(rsDonHang.getString("ID")); // ID khách hàng để dùng cho việc cộng điểm
                    kh.setTen(rsDonHang.getString("tenKH"));
                    kh.setSdt(rsDonHang.getString("sdtKH"));
                    kh.setEmail(rsDonHang.getString("emailKH"));
                    dh.setKhachHang(kh);

                    // Tính tổng tiền và lấy chi tiết
                    float tongtien = 0;
                    List<DonHangChiTiet> listChiTiet = new ArrayList<>();
                    psChiTiet.setString(1, dh.getId());

                    try (ResultSet rsChiTiet = psChiTiet.executeQuery()) {
                        while (rsChiTiet.next()) {
                            DonHangChiTiet ct = new DonHangChiTiet();
                            ct.setSoluong(rsChiTiet.getInt("soluong"));
                            ct.setDongia(rsChiTiet.getFloat("giaban"));
                            tongtien += ct.getSoluong() * ct.getDongia();

                            SanPham sp = new SanPham();
                            sp.setTen(rsChiTiet.getString("tenSP"));
                            ct.setSanpham(sp);
                            listChiTiet.add(ct);
                        }
                    }
                    dh.setListdonhang(listChiTiet);
                    dh.setTongtien(tongtien); // Set tổng tiền đã tính
                    listDonHang.add(dh);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return listDonHang;
    }

    // --- 2. XÁC NHẬN (Nhận đơn) ---
    public boolean xacNhanDon(DonHang d) {
        // Cố định trạng thái 'Đang giao' trong SQL để đảm bảo an toàn dữ liệu
        String sql = "UPDATE tblDonHang SET trangthai = 'Đang giao' WHERE id = ? AND trangthai IN ('Chờ xử lí', 'Đã xác nhận')";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, d.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // --- 3. NHẢ ĐƠN (Trả lại hệ thống) ---
    public boolean huyNhanDon(DonHang d) {
        String sql = "UPDATE tblDonHang SET trangthai = 'Chờ xử lí', NhanVienid = NULL WHERE id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, d.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // --- 4. HỦY ĐƠN ---
    public boolean huyDonHang(DonHang d) {
        String sql = "UPDATE tblDonHang SET trangthai = 'Đã hủy', ghichu = ? WHERE id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, d.getGhichu());
            ps.setString(2, d.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // --- 5. GIAO THẤT BẠI ---
    public boolean giaoThatBai(DonHang d) {
        String sql = "UPDATE tblDonHang SET trangthai = 'Giao thất bại', ghichu = ? WHERE id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, d.getGhichu());
            ps.setString(2, d.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean daGiaoDon(DonHang d) {
        // Thêm cập nhật cột ghichu = ?
        String sqlUpdateDon = "UPDATE tblDonHang SET trangthai = 'Đã giao', ghichu = ? " +
                "WHERE id = ? AND trangthai = 'Đang giao'";

        String sqlCongDiem = "UPDATE tblKhachHang SET diemtichluy = diemtichluy + 2 WHERE NguoiDungid = ?";

        PreparedStatement psUpdate = null;
        PreparedStatement psCongDiem = null;

        try {
            con.setAutoCommit(false);

            psUpdate = con.prepareStatement(sqlUpdateDon);
            psUpdate.setString(1, d.getGhichu()); // Set ghi chú
            psUpdate.setString(2, d.getId());
            int rowsUpdate = psUpdate.executeUpdate();

            if (rowsUpdate > 0) {
                if (d.getKhachHang() != null && d.getKhachHang().getId() != null) {
                    psCongDiem = con.prepareStatement(sqlCongDiem);
                    psCongDiem.setString(1, d.getKhachHang().getId());
                    psCongDiem.executeUpdate();
                }
                con.commit();
                return true;
            } else {
                con.rollback();
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            try { if (con != null) con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            return false;
        } finally {
            try {
                if (con != null) con.setAutoCommit(true);
            } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}
