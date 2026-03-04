package com.traffic.service;

import com.traffic.model.User;

public interface UserService {
	
	boolean registerUser(User user);

	User login(String username, String password);
	
	User getUserById(int id);

}
