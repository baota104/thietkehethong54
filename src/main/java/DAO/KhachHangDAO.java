package DAO;

import model.KhachHang;
import java.sql.*;
import java.util.List;

public class KhachHangDAO extends DAO {
    private DiaChiDAO diaChiDAO = new DiaChiDAO();

    public KhachHangDAO() {
        super();
    }

    /**
     * Lấy thông tin khách hàng (JOIN NguoiDung + tblKhachHang)
     */
    public KhachHang getTTKhachHang(String idNguoiDung) {
        String sql = """
            SELECT nd.*, kh.diemtichluy
            FROM NguoiDung nd
            JOIN tblKhachHang kh ON nd.id = kh.NguoiDungid
            WHERE nd.id = ?
        """;

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, idNguoiDung);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                KhachHang kh = new KhachHang(
                        rs.getString("id"),
                        rs.getString("vaitro"),
                        rs.getString("ten"),
                        rs.getString("sdt"),
                        rs.getString("email"),
                        rs.getString("matkhau"),
                        rs.getString("ghichu"),
                        rs.getDate("ngaysinh"),
                        rs.getInt("diemtichluy")
                );

                kh.setDiachiList(diaChiDAO.getDiaChi(idNguoiDung));
                kh.setGhid(getIDGH(idNguoiDung));
                return kh;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    public String getIDGH(String id){
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
