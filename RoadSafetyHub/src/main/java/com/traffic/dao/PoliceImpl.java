package com.traffic.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

import com.traffic.model.PoliceOfficer;
import com.traffic.utility.DBConnection;

public class PoliceImpl implements PoliceInterface {

	@Override
	public boolean addPoliceOfficer(PoliceOfficer officer) {
		String sql = "INSERT INTO policeofficers(name, badge_number, user_id) VALUES(?,?,?)";

		try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

			ps.setString(1, officer.getName());
			ps.setString(2, officer.getBadgeNumber());
			ps.setInt(3, officer.getUserId());

			return ps.executeUpdate() > 0;

		} catch (Exception e) {
			e.printStackTrace();
		}

		return false;
	}

	@Override
	public PoliceOfficer getPoliceOfficerById(int officerId) {
		String sql = "SELECT * FROM policeofficers WHERE officer_id=?";

		try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

			ps.setInt(1, officerId);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				PoliceOfficer p = new PoliceOfficer();
				p.setOfficerId(rs.getInt("officer_id"));
				p.setName(rs.getString("name"));
				p.setBadgeNumber(rs.getString("badge_number"));
				p.setUserId(rs.getInt("user_id"));
				return p;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;

	}

	@Override
	public List<PoliceOfficer> getAllPoliceOfficers() {
		List<PoliceOfficer> list = new ArrayList<>();
		String sql = "SELECT * FROM policeofficers";

		try (Connection con = DBConnection.getConnection();
				PreparedStatement ps = con.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {

			while (rs.next()) {
				PoliceOfficer p = new PoliceOfficer();
				p.setOfficerId(rs.getInt("officer_id"));
				p.setName(rs.getString("name"));
				p.setBadgeNumber(rs.getString("badge_number"));
				p.setUserId(rs.getInt("user_id"));
				list.add(p);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	@Override
	public boolean updatePoliceOfficer(PoliceOfficer officer) {
		String sql = "UPDATE policeofficers SET name=?, badge_number=? WHERE officer_id=?";

		try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

			ps.setString(1, officer.getName());
			ps.setString(2, officer.getBadgeNumber());
			ps.setInt(3, officer.getOfficerId());

			return ps.executeUpdate() > 0;

		} catch (Exception e) {
			e.printStackTrace();
		}

		return false;
	}

	@Override
	public boolean deletePoliceOfficer(int officerId) {
		String sql = "DELETE FROM policeofficers WHERE officer_id=?";

		try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

			ps.setInt(1, officerId);
			return ps.executeUpdate() > 0;

		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

}
