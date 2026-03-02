package com.traffic.dao;

import java.util.List;

import com.traffic.model.PoliceOfficer;

public interface PoliceInterface {
	boolean addPoliceOfficer(PoliceOfficer officer);

	PoliceOfficer getPoliceOfficerById(int officerId);

	List<PoliceOfficer> getAllPoliceOfficers();

	boolean updatePoliceOfficer(PoliceOfficer officer);

	boolean deletePoliceOfficer(int officerId);
}
