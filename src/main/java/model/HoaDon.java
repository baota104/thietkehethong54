package model;

import java.util.Date;

public class HoaDon {
    private String id;
    private ThanhToan thanhtoan;
    private DonHang donHang;

    public HoaDon(String id, ThanhToan thanhtoan, DonHang donHang) {
        this.id = id;
        this.thanhtoan = thanhtoan;
        this.donHang = donHang;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
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
