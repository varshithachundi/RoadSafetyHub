package com.traffic.controller;

import java.io.IOException;
import java.util.List;
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
        String base = request.getContextPath();

        // ── LOGIN ──────────────────────────────────────────────
        if (action.equals("login")) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            User user = userService.login(username, password);
            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                String role = user.getRole();
                if (role.equalsIgnoreCase("admin"))
                    response.sendRedirect(base + "/admin/dashboard.jsp");
                else if (role.equalsIgnoreCase("police"))
                    response.sendRedirect(base + "/police/dashboard.jsp");
                else if (role.equalsIgnoreCase("owner"))
                    response.sendRedirect(base + "/owner/dashboard.jsp");
                else
                    response.sendRedirect(base + "/index.jsp?error=Unknown role");
            } else {
                response.sendRedirect(base + "/index.jsp?error=Invalid username or password");
            }
        }

        // ── VEHICLE NUMBER LOGIN (guest or registered) ─────────
        else if (action.equals("vehicleLogin")) {
            String vehicleNumber = request.getParameter("vehicleNumber").trim().toUpperCase();

            // Find vehicle in DB
            VehicleService vehicleService = new VehicleServiceImpl();
            Vehicle foundVehicle = null;
            for (Vehicle v : vehicleService.getAllVehicles()) {
                if (v.getVehicleNumber().equalsIgnoreCase(vehicleNumber)) {
                    foundVehicle = v;
                    break;
                }
            }

            if (foundVehicle == null) {
                response.sendRedirect(base + "/index.jsp?error=Vehicle number " + vehicleNumber + " not found in system.");
                return;
            }

            // Store vehicle info in session as a guest
            HttpSession session = request.getSession();
            session.setAttribute("guestVehicle", foundVehicle);
            session.setAttribute("guestVehicleNumber", vehicleNumber);

            // If owner is registered and linked, also load owner info
            Owner linkedOwner = null;
            for (Owner o : ownerService.getAllOwners()) {
                if (o.getOwnerId() == foundVehicle.getOwnerId()) {
                    linkedOwner = o;
                    break;
                }
            }
            if (linkedOwner != null) session.setAttribute("guestOwner", linkedOwner);

            response.sendRedirect(base + "/owner/vehicleViolations.jsp");
        }

        // ── REGISTER ───────────────────────────────────────────
        else if (action.equals("register")) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String role     = request.getParameter("role");

            User user = new User();
            user.setUsername(username);
            user.setPassword(password);
            user.setRole(role);

            boolean registered = userService.registerUser(user);
            if (!registered) {
                response.sendRedirect(base + "/index.jsp?error=Registration failed. Username may already exist.");
                return;
            }

            User newUser = userService.login(username, password);
            if (newUser != null) {
                if (role.equalsIgnoreCase("owner")) {
                    Owner owner = new Owner();
                    owner.setName(username);
                    owner.setMobile("");
                    owner.setAddress("");
                    owner.setUserId(newUser.getUserId());
                    ownerService.addOwner(owner);
                } else if (role.equalsIgnoreCase("police")) {
                    PoliceOfficer officer = new PoliceOfficer();
                    officer.setName(username);
                    officer.setBadgeNumber("BADGE-" + newUser.getUserId());
                    officer.setUserId(newUser.getUserId());
                    policeService.addPoliceOfficer(officer);
                }
            }
            response.sendRedirect(base + "/index.jsp?msg=Registration successful! Please login.");
        }

        // ── LOGOUT ─────────────────────────────────────────────
        else if (action.equals("logout")) {
            HttpSession session = request.getSession(false);
            if (session != null) session.invalidate();
            response.sendRedirect(base + "/index.jsp");
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
