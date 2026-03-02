package com.traffic.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.traffic.model.Violation;
import com.traffic.utility.DBConnection;

public class ViolationImpl implements ViolationInterface {
	private Connection con;

	public void ViolationsDAOImpl() {
		con = DBConnection.getConnection();
	}

	@Override
	public boolean addViolation(Violation violation) {
		boolean status = false;

		try {
			String sql = "INSERT INTO violations (vehicle_id, rule_id, officer_id, violation_date, payment_status) VALUES (?, ?, ?, ?, ?)";

			PreparedStatement ps = con.prepareStatement(sql);
			ps.setInt(1, violation.getVehicleId());
			ps.setInt(2, violation.getRuleId());
			ps.setInt(3, violation.getOfficerId());
			ps.setTimestamp(4, violation.getViolationDate());
			ps.setString(5, violation.getPaymentStatus());

			status = ps.executeUpdate() > 0;

		} catch (Exception e) {
			System.out.println(e.getMessage());
		}

		return status;
	}

	@Override
	public List<Violation> getAllViolations() {
		List<Violation> list = new ArrayList<>();

		try {

			String sql = "SELECT v.* FROM violations v " + "JOIN vehicle ve ON v.vehicle_id = ve.vehicle_id "
					+ "JOIN traffic_rule r ON v.rule_id = r.rule_id " + "JOIN police p ON v.officer_id = p.officer_id";

			PreparedStatement ps = con.prepareStatement(sql);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				Violation violation = new Violation();

				violation.setViolationId(rs.getInt("violation_id"));
				violation.setVehicleId(rs.getInt("vehicle_id"));
				violation.setRuleId(rs.getInt("rule_id"));
				violation.setOfficerId(rs.getInt("officer_id"));
				violation.setViolationDate(rs.getTimestamp("violation_date"));
				violation.setPaymentStatus(rs.getString("payment_status"));

				list.add(violation);
			}

		} catch (Exception e) {
			System.out.println(e.getMessage());
		}

		return list;
	}

	@Override
	public Violation getViolationById(int violationId) {
		Violation violation = null;

		try {

			String sql = "SELECT * FROM violations WHERE violation_id = ?";

			PreparedStatement ps = con.prepareStatement(sql);
			ps.setInt(1, violationId);

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				violation = new Violation();

				violation.setViolationId(rs.getInt("violation_id"));
				violation.setVehicleId(rs.getInt("vehicle_id"));
				violation.setRuleId(rs.getInt("rule_id"));
				violation.setOfficerId(rs.getInt("officer_id"));
				violation.setViolationDate(rs.getTimestamp("violation_date"));
				violation.setPaymentStatus(rs.getString("payment_status"));
			}

		} catch (Exception e) {
			System.out.println(e.getMessage());
		}

		return violation;
	}

	@Override
	public boolean updatePaymentStatus(int violationId, String status) {
		boolean result = false;

		try {
			String sql = "UPDATE violations SET payment_status = ? WHERE violation_id = ?";

			PreparedStatement ps = con.prepareStatement(sql);
			ps.setString(1, status);
			ps.setInt(2, violationId);

			result = ps.executeUpdate() > 0;

		} catch (Exception e) {
			System.out.println(e.getMessage());
		}

		return result;
	}

	@Override
	public boolean deleteViolation(int violationId) {
		boolean result = false;

		try {
			String sql = "DELETE FROM violations WHERE violation_id = ?";

			PreparedStatement ps = con.prepareStatement(sql);
			ps.setInt(1, violationId);

			result = ps.executeUpdate() > 0;

		} catch (Exception e) {
			System.out.println(e.getMessage());
		}

		return result;
	}
}
