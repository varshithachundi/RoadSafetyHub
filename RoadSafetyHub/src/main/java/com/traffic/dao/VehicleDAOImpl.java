package com.traffic.dao;

import com.traffic.model.Vehicle;
import com.traffic.utility.DBConnection;
import java.sql.*;
import java.util.*;

public class VehicleDAOImpl implements VehicleDAO {

    @Override
    public boolean addVehicle(Vehicle vehicle) {
        String sql = "INSERT INTO vehicle (vehicle_number, vehicle_type, owner_id) VALUES (?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, vehicle.getVehicleNumber());
            ps.setString(2, vehicle.getVehicleType());
            ps.setInt(3, vehicle.getOwnerId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<Vehicle> getAllVehicles() {
        List<Vehicle> list = new ArrayList<>();
        String sql = "SELECT * FROM vehicle ORDER BY vehicle_id DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Vehicle v = new Vehicle();
                v.setVehicleId(rs.getInt("vehicle_id"));
                v.setVehicleNumber(rs.getString("vehicle_number"));
                v.setVehicleType(rs.getString("vehicle_type"));
                v.setOwnerId(rs.getInt("owner_id"));
                list.add(v);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Vehicle> getVehiclesByOwnerId(int ownerId) {
        List<Vehicle> list = new ArrayList<>();
        String sql = "SELECT * FROM vehicle WHERE owner_id = ? ORDER BY vehicle_id DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Vehicle v = new Vehicle();
                v.setVehicleId(rs.getInt("vehicle_id"));
                v.setVehicleNumber(rs.getString("vehicle_number"));
                v.setVehicleType(rs.getString("vehicle_type"));
                v.setOwnerId(rs.getInt("owner_id"));
                list.add(v);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean updateVehicle(Vehicle vehicle) {
        String sql = "UPDATE vehicle SET vehicle_number=?, vehicle_type=? WHERE vehicle_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, vehicle.getVehicleNumber());
            ps.setString(2, vehicle.getVehicleType());
            ps.setInt(3, vehicle.getVehicleId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean deleteVehicle(int vehicleId) {
        String sql = "DELETE FROM vehicle WHERE vehicle_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, vehicleId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
