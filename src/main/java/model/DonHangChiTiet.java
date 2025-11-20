package model;

public class DonHangChiTiet {
    private String id,ghichu;
    private float dongia,giamgia,tongtien;
    private int soluong;
    private SanPham sanpham;

    public DonHangChiTiet(String id, String ghichu, float dongia, float giamgia, float tongtien, int soluong, SanPham sanpham) {
        this.id = id;
        this.ghichu = ghichu;
        this.dongia = dongia;
        this.giamgia = giamgia;
        this.tongtien = tongtien;
        this.soluong = soluong;
        this.sanpham = sanpham;
    }
    public DonHangChiTiet() {

    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getGhichu() {
        return ghichu;
    }

    public void setGhichu(String ghichu) {
        this.ghichu = ghichu;
    }

    public float getDongia() {
        return dongia;
    }

    public void setDongia(float dongia) {
        this.dongia = dongia;
    }

    public float getGiamgia() {
        return giamgia;
    }

    public void setGiamgia(float giamgia) {
        this.giamgia = giamgia;
    }

    public float getTongtien() {
        return tongtien;
    }

    public void setTongtien(float tongtien) {
        this.tongtien = tongtien;
    }

    public int getSoluong() {
        return soluong;
    }

    public void setSoluong(int soluong) {
        this.soluong = soluong;
    }

    public SanPham getSanpham() {
        return sanpham;
    }

    public void setSanpham(SanPham sanpham) {
        this.sanpham = sanpham;
    }
}
