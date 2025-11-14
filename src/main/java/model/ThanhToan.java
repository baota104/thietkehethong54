package model;

import java.sql.Date;

public class ThanhToan {
    private String id,phuongthuc,trangthai,QR,ghichu;
    private Date ngaythanhtoan;
    private float tongtien;

    public ThanhToan(String id, String phuongthuc, String trangthai, String QR, String ghichu, Date ngaythanhtoan, float tongtien) {
        this.id = id;
        this.phuongthuc = phuongthuc;
        this.trangthai = trangthai;
        this.QR = QR;
        this.ghichu = ghichu;
        this.ngaythanhtoan = ngaythanhtoan;
        this.tongtien = tongtien;
    }
    public ThanhToan(){

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

    public String getQR() {
        return QR;
    }

    public void setQR(String QR) {
        this.QR = QR;
    }

    public String getGhichu() {
        return ghichu;
    }

    public void setGhichu(String ghichu) {
        this.ghichu = ghichu;
    }

    public Date getNgaythanhtoan() {
        return ngaythanhtoan;
    }

    public void setNgaythanhtoan(Date ngaythanhtoan) {
        this.ngaythanhtoan = ngaythanhtoan;
    }

    public float getTongtien() {
        return tongtien;
    }

    public void setTongtien(float tongtien) {
        this.tongtien = tongtien;
    }
}
