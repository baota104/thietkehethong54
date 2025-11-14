package DAO;

import model.*;
import java.sql.*;
import java.util.*;

public class GioHangDAO extends DAO {

    public GioHang getSPGioHang(String idGiohang) {
        GioHang gioHang = new GioHang();
        List<GioHangChiTiet> list = new ArrayList<>();
        try {


            String gioHangId = idGiohang;
            // 2️ Lấy chi tiết sản phẩm trong giỏ
            String sql = """
                SELECT ghct.id, ghct.soluong, sp.id AS spid, sp.ten, sp.giaban, sp.anh, sp.donvi
                FROM tblGioHangChiTiet ghct
                JOIN tblSanPham sp ON ghct.SanPhamid = sp.id
                WHERE ghct.GioHangid = ?
            """;

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, gioHangId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                SanPham sp = new SanPham(
                        rs.getString("spid"),
                        rs.getString("ten"),
                        null,
                        rs.getString("anh"),
                        rs.getString("donvi"),
                        null,
                        0,
                        rs.getFloat("giaban"),
                        0,
                        0,
                        null
                );
                GioHangChiTiet item = new GioHangChiTiet(
                        rs.getString("id"),
                        rs.getFloat("giaban"),
                        rs.getFloat("giaban") * rs.getInt("soluong"),
                        rs.getInt("soluong"),
                        sp
                );
                list.add(item);
            }

            gioHang.setId(idGiohang);
            gioHang.setGioHangChiTiet(list);
            return gioHang;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    public boolean ThemSPvaoGio(GioHangChiTiet ct, String gioHangId) {
        String sanPhamId = ct.getSanPham().getId();
        int soLuongThem = ct.getSoluong();

        try {
            //  Bắt đầu transaction
            con.setAutoCommit(false);

            // Kiểm tra tồn kho
            String sqlStock = "SELECT tonkho FROM tblSanPham WHERE id = ?";
            PreparedStatement psStock = con.prepareStatement(sqlStock);
            psStock.setString(1, sanPhamId);
            ResultSet rsStock = psStock.executeQuery();

            int tonKho = 0;
            if (rsStock.next()) {
                tonKho = rsStock.getInt("tonkho");
            } else {
                con.rollback();
                System.out.println("ERROR: Không tìm thấy sản phẩm để kiểm tra tồn kho.");
                return false;
            }

            // Kiểm tra sản phẩm đã có trong giỏ chưa
            String sqlCheck = "SELECT id, soluong FROM tblGioHangChiTiet WHERE GioHangid = ? AND SanPhamid = ?";
            PreparedStatement psCheck = con.prepareStatement(sqlCheck);
            psCheck.setString(1, gioHangId);
            psCheck.setString(2, sanPhamId);
            ResultSet rs = psCheck.executeQuery();

            if (rs.next()) {
                // Đã có trong giỏ → cập nhật số lượng
                int soluongHienTai = rs.getInt("soluong");
                int soluongMoi = soluongHienTai + soLuongThem;

                if (soluongMoi > tonKho) {
                    con.rollback();
                    System.out.println(" Không đủ tồn kho để thêm sản phẩm!");
                    return false;
                }

                String sqlUpdate = "UPDATE tblGioHangChiTiet SET soluong = ? WHERE id = ?";
                PreparedStatement psUpdate = con.prepareStatement(sqlUpdate);
                psUpdate.setInt(1, soluongMoi);
                psUpdate.setString(2, rs.getString("id"));
                psUpdate.executeUpdate();

            } else {
                // Chưa có trong giỏ → thêm mới
                if (soLuongThem > tonKho) {
                    con.rollback();
                    System.out.println(" Không đủ tồn kho để thêm sản phẩm mới!");
                    return false;
                }

                String idChiTiet = UUID.randomUUID().toString();
                String sqlInsert = "INSERT INTO tblGioHangChiTiet (id, soluong, SanPhamid, GioHangid) VALUES (?, ?, ?, ?)";
                PreparedStatement psInsert = con.prepareStatement(sqlInsert);
                psInsert.setString(1, idChiTiet);
                psInsert.setInt(2, soLuongThem);
                psInsert.setString(3, sanPhamId);
                psInsert.setString(4, gioHangId);
                psInsert.executeUpdate();
            }

            // 3 Cập nhật tổng số sản phẩm trong giỏ
            String sqlUpdateTong = """
            UPDATE tblGioHang 
            SET tongsanpham = (SELECT COALESCE(SUM(soluong), 0) 
                               FROM tblGioHangChiTiet 
                               WHERE GioHangid = ?) 
            WHERE id = ?;
        """;
            PreparedStatement psTong = con.prepareStatement(sqlUpdateTong);
            psTong.setString(1, gioHangId);
            psTong.setString(2, gioHangId);
            psTong.executeUpdate();

            //  Nếu mọi thứ thành công → commit
            con.commit();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            try {
                con.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            return false;
        } finally {
            try {
                con.setAutoCommit(true); // Khôi phục lại chế độ mặc định
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }


    //  Xóa sản phẩm trong giỏ
    public boolean XoaSanPham(String idGioHangChiTiet) {
        try {
            String sql = "DELETE FROM tblGioHangChiTiet WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, idGioHangChiTiet);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Điều chỉnh số lượng (tăng / giảm)
    public boolean DieuChinhSl(GioHangChiTiet item, boolean tang) {
        try {
            int newQty = item.getSoluong() + (tang ? 1 : -1);
            if (newQty <= 0) return XoaSanPham(item.getId());

            String sql = "UPDATE tblGioHangChiTiet SET soluong = ? WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, newQty);
            ps.setString(2, item.getId());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public String getID(String id){
        try {
            // 1️ Kiểm tra giỏ hàng của khách có chưa
            String gioHangId = null;
            String sqlCheckCart = "SELECT id FROM tblGioHang WHERE KhachHangid = ?";
            PreparedStatement ps1 = con.prepareStatement(sqlCheckCart);
            ps1.setString(1, id);
            ResultSet rs1 = ps1.executeQuery();

            if (rs1.next()) {
                gioHangId = rs1.getString("id");
                return gioHangId;
            } else {
                return gioHangId;
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

}
