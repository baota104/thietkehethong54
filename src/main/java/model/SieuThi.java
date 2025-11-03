package model;

import java.util.List;

public class SieuThi {
    private String id,ten,diachi,mota;
    private List<SanPham> listSanPham;

    public SieuThi(String id, String ten, String diachi, String mota, List<SanPham> listSanPham) {
        this.id = id;
        this.ten = ten;
        this.diachi = diachi;
        this.mota = mota;
        this.listSanPham = listSanPham;
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

    public String getDiachi() {
        return diachi;
    }

    public void setDiachi(String diachi) {
        this.diachi = diachi;
    }

    public String getMota() {
        return mota;
    }

    public void setMota(String mota) {
        this.mota = mota;
    }
}
