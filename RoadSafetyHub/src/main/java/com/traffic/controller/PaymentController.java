package com.traffic.controller;

import java.io.IOException;

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

		// ADD PAYMENT
		if (action.equals("pay")) {

			int violationId = Integer.parseInt(request.getParameter("violationId"));
			double amount = Double.parseDouble(request.getParameter("amount"));
			String paymentMethod = request.getParameter("paymentMethod");

			Payment payment = new Payment();
			payment.setViolationId(violationId);
			payment.setAmount(amount);
			payment.setPaymentMethod(paymentMethod);

			boolean result = paymentService.addPayment(payment);

			if (result) {

				// update violation status to PAID
				violationService.payFine(violationId);

				response.sendRedirect("owner/myViolations.jsp?msg=Payment Successful");

			} else {
				response.sendRedirect("owner/payment.jsp?error=Payment Failed");
			}
		}
	}
}