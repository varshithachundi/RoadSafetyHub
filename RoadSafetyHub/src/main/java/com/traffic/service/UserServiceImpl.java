package com.traffic.service;

import com.traffic.dao.UserImpl;
import com.traffic.dao.UserInterface;
import com.traffic.model.User;

public class UserServiceImpl implements UserService {

	private UserInterface userDAO;

	public UserServiceImpl() {
		userDAO = new UserImpl();
	}

	@Override
	public boolean registerUser(User user) {
		if (user.getUsername() == null || user.getUsername().trim().isEmpty()) {
			return false;
		}

		if (user.getPassword() == null || user.getPassword().trim().isEmpty()) {
			return false;
		}

		if (user.getRole() == null || user.getRole().trim().isEmpty()) {
			return false;
		}

		return userDAO.registerUser(user);
	}

	@Override
	public User login(String username, String password) {
		if (username == null || password == null) {
			return null;
		}

		return userDAO.login(username, password);
	}

	@Override
	public User getUserById(int id) {
		return userDAO.getUserById(id);
	}

}
