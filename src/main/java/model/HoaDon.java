package model;

import java.util.Date;

public class HoaDon {
    private String id,phuongthuc,trangthai;
    private Date ngaylap;
    private ThanhToan thanhtoan;
    private DonHang donHang;

    public HoaDon(String id, String phuongthuc, String trangthai, Date ngaylap, ThanhToan thanhtoan, DonHang donHang) {
        this.id = id;
        this.phuongthuc = phuongthuc;
        this.trangthai = trangthai;
        this.ngaylap = ngaylap;
        this.thanhtoan = thanhtoan;
        this.donHang = donHang;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getPhuongthuc() {
        return phuongthuc;
    }

    public void setPhuongthuc(String phuongthuc) {
        this.phuongthuc = phuongthuc;
    }

    public String getTrangthai() {
        return trangthai;
    }

    public void setTrangthai(String trangthai) {
        this.trangthai = trangthai;
    }

    public Date getNgaylap() {
        return ngaylap;
    }

    public void setNgaylap(Date ngaylap) {
        this.ngaylap = ngaylap;
    }

    public ThanhToan getThanhtoan() {
        return thanhtoan;
    }

    public void setThanhtoan(ThanhToan thanhtoan) {
        this.thanhtoan = thanhtoan;
    }

    public DonHang getDonHang() {
        return donHang;
    }

    public void setDonHang(DonHang donHang) {
        this.donHang = donHang;
    }
}
