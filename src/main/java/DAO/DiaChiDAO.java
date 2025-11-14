package DAO;

import model.Diachi;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DiaChiDAO extends DAO{
    public DiaChiDAO() {
        super();
    }
    public boolean themDiaChi(Diachi diaChi) {
        String sql = "INSERT INTO tblDiaChi (id, diachichitiet, KhachHangid) VALUES (?, ?, ?)";

        try {
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setString(1, diaChi.getId());
            stmt.setString(2, diaChi.getDiachichitiet());
            stmt.setString(3, diaChi.getIdkh());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public List<Diachi> getDiaChi(String idKhachHang) {
        List<Diachi> list = new ArrayList<>();
        String sql = "SELECT * FROM tblDiaChi WHERE KhachHangid = ?";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, idKhachHang);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Diachi(
                        rs.getString("id"),
                        rs.getString("diachichitiet")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

}
