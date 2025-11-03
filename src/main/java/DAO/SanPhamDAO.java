package DAO;

import model.SanPham;
import model.TheLoai;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class SanPhamDAO extends DAO {
    private static final String SEARCH_BY_NAME = "SELECT * FROM tblSanPham WHERE ten LIKE ?";
    private static final String FILTER_BY_CATEGORY = """
        SELECT sp.* FROM tblSanPham sp
        JOIN tblTheLoai tl ON sp.TheLoaiid = tl.id
        WHERE tl.ten LIKE ?;
    """;

    public SanPhamDAO() {
        super(); // Gọi constructor của lớp cha để đảm bảo có kết nối
    }
    public List<SanPham> getProductsByCondition(String condition) {
        List<SanPham> list = new ArrayList<>();
        String sql = "SELECT * FROM tblSanPham WHERE tonkho > 0"; // ví dụ đơn giản
        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
            System.out.println("DEBUG: So san pham lay duoc = " + list.size());
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }


    //  public List<SanPham> getProductsByCondition(String condition) {
//        List<SanPham> list = new ArrayList<>();
//
//        // Xác định điều kiện tìm kiếm thực tế
//        String sql = """
//            SELECT sp.*, tl.id as theloai_id, tl.ten as theloai_ten, tl.mota as theloai_mota
//            FROM tblSanPham sp
//            JOIN tblTheLoai tl ON sp.TheLoaiid = tl.id
//            WHERE tl.ten LIKE ?
//            LIMIT 12;
//        """;
//
//        try (PreparedStatement ps = con.prepareStatement(sql)) {
//            // Chuyển điều kiện thành pattern LIKE
//            ps.setString(1, "%" + condition + "%");
//
//            try (ResultSet rs = ps.executeQuery()) {
//                while (rs.next()) {
//                    TheLoai tl = new TheLoai(
//                            rs.getString("theloai_id"),
//                            rs.getString("theloai_ten"),
//                            rs.getString("theloai_mota")
//                    );
//
//                    SanPham sp = new SanPham(
//                            rs.getString("id"),
//                            rs.getString("ten"),
//                            rs.getString("mota"),
//                            rs.getString("anh"),
//                            rs.getString("donvi"),
//                            rs.getString("thuonghieu"),
//                            rs.getFloat("giagoc"),
//                            rs.getFloat("giaban"),
//                            rs.getFloat("giamgia"),
//                            rs.getInt("tonkho"),
//                            tl
//                    );
//
//                    list.add(sp);
//                }
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//
//        return list;
//    }

    //  Hàm phụ — xác định điều kiện gợi ý dựa theo thời gian
    public String suggestConditionByTime() {
        int month = LocalDate.now().getMonthValue();

        if (month >= 5 && month <= 8) {
            return "Nước uống"; // Mùa hè
        } else if (month >= 11 || month <= 2) {
            return "Đồ ăn"; // Mùa đông
        } else {
            return "Gia dụng"; // Mùa thường
        }
    }

    public List<SanPham> searchByName(String keyword) {
        List<SanPham> list = new ArrayList<>();
        try (PreparedStatement ps = con.prepareStatement(SEARCH_BY_NAME)) {
            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // --- Lọc theo thể loại ---
    public List<SanPham> filterByCategory(String category) {
        List<SanPham> list = new ArrayList<>();
        try (PreparedStatement ps = con.prepareStatement(FILTER_BY_CATEGORY)) {
            ps.setString(1, "%" + category + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // --- Map dữ liệu từ ResultSet sang đối tượng SanPham ---
    private SanPham mapResultSet(ResultSet rs) throws SQLException {
        TheLoai tl = new TheLoai(rs.getString("TheLoaiid"), "", "");
        return new SanPham(
                rs.getString("id"),
                rs.getString("ten"),
                rs.getString("mota"),
                rs.getString("anh"),
                rs.getString("donvi"),
                rs.getString("thuonghieu"),
                rs.getFloat("giagoc"),
                rs.getFloat("giaban"),
                rs.getFloat("giamgia"),
                rs.getInt("tonkho"),
                tl
        );
    }
    public boolean ThemSPvaoGio(String sp, String khachHangId) {
        try {
            // 1️ Kiểm tra giỏ hàng của khách có chưa
            String gioHangId = null;
            String sqlCheckCart = "SELECT id FROM tblGioHang WHERE KhachHangid = ?";
            PreparedStatement ps1 = con.prepareStatement(sqlCheckCart);
            ps1.setString(1, khachHangId);
            ResultSet rs1 = ps1.executeQuery();

            if (rs1.next()) {
                gioHangId = rs1.getString("id");
            } else {
                gioHangId = UUID.randomUUID().toString();
                String sqlInsertCart = "INSERT INTO tblGioHang (id, tongsanpham, KhachHangid) VALUES (?, 0, ?)";
                PreparedStatement ps2 = con.prepareStatement(sqlInsertCart);
                ps2.setString(1, gioHangId);
                ps2.setString(2, khachHangId);
                ps2.executeUpdate();
            }
            // 2️ Kiểm tra xem sản phẩm đã tồn tại trong chi tiết giỏ chưa
            String sqlCheckItem = "SELECT id, soluong FROM tblGioHangChiTiet WHERE GioHangid = ? AND SanPhamid = ?";
            PreparedStatement ps3 = con.prepareStatement(sqlCheckItem);
            ps3.setString(1, gioHangId);
            ps3.setString(2, sp);
            ResultSet rs2 = ps3.executeQuery();

            if (rs2.next()) {
                // Nếu có → cập nhật số lượng
                int newQty = rs2.getInt("soluong") + 1;
                String sqlUpdate = "UPDATE tblGioHangChiTiet SET soluong = ? WHERE id = ?";
                PreparedStatement ps4 = con.prepareStatement(sqlUpdate);
                ps4.setInt(1, newQty);
                ps4.setString(2, rs2.getString("id"));
                ps4.executeUpdate();
            } else {
                // Nếu chưa có → thêm mới
                String idChiTiet = UUID.randomUUID().toString();
                String sqlInsert = "INSERT INTO tblGioHangChiTiet (id, soluong, SanPhamid, GioHangid) VALUES (?, 1, ?, ?)";
                PreparedStatement ps5 = con.prepareStatement(sqlInsert);
                ps5.setString(1, idChiTiet);
                ps5.setString(2, sp);
                ps5.setString(3, gioHangId);
                ps5.executeUpdate();
            }

            // 3️ Cập nhật tổng số sản phẩm trong tblGioHang
            String sqlCount = "SELECT SUM(soluong) AS total FROM tblGioHangChiTiet WHERE GioHangid = ?";
            PreparedStatement ps6 = con.prepareStatement(sqlCount);
            ps6.setString(1, gioHangId);
            ResultSet rs3 = ps6.executeQuery();

            if (rs3.next()) {
                int total = rs3.getInt("total");
                String sqlUpdateCart = "UPDATE tblGioHang SET tongsanpham = ? WHERE id = ?";
                PreparedStatement ps7 = con.prepareStatement(sqlUpdateCart);
                ps7.setInt(1, total);
                ps7.setString(2, gioHangId);
                ps7.executeUpdate();
            }

            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public SanPham getSanPhamById(String id) {
        try {
            PreparedStatement ps = con.prepareStatement("SELECT * FROM tblSanPham WHERE id = ?");
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

}
