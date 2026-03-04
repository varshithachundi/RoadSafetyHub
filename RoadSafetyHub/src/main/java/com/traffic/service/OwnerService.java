package com.traffic.service;

import java.util.List;
import com.traffic.model.Owner;

public interface OwnerService {

	boolean addOwner(Owner owner);

	Owner getOwnerById(int ownerId);

	List<Owner> getAllOwners();

	boolean updateOwner(Owner owner);

	boolean deleteOwner(int ownerId);
}