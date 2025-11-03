package model;

import java.util.List;

public class GioHang {
    private String id;
    private int tongsanpham;
    private List<GioHangChiTiet> gioHangChiTiet;

    public GioHang(String id, int tongsanpham, List<GioHangChiTiet> gioHangChiTiet) {
        this.id = id;
        this.tongsanpham = tongsanpham;
        this.gioHangChiTiet = gioHangChiTiet;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public int getTongsanpham() {
        return tongsanpham;
    }

    public void setTongsanpham(int tongsanpham) {
        this.tongsanpham = tongsanpham;
    }

    public List<GioHangChiTiet> getGioHangChiTiet() {
        return gioHangChiTiet;
    }

    public void setGioHangChiTiet(List<GioHangChiTiet> gioHangChiTiet) {
        this.gioHangChiTiet = gioHangChiTiet;
    }
}
