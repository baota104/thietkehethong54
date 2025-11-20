package DAO;

import model.DonHang;
import model.DonHangChiTiet;
import model.HoaDon;
import model.ThanhToan;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class HoaDonDAO extends DAO{
    public HoaDonDAO() {
        super();
    }
    public boolean TaoHoaDon(HoaDon hoaDon) {

        DonHang donHang = hoaDon.getDonHang();
        ThanhToan thanhToan = hoaDon.getThanhtoan();
        List<DonHangChiTiet> chiTietList = donHang.getListdonhang();
        String khachHangId = donHang.getKhachHang().getId();

        String sqlInsertDonHang = "INSERT INTO tblDonHang (id, ngaydathang, trangthai, giamgia, ghichu, thoigiandukien, phiShip, diachigiaohang, MaGiamGiaid, NhanVienid, KhachHangid) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String sqlInsertChiTiet = "INSERT INTO tblDonHangChiTiet (id, soluong, gia, SanPhamid, DonHangid) VALUES (?, ?, ?, ?, ?)";
        String sqlInsertHoaDon = "INSERT INTO tblHoaDon (ngaythanhtoan, tongthanhtoan, phuongthucthanhtoan, maQR, ghichu, DonHangid,ttthanhtoan) VALUES (?, ?, ?, ?, ?, ?,?)";

        String sqlCheckStock = "SELECT tonkho FROM tblSanPham WHERE id = ? FOR UPDATE"; // Khóa dòng để kiểm tra
        String sqlUpdateStock = "UPDATE tblSanPham SET tonkho = tonkho - ? WHERE id = ?";

        try {
            // 1. BẮT ĐẦU TRANSACTION
            con.setAutoCommit(false);

            // 2. KIỂM TRA TỒN KHO (VÀ KHÓA CÁC SẢN PHẨM)
            for (DonHangChiTiet item : chiTietList) {
                PreparedStatement psCheck = con.prepareStatement(sqlCheckStock);
                psCheck.setString(1, item.getSanpham().getId());
                ResultSet rsStock = psCheck.executeQuery();

                if (rsStock.next()) {
                    int tonKhoHienTai = rsStock.getInt("tonkho");
                    if (tonKhoHienTai < item.getSoluong()) {
                        // Nếu hết hàng, hủy bỏ giao dịch
                        con.rollback();
                        System.err.println("Giao dịch thất bại: Sản phẩm " + item.getSanpham().getTen() + " không đủ tồn kho.");
                        return false;
                    }
                } else {
                    // Nếu không tìm thấy sản phẩm
                    con.rollback();
                    System.err.println("Giao dịch thất bại: Không tìm thấy sản phẩm ID " + item.getSanpham().getId());
                    return false;
                }
            }

            // 3. THÊM ĐƠN HÀNG (tblDonHang)
            PreparedStatement psDonHang = con.prepareStatement(sqlInsertDonHang);
            psDonHang.setString(1, donHang.getId());
            psDonHang.setDate(2, new java.sql.Date(donHang.getNgaydat().getTime()));
            psDonHang.setString(3, donHang.getTrangthai());
            psDonHang.setFloat(4, donHang.getTongkhuyenmai()); // giamgia
            psDonHang.setString(5, donHang.getGhichu());
            psDonHang.setTimestamp(6, new java.sql.Timestamp(donHang.getThoigiandukiengiao().getTime()));
            psDonHang.setFloat(7, donHang.getShip());
            psDonHang.setString(8, donHang.getDiaChiGiaoHang());
            psDonHang.setString(9, (donHang.getMaGiamGia() != null ? donHang.getMaGiamGia().getId() : null));
            psDonHang.setString(10, (donHang.getNhanVien() != null ? donHang.getNhanVien().getId() : null));
            psDonHang.setString(11, khachHangId); // KhachHangid
            psDonHang.executeUpdate();

            // 4. THÊM CHI TIẾT ĐƠN HÀNG VÀ CẬP NHẬT TỒN KHO (Loop)
            for (DonHangChiTiet item : chiTietList) {
                // 4a. Thêm chi tiết
                PreparedStatement psChiTiet = con.prepareStatement(sqlInsertChiTiet);
                psChiTiet.setString(1, item.getId());
                psChiTiet.setInt(2, item.getSoluong());
                psChiTiet.setFloat(3, item.getDongia()); // 'gia' trong tblDonHangChiTiet
                psChiTiet.setString(4, item.getSanpham().getId());
                psChiTiet.setString(5, donHang.getId());
                psChiTiet.executeUpdate();

                // 4b. Cập nhật (trừ) tồn kho
                PreparedStatement psUpdateStock = con.prepareStatement(sqlUpdateStock);
                psUpdateStock.setInt(1, item.getSoluong());
                psUpdateStock.setString(2, item.getSanpham().getId());
                psUpdateStock.executeUpdate();
            }

            // 5. THÊM HÓA ĐƠN (tblHoaDon)
            PreparedStatement psHoaDon = con.prepareStatement(sqlInsertHoaDon);
            psHoaDon.setDate(1, new java.sql.Date(thanhToan.getNgaythanhtoan().getTime()));
            psHoaDon.setFloat(2, thanhToan.getTongtien());
            psHoaDon.setString(3, thanhToan.getPhuongthuc());
            psHoaDon.setString(4, thanhToan.getQR()); // maQR (có thể null)
            psHoaDon.setString(5, thanhToan.getGhichu());
            psHoaDon.setString(6, donHang.getId()); // DonHangid
            psHoaDon.setString(7, thanhToan.getTrangthai());
            psHoaDon.executeUpdate();

            // 6. COMMIT TRANSACTION
            con.commit();
            System.out.println("Tạo Hóa Đơn (Transaction) thành công!");
            return true;

        } catch (SQLException e) {
            // 7. ROLLBACK NẾU CÓ LỖI
            e.printStackTrace();
            try {
                if (con != null) {
                    con.rollback();
                    System.err.println("Transaction rolled back do lỗi.");
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            return false;
        } finally {
            try {
                if (con != null) {
                    con.setAutoCommit(true);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    public boolean HuyDonHang(HoaDon hoaDon) {
        DonHang donHang = hoaDon.getDonHang();
        List<DonHangChiTiet> chiTietList = donHang.getListdonhang();

        String sqlUpdateDonHang = "UPDATE tblDonHang SET trangthai = ? WHERE id = ?";
        String sqlUpdateHoaDon = "UPDATE tblHoaDon SET ghichu = ? WHERE DonHangid = ?";
        String sqlRestoreStock = "UPDATE tblSanPham SET tonkho = tonkho + ? WHERE id = ?";

        try {
            // 1. BẮT ĐẦU TRANSACTION
            con.setAutoCommit(false);

            // 2. CẬP NHẬT TRẠNG THÁI ĐƠN HÀNG -> "Đã hủy"
            PreparedStatement psDonHang = con.prepareStatement(sqlUpdateDonHang);
            psDonHang.setString(1, "Đã hủy");
            psDonHang.setString(2, donHang.getId());
            psDonHang.executeUpdate();

            // 3. CẬP NHẬT HÓA ĐƠN -> "Đã hủy/Chờ hoàn tiền"
            PreparedStatement psHoaDon = con.prepareStatement(sqlUpdateHoaDon);
            psHoaDon.setString(1, "Đơn hàng đã hủy, chờ hoàn tiền.");
            psHoaDon.setString(2, donHang.getId());
            psHoaDon.executeUpdate();

            // 4. HOÀN TRẢ TỒN KHO
            for (DonHangChiTiet item : chiTietList) {
                PreparedStatement psRestoreStock = con.prepareStatement(sqlRestoreStock);
                psRestoreStock.setInt(1, item.getSoluong());
                psRestoreStock.setString(2, item.getSanpham().getId());
                psRestoreStock.executeUpdate();
            }

            // 5. COMMIT TRANSACTION
            con.commit();
            System.out.println("Hủy Đơn Hàng (Transaction) thành công!");
            return true;

        } catch (SQLException e) {
            // 6. ROLLBACK NẾU CÓ LỖI
            e.printStackTrace();
            try {
                if (con != null) con.rollback();
            } catch (SQLException ex) { ex.printStackTrace(); }
            return false;
        } finally {
            // 7. BẬT LẠI AUTO-COMMIT
            try {
                if (con != null) con.setAutoCommit(true);
            } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}
