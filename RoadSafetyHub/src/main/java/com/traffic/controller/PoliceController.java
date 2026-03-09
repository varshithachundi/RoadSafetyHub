package com.traffic.controller;

import java.io.IOException;
import com.traffic.model.PoliceOfficer;
import com.traffic.service.PoliceService;
import com.traffic.service.PoliceServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/PoliceController")
public class PoliceController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    PoliceService policeService = new PoliceServiceImpl();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String base = request.getContextPath();

        if (action.equals("add")) {
            PoliceOfficer officer = new PoliceOfficer();
            officer.setName(request.getParameter("name"));
            officer.setBadgeNumber(request.getParameter("badgeNumber"));
            officer.setUserId(Integer.parseInt(request.getParameter("userId")));
            boolean result = policeService.addPoliceOfficer(officer);
            response.sendRedirect(base + (result ? "/admin/police.jsp?msg=Officer Added Successfully" : "/admin/police.jsp?error=Failed to add officer"));
        }
        else if (action.equals("update")) {
            PoliceOfficer officer = new PoliceOfficer();
            officer.setOfficerId(Integer.parseInt(request.getParameter("officerId")));
            officer.setName(request.getParameter("name"));
            officer.setBadgeNumber(request.getParameter("badgeNumber"));
            boolean result = policeService.updatePoliceOfficer(officer);
            response.sendRedirect(base + (result ? "/admin/police.jsp?msg=Officer Updated Successfully" : "/admin/police.jsp?error=Update Failed"));
        }
        else if (action.equals("delete")) {
            int officerId = Integer.parseInt(request.getParameter("officerId"));
            boolean result = policeService.deletePoliceOfficer(officerId);
            response.sendRedirect(base + (result ? "/admin/police.jsp?msg=Officer Deleted Successfully" : "/admin/police.jsp?error=Delete Failed"));
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/admin/police.jsp");
    }
}
