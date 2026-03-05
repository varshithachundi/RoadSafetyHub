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

		// ADD POLICE OFFICER
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
				response.sendRedirect("admin/policeList.jsp?msg=Police Added");
			} else {
				response.sendRedirect("admin/addPolice.jsp?error=Failed");
			}
		}

		// UPDATE POLICE
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
				response.sendRedirect("admin/policeList.jsp?msg=Updated");
			} else {
				response.sendRedirect("admin/editPolice.jsp?error=Failed");
			}
		}

		// DELETE POLICE
		else if (action.equals("delete")) {
			int officerId = Integer.parseInt(request.getParameter("officerId"));
			boolean result = policeService.deletePoliceOfficer(officerId);
			if (result) {
				response.sendRedirect("admin/policeList.jsp?msg=Deleted");
			} else {
				response.sendRedirect("admin/policeList.jsp?error=Failed");
			}
		}
	}
}