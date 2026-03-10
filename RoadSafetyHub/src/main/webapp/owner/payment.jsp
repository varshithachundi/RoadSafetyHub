<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ page import="com.traffic.model.*,com.traffic.service.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getRole().equalsIgnoreCase("owner")) {
        response.sendRedirect(request.getContextPath() + "/index.jsp"); return;
    }
    String vidStr = request.getParameter("violationId");
    Violation violation = null;
    TrafficRule rule = null;
    String vehicleNumber = "";

    if (vidStr != null && !vidStr.isEmpty()) {
        violation = new ViolationServiceImpl().getViolationById(Integer.parseInt(vidStr));
        if (violation != null) {
            rule = new TrafficRuleServiceImpl().getTrafficRuleById(violation.getRuleId());
            Vehicle veh = null;
            for (Vehicle v : new VehicleServiceImpl().getAllVehicles()) {
                if (v.getVehicleId() == violation.getVehicleId()) { veh = v; break; }
            }
            if (veh != null) vehicleNumber = veh.getVehicleNumber();
        }
    }

    // Amount: from URL param (passed by myViolations), fallback to rule
    double fineAmount = 0;
    String amtParam = request.getParameter("amount");
    if (amtParam != null && !amtParam.isEmpty()) {
        try { fineAmount = Double.parseDouble(amtParam); } catch (Exception e) {}
    }
    if (fineAmount == 0 && rule != null) fineAmount = rule.getFineAmount();

    String error = request.getParameter("error");
    String msg   = request.getParameter("msg");
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
    .payment-card{background:var(--card);border:1px solid var(--border);border-radius:16px;padding:36px;width:100%;max-width:560px;}
    /* VIOLATION SUMMARY BOX */
    .v-summary{background:#080e08;border:1px solid var(--border);border-radius:12px;padding:20px 22px;margin-bottom:28px;}
    .v-summary-title{font-family:'Bebas Neue',sans-serif;font-size:15px;letter-spacing:1.5px;color:var(--gold);margin-bottom:14px;}
    .v-row{display:flex;justify-content:space-between;align-items:center;padding:8px 0;border-bottom:1px solid rgba(255,255,255,0.04);font-size:14px;}
    .v-row:last-child{border-bottom:none;}
    .v-label{color:#666;}
    .v-val{color:#e0e0e0;font-weight:500;}
    /* BIG FINE DISPLAY */
    .fine-box{background:linear-gradient(135deg,#1a0a00,#2a1500);border:2px solid var(--gold);border-radius:12px;padding:20px;text-align:center;margin-bottom:28px;}
    .fine-box .fine-label{font-size:12px;color:#888;text-transform:uppercase;letter-spacing:2px;margin-bottom:6px;}
    .fine-box .fine-number{font-family:'Bebas Neue',sans-serif;font-size:56px;color:var(--gold);line-height:1;}
    .fine-box .fine-rule{font-size:13px;color:#aaa;margin-top:6px;}
    /* FORM */
    .form-section-title{font-family:'Bebas Neue',sans-serif;font-size:16px;letter-spacing:1.5px;color:var(--gold);margin-bottom:16px;}
    .method-option{background:#1a2a1a;border:1px solid #2a4a2a;border-radius:8px;padding:13px 16px;cursor:pointer;margin-bottom:8px;display:flex;align-items:center;gap:12px;transition:border-color 0.2s;}
    .method-option:hover{border-color:var(--green);}
    .method-option.selected{border-color:var(--green);background:#1a3a1a;}
    .method-option input[type=radio]{accent-color:var(--green);width:16px;height:16px;flex-shrink:0;}
    .method-option label{cursor:pointer;color:#ccc;font-size:14px;margin:0;flex:1;}
    .method-option .method-desc{font-size:11px;color:#555;display:block;margin-top:2px;}
    .divider{height:1px;background:var(--border);margin:24px 0;}
    .btn-row{display:flex;gap:12px;}
    .btn-pay-submit{background:var(--green);color:#fff;font-weight:700;border:none;border-radius:8px;padding:14px 32px;font-size:16px;flex:1;cursor:pointer;transition:background 0.2s;}
    .btn-pay-submit:hover{background:#388e3c;}
    .btn-back{background:transparent;border:1px solid #444;color:#aaa;border-radius:8px;padding:14px 20px;font-size:14px;text-decoration:none;display:inline-flex;align-items:center;}
    .btn-back:hover{border-color:var(--gold);color:var(--gold);}
    .state-card{text-align:center;padding:60px 20px;}
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
        <p>Complete your traffic fine payment</p>
    </div>
    <div class="content">
        <div class="payment-card">
            <% if (msg != null) { %><div class="alert-success">✅ <%= msg %></div><% } %>
            <% if (error != null) { %><div class="alert-error">❌ <%= error %></div><% } %>

            <% if (violation == null) { %>
            <div class="state-card">
                <div style="font-size:56px;margin-bottom:16px;">⚠️</div>
                <h4 style="color:#f44336;font-family:'Bebas Neue',sans-serif;font-size:24px;letter-spacing:2px;">NOT FOUND</h4>
                <p style="color:#555;margin:12px 0 20px;">Violation not found or already paid.</p>
                <a href="myViolations.jsp" class="btn-back">← Back to Violations</a>
            </div>

            <% } else if ("PAID".equalsIgnoreCase(violation.getPaymentStatus())) { %>
            <div class="state-card">
                <div style="font-size:56px;margin-bottom:16px;">✅</div>
                <h4 style="color:#4caf50;font-family:'Bebas Neue',sans-serif;font-size:24px;letter-spacing:2px;">ALREADY PAID</h4>
                <p style="color:#555;margin:12px 0 20px;">This fine has already been cleared.</p>
                <a href="myViolations.jsp" class="btn-back">← Back to Violations</a>
            </div>

            <% } else { %>

            <!-- VIOLATION SUMMARY -->
            <div class="v-summary">
                <div class="v-summary-title">📋 Violation Details</div>
                <div class="v-row"><span class="v-label">Violation ID</span><span class="v-val">#<%= violation.getViolationId() %></span></div>
                <div class="v-row"><span class="v-label">Vehicle</span><span class="v-val">🚗 <%= vehicleNumber.isEmpty() ? "Vehicle #"+violation.getVehicleId() : vehicleNumber %></span></div>
                <div class="v-row"><span class="v-label">Violation Type</span><span class="v-val"><%= rule != null ? rule.getRuleName() : "Rule #"+violation.getRuleId() %></span></div>
                <div class="v-row"><span class="v-label">Penalty Points</span><span class="v-val" style="color:#f44336;"><%= rule != null ? rule.getPenaltyPoints()+" pts" : "N/A" %></span></div>
                <div class="v-row"><span class="v-label">Date</span><span class="v-val" style="font-size:13px;"><%= violation.getViolationDate()!=null?violation.getViolationDate().toString().substring(0,16):"N/A" %></span></div>
            </div>

            <!-- BIG FINE AMOUNT -->
            <div class="fine-box">
                <div class="fine-label">Total Fine Amount</div>
                <div class="fine-number">₹<%= String.format("%.0f", fineAmount) %></div>
                <div class="fine-rule"><%= rule != null ? rule.getRuleName() : "" %></div>
            </div>

            <!-- PAYMENT FORM -->
            <form action="../payment" method="post">
                <input type="hidden" name="action" value="pay">
                <input type="hidden" name="violationId" value="<%= violation.getViolationId() %>">
                <input type="hidden" name="amount" value="<%= fineAmount %>">

                <div class="form-section-title">💳 Select Payment Method</div>

                <div class="method-option" onclick="selectMethod(this,'UPI')">
                    <input type="radio" name="paymentMethod" value="UPI" id="upi" required>
                    <label for="upi">
                        📱 UPI
                        <span class="method-desc">GPay / PhonePe / Paytm / BHIM</span>
                    </label>
                </div>
                <div class="method-option" onclick="selectMethod(this,'Card')">
                    <input type="radio" name="paymentMethod" value="Card" id="card">
                    <label for="card">
                        💳 Debit / Credit Card
                        <span class="method-desc">Visa / Mastercard / RuPay</span>
                    </label>
                </div>
                <div class="method-option" onclick="selectMethod(this,'Net Banking')">
                    <input type="radio" name="paymentMethod" value="Net Banking" id="nb">
                    <label for="nb">
                        🏦 Net Banking
                        <span class="method-desc">SBI / HDFC / ICICI / Axis</span>
                    </label>
                </div>
                <div class="method-option" onclick="selectMethod(this,'Cash')">
                    <input type="radio" name="paymentMethod" value="Cash" id="cash">
                    <label for="cash">
                        💵 Cash
                        <span class="method-desc">Pay at RTO / Traffic Police office</span>
                    </label>
                </div>

                <div class="divider"></div>
                <div class="btn-row">
                    <a href="myViolations.jsp" class="btn-back">← Back</a>
                    <button type="submit" class="btn-pay-submit">✅ Pay ₹<%= String.format("%.0f", fineAmount) %> Now</button>
                </div>
            </form>
            <% } %>
        </div>
    </div>
</div>
<footer>© 2026 RoadSafetyHub | Developed by Varshitha | Owner Portal</footer>
<script>
function selectMethod(el, val) {
    document.querySelectorAll('.method-option').forEach(o => o.classList.remove('selected'));
    el.classList.add('selected');
    el.querySelector('input[type=radio]').checked = true;
}
</script>
</body>
</html>
