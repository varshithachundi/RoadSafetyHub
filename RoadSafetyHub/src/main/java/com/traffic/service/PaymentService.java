package com.traffic.service;

import java.util.List;
import com.traffic.model.Payment;

public interface PaymentService {

    boolean addPayment(Payment payment);

    Payment getPaymentById(int paymentId);

    List<Payment> getPaymentsByViolationId(int violationId);

    List<Payment> getAllPayments();
}