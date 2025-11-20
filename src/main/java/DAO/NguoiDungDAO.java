package DAO;

import model.KhachHang;
import model.NguoiDung;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.UUID;

public class NguoiDungDAO extends DAO {

    public NguoiDungDAO() {
        super();
    }

    //  Đăng ký tài khoản mới
    public boolean DangKiMoi(NguoiDung n) {
        String insertNguoiDung = "INSERT INTO NguoiDung(id, ten, email, sdt, matkhau, ghichu, ngaysinh, vaitro) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        String insertKhachHang = "INSERT INTO tblKhachHang(NguoiDungid, diemtichluy) VALUES (?, 0)";
        String insertGioHang = "INSERT INTO tblGioHang(id, tongsanpham, KhachHangid) VALUES (?, 0, ?)";

        try {
            con.setAutoCommit(false); //  Bắt đầu transaction

            // 1️ Thêm người dùng
            PreparedStatement psUser = con.prepareStatement(insertNguoiDung);
            psUser.setString(1, n.getId());
            psUser.setString(2, n.getTen());
            psUser.setString(3, n.getEmail());
            psUser.setString(4, n.getSdt());
            psUser.setString(5, n.getPassword());
            psUser.setString(6, n.getGhichu());
            psUser.setDate(7, n.getNgaysinh());
            psUser.setString(8, n.getVaitro());
            psUser.executeUpdate();

            // 2️ Thêm khách hàng
            PreparedStatement psKH = con.prepareStatement(insertKhachHang);
            psKH.setString(1, n.getId());
            psKH.executeUpdate();

            // 3️ Tạo giỏ hàng
            String gioHangId = UUID.randomUUID().toString();
            PreparedStatement psGH = con.prepareStatement(insertGioHang);
            psGH.setString(1, gioHangId);
            psGH.setString(2, n.getId());
            psGH.executeUpdate();

            con.commit();
            System.out.println("Tạo người dùng, khách hàng, giỏ hàng, yêu thích thành công!");
            return true;

        } catch (SQLException e) {
            try {
                con.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                con.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public boolean CheckTonTai(String email, String sdt) {
        String sql = "SELECT * FROM NguoiDung WHERE email = ? OR sdt = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, sdt);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return true;
        }
    }
    //  Kiểm tra đăng nhập
    public boolean DangNhap(NguoiDung nd) {
        String sql = "SELECT * FROM NguoiDung WHERE sdt = ? AND matkhau = ?";
        boolean result = false;
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, nd.getSdt());
            ps.setString(2, nd.getPassword());
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                nd.setId(rs.getString("id"));
                nd.setTen(rs.getString("ten"));
                nd.setEmail(rs.getString("email"));
                nd.setSdt(rs.getString("sdt"));
                nd.setPassword(rs.getString("matkhau"));
                nd.setGhichu(rs.getString("ghichu"));
                nd.setNgaysinh(rs.getDate("ngaysinh"));
                nd.setVaitro(rs.getString("vaitro"));
                result = true;
            }
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

}