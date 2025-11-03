package model;

public class SanPham {
    private String id,ten,mota,anh,donvi,thuonghieu;
    private float giagoc,giaban,giamgia;
    private int tonkho;
    private TheLoai theloai;

    public SanPham(String id, String ten, String mota, String anh, String donvi, String thuonghieu, float giagoc, float giaban, float giamgia, int tonkho, TheLoai theloai) {
        this.id = id;
        this.ten = ten;
        this.mota = mota;
        this.anh = anh;
        this.donvi = donvi;
        this.thuonghieu = thuonghieu;
        this.giagoc = giagoc;
        this.giaban = giaban;
        this.giamgia = giamgia;
        this.tonkho = tonkho;
        this.theloai = theloai;
    }

    public SanPham() {
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTen() {
        return ten;
    }

    public void setTen(String ten) {
        this.ten = ten;
    }

    public String getMota() {
        return mota;
    }

    public void setMota(String mota) {
        this.mota = mota;
    }

    public String getAnh() {
        return anh;
    }

    public void setAnh(String anh) {
        this.anh = anh;
    }

    public String getDonvi() {
        return donvi;
    }

    public void setDonvi(String donvi) {
        this.donvi = donvi;
    }

    public String getThuonghieu() {
        return thuonghieu;
    }

    public void setThuonghieu(String thuonghieu) {
        this.thuonghieu = thuonghieu;
    }

    public float getGiagoc() {
        return giagoc;
    }

    public void setGiagoc(float giagoc) {
        this.giagoc = giagoc;
    }

    public float getGiaban() {
        return giaban;
    }

    public void setGiaban(float giaban) {
        this.giaban = giaban;
    }

    public float getGiamgia() {
        return giamgia;
    }

    public void setGiamgia(float giamgia) {
        this.giamgia = giamgia;
    }

    public int getTonkho() {
        return tonkho;
    }

    public void setTonkho(int tonkho) {
        this.tonkho = tonkho;
    }

    public TheLoai getTheloai() {
        return theloai;
    }

    public void setTheloai(TheLoai theloai) {
        this.theloai = theloai;
    }
}
