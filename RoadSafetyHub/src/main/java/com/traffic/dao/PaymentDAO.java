package com.traffic.dao;

import com.traffic.model.Payment;
import java.util.List;

public interface PaymentDAO {
    boolean addPayment(Payment payment);
    List<Payment> getAllPayments();
    Payment getPaymentByViolationId(int violationId);
}
