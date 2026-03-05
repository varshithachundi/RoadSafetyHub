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

		// ADD VEHICLE
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
				response.sendRedirect("owner/vehicleList.jsp?msg=Vehicle Added");
			} else {
				response.sendRedirect("owner/addVehicle.jsp?error=Failed");
			}
		}

		// UPDATE VEHICLE
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
				response.sendRedirect("owner/vehicleList.jsp?msg=Updated");
			} else {
				response.sendRedirect("owner/editVehicle.jsp?error=Failed");
			}
		}

		// DELETE VEHICLE
		else if (action.equals("delete")) {
			int vehicleId = Integer.parseInt(request.getParameter("vehicleId"));
			boolean result = vehicleService.deleteVehicle(vehicleId);
			if (result) {
				response.sendRedirect("owner/vehicleList.jsp?msg=Deleted");
			} else {
				response.sendRedirect("owner/vehicleList.jsp?error=Failed");
			}
		}
	}
}