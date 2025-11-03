package model;

public class SanPhamYeuThichChiTiet {
    private String id;
    private SanPham sanpham;

    public SanPhamYeuThichChiTiet(String id, SanPham sanpham) {
        this.id = id;
        this.sanpham = sanpham;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public SanPham getSanpham() {
        return sanpham;
    }

    public void setSanpham(SanPham sanpham) {
        this.sanpham = sanpham;
    }
}
