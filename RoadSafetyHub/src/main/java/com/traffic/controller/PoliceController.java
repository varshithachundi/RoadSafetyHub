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

		if (action.equals("add")) {
			String name = request.getParameter("name");
			String badgeNumber = request.getParameter("badgeNumber");
			int userId = Integer.parseInt(request.getParameter("userId"));
			PoliceOfficer officer = new PoliceOfficer();
			officer.setName(name);
			officer.setBadgeNumber(badgeNumber);
			officer.setUserId(userId);
			boolean result = policeService.addPoliceOfficer(officer);
			if (result) {
				response.sendRedirect("admin/police.jsp?msg=Officer Added Successfully");
			} else {
				response.sendRedirect("admin/police.jsp?error=Failed to add officer");
			}
		}
		else if (action.equals("update")) {
			int officerId = Integer.parseInt(request.getParameter("officerId"));
			String name = request.getParameter("name");
			String badgeNumber = request.getParameter("badgeNumber");
			PoliceOfficer officer = new PoliceOfficer();
			officer.setOfficerId(officerId);
			officer.setName(name);
			officer.setBadgeNumber(badgeNumber);
			boolean result = policeService.updatePoliceOfficer(officer);
			if (result) {
				response.sendRedirect("admin/police.jsp?msg=Officer Updated Successfully");
			} else {
				response.sendRedirect("admin/police.jsp?error=Update Failed");
			}
		}
		else if (action.equals("delete")) {
			int officerId = Integer.parseInt(request.getParameter("officerId"));
			boolean result = policeService.deletePoliceOfficer(officerId);
			if (result) {
				response.sendRedirect("admin/police.jsp?msg=Officer Deleted Successfully");
			} else {
				response.sendRedirect("admin/police.jsp?error=Delete Failed");
			}
		}
	}
}
