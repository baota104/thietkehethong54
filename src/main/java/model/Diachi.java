package model;

public class Diachi {
    private String id,diachichitiet,idkh;

    public Diachi() {
    }

    public String getId() {
        return id;
    }

    public String getIdkh() {
        return idkh;
    }

    public void setIdkh(String idkh) {
        this.idkh = idkh;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getDiachichitiet() {
        return diachichitiet;
    }

    public void setDiachichitiet(String diachichitiet) {
        this.diachichitiet = diachichitiet;
    }

    public Diachi(String id, String diachichitiet) {
        this.id = id;
        this.diachichitiet = diachichitiet;
    }
}
