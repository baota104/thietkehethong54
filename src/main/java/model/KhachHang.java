package model;

import java.sql.Date;
import java.util.List;

public class KhachHang extends NguoiDung {
    private int diemtichluy;
    private List<Diachi> diachiList;


    public KhachHang(String id, String vaitro, String ten, String sdt, String email, String password, String ghichu, Date ngaysinh,int diemtichluy) {
        super(id, vaitro, ten, sdt, email, password, ghichu, ngaysinh);
        this.diemtichluy = diemtichluy;
    }

    public int getDiemtichluy() {
        return diemtichluy;
    }

    public void setDiemtichluy(int diemtichluy) {
        this.diemtichluy = diemtichluy;
    }
}
