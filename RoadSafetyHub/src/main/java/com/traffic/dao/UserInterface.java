package com.traffic.dao;

import com.traffic.model.User;

public interface UserInterface {
	
	boolean registerUser(User user);
	User login(String username, String password);
	User getUserById(int id);
}
