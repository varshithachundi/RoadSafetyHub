package com.traffic.controller;

import java.io.IOException;
import com.traffic.model.Violation;
import com.traffic.service.ViolationService;
import com.traffic.service.ViolationServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ViolationController")
public class ViolationController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    ViolationService violationService = new ViolationServiceImpl();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String base = request.getContextPath();

        if (action.equals("add")) {
            Violation violation = new Violation();
            violation.setVehicleId(Integer.parseInt(request.getParameter("vehicleId")));
            violation.setRuleId(Integer.parseInt(request.getParameter("ruleId")));
            violation.setOfficerId(Integer.parseInt(request.getParameter("officerId")));
            violation.setPaymentStatus("UNPAID");
            boolean result = violationService.addViolation(violation);
            response.sendRedirect(base + (result ? "/police/violationList.jsp?msg=Violation Added Successfully" : "/police/addViolation.jsp?error=Failed to add violation"));
        }
        else if (action.equals("pay")) {
            int violationId = Integer.parseInt(request.getParameter("violationId"));
            boolean result = violationService.payFine(violationId);
            response.sendRedirect(base + (result ? "/owner/myViolations.jsp?msg=Fine Paid Successfully" : "/owner/myViolations.jsp?error=Payment Failed"));
        }
        else if (action.equals("delete")) {
            int violationId = Integer.parseInt(request.getParameter("violationId"));
            boolean result = violationService.deleteViolation(violationId);
            response.sendRedirect(base + (result ? "/admin/violations.jsp?msg=Violation Deleted" : "/admin/violations.jsp?error=Delete Failed"));
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/admin/violations.jsp");
    }
}
