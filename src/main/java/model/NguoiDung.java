package model;

import java.sql.Date;

public class NguoiDung {
    private String id,vaitro,ten,sdt,email,password,ghichu;
    private Date ngaysinh;

    public NguoiDung() {
    }

    public NguoiDung(String id, String vaitro, String ten, String sdt, String email, String password, String ghichu, Date ngaysinh) {
        this.id = id;
        this.vaitro = vaitro;
        this.ten = ten;
        this.sdt = sdt;
        this.email = email;
        this.password = password;
        this.ghichu = ghichu;
        this.ngaysinh = ngaysinh;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getVaitro() {
        return vaitro;
    }

    public void setVaitro(String vaitro) {
        this.vaitro = vaitro;
    }

    public String getTen() {
        return ten;
    }

    public void setTen(String ten) {
        this.ten = ten;
    }

    public String getSdt() {
        return sdt;
    }

    public void setSdt(String sdt) {
        this.sdt = sdt;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getGhichu() {
        return ghichu;
    }

    public void setGhichu(String ghichu) {
        this.ghichu = ghichu;
    }

    public Date getNgaysinh() {
        return ngaysinh;
    }

    public void setNgaysinh(Date ngaysinh) {
        this.ngaysinh = ngaysinh;
    }
}
