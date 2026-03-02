package com.traffic.model;

public class TrafficRules {
	private int ruleId;
	private String ruleName;
	private double fineAmount;
	private int penaltyPoints;

	public TrafficRules() {
	}

	public TrafficRules(int ruleId, String ruleName, double fineAmount, int penaltyPoints) {
		this.ruleId = ruleId;
		this.ruleName = ruleName;
		this.fineAmount = fineAmount;
		this.penaltyPoints = penaltyPoints;
	}

	public int getRuleId() {
		return ruleId;
	}

	public void setRuleId(int ruleId) {
		this.ruleId = ruleId;
	}

	public String getRuleName() {
		return ruleName;
	}

	public void setRuleName(String ruleName) {
		this.ruleName = ruleName;
	}

	public double getFineAmount() {
		return fineAmount;
	}

	public void setFineAmount(double fineAmount) {
		this.fineAmount = fineAmount;
	}

	public int getPenaltyPoints() {
		return penaltyPoints;
	}

	public void setPenaltyPoints(int penaltyPoints) {
		this.penaltyPoints = penaltyPoints;
	}

	@Override
	public String toString() {
		return "TrafficRules [ruleId=" + ruleId + ", ruleName=" + ruleName + ", fineAmount=" + fineAmount
				+ ", penaltyPoints=" + penaltyPoints + "]";
	}

}
