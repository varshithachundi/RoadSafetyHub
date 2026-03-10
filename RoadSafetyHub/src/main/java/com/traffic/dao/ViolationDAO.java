package com.traffic.dao;

import com.traffic.model.Violation;
import java.util.List;

public interface ViolationDAO {
    boolean addViolation(Violation violation);
    List<Violation> getAllViolations();
    Violation getViolationById(int violationId);
    boolean payFine(int violationId);
    boolean deleteViolation(int violationId);
}
