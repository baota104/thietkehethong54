<%@ page import="java.util.*, DAO.SanPhamDAO, model.SanPham" %>
<%@ page import="jdk.jfr.Category" %>

<%
    request.setCharacterEncoding("UTF-8");
    String search = request.getParameter("search");
    String category = request.getParameter("category");

    SanPhamDAO dao = new SanPhamDAO();
    String dieuKien = dao.suggestConditionByTime(); // Hệ thống tự chọn
    List<SanPham> list = dao.getProductsByCondition(dieuKien);

    if (search != null && !search.isEmpty()) {
        list = dao.searchByName(search);
    } else if (category != null && !category.isEmpty()) {
        list = dao.filterByCategory(category);
    }

    request.setAttribute("products", list);
    request.getRequestDispatcher("giaodienchinh.jsp").forward(request, response);

    String productId = request.getParameter("productId");
    model.NguoiDung user = (model.NguoiDung) session.getAttribute("user");

    if (productId != null && user != null) {
        boolean ok = dao.ThemSPvaoGio(productId, user.getId());
        if (ok) {
            out.println("<p style='color:green'>Thêm vào giỏ hàng thành công!</p>");
        } else {
            out.println("<p style='color:red'>Thêm thất bại!</p>");
        }
    }
%>
