<%@ page import="DAO.NguoiDungDAO, model.NguoiDung" %>
<%@ page import="model.KhachHang" %>
<%@ page import="DAO.KhachHangDAO" %>
<%@ page import="model.NhanVien" %>
<%@ page import="DAO.NhanVienDAO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%
    String sdt = request.getParameter("sdt");
    String matkhau = request.getParameter("matkhau");
    NguoiDungDAO dao = new NguoiDungDAO();
    NguoiDung nd = new NguoiDung();
    nd.setSdt(sdt);
    nd.setPassword(matkhau);
    boolean ok = dao.DangNhap(nd);
    session.setAttribute("nguoidung", nd);
    if (ok && (nd.getVaitro().equalsIgnoreCase("khachhang"))){
        KhachHang kh =  (new KhachHangDAO()).getTTKhachHang(nd.getId());
        session.setAttribute("khachhang", kh);
        response.sendRedirect("GDChinhKhachHang.jsp");
    }
    else if(ok && (nd.getVaitro().equalsIgnoreCase("nhanvien"))){
        NhanVien nv = (new NhanVienDAO()).getTTNhanVien(nd.getId());
        session.setAttribute("nhanvien",nv);
        response.sendRedirect("GDChinhNV.jsp");
    }
    else {
        response.sendRedirect("thongbao.jsp?msg=Đăng nhập thất bại!");
    }
%>
