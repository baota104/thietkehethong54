package model;

import java.sql.Date;

public class NhanVien extends NguoiDung {
    private String vitri;
    public NhanVien(String id, String vaitro, String ten, String sdt, String email, String password, String ghichu, Date ngaysinh,String vitri) {
        super(id, vaitro, ten, sdt, email, password, ghichu, ngaysinh);
        this.vitri = vitri;
    }

    public String getVitri() {
        return vitri;
    }

    public void setVitri(String vitri) {
        this.vitri = vitri;
    }
}
