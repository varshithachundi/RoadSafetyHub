package com.traffic.service;

import java.util.List;

import com.traffic.dao.ViolationInterface;
import com.traffic.dao.ViolationImpl;
import com.traffic.model.Violation;

public class ViolationServiceImpl implements ViolationService {

    private ViolationInterface violationDAO;

    public ViolationServiceImpl() {
        violationDAO = new ViolationImpl();
    }

    @Override
    public boolean addViolation(Violation violation) {
        return violationDAO.addViolation(violation);
    }

    @Override
    public List<Violation> getAllViolations() {
        return violationDAO.getAllViolations();
    }

    @Override
    public Violation getViolationById(int violationId) {
        return violationDAO.getViolationById(violationId);
    }

    @Override
    public boolean payFine(int violationId) {
        return violationDAO.updatePaymentStatus(violationId, "PAID");
    }

    @Override
    public boolean deleteViolation(int violationId) {
        return violationDAO.deleteViolation(violationId);
    }
}