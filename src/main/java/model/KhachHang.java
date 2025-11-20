package model;

import java.sql.Date;
import java.util.List;

public class KhachHang extends NguoiDung {
    private int diemtichluy;
    private List<Diachi> diachiList;
    private GioHang gioHang;


    public KhachHang(String id, String vaitro, String ten, String sdt, String email, String password, String ghichu, Date ngaysinh,int diemtichluy) {
        super(id, vaitro, ten, sdt, email, password, ghichu, ngaysinh);
        this.diemtichluy = diemtichluy;
    }

    public GioHang getGioHang() {
        return gioHang;
    }

    public void setGioHang(GioHang gioHang) {
        this.gioHang = gioHang;
    }

    public KhachHang(){

    }


    public int getDiemtichluy() {
        return diemtichluy;
    }

    public void setDiemtichluy(int diemtichluy) {
        this.diemtichluy = diemtichluy;
    }

    public List<Diachi> getDiachiList() {
        return diachiList;
    }

    public void setDiachiList(List<Diachi> diachiList) {
        this.diachiList = diachiList;
    }

    @Override
    public String toString() {
        return "KhachHang{" +
                "diemtichluy=" + diemtichluy +
                ", diachiList=" + diachiList +
                '}';
    }
}
