package DAO;

import model.NguoiDung;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    private String jdbcURL = "jdbc:mysql://localhost:3306/demo_db?useSSL=false&serverTimezone=UTC";
    private String jdbcUsername = "root";
    private String jdbcPassword = "shanks542"; // đổi theo mật khẩu MySQL của bạn

    private static final String SELECT_ALL_USERS = "SELECT * FROM users";

//    public List<NguoiDung> getAllUsers() {
//        List<NguoiDung> users = new ArrayList<>();
//
//        try {
//            // Đảm bảo driver MySQL được load
//            Class.forName("com.mysql.cj.jdbc.Driver");
//
//            // Kết nối đến DB
//            Connection connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
//
//            PreparedStatement ps = connection.prepareStatement(SELECT_ALL_USERS);
//            ResultSet rs = ps.executeQuery();
//
//            while (rs.next()) {
//                int id = rs.getInt("id");
//                String name = rs.getString("name");
//                String email = rs.getString("email");
//                users.add(new NguoiDung(id, name, email));
//            }
//
//            rs.close();
//            ps.close();
//            connection.close();
//
//        } catch (ClassNotFoundException e) {
//            System.out.println(" Không tìm thấy driver MySQL. Kiểm tra pom.xml hoặc WEB-INF/lib.");
//            e.printStackTrace();
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return users;
//    }

}
