package com.traffic.dao;

import com.traffic.model.TrafficRule;
import com.traffic.utility.DBConnection;
import java.sql.*;
import java.util.*;

public class TrafficRuleDAOImpl implements TrafficRuleDAO {

	@Override
	public List<TrafficRule> getAllTrafficRules() {
		List<TrafficRule> list = new ArrayList<>();
		String sql = "SELECT * FROM trafficrules ORDER BY rule_id";
		try (Connection con = DBConnection.getConnection();
				PreparedStatement ps = con.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {
			while (rs.next()) {
				TrafficRule rule = new TrafficRule();
				rule.setRuleId(rs.getInt("rule_id"));
				rule.setRuleName(rs.getString("rule_name"));
				rule.setFineAmount(rs.getDouble("fine_amount"));
				rule.setPenaltyPoints(rs.getInt("penalty_points"));
				list.add(rule);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	@Override
	public TrafficRule getTrafficRuleById(int ruleId) {
		String sql = "SELECT * FROM trafficrules WHERE rule_id = ?";
		try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
			ps.setInt(1, ruleId);
			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				TrafficRule rule = new TrafficRule();
				rule.setRuleId(rs.getInt("rule_id"));
				rule.setRuleName(rs.getString("rule_name"));
				rule.setFineAmount(rs.getDouble("fine_amount"));
				rule.setPenaltyPoints(rs.getInt("penalty_points"));
				return rule;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
}
