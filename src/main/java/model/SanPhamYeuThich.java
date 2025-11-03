package model;

import java.util.List;

public class SanPhamYeuThich {
    private String id;
    private int tongsanpham;
    private List<SanPhamYeuThichChiTiet> sanPhamYeuThichChiTiet;

    public SanPhamYeuThich(String id, int tongsanpham, List<SanPhamYeuThichChiTiet> sanPhamYeuThichChiTiet) {
        this.id = id;
        this.tongsanpham = tongsanpham;
        this.sanPhamYeuThichChiTiet = sanPhamYeuThichChiTiet;
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

    public List<SanPhamYeuThichChiTiet> getSanPhamYeuThichChiTiet() {
        return sanPhamYeuThichChiTiet;
    }

    public void setSanPhamYeuThichChiTiet(List<SanPhamYeuThichChiTiet> sanPhamYeuThichChiTiet) {
        this.sanPhamYeuThichChiTiet = sanPhamYeuThichChiTiet;
    }
}
