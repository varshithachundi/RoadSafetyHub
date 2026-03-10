package com.traffic.dao;

import com.traffic.model.Vehicle;
import java.util.List;

public interface VehicleDAO {
    boolean addVehicle(Vehicle vehicle);
    List<Vehicle> getAllVehicles();
    List<Vehicle> getVehiclesByOwnerId(int ownerId);
    boolean updateVehicle(Vehicle vehicle);
    boolean deleteVehicle(int vehicleId);
}
