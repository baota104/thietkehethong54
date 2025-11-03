package DAO;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DAO {
    protected static Connection con = null;

    public DAO() {
        if (con == null) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/sieuthi_db", "root", "shanks542");
                System.out.println(" Kết nối DB thành công");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
