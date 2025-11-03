package model;

public class Diachi {
    private String id,diachichitiet;

    public String getId() {
        return id;
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
