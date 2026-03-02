package com.traffic.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import com.traffic.model.Owner;
import com.traffic.utility.DBConnection;

public class OwnerImpl implements OwnerInterface {

	@Override
	public boolean addOwner(Owner owner) {
		String sql = "INSERT INTO owners(name, mobile, address, user_id) VALUES(?,?,?,?)";

		try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

			ps.setString(1, owner.getName());
			ps.setString(2, owner.getMobile());
			ps.setString(3, owner.getAddress());
			ps.setInt(4, owner.getUserId());

			return ps.executeUpdate() > 0;

		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	@Override
	public Owner getOwnerById(int ownerId) {
		String sql = "SELECT * FROM owners WHERE owner_id=?";

		try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

			ps.setInt(1, ownerId);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				Owner owner = new Owner();
				owner.setOwnerId(rs.getInt("owner_id"));
				owner.setName(rs.getString("name"));
				owner.setMobile(rs.getString("mobile"));
				owner.setAddress(rs.getString("address"));
				owner.setUserId(rs.getInt("user_id"));

				return owner;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}

	@Override
	public List<Owner> getAllOwners() {
		List<Owner> list = new ArrayList<>();
		String sql = "SELECT * FROM owners";

		try (Connection con = DBConnection.getConnection();
				PreparedStatement ps = con.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {

			while (rs.next()) {

				Owner owner = new Owner();
				owner.setOwnerId(rs.getInt("owner_id"));
				owner.setName(rs.getString("name"));
				owner.setMobile(rs.getString("mobile"));
				owner.setAddress(rs.getString("address"));
				owner.setUserId(rs.getInt("user_id"));

				list.add(owner);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	@Override
	public boolean updateOwner(Owner owner) {
		String sql = "UPDATE owners SET name=?, mobile=?, address=? WHERE owner_id=?";

		try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

			ps.setString(1, owner.getName());
			ps.setString(2, owner.getMobile());
			ps.setString(3, owner.getAddress());
			ps.setInt(4, owner.getOwnerId());

			return ps.executeUpdate() > 0;

		} catch (Exception e) {
			e.printStackTrace();
		}

		return false;
	}

	@Override
	public boolean deleteOwner(int ownerId) {
		String sql = "DELETE FROM owners WHERE owner_id=?";

		try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

			ps.setInt(1, ownerId);
			return ps.executeUpdate() > 0;

		} catch (Exception e) {
			e.printStackTrace();
		}

		return false;
	}

}
