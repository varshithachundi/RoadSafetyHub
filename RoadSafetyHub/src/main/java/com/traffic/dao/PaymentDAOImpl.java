package com.traffic.dao;

import com.traffic.model.Payment;
import com.traffic.utility.DBConnection;
import java.sql.*;
import java.util.*;

public class PaymentDAOImpl implements PaymentDAO {

    @Override
    public boolean addPayment(Payment payment) {
        String sql = "INSERT INTO payments (violation_id, amount, payment_date, payment_method) VALUES (?, ?, NOW(), ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, payment.getViolationId());
            ps.setDouble(2, payment.getAmount());
            ps.setString(3, payment.getPaymentMethod());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<Payment> getAllPayments() {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT * FROM payments ORDER BY payment_id DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Payment p = new Payment();
                p.setPaymentId(rs.getInt("payment_id"));
                p.setViolationId(rs.getInt("violation_id"));
                p.setAmount(rs.getDouble("amount"));
                p.setPaymentMethod(rs.getString("payment_method"));
                // Convert SQL Timestamp to LocalDateTime
                Timestamp ts = rs.getTimestamp("payment_date");
                if (ts != null) p.setPaymentDate(ts.toLocalDateTime());
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Payment getPaymentByViolationId(int violationId) {
        String sql = "SELECT * FROM payments WHERE violation_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, violationId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Payment p = new Payment();
                p.setPaymentId(rs.getInt("payment_id"));
                p.setViolationId(rs.getInt("violation_id"));
                p.setAmount(rs.getDouble("amount"));
                p.setPaymentMethod(rs.getString("payment_method"));
                Timestamp ts = rs.getTimestamp("payment_date");
                if (ts != null) p.setPaymentDate(ts.toLocalDateTime());
                return p;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
