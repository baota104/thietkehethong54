<%@ page import="DAO.GioHangDAO, model.GioHangChiTiet, model.NguoiDung" %>

<%
    request.setCharacterEncoding("UTF-8");
    NguoiDung user = (NguoiDung) session.getAttribute("user");

    GioHangDAO dao = new GioHangDAO();
    String action = request.getParameter("action");

    if ("delete".equals(action)) {
        String idChiTiet = request.getParameter("idChiTiet");
        dao.XoaSanPham(idChiTiet);

    } else if ("update".equals(action)) {
        String idChiTiet = request.getParameter("idChiTiet");
        String change = request.getParameter("change");
        boolean tang = "increase".equals(change);

        int soluong = Integer.parseInt(request.getParameter("soluong"));
        GioHangChiTiet item = new GioHangChiTiet(idChiTiet, 0, 0, soluong, null);

        dao.DieuChinhSl(item, tang);
    }

    // Sau khi xử lý, load lại danh sách sản phẩm
    request.setAttribute("cartItems", dao.getSPGioHang(user.getId()));
    request.getRequestDispatcher("giohang.jsp").forward(request, response);
%>
