package com.traffic.controller;

import java.io.IOException;

import com.traffic.dao.UserImpl;
import com.traffic.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/UserController")
public class UserController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserImpl userDao = new UserImpl();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        // REGISTER USER
        if (action.equalsIgnoreCase("register")) {

            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String role = request.getParameter("role");

            User user = new User();
            user.setUsername(username);
            user.setPassword(password);
            user.setRole(role);

            boolean status = userDao.registerUser(user);

            if (status) {
                response.sendRedirect("index.jsp?success=registered");
            } else {
                response.sendRedirect("index.jsp?error=registrationFailed");
            }
        }

        // LOGIN USER
        else if (action.equalsIgnoreCase("login")) {

            String username = request.getParameter("username");
            String password = request.getParameter("password");

            User user = userDao.login(username, password);

            if (user != null) {

                HttpSession session = request.getSession();
                session.setAttribute("user", user);

                String role = user.getRole();

                if (role.equalsIgnoreCase("admin")) {
                    response.sendRedirect("admin/dashboard.jsp");
                }
                else if (role.equalsIgnoreCase("police")) {
                    response.sendRedirect("police/dashboard.jsp");
                }
                else if (role.equalsIgnoreCase("owner")) {
                    response.sendRedirect("owner/dashboard.jsp");
                }
            } else {
                response.sendRedirect("index.jsp?error=invalidLogin");
            }
        }
    }
}