package DAO;

import model.KhachHang;
import model.NguoiDung;

import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class KhachHangDAO extends DAO{
    public KhachHangDAO() {
        super();
    }
//    public KhachHang getTTKhachHang(String id){
//        String sql = "SELECT * FROM tblKhachHang WHERE id = ?";
//        try {
//            PreparedStatement ps = con.prepareStatement(sql);
//            ps.setString(1, id);
//            ResultSet rs = ps.executeQuery();
//            if (rs.next()) {
//                KhachHang kh = new KhachHang(rs.getString("NguoiDungid"),)
//                NguoiDung nd = new NguoiDung();
//                nd.setId(rs.getString("id"));
//                nd.setTen(rs.getString("ten"));
//                nd.setEmail(rs.getString("email"));
//                nd.setSdt(rs.getString("sdt"));
//                nd.setPassword(rs.getString("matkhau"));
//                nd.setVaitro(rs.getString("vaitro"));
//                return nd;
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return null;
//    }
}
