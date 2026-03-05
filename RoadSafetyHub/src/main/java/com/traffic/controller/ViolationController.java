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

		// ADD VIOLATION
		if (action.equals("add")) {

			int vehicleId = Integer.parseInt(request.getParameter("vehicleId"));
			int ruleId = Integer.parseInt(request.getParameter("ruleId"));
			int officerId = Integer.parseInt(request.getParameter("officerId"));

			Violation violation = new Violation();
			violation.setVehicleId(vehicleId);
			violation.setRuleId(ruleId);
			violation.setOfficerId(officerId);

			boolean result = violationService.addViolation(violation);

			if (result) {
				response.sendRedirect("police/violationList.jsp?msg=Violation Added");
			} else {
				response.sendRedirect("police/addViolation.jsp?error=Failed");
			}
		}

		// PAY FINE
		else if (action.equals("pay")) {

			int violationId = Integer.parseInt(request.getParameter("violationId"));

			boolean result = violationService.payFine(violationId);

			if (result) {
				response.sendRedirect("owner/myViolations.jsp?msg=Fine Paid");
			} else {
				response.sendRedirect("owner/myViolations.jsp?error=Payment Failed");
			}
		}

		// DELETE VIOLATION
		else if (action.equals("delete")) {

			int violationId = Integer.parseInt(request.getParameter("violationId"));

			boolean result = violationService.deleteViolation(violationId);

			if (result) {
				response.sendRedirect("admin/violationList.jsp?msg=Deleted");
			} else {
				response.sendRedirect("admin/violationList.jsp?error=Failed");
			}
		}
	}
}