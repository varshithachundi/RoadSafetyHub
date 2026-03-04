package com.traffic.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.traffic.model.Payment;
import com.traffic.utility.DBConnection;

public class PaymentImpl implements PaymentInterface {

	@Override
	public boolean addPayment(Payment payment) {
		String sql = "INSERT INTO payments(violation_id, amount, payment_method) VALUES(?,?,?)";

		try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

			ps.setInt(1, payment.getViolationId());
			ps.setDouble(2, payment.getAmount());
			ps.setString(3, payment.getPaymentMethod());

			return ps.executeUpdate() > 0;

		} catch (Exception e) {
			e.printStackTrace();
		}

		return false;
	}

	@Override
	public Payment getPaymentById(int paymentId) {
		String sql = "SELECT * FROM payments WHERE payment_id=?";

		try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

			ps.setInt(1, paymentId);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				Payment p = new Payment();
				p.setPaymentId(rs.getInt("payment_id"));
				p.setViolationId(rs.getInt("violation_id"));
				p.setAmount(rs.getDouble("amount"));
				p.setPaymentMethod(rs.getString("payment_method"));
				p.setPaymentDate(rs.getTimestamp("payment_date").toLocalDateTime());
				return p;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}

	@Override
	public List<Payment> getPaymentsByViolationId(int violationId) {
		List<Payment> list = new ArrayList<>();
		String sql = "SELECT * FROM payments WHERE violation_id=?";

		try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

			ps.setInt(1, violationId);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				Payment p = new Payment();
				p.setPaymentId(rs.getInt("payment_id"));
				p.setViolationId(rs.getInt("violation_id"));
				p.setAmount(rs.getDouble("amount"));
				p.setPaymentMethod(rs.getString("payment_method"));
				p.setPaymentDate(rs.getTimestamp("payment_date").toLocalDateTime());
				list.add(p);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	@Override
	public List<Payment> getAllPayments() {
		List<Payment> list = new ArrayList<>();
		String sql = "SELECT * FROM payments";

		try (Connection con = DBConnection.getConnection();
				PreparedStatement ps = con.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {

			while (rs.next()) {
				Payment p = new Payment();
				p.setPaymentId(rs.getInt("payment_id"));
				p.setViolationId(rs.getInt("violation_id"));
				p.setAmount(rs.getDouble("amount"));
				p.setPaymentMethod(rs.getString("payment_method"));
				p.setPaymentDate(rs.getTimestamp("payment_date").toLocalDateTime());
				list.add(p);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

}
