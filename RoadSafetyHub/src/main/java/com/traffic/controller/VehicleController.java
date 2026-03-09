package com.traffic.controller;
import java.io.IOException;
import com.traffic.model.Vehicle;
import com.traffic.service.VehicleService;
import com.traffic.service.VehicleServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/vehicle")
public class VehicleController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	VehicleService vehicleService = new VehicleServiceImpl();

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");

		if (action.equals("add")) {
			String vehicleNumber = request.getParameter("vehicleNumber");
			String vehicleType = request.getParameter("vehicleType");
			int ownerId = Integer.parseInt(request.getParameter("ownerId"));
			Vehicle vehicle = new Vehicle();
			vehicle.setVehicleNumber(vehicleNumber);
			vehicle.setVehicleType(vehicleType);
			vehicle.setOwnerId(ownerId);
			boolean result = vehicleService.addVehicle(vehicle);
			if (result) {
				response.sendRedirect("owner/myVehicles.jsp?msg=Vehicle Added Successfully");
			} else {
				response.sendRedirect("owner/myVehicles.jsp?error=Failed to add vehicle");
			}
		}
		else if (action.equals("update")) {
			int vehicleId = Integer.parseInt(request.getParameter("vehicleId"));
			String vehicleNumber = request.getParameter("vehicleNumber");
			String vehicleType = request.getParameter("vehicleType");
			Vehicle vehicle = new Vehicle();
			vehicle.setVehicleId(vehicleId);
			vehicle.setVehicleNumber(vehicleNumber);
			vehicle.setVehicleType(vehicleType);
			boolean result = vehicleService.updateVehicle(vehicle);
			if (result) {
				response.sendRedirect("owner/myVehicles.jsp?msg=Vehicle Updated Successfully");
			} else {
				response.sendRedirect("owner/myVehicles.jsp?error=Update Failed");
			}
		}
		else if (action.equals("delete")) {
			int vehicleId = Integer.parseInt(request.getParameter("vehicleId"));
			boolean result = vehicleService.deleteVehicle(vehicleId);
			if (result) {
				response.sendRedirect("owner/myVehicles.jsp?msg=Vehicle Deleted Successfully");
			} else {
				response.sendRedirect("owner/myVehicles.jsp?error=Delete Failed");
			}
		}
	}
}
