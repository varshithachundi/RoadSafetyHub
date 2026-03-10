package com.traffic.service;

import com.traffic.dao.ViolationDAO;
import com.traffic.dao.ViolationDAOImpl;
import com.traffic.model.Violation;
import java.util.List;

public class ViolationServiceImpl implements ViolationService {

    ViolationDAO dao = new ViolationDAOImpl();

    @Override
    public boolean addViolation(Violation violation) {
        return dao.addViolation(violation);
    }

    @Override
    public List<Violation> getAllViolations() {
        return dao.getAllViolations();
    }

    @Override
    public Violation getViolationById(int violationId) {
        return dao.getViolationById(violationId);
    }

    @Override
    public boolean payFine(int violationId) {
        return dao.payFine(violationId);
    }

    @Override
    public boolean deleteViolation(int violationId) {
        return dao.deleteViolation(violationId);
    }
}
