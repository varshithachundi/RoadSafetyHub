package com.traffic.service;

import java.util.List;
import com.traffic.model.Vehicle;

public interface VehicleService {

    boolean addVehicle(Vehicle vehicle);

    Vehicle getVehicleById(int vehicleId);

    List<Vehicle> getAllVehicles();

    List<Vehicle> getVehiclesByOwnerId(int ownerId);

    boolean updateVehicle(Vehicle vehicle);

    boolean deleteVehicle(int vehicleId);
}