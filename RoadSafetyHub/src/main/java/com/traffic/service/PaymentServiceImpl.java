package com.traffic.service;

import java.util.List;

import com.traffic.dao.PaymentInterface;
import com.traffic.dao.PaymentImpl;
import com.traffic.model.Payment;

public class PaymentServiceImpl implements PaymentService {

	private PaymentInterface paymentDAO;

	public PaymentServiceImpl() {
		paymentDAO = new PaymentImpl();
	}

	@Override
	public boolean addPayment(Payment payment) {

		if (payment == null) {
			return false;
		}

		if (payment.getViolationId() <= 0) {
			return false;
		}

		if (payment.getAmount() <= 0) {
			return false;
		}

		return paymentDAO.addPayment(payment);
	}

	@Override
	public Payment getPaymentById(int paymentId) {
		return paymentDAO.getPaymentById(paymentId);
	}

	@Override
	public List<Payment> getPaymentsByViolationId(int violationId) {
		return paymentDAO.getPaymentsByViolationId(violationId);
	}

	@Override
	public List<Payment> getAllPayments() {
		return paymentDAO.getAllPayments();
	}
}