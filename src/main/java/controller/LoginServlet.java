//package controller;
//
//import DAO.UserDAO;
//import jakarta.servlet.*;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.*;
//import java.io.IOException;
//
//@WebServlet("/login")
//public class LoginServlet extends HttpServlet {
//    private UserDAO userDAO = new UserDAO();
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        String name = request.getParameter("name");
//        String email = request.getParameter("email");
//
//        boolean isValid = userDAO.validateUser(name, email);
//
//        if (isValid) {
//            HttpSession session = request.getSession();
//            session.setAttribute("username", name);
//            response.sendRedirect("index.jsp");
//        } else {
//            request.setAttribute("error", "Sai tên hoặc email!");
//            request.getRequestDispatcher("error.jsp").forward(request, response);
//        }
//    }
//}
