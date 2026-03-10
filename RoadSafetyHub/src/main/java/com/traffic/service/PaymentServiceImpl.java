package com.traffic.service;

import com.traffic.dao.PaymentDAO;
import com.traffic.dao.PaymentDAOImpl;
import com.traffic.model.Payment;
import java.util.List;

public class PaymentServiceImpl implements PaymentService {

    PaymentDAO dao = new PaymentDAOImpl();

    @Override
    public boolean addPayment(Payment payment) {
        return dao.addPayment(payment);
    }

    @Override
    public List<Payment> getAllPayments() {
        return dao.getAllPayments();
    }

    @Override
    public Payment getPaymentByViolationId(int violationId) {
        return dao.getPaymentByViolationId(violationId);
    }
}
