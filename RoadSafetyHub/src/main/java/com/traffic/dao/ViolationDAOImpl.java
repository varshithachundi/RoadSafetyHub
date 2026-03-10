package com.traffic.dao;

import com.traffic.model.Violation;
import com.traffic.utility.DBConnection;
import java.sql.*;
import java.util.*;

public class ViolationDAOImpl implements ViolationDAO {

    @Override
    public boolean addViolation(Violation violation) {
        String sql = "INSERT INTO violations (vehicle_id, rule_id, officer_id, violation_date, payment_status) VALUES (?, ?, ?, NOW(), ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, violation.getVehicleId());
            ps.setInt(2, violation.getRuleId());
            ps.setInt(3, violation.getOfficerId());
            ps.setString(4, "UNPAID");
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<Violation> getAllViolations() {
        List<Violation> list = new ArrayList<>();
        String sql = "SELECT * FROM violations ORDER BY violation_id DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Violation v = new Violation();
                v.setViolationId(rs.getInt("violation_id"));
                v.setVehicleId(rs.getInt("vehicle_id"));
                v.setRuleId(rs.getInt("rule_id"));
                v.setOfficerId(rs.getInt("officer_id"));
                v.setViolationDate(rs.getTimestamp("violation_date"));
                v.setPaymentStatus(rs.getString("payment_status"));
                list.add(v);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Violation getViolationById(int violationId) {
        String sql = "SELECT * FROM violations WHERE violation_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, violationId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Violation v = new Violation();
                v.setViolationId(rs.getInt("violation_id"));
                v.setVehicleId(rs.getInt("vehicle_id"));
                v.setRuleId(rs.getInt("rule_id"));
                v.setOfficerId(rs.getInt("officer_id"));
                v.setViolationDate(rs.getTimestamp("violation_date"));
                v.setPaymentStatus(rs.getString("payment_status"));
                return v;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean payFine(int violationId) {
        String sql = "UPDATE violations SET payment_status = 'PAID' WHERE violation_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, violationId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean deleteViolation(int violationId) {
        String sql = "DELETE FROM violations WHERE violation_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, violationId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
