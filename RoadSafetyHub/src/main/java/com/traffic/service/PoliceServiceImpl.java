package com.traffic.service;

import java.util.List;

import com.traffic.dao.PoliceInterface;
import com.traffic.dao.PoliceImpl;
import com.traffic.model.PoliceOfficer;

public class PoliceServiceImpl implements PoliceService {

    private PoliceInterface policeDAO;

    public PoliceServiceImpl() {
        policeDAO = new PoliceImpl();
    }

    @Override
    public boolean addPoliceOfficer(PoliceOfficer officer) {
        if (officer.getName() == null || officer.getName().trim().isEmpty()) {
            return false;
        }
        return policeDAO.addPoliceOfficer(officer);
    }

    @Override
    public PoliceOfficer getPoliceOfficerById(int officerId) {
        return policeDAO.getPoliceOfficerById(officerId);
    }

    @Override
    public List<PoliceOfficer> getAllPoliceOfficers() {
        return policeDAO.getAllPoliceOfficers();
    }

    @Override
    public boolean updatePoliceOfficer(PoliceOfficer officer) {
        return policeDAO.updatePoliceOfficer(officer);
    }

    @Override
    public boolean deletePoliceOfficer(int officerId) {
        return policeDAO.deletePoliceOfficer(officerId);
    }
}