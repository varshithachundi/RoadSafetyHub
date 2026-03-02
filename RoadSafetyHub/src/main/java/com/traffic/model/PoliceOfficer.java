package com.traffic.model;

public class PoliceOfficer {
	private int officerId;
	private String name;
	private String badgeNumber;
	private int userId;

	public PoliceOfficer() {
	}

	public PoliceOfficer(int officerId, String name, String badgeNumber, int userId) {
		this.officerId = officerId;
		this.name = name;
		this.badgeNumber = badgeNumber;
		this.userId = userId;
	}

	public int getOfficerId() {
		return officerId;
	}

	public void setOfficerId(int officerId) {
		this.officerId = officerId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getBadgeNumber() {
		return badgeNumber;
	}

	public void setBadgeNumber(String badgeNumber) {
		this.badgeNumber = badgeNumber;
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	@Override
	public String toString() {
		return "PoliceOfficer [officerId=" + officerId + ", name=" + name + ", badgeNumber=" + badgeNumber + ", userId="
				+ userId + "]";
	}

}
