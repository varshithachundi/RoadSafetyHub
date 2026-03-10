package com.traffic.controller;

import java.io.IOException;
import com.traffic.model.*;
import com.traffic.service.*;
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
    OwnerService ownerService = new OwnerServiceImpl();
    PoliceService policeService = new PoliceServiceImpl();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // ── LOGIN ──────────────────────────────────────────────
        if (action.equals("login")) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            User user = userService.login(username, password);

            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);

                String role = user.getRole();
                if (role.equalsIgnoreCase("admin")) {
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
                } else if (role.equalsIgnoreCase("police")) {
                    response.sendRedirect(request.getContextPath() + "/police/dashboard.jsp");
                } else if (role.equalsIgnoreCase("owner")) {
                    response.sendRedirect(request.getContextPath() + "/owner/dashboard.jsp");
                } else {
                    response.sendRedirect(request.getContextPath() + "/index.jsp?error=Unknown role");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/index.jsp?error=Invalid username or password");
            }
        }

        // ── REGISTER ───────────────────────────────────────────
        else if (action.equals("register")) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String role     = request.getParameter("role");

            // 1. Create the user account
            User user = new User();
            user.setUsername(username);
            user.setPassword(password);
            user.setRole(role);

            boolean registered = userService.registerUser(user);

            if (!registered) {
                response.sendRedirect(request.getContextPath() + "/index.jsp?error=Registration failed. Username may already exist.");
                return;
            }

            // 2. Fetch the newly created user to get their userId
            User newUser = userService.login(username, password);

            if (newUser != null) {

                // 3a. Auto-create Owner profile
                if (role.equalsIgnoreCase("owner")) {
                    Owner owner = new Owner();
                    owner.setName(username);          // default name = username (admin can update later)
                    owner.setMobile("");
                    owner.setAddress("");
                    owner.setUserId(newUser.getUserId());
                    ownerService.addOwner(owner);
                }

                // 3b. Auto-create Police Officer profile
                else if (role.equalsIgnoreCase("police")) {
                    PoliceOfficer officer = new PoliceOfficer();
                    officer.setName(username);        // default name = username
                    officer.setBadgeNumber("BADGE-" + newUser.getUserId()); // auto badge
                    officer.setUserId(newUser.getUserId());
                    policeService.addPoliceOfficer(officer);
                }
            }

            response.sendRedirect(request.getContextPath() + "/index.jsp?msg=Registration successful! Please login.");
        }

        // ── LOGOUT ─────────────────────────────────────────────
        else if (action.equals("logout")) {
            HttpSession session = request.getSession(false);
            if (session != null) session.invalidate();
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }
}
