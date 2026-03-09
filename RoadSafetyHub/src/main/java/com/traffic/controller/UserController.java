package com.traffic.controller;

import java.io.IOException;
import com.traffic.model.User;
import com.traffic.service.UserService;
import com.traffic.service.UserServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/UserController")
public class UserController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    UserService userService = new UserServiceImpl();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action.equals("login")) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            User user = userService.login(username, password);

            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);

                String role = user.getRole();
                if (role.equalsIgnoreCase("admin")) {
                    response.sendRedirect("admin/dashboard.jsp");
                } else if (role.equalsIgnoreCase("police")) {
                    response.sendRedirect("police/dashboard.jsp");
                } else if (role.equalsIgnoreCase("owner")) {
                    response.sendRedirect("owner/dashboard.jsp");
                } else {
                    response.sendRedirect("index.jsp?error=Unknown role");
                }
            } else {
                response.sendRedirect("index.jsp?error=Invalid username or password");
            }
        }

        else if (action.equals("register")) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String role = request.getParameter("role");

            User user = new User();
            user.setUsername(username);
            user.setPassword(password);
            user.setRole(role);

            boolean result = userService.registerUser(user);
            if (result) {
                response.sendRedirect("index.jsp?msg=Registration successful! Please login.");
            } else {
                response.sendRedirect("index.jsp?error=Registration failed. Username may already exist.");
            }
        }

        else if (action.equals("logout")) {
            HttpSession session = request.getSession(false);
            if (session != null) session.invalidate();
            response.sendRedirect("index.jsp");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) session.invalidate();
        }
        response.sendRedirect("index.jsp");
    }
}
