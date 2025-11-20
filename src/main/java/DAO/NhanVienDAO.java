package DAO;

import model.KhachHang;
import model.NhanVien;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import static DAO.DAO.con;

public class NhanVienDAO {
    public NhanVienDAO() {
        super();
    }
    public NhanVien getTTNhanVien(String idNguoiDung){
        String sql = """
            SELECT nd.*, nv.vitri
            FROM NguoiDung nd
            JOIN tblNhanVien nv ON nd.id = nv.NguoiDungid
            WHERE nd.id = ?
        """;
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, idNguoiDung);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                NhanVien nv = new NhanVien(
                        rs.getString("id"),
                        rs.getString("vaitro"),
                        rs.getString("ten"),
                        rs.getString("sdt"),
                        rs.getString("email"),
                        rs.getString("matkhau"),
                        rs.getString("ghichu"),
                        rs.getDate("ngaysinh"),
                        rs.getString("vitri")
                );

                return nv;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
