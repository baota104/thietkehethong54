package model;

import java.sql.Date;
import java.util.List;

public class DonHang {
    private String id,trangthai,ghichu;
    private Date thoigiandukiengiao,ngaydat;
    private float tongtien,ship,tongkhuyenmai;
    private List<DonHangChiTiet> listdonhang;
    private KhachHang khachHang;
    private NhanVien nhanVien;
    private MaGiamGia maGiamGia;

    public DonHang(String id, String trangthai, String ghichu, Date thoigiandukiengiao, Date ngaydat, float tongtien, float ship, float tongkhuyenmai, List<DonHangChiTiet> listdonhang, KhachHang khachHang, NhanVien nhanVien, MaGiamGia maGiamGia) {
        this.id = id;
        this.trangthai = trangthai;
        this.ghichu = ghichu;
        this.thoigiandukiengiao = thoigiandukiengiao;
        this.ngaydat = ngaydat;
        this.tongtien = tongtien;
        this.ship = ship;
        this.tongkhuyenmai = tongkhuyenmai;
        this.listdonhang = listdonhang;
        this.khachHang = khachHang;
        this.nhanVien = nhanVien;
        this.maGiamGia = maGiamGia;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTrangthai() {
        return trangthai;
    }

    public void setTrangthai(String trangthai) {
        this.trangthai = trangthai;
    }

    public String getGhichu() {
        return ghichu;
    }

    public void setGhichu(String ghichu) {
        this.ghichu = ghichu;
    }

    public Date getThoigiandukiengiao() {
        return thoigiandukiengiao;
    }

    public void setThoigiandukiengiao(Date thoigiandukiengiao) {
        this.thoigiandukiengiao = thoigiandukiengiao;
    }

    public Date getNgaydat() {
        return ngaydat;
    }

    public void setNgaydat(Date ngaydat) {
        this.ngaydat = ngaydat;
    }

    public float getTongtien() {
        return tongtien;
    }

    public void setTongtien(float tongtien) {
        this.tongtien = tongtien;
    }

    public float getShip() {
        return ship;
    }

    public void setShip(float ship) {
        this.ship = ship;
    }

    public float getTongkhuyenmai() {
        return tongkhuyenmai;
    }

    public void setTongkhuyenmai(float tongkhuyenmai) {
        this.tongkhuyenmai = tongkhuyenmai;
    }

    public List<DonHangChiTiet> getListdonhang() {
        return listdonhang;
    }

    public void setListdonhang(List<DonHangChiTiet> listdonhang) {
        this.listdonhang = listdonhang;
    }

    public KhachHang getKhachHang() {
        return khachHang;
    }

    public void setKhachHang(KhachHang khachHang) {
        this.khachHang = khachHang;
    }

    public NhanVien getNhanVien() {
        return nhanVien;
    }

    public void setNhanVien(NhanVien nhanVien) {
        this.nhanVien = nhanVien;
    }

    public MaGiamGia getMaGiamGia() {
        return maGiamGia;
    }

    public void setMaGiamGia(MaGiamGia maGiamGia) {
        this.maGiamGia = maGiamGia;
    }
}
