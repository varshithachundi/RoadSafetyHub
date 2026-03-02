package com.traffic.model;

public class Owner {
	private int ownerId;
	private String name;
	private String mobile;
	private String address;
	private int userId;

	public Owner() {
	}

	public Owner(int ownerId, String name, String mobile, String address, int userId) {
		this.ownerId = ownerId;
		this.name = name;
		this.mobile = mobile;
		this.address = address;
		this.userId = userId;
	}

	public int getOwnerId() {
		return ownerId;
	}

	public void setOwnerId(int ownerId) {
		this.ownerId = ownerId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	@Override
	public String toString() {
		return "Owner [ownerId=" + ownerId + ", name=" + name + ", mobile=" + mobile + ", address=" + address
				+ ", userId=" + userId + "]";
	}

}
