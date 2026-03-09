<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ page import="com.traffic.model.*,com.traffic.service.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getRole().equalsIgnoreCase("owner")) {
        response.sendRedirect(request.getContextPath() + "/index.jsp"); return;
    }
    String vidStr = request.getParameter("violationId");
    Violation violation = null;
    if (vidStr != null && !vidStr.isEmpty()) {
        violation = new ViolationServiceImpl().getViolationById(Integer.parseInt(vidStr));
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
    :root{--gold:#ffc107;--green:#4caf50;--dark:#0a120a;--card:#0f1a0f;--border:rgba(76,175,80,0.25);}
    *{box-sizing:border-box;margin:0;padding:0;}
    body{background:var(--dark);color:#e0e0e0;font-family:'DM Sans',sans-serif;min-height:100vh;}
    .top-nav{background:rgba(10,18,10,0.98);border-bottom:2px solid var(--green);padding:14px 28px;display:flex;align-items:center;justify-content:space-between;position:fixed;top:0;left:0;right:0;z-index:1000;}
    .nav-brand{font-family:'Bebas Neue',sans-serif;font-size:24px;letter-spacing:3px;color:var(--gold);text-decoration:none;}
    .nav-links{display:flex;align-items:center;gap:8px;flex-wrap:wrap;}
    .nav-link-btn{color:#ccc;text-decoration:none;padding:7px 16px;border-radius:6px;font-size:14px;border:1px solid transparent;transition:all 0.2s;}
    .nav-link-btn:hover{color:var(--green);border-color:var(--green);background:rgba(76,175,80,0.08);}
    .nav-user{background:rgba(76,175,80,0.15);border:1px solid var(--green);border-radius:20px;padding:5px 14px;font-size:13px;color:var(--green);}
    .nav-logout{background:transparent;border:1px solid #555;color:#aaa;padding:7px 16px;border-radius:6px;text-decoration:none;font-size:13px;}
    .nav-logout:hover{border-color:#f44336;color:#f44336;}
    .main-wrapper{padding-top:70px;}
    .page-header{background:linear-gradient(135deg,#0a120a,#0d1e0d);border-bottom:1px solid var(--border);padding:32px;}
    .page-header h1{font-family:'Bebas Neue',sans-serif;font-size:36px;letter-spacing:3px;color:var(--green);}
    .page-header p{color:#888;font-size:14px;margin-top:4px;}
    .content{padding:32px;display:flex;justify-content:center;}
    .payment-card{background:var(--card);border:1px solid var(--border);border-radius:16px;padding:36px;width:100%;max-width:540px;}
    .payment-card h4{font-family:'Bebas Neue',sans-serif;font-size:24px;letter-spacing:2px;color:var(--gold);margin-bottom:24px;}
    .violation-summary{background:#080e08;border:1px solid var(--border);border-radius:10px;padding:20px;margin-bottom:28px;}
    .violation-summary .s-title{color:var(--gold);font-size:12px;text-transform:uppercase;letter-spacing:1px;margin-bottom:14px;}
    .s-row{display:flex;justify-content:space-between;margin-bottom:10px;font-size:14px;}
    .s-row .s-label{color:#666;}
    .s-row .s-val{color:#fff;font-weight:600;}
    .badge-unpaid{background:#2a0d0d;color:#f44336;border:1px solid #f44336;font-size:11px;padding:3px 10px;border-radius:20px;}
    .form-group{margin-bottom:20px;}
    .form-group label{display:block;color:#aaa;font-size:13px;margin-bottom:7px;}
    .form-group input{width:100%;background:#1a2a1a;border:1px solid #2a4a2a;color:#e0e0e0;border-radius:8px;padding:11px 14px;font-size:14px;font-family:'DM Sans',sans-serif;}
    .form-group input:focus{border-color:var(--green);outline:none;}
    .form-group small{color:#555;font-size:11px;margin-top:5px;display:block;}
    .method-option{background:#1a2a1a;border:1px solid #2a4a2a;border-radius:8px;padding:13px 16px;cursor:pointer;margin-bottom:8px;display:flex;align-items:center;gap:12px;transition:border-color 0.2s;}
    .method-option:hover{border-color:var(--green);}
    .method-option input[type=radio]{accent-color:var(--green);width:16px;height:16px;flex-shrink:0;}
    .method-option label{cursor:pointer;color:#ccc;font-size:14px;margin:0;}
    .divider{height:1px;background:var(--border);margin:24px 0;}
    .btn-row{display:flex;gap:12px;}
    .btn-pay{background:var(--green);color:#fff;font-weight:700;border:none;border-radius:8px;padding:13px 32px;font-size:15px;flex:1;cursor:pointer;transition:background 0.2s;}
    .btn-pay:hover{background:#388e3c;}
    .btn-back{background:transparent;border:1px solid #444;color:#aaa;border-radius:8px;padding:13px 20px;font-size:14px;text-decoration:none;display:inline-flex;align-items:center;}
    .btn-back:hover{border-color:var(--gold);color:var(--gold);}
    .state-card{text-align:center;padding:60px 20px;}
    .state-card .icon{font-size:56px;margin-bottom:16px;}
    .state-card h4{font-family:'Bebas Neue',sans-serif;font-size:24px;letter-spacing:2px;margin-bottom:12px;}
    .alert-success{background:#0d2218;border:1px solid #4caf50;color:#4caf50;border-radius:8px;padding:12px 18px;margin-bottom:20px;}
    .alert-error{background:#2a0d0d;border:1px solid #f44336;color:#f44336;border-radius:8px;padding:12px 18px;margin-bottom:20px;}
    footer{background:#060e06;color:#444;text-align:center;padding:18px;font-size:12px;border-top:1px solid #1a2a1a;margin-top:40px;}
</style>
</head>
<body>
<nav class="top-nav">
    <a href="dashboard.jsp" class="nav-brand">🚦 RoadSafetyHub</a>
    <div class="nav-links">
        <a href="dashboard.jsp" class="nav-link-btn">🏠 Dashboard</a>
        <a href="myVehicles.jsp" class="nav-link-btn">🚗 My Vehicles</a>
        <a href="myViolations.jsp" class="nav-link-btn">⚠️ My Violations</a>
        <span class="nav-user">👤 <%= user.getUsername() %> [OWNER]</span>
        <a href="../index.jsp" class="nav-logout">Logout</a>
    </div>
</nav>
<div class="main-wrapper">
    <div class="page-header">
        <h1>💳 Pay Fine</h1>
        <p>Complete your traffic fine payment securely</p>
    </div>
    <div class="content">
        <div class="payment-card">
            <% if (msg != null) { %><div class="alert-success">✅ <%= msg %></div><% } %>
            <% if (error != null) { %><div class="alert-error">❌ <%= error %></div><% } %>

            <% if (violation == null) { %>
            <div class="state-card">
                <div class="icon">⚠️</div>
                <h4 style="color:#f44336;">NOT FOUND</h4>
                <p style="color:#555;margin-bottom:20px;">Violation not found or already paid.</p>
                <a href="myViolations.jsp" class="btn-back">← Back to Violations</a>
            </div>
            <% } else if ("PAID".equalsIgnoreCase(violation.getPaymentStatus())) { %>
            <div class="state-card">
                <div class="icon">✅</div>
                <h4 style="color:#4caf50;">ALREADY PAID</h4>
                <p style="color:#555;margin-bottom:20px;">This fine has already been cleared.</p>
                <a href="myViolations.jsp" class="btn-back">← Back to Violations</a>
            </div>
            <% } else { %>
            <h4>💳 Payment Details</h4>
            <div class="violation-summary">
                <div class="s-title">📋 Violation Summary</div>
                <div class="s-row"><span class="s-label">Violation ID</span><span class="s-val">#<%= violation.getViolationId() %></span></div>
                <div class="s-row"><span class="s-label">Vehicle ID</span><span class="s-val">🚗 <%= violation.getVehicleId() %></span></div>
                <div class="s-row"><span class="s-label">Rule ID</span><span class="s-val">📋 Rule-<%= violation.getRuleId() %></span></div>
                <div class="s-row"><span class="s-label">Date</span><span class="s-val" style="font-size:13px;"><%= violation.getViolationDate()!=null?violation.getViolationDate().toString().substring(0,16):"N/A" %></span></div>
                <div class="s-row"><span class="s-label">Status</span><span class="s-val"><span class="badge-unpaid">❌ UNPAID</span></span></div>
            </div>
            <form action="../payment" method="post">
                <input type="hidden" name="action" value="pay">
                <input type="hidden" name="violationId" value="<%= violation.getViolationId() %>">
                <div class="form-group">
                    <label>💰 Fine Amount (₹) *</label>
                    <input type="number" name="amount" required min="1" step="0.01" placeholder="Enter amount from traffic rules table">
                    <small>Check the trafficrules table for the exact fine amount for Rule-<%= violation.getRuleId() %></small>
                </div>
                <div class="form-group">
                    <label>💳 Payment Method *</label>
                    <div class="method-option"><input type="radio" name="paymentMethod" value="UPI" id="upi" required><label for="upi">📱 UPI (GPay / PhonePe / Paytm)</label></div>
                    <div class="method-option"><input type="radio" name="paymentMethod" value="Card" id="card"><label for="card">💳 Debit / Credit Card</label></div>
                    <div class="method-option"><input type="radio" name="paymentMethod" value="Net Banking" id="nb"><label for="nb">🏦 Net Banking</label></div>
                    <div class="method-option"><input type="radio" name="paymentMethod" value="Cash" id="cash"><label for="cash">💵 Cash</label></div>
                </div>
                <div class="divider"></div>
                <div class="btn-row">
                    <a href="myViolations.jsp" class="btn-back">← Back</a>
                    <button type="submit" class="btn-pay">✅ Confirm Payment</button>
                </div>
            </form>
            <% } %>
        </div>
    </div>
</div>
<footer>© 2026 RoadSafetyHub | Developed by Varshitha | Owner Portal</footer>
</body>
</html>
