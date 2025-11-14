package model;

public class GioHangChiTiet {
    private String id;
    private float giaban,tongtien;
    private int soluong;
    private SanPham sanPham;

    public GioHangChiTiet(String id, float giaban, float tongtien, int soluong, SanPham sanPham) {
        this.id = id;
        this.giaban = giaban;
        this.tongtien = tongtien;
        this.soluong = soluong;
        this.sanPham = sanPham;
    }
    public GioHangChiTiet(){

    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public float getGiaban() {
        return giaban;
    }

    public void setGiaban(float giaban) {
        this.giaban = giaban;
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

    public SanPham getSanPham() {
        return sanPham;
    }

    public void setSanPham(SanPham sanPham) {
        this.sanPham = sanPham;
    }
}
