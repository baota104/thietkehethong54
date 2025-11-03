package DAO;

import model.*;
import java.sql.*;
import java.util.*;

public class GioHangDAO extends DAO {

    public List<GioHangChiTiet> getSPGioHang(String idKhachHang) {
        List<GioHangChiTiet> list = new ArrayList<>();
        try {
            // 1️ Lấy id giỏ hàng từ khách hàng
            String sqlCart = "SELECT id FROM tblGioHang WHERE KhachHangid = ?";
            PreparedStatement psCart = con.prepareStatement(sqlCart);
            psCart.setString(1, idKhachHang);
            ResultSet rsCart = psCart.executeQuery();

            if (!rsCart.next()) {
                System.out.println(" Không tìm thấy giỏ hàng của khách hàng " + idKhachHang);
                return list; // Giỏ hàng trống
            }

            String gioHangId = rsCart.getString("id");

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

            System.out.println(" Lấy " + list.size() + " sản phẩm trong giỏ hàng của khách " + idKhachHang);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
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
}
