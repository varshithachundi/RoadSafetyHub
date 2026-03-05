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

        if (action.equals("register")) {

            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String role = request.getParameter("role");

            User user = new User();
            user.setUsername(username);
            user.setPassword(password);
            user.setRole(role);

            boolean status = userDao.registerUser(user);

            if (status) {
                response.sendRedirect("login.jsp");
            } else {
                response.sendRedirect("register.jsp?error=Registration Failed");
            }
        }

        else if (action.equals("login")) {

            String username = request.getParameter("username");
            String password = request.getParameter("password");

            User user = userDao.login(username, password);

            if (user != null) {

                HttpSession session = request.getSession();
                session.setAttribute("user", user);

                String role = user.getRole();

                if (role.equalsIgnoreCase("ADMIN")) {
                    response.sendRedirect("adminDashboard.jsp");
                }

                else if (role.equalsIgnoreCase("POLICE")) {
                    response.sendRedirect("policeDashboard.jsp");
                }

                else if (role.equalsIgnoreCase("OWNER")) {
                    response.sendRedirect("ownerDashboard.jsp");
                }

            } else {
                response.sendRedirect("login.jsp?error=Invalid Credentials");
            }
        }
    }
}