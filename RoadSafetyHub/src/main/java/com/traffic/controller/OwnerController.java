package com.traffic.controller;
import java.io.IOException;
import com.traffic.model.Owner;
import com.traffic.service.OwnerService;
import com.traffic.service.OwnerServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/OwnerController")
public class OwnerController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	OwnerService ownerService = new OwnerServiceImpl();

	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		String action = request.getParameter("action");

		if (action.equals("add")) {
			String name = request.getParameter("name");
			String mobile = request.getParameter("mobile");
			String address = request.getParameter("address");
			int userId = Integer.parseInt(request.getParameter("userId"));
			Owner owner = new Owner();
			owner.setName(name);
			owner.setMobile(mobile);
			owner.setAddress(address);
			owner.setUserId(userId);
			boolean result = ownerService.addOwner(owner);
			if (result) {
				response.sendRedirect("admin/owners.jsp?msg=Owner Added Successfully");
			} else {
				response.sendRedirect("admin/owners.jsp?error=Failed to add owner");
			}
		}
		else if (action.equals("update")) {
			int ownerId = Integer.parseInt(request.getParameter("ownerId"));
			String name = request.getParameter("name");
			String mobile = request.getParameter("mobile");
			String address = request.getParameter("address");
			Owner owner = new Owner();
			owner.setOwnerId(ownerId);
			owner.setName(name);
			owner.setMobile(mobile);
			owner.setAddress(address);
			boolean result = ownerService.updateOwner(owner);
			if (result) {
				response.sendRedirect("admin/owners.jsp?msg=Owner Updated Successfully");
			} else {
				response.sendRedirect("admin/owners.jsp?error=Update Failed");
			}
		}
		else if (action.equals("delete")) {
			int ownerId = Integer.parseInt(request.getParameter("ownerId"));
			boolean result = ownerService.deleteOwner(ownerId);
			if (result) {
				response.sendRedirect("admin/owners.jsp?msg=Owner Deleted Successfully");
			} else {
				response.sendRedirect("admin/owners.jsp?error=Delete Failed");
			}
		}
	}
}
