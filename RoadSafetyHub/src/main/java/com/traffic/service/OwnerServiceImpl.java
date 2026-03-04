package com.traffic.service;

import java.util.List;

import com.traffic.dao.OwnerInterface;
import com.traffic.dao.OwnerImpl;
import com.traffic.model.Owner;

public class OwnerServiceImpl implements OwnerService {

    private OwnerInterface ownerDAO;

    public OwnerServiceImpl() {
        ownerDAO = new OwnerImpl();
    }

    @Override
    public boolean addOwner(Owner owner) {
        if (owner.getName() == null || owner.getName().trim().isEmpty()) {
            return false;
        }
        return ownerDAO.addOwner(owner);
    }

    @Override
    public Owner getOwnerById(int ownerId) {
        return ownerDAO.getOwnerById(ownerId);
    }

    @Override
    public List<Owner> getAllOwners() {
        return ownerDAO.getAllOwners();
    }

    @Override
    public boolean updateOwner(Owner owner) {
        return ownerDAO.updateOwner(owner);
    }

    @Override
    public boolean deleteOwner(int ownerId) {
        return ownerDAO.deleteOwner(ownerId);
    }
}