package com.traffic.dao;

import java.util.List;

import com.traffic.model.Violation;

public interface ViolationInterface {
	boolean addViolation(Violation violation);

    List<Violation> getAllViolations();

    Violation getViolationById(int violationId);

    boolean updatePaymentStatus(int violationId, String status);

    boolean deleteViolation(int violationId);
}
