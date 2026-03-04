package com.traffic.service;

import java.util.List;
import com.traffic.model.Violation;

public interface ViolationService {

    boolean addViolation(Violation violation);

    List<Violation> getAllViolations();

    Violation getViolationById(int violationId);

    boolean payFine(int violationId);

    boolean deleteViolation(int violationId);
}