package com.traffic.controller;

import java.io.IOException;
import java.sql.Timestamp;
import com.traffic.model.Payment;
import com.traffic.service.PaymentService;
import com.traffic.service.PaymentServiceImpl;
import com.traffic.service.ViolationService;
import com.traffic.service.ViolationServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/payment")
public class PaymentController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    PaymentService paymentService = new PaymentServiceImpl();
    ViolationService violationService = new ViolationServiceImpl();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action.equals("pay")) {
            try {
                int violationId = Integer.parseInt(request.getParameter("violationId"));
                double amount = Double.parseDouble(request.getParameter("amount"));
                String paymentMethod = request.getParameter("paymentMethod");

                // Save payment record
                Payment payment = new Payment();
                payment.setViolationId(violationId);
                payment.setAmount(amount);
                payment.setPaymentMethod(paymentMethod);
              
                boolean paymentSaved = paymentService.addPayment(payment);

                // Update violation status to PAID
                boolean statusUpdated = violationService.payFine(violationId);

                if (paymentSaved && statusUpdated) {
                    response.sendRedirect("owner/myViolations.jsp?msg=Payment Successful! Fine Cleared.");
                } else {
                    response.sendRedirect("owner/payment.jsp?violationId=" + violationId + "&error=Payment processing failed. Try again.");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("owner/myViolations.jsp?error=Payment error: " + e.getMessage());
            }
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("owner/myViolations.jsp");
    }
}
