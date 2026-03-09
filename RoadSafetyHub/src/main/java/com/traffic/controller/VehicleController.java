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
        String base = request.getContextPath();

        if (action.equals("add")) {
            Vehicle vehicle = new Vehicle();
            vehicle.setVehicleNumber(request.getParameter("vehicleNumber"));
            vehicle.setVehicleType(request.getParameter("vehicleType"));
            vehicle.setOwnerId(Integer.parseInt(request.getParameter("ownerId")));
            boolean result = vehicleService.addVehicle(vehicle);
            response.sendRedirect(base + (result ? "/owner/myVehicles.jsp?msg=Vehicle Added Successfully" : "/owner/myVehicles.jsp?error=Failed to add vehicle"));
        }
        else if (action.equals("update")) {
            Vehicle vehicle = new Vehicle();
            vehicle.setVehicleId(Integer.parseInt(request.getParameter("vehicleId")));
            vehicle.setVehicleNumber(request.getParameter("vehicleNumber"));
            vehicle.setVehicleType(request.getParameter("vehicleType"));
            boolean result = vehicleService.updateVehicle(vehicle);
            response.sendRedirect(base + (result ? "/owner/myVehicles.jsp?msg=Vehicle Updated Successfully" : "/owner/myVehicles.jsp?error=Update Failed"));
        }
        else if (action.equals("delete")) {
            int vehicleId = Integer.parseInt(request.getParameter("vehicleId"));
            boolean result = vehicleService.deleteVehicle(vehicleId);
            response.sendRedirect(base + (result ? "/owner/myVehicles.jsp?msg=Vehicle Deleted Successfully" : "/owner/myVehicles.jsp?error=Delete Failed"));
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/owner/myVehicles.jsp");
    }
}
