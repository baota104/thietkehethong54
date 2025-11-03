package model;

import java.sql.Date;

public class MaGiamGia {
    private String id,code,mota,dieukienapdung;
    private int soluong;
    private float phantramgiamgia;
    private Date ngaybd,ngaykt;

    public MaGiamGia(String id, String code, String mota, String dieukienapdung, int soluong, float phantramgiamgia, Date ngaybd, Date ngaykt) {
        this.id = id;
        this.code = code;
        this.mota = mota;
        this.dieukienapdung = dieukienapdung;
        this.soluong = soluong;
        this.phantramgiamgia = phantramgiamgia;
        this.ngaybd = ngaybd;
        this.ngaykt = ngaykt;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getMota() {
        return mota;
    }

    public void setMota(String mota) {
        this.mota = mota;
    }

    public String getDieukienapdung() {
        return dieukienapdung;
    }

    public void setDieukienapdung(String dieukienapdung) {
        this.dieukienapdung = dieukienapdung;
    }

    public int getSoluong() {
        return soluong;
    }

    public void setSoluong(int soluong) {
        this.soluong = soluong;
    }

    public float getPhantramgiamgia() {
        return phantramgiamgia;
    }

    public void setPhantramgiamgia(float phantramgiamgia) {
        this.phantramgiamgia = phantramgiamgia;
    }

    public Date getNgaybd() {
        return ngaybd;
    }

    public void setNgaybd(Date ngaybd) {
        this.ngaybd = ngaybd;
    }

    public Date getNgaykt() {
        return ngaykt;
    }

    public void setNgaykt(Date ngaykt) {
        this.ngaykt = ngaykt;
    }
}
