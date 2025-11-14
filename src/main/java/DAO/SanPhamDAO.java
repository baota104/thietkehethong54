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


      public List<SanPham> getSPGoiY() {
        String condition = this.suggestConditionByTime();
        List<SanPham> list = new ArrayList<>();

        // Xác định điều kiện tìm kiếm thực tế
        String sql = """
            SELECT sp.*, tl.id as theloai_id, tl.ten as theloai_ten, tl.mota as theloai_mota
            FROM tblSanPham sp
            JOIN tblTheLoai tl ON sp.TheLoaiid = tl.id
            WHERE tl.ten LIKE ?
            LIMIT 12;
        """;

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            // Chuyển điều kiện thành pattern LIKE
            ps.setString(1, "%" + condition + "%");

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TheLoai tl = new TheLoai(
                            rs.getString("theloai_id"),
                            rs.getString("theloai_ten"),
                            rs.getString("theloai_mota")
                    );
                    SanPham sp = new SanPham(
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

                    list.add(sp);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

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



}
