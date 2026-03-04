package com.traffic.service;

import java.util.List;

import com.traffic.dao.VehicleInterface;
import com.traffic.dao.VehicleImpl;
import com.traffic.model.Vehicle;

public class VehicleServiceImpl implements VehicleService {

    private VehicleInterface vehicleDAO;

    public VehicleServiceImpl() {
        vehicleDAO = new VehicleImpl();
    }

    @Override
    public boolean addVehicle(Vehicle vehicle) {
        if (vehicle.getVehicleNumber() == null || vehicle.getVehicleNumber().trim().isEmpty()) {
            return false;
        }
        return vehicleDAO.addVehicle(vehicle);
    }

    @Override
    public Vehicle getVehicleById(int vehicleId) {
        return vehicleDAO.getVehicleById(vehicleId);
    }

    @Override
    public List<Vehicle> getAllVehicles() {
        return vehicleDAO.getAllVehicles();
    }

    @Override
    public List<Vehicle> getVehiclesByOwnerId(int ownerId) {
        return vehicleDAO.getVehiclesByOwnerId(ownerId);
    }

    @Override
    public boolean updateVehicle(Vehicle vehicle) {
        return vehicleDAO.updateVehicle(vehicle);
    }

    @Override
    public boolean deleteVehicle(int vehicleId) {
        return vehicleDAO.deleteVehicle(vehicleId);
    }
}