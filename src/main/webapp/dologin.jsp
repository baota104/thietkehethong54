<%@ page import="DAO.NguoiDungDAO, model.NguoiDung" %>
<%
    String sdt = request.getParameter("sdt");
    String matkhau = request.getParameter("matkhau");

    NguoiDungDAO dao = new NguoiDungDAO();
    NguoiDung user = dao.DangNhap(sdt, matkhau);

    if (user != null) {
        session.setAttribute("user", user);
        response.sendRedirect("dogiaodienchinh.jsp");
    } else {
        response.sendRedirect("thongbao.jsp?msg=Đăng nhập thất bại!");
    }
%>
