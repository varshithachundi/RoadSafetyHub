<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.traffic.model.*" %>
<%@ page import="com.traffic.service.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getRole().equalsIgnoreCase("owner")) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    String violationIdStr = request.getParameter("violationId");
    Violation violation = null;
    if (violationIdStr != null) {
        ViolationService violationService = new ViolationServiceImpl();
        violation = violationService.getViolationById(Integer.parseInt(violationIdStr));
    }
    String error = request.getParameter("error");
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Pay Fine – RoadSafetyHub</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet">
<style>
    :root { --gold: #ffc107; --dark: #0f0f0f; --card-bg: #1a1a1a; --border: rgba(255,193,7,0.2); --green: #4caf50; }
    body { background: var(--dark); color: #e0e0e0; font-family: 'DM Sans', sans-serif; padding-top: 70px; min-height: 100vh; }
    .page-header { background: #0a1f0a; border-bottom: 2px solid var(--green); padding: 24px 0 18px; margin-bottom: 36px; }
    .page-header h2 { font-family: 'Bebas Neue', sans-serif; font-size: 32px; letter-spacing: 3px; color: var(--green); margin: 0; }
    .payment-card { background: var(--card-bg); border: 1px solid var(--border); border-radius: 16px; padding: 36px; max-width: 560px; margin: 0 auto; }
    .payment-card h4 { font-family: 'Bebas Neue', sans-serif; font-size: 24px; letter-spacing: 2px; color: var(--gold); margin-bottom: 24px; }
    .violation-summary { background: #111; border: 1px solid var(--border); border-radius: 10px; padding: 18px; margin-bottom: 28px; }
    .violation-summary .row { margin-bottom: 8px; }
    .violation-summary .label { color: #888; font-size: 12px; text-transform: uppercase; letter-spacing: 1px; }
    .violation-summary .value { color: #fff; font-weight: 600; font-size: 14px; }
    label { color: #aaa; font-size: 13px; font-weight: 500; margin-bottom: 5px; display: block; }
    .form-control-dark, .form-select-dark {
        background: #2a2a2a; border: 1px solid #444; color: #e0e0e0; border-radius: 8px;
        padding: 10px 14px; width: 100%; font-size: 14px; transition: border-color 0.2s;
    }
    .form-control-dark:focus, .form-select-dark:focus {
        background: #333; border-color: var(--gold); color: #fff; outline: none;
        box-shadow: 0 0 0 3px rgba(255,193,7,0.15);
    }
    .form-select-dark option { background: #2a2a2a; }
    .btn-pay { background: var(--green); color: #fff; font-weight: 700; border: none; border-radius: 8px; padding: 13px 32px; font-size: 15px; width: 100%; transition: background 0.2s; }
    .btn-pay:hover { background: #388e3c; }
    .btn-back { background: transparent; border: 1px solid #444; color: #aaa; border-radius: 8px; padding: 13px 24px; font-size: 14px; text-decoration: none; display: inline-block; transition: all 0.2s; }
    .btn-back:hover { border-color: var(--gold); color: var(--gold); text-decoration: none; }
    .method-option { background: #2a2a2a; border: 1px solid #444; border-radius: 8px; padding: 12px 16px; cursor: pointer; transition: all 0.2s; margin-bottom: 8px; display: flex; align-items: center; gap: 10px; }
    .method-option:hover { border-color: var(--gold); }
    .method-option input[type=radio] { accent-color: var(--gold); width: 16px; height: 16px; }
    .badge-unpaid { background: #3a1a1a; color: #f44336; border: 1px solid #f44336; font-size: 12px; padding: 5px 12px; border-radius: 20px; }
    footer { background: #111; color: #555; text-align: center; padding: 16px; font-size: 13px; border-top: 1px solid #222; margin-top: 60px; }
    .divider { height: 1px; background: var(--border); margin: 24px 0; }
</style>
</head>
<body>
<%@ include file="../navbar.jsp" %>

<div class="page-header">
    <div class="container-fluid px-4">
        <h2>💳 Pay Fine</h2>
        <p style="color:#aaa;margin:0;font-size:13px;">Complete your traffic fine payment</p>
    </div>
</div>

<div class="container px-4 pb-5">
    <% if (error != null) { %>
    <div class="alert mb-4" style="background:#3a1a1a;border:1px solid #f44336;color:#f44336;border-radius:8px;max-width:560px;margin:0 auto 20px;">❌ <%= error %></div>
    <% } %>
    <% if (msg != null) { %>
    <div class="alert mb-4" style="background:#1a3a1a;border:1px solid #4caf50;color:#4caf50;border-radius:8px;max-width:560px;margin:0 auto 20px;">✅ <%= msg %></div>
    <% } %>

    <% if (violation == null) { %>
    <div class="payment-card text-center">
        <div style="font-size:48px;margin-bottom:16px;">⚠️</div>
        <h4>VIOLATION NOT FOUND</h4>
        <p class="text-muted">The violation you're looking for doesn't exist or has already been paid.</p>
        <a href="${pageContext.request.contextPath}/owner/myViolations.jsp" class="btn-back px-4" style="display:inline-block;">← Back to Violations</a>
    </div>
    <% } else if ("PAID".equalsIgnoreCase(violation.getPaymentStatus())) { %>
    <div class="payment-card text-center">
        <div style="font-size:48px;margin-bottom:16px;">✅</div>
        <h4>ALREADY PAID</h4>
        <p class="text-muted">This violation fine has already been paid.</p>
        <a href="${pageContext.request.contextPath}/owner/myViolations.jsp" class="btn-back px-4" style="display:inline-block;">← Back to Violations</a>
    </div>
    <% } else { %>
    <div class="payment-card">
        <h4>💳 Payment Details</h4>

        <!-- Violation Summary -->
        <div class="violation-summary">
            <p style="color:var(--gold);font-size:13px;text-transform:uppercase;letter-spacing:1px;margin-bottom:14px;">📋 Violation Summary</p>
            <div class="row">
                <div class="col-6"><div class="label">Violation ID</div><div class="value">#<%= violation.getViolationId() %></div></div>
                <div class="col-6"><div class="label">Vehicle ID</div><div class="value">🚗 <%= violation.getVehicleId() %></div></div>
            </div>
            <div class="row">
                <div class="col-6"><div class="label">Rule ID</div><div class="value">📋 <%= violation.getRuleId() %></div></div>
                <div class="col-6"><div class="label">Status</div><div class="value"><span class="badge-unpaid">❌ UNPAID</span></div></div>
            </div>
            <div class="row">
                <div class="col-12"><div class="label">Date</div><div class="value" style="font-size:13px;"><%= violation.getViolationDate() != null ? violation.getViolationDate().toString().substring(0,16) : "N/A" %></div></div>
            </div>
        </div>

        <form action="${pageContext.request.contextPath}/payment" method="post">
            <input type="hidden" name="action" value="pay">
            <input type="hidden" name="violationId" value="<%= violation.getViolationId() %>">

            <div class="mb-4">
                <label>💰 Fine Amount (₹) *</label>
                <input type="number" name="amount" class="form-control-dark" required min="1" step="0.01" placeholder="Enter fine amount from traffic rules">
                <small style="color:#555;font-size:11px;">Refer to the traffic rules table for the exact fine amount</small>
            </div>

            <div class="mb-4">
                <label>💳 Payment Method *</label>
                <div class="method-option">
                    <input type="radio" name="paymentMethod" value="UPI" id="upi" required>
                    <label for="upi" style="margin:0;cursor:pointer;color:#e0e0e0;">📱 UPI (GPay, PhonePe, Paytm)</label>
                </div>
                <div class="method-option">
                    <input type="radio" name="paymentMethod" value="Card" id="card">
                    <label for="card" style="margin:0;cursor:pointer;color:#e0e0e0;">💳 Debit / Credit Card</label>
                </div>
                <div class="method-option">
                    <input type="radio" name="paymentMethod" value="Net Banking" id="netbank">
                    <label for="netbank" style="margin:0;cursor:pointer;color:#e0e0e0;">🏦 Net Banking</label>
                </div>
                <div class="method-option">
                    <input type="radio" name="paymentMethod" value="Cash" id="cash">
                    <label for="cash" style="margin:0;cursor:pointer;color:#e0e0e0;">💵 Cash</label>
                </div>
            </div>

            <div class="divider"></div>

            <div class="d-flex gap-3">
                <a href="${pageContext.request.contextPath}/owner/myViolations.jsp" class="btn-back">← Back</a>
                <button type="submit" class="btn-pay">✅ Confirm Payment</button>
            </div>
        </form>
    </div>
    <% } %>
</div>

<footer>© 2026 RoadSafetyHub | Developed by Varshitha</footer>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
