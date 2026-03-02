package com.traffic.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.traffic.model.User;
import com.traffic.utility.DBConnection;

public class UserImpl implements UserInterface {

	@Override
	public boolean registerUser(User user) {
		boolean status = false;

		try {
			Connection con = DBConnection.getConnection();

			String sql = "INSERT INTO users (username, password, role) VALUES (?, ?, ?)";

			PreparedStatement ps = con.prepareStatement(sql);
			ps.setString(1, user.getUsername());
			ps.setString(2, user.getPassword());
			ps.setString(3, user.getRole());

			int rows = ps.executeUpdate();

			if (rows > 0) {
				status = true;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return status;
	}

	@Override
	public User login(String username, String password) {
		User user = null;

		try {
			Connection con = DBConnection.getConnection();

			String sql = "SELECT * FROM users WHERE username=? AND password=?";

			PreparedStatement ps = con.prepareStatement(sql);
			ps.setString(1, username);
			ps.setString(2, password);

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				user = new User();

				user.setUserId(rs.getInt("user_id"));
				user.setUsername(rs.getString("username"));
				user.setPassword(rs.getString("password"));
				user.setRole(rs.getString("role"));
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return user;
	}

	@Override
	public User getUserById(int id) {
		User user = null;

		try {
			Connection con = DBConnection.getConnection();

			String sql = "SELECT * FROM users WHERE user_id=?";

			PreparedStatement ps = con.prepareStatement(sql);
			ps.setInt(1, id);

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				user = new User();

				user.setUserId(rs.getInt("user_id"));
				user.setUsername(rs.getString("username"));
				user.setPassword(rs.getString("password"));
				user.setRole(rs.getString("role"));
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return user;
	}
}
