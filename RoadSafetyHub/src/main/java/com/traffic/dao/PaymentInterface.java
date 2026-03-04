package com.traffic.dao;

import java.util.List;

import com.traffic.model.Payment;

public interface PaymentInterface {
	boolean addPayment(Payment payment);

	Payment getPaymentById(int paymentId);

	List<Payment> getPaymentsByViolationId(int violationId);

	List<Payment> getAllPayments();
}
