package DAO;

import model.Diachi;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class DiaChiDAO extends DAO{
    public DiaChiDAO() {
        super();
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
