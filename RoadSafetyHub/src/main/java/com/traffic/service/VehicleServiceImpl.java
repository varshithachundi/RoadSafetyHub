package com.traffic.service;

import com.traffic.dao.VehicleDAO;
import com.traffic.dao.VehicleDAOImpl;
import com.traffic.model.Vehicle;
import java.util.List;

public class VehicleServiceImpl implements VehicleService {

    VehicleDAO dao = new VehicleDAOImpl();

    @Override
    public boolean addVehicle(Vehicle vehicle) {
        return dao.addVehicle(vehicle);
    }

    @Override
    public List<Vehicle> getAllVehicles() {
        return dao.getAllVehicles();
    }

    @Override
    public List<Vehicle> getVehiclesByOwnerId(int ownerId) {
        return dao.getVehiclesByOwnerId(ownerId);
    }

    @Override
    public boolean updateVehicle(Vehicle vehicle) {
        return dao.updateVehicle(vehicle);
    }

    @Override
    public boolean deleteVehicle(int vehicleId) {
        return dao.deleteVehicle(vehicleId);
    }
}
