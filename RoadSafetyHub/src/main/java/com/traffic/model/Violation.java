package com.traffic.model;

import java.sql.Timestamp;

public class Violation {

    private int violationId;
    private int vehicleId;
    private int ruleId;
    private int officerId;
    private Timestamp violationDate;
    private String paymentStatus;

    public Violation() {}

    public int getViolationId() { return violationId; }
    public void setViolationId(int violationId) { this.violationId = violationId; }

    public int getVehicleId() { return vehicleId; }
    public void setVehicleId(int vehicleId) { this.vehicleId = vehicleId; }

    public int getRuleId() { return ruleId; }
    public void setRuleId(int ruleId) { this.ruleId = ruleId; }

    public int getOfficerId() { return officerId; }
    public void setOfficerId(int officerId) { this.officerId = officerId; }

    public Timestamp getViolationDate() { return violationDate; }
    public void setViolationDate(Timestamp violationDate) { this.violationDate = violationDate; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }
}
