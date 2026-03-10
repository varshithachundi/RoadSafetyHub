<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ page import="com.traffic.model.*,com.traffic.service.*,java.util.*" %>
<%
    // Allow both registered owners AND guests (vehicle number login)
    Vehicle guestVehicle = (Vehicle) session.getAttribute("guestVehicle");
    User user = (User) session.getAttribute("user");

    // Must have either a guest vehicle session OR be a logged-in owner
    if (guestVehicle == null && (user == null || !user.getRole().equalsIgnoreCase("owner"))) {
        response.sendRedirect(request.getContextPath() + "/index.jsp?error=Please enter your vehicle number to view violations.");
        return;
    }

    // Determine which vehicle to show
    Vehicle targetVehicle = guestVehicle;
    Owner linkedOwner = (Owner) session.getAttribute("guestOwner");
    boolean isGuest = (guestVehicle != null);

    // If logged-in owner, find their vehicle from URL param
    if (!isGuest && user != null) {
        String vidParam = request.getParameter("vehicleId");
        if (vidParam != null) {
            int vid = Integer.parseInt(vidParam);
            for (Vehicle v : new VehicleServiceImpl().getAllVehicles()) {
                if (v.getVehicleId() == vid) { targetVehicle = v; break; }
            }
        }
    }

    // Load violations for this vehicle
    List<Violation> violations = new ArrayList<>();
    TrafficRuleService ruleService = new TrafficRuleServiceImpl();
    Map<Integer, TrafficRule> rulesMap = new HashMap<>();
    for (TrafficRule r : ruleService.getAllTrafficRules()) rulesMap.put(r.getRuleId(), r);

    double totalDue = 0;
    if (targetVehicle != null) {
        for (Violation v : new ViolationServiceImpl().getAllViolations()) {
            if (v.getVehicleId() == targetVehicle.getVehicleId()) {
                violations.add(v);
                if ("UNPAID".equalsIgnoreCase(v.getPaymentStatus())) {
                    TrafficRule r = rulesMap.get(v.getRuleId());
                    if (r != null) totalDue += r.getFineAmount();
                }
            }
        }
    }
    long paid = violations.stream().filter(v -> "PAID".equalsIgnoreCase(v.getPaymentStatus())).count();
    long unpaid = violations.size() - paid;

    String msg = request.getParameter("msg");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Vehicle Violations – RoadSafetyHub</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet">
<style>
    :root{--gold:#ffc107;--green:#4caf50;--dark:#0a0a0a;--card:#141414;--border:rgba(255,193,7,0.2);}
    *{box-sizing:border-box;margin:0;padding:0;}
    body{background:var(--dark);color:#e0e0e0;font-family:'DM Sans',sans-serif;min-height:100vh;}
    .top-nav{background:rgba(10,10,10,0.98);border-bottom:2px solid var(--gold);padding:14px 28px;display:flex;align-items:center;justify-content:space-between;position:fixed;top:0;left:0;right:0;z-index:1000;}
    .nav-brand{font-family:'Bebas Neue',sans-serif;font-size:24px;letter-spacing:3px;color:var(--gold);text-decoration:none;}
    .nav-right{display:flex;align-items:center;gap:10px;}
    .nav-info{background:rgba(255,193,7,0.12);border:1px solid var(--gold);border-radius:20px;padding:5px 14px;font-size:13px;color:var(--gold);}
    .btn-logout{background:transparent;border:1px solid #555;color:#aaa;padding:7px 16px;border-radius:6px;text-decoration:none;font-size:13px;}
    .btn-logout:hover{border-color:#f44336;color:#f44336;}
    .main-wrapper{padding-top:70px;}
    /* HERO */
    .hero{background:linear-gradient(135deg,#0a0a0a,#1a1200);border-bottom:1px solid var(--border);padding:36px 32px;position:relative;overflow:hidden;}
    .hero::before{content:'🚗';position:absolute;right:40px;top:50%;transform:translateY(-50%);font-size:90px;opacity:0.07;}
    .hero h1{font-family:'Bebas Neue',sans-serif;font-size:38px;letter-spacing:4px;color:var(--gold);margin-bottom:6px;}
    .hero p{color:#888;font-size:14px;}
    .hero strong{color:var(--gold);}
    .content{padding:32px;}
    .alert-success{background:#0d2218;border:1px solid #4caf50;color:#4caf50;border-radius:8px;padding:12px 18px;margin-bottom:20px;}
    .alert-error{background:#2a0d0d;border:1px solid #f44336;color:#f44336;border-radius:8px;padding:12px 18px;margin-bottom:20px;}
    /* VEHICLE INFO CARD */
    .vehicle-card{background:var(--card);border:2px solid var(--gold);border-radius:14px;padding:22px 26px;margin-bottom:28px;display:flex;align-items:center;gap:20px;flex-wrap:wrap;}
    .vehicle-icon{font-size:48px;}
    .vehicle-info h4{font-family:'Bebas Neue',sans-serif;font-size:28px;letter-spacing:3px;color:var(--gold);margin-bottom:4px;}
    .vehicle-info p{color:#888;font-size:13px;}
    .vehicle-info .type-badge{display:inline-block;background:#2a2a2a;color:#aaa;border-radius:6px;padding:2px 10px;font-size:12px;margin-top:4px;}
    .guest-badge{margin-left:auto;background:#1a1200;border:1px solid var(--gold);border-radius:20px;padding:6px 16px;color:var(--gold);font-size:12px;}
    /* TOTAL DUE */
    .total-due-box{background:linear-gradient(135deg,#1a0500,#2a0d00);border:2px solid #f44336;border-radius:14px;padding:20px 26px;margin-bottom:28px;display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:12px;}
    .total-due-box.all-clear{background:linear-gradient(135deg,#051a05,#0d2a0d);border-color:#4caf50;}
    .due-label{font-size:13px;color:#888;text-transform:uppercase;letter-spacing:1px;margin-bottom:4px;}
    .due-amount{font-family:'Bebas Neue',sans-serif;font-size:42px;color:#f44336;line-height:1;}
    .due-amount.clear{color:#4caf50;}
    .due-msg{font-size:13px;color:#888;margin-top:4px;}
    /* SUMMARY */
    .summary-bar{display:flex;gap:12px;flex-wrap:wrap;margin-bottom:20px;}
    .badge-paid{background:#0d2218;color:#4caf50;border:1px solid #4caf50;font-size:12px;padding:5px 14px;border-radius:20px;}
    .badge-unpaid{background:#2a0d0d;color:#f44336;border:1px solid #f44336;font-size:12px;padding:5px 14px;border-radius:20px;}
    .badge-total{background:#2a2a2a;color:var(--gold);border:1px solid var(--border);font-size:12px;padding:5px 14px;border-radius:20px;}
    /* TABLE */
    .table-card{background:var(--card);border:1px solid var(--border);border-radius:14px;overflow:hidden;}
    .custom-table{width:100%;border-collapse:collapse;}
    .custom-table thead th{background:#111;color:var(--gold);font-family:'Bebas Neue',sans-serif;letter-spacing:1px;font-size:13px;padding:14px 16px;text-align:left;border-bottom:1px solid var(--border);}
    .custom-table tbody td{padding:13px 16px;border-bottom:1px solid rgba(255,255,255,0.04);color:#bbb;font-size:14px;vertical-align:middle;}
    .custom-table tbody tr:hover{background:rgba(255,193,7,0.03);}
    .custom-table tbody tr:last-child td{border-bottom:none;}
    .vid{color:var(--gold);font-weight:700;}
    .fine-due{color:#f44336;font-weight:700;font-size:15px;}
    .fine-clear{color:#4caf50;font-weight:700;font-size:15px;}
    .rule-sub{font-size:11px;color:#555;display:block;margin-top:2px;}
    .btn-pay{background:var(--gold);color:#000;font-weight:700;border:none;border-radius:6px;padding:7px 16px;font-size:13px;text-decoration:none;display:inline-block;}
    .btn-pay:hover{background:#e0a800;color:#000;}
    /* REGISTER CTA */
    .register-cta{background:#111820;border:1px solid rgba(33,150,243,0.4);border-radius:14px;padding:24px 28px;margin-top:32px;display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:16px;}
    .register-cta h5{color:#64b5f6;margin-bottom:6px;font-size:16px;}
    .register-cta p{color:#555;font-size:13px;margin:0;}
    .btn-register{background:#2196f3;color:#fff;font-weight:700;border:none;border-radius:8px;padding:10px 24px;font-size:14px;text-decoration:none;white-space:nowrap;}
    .btn-register:hover{background:#1976d2;color:#fff;}
    .empty-state{text-align:center;padding:60px 20px;}
    footer{background:#080808;color:#444;text-align:center;padding:18px;font-size:12px;border-top:1px solid #1a1a1a;margin-top:40px;}
</style>
</head>
<body>
<nav class="top-nav">
    <a href="../index.jsp" class="nav-brand">🚦 RoadSafetyHub</a>
    <div class="nav-right">
        <% if (targetVehicle != null) { %>
        <span class="nav-info">🚗 <%= targetVehicle.getVehicleNumber() %></span>
        <% } %>
        <% if (isGuest) { %>
        <a href="../index.jsp" class="btn-logout" onclick="session.invalidate()">Exit</a>
        <% } else { %>
        <a href="dashboard.jsp" class="btn-logout">← Dashboard</a>
        <% } %>
    </div>
</nav>

<div class="main-wrapper">
    <div class="hero">
        <h1>🚗 Vehicle Violations</h1>
        <p>Showing all violations for vehicle <strong><%= targetVehicle != null ? targetVehicle.getVehicleNumber() : "" %></strong></p>
    </div>
    <div class="content">
        <% if (msg != null) { %><div class="alert-success">✅ <%= msg %></div><% } %>
        <% if (error != null) { %><div class="alert-error">❌ <%= error %></div><% } %>

        <!-- VEHICLE INFO -->
        <% if (targetVehicle != null) { %>
        <div class="vehicle-card">
            <div class="vehicle-icon">🚗</div>
            <div class="vehicle-info">
                <h4><%= targetVehicle.getVehicleNumber() %></h4>
                <p>Vehicle ID: #<%= targetVehicle.getVehicleId() %></p>
                <span class="type-badge"><%= targetVehicle.getVehicleType() %></span>
            </div>
            <div class="guest-badge"><%= isGuest ? "👤 Guest View" : "✅ Registered Owner" %></div>
        </div>

        <!-- TOTAL DUE -->
        <div class="total-due-box <%= totalDue == 0 ? "all-clear" : "" %>">
            <div>
                <div class="due-label">Total Amount Due</div>
                <div class="due-amount <%= totalDue == 0 ? "clear" : "" %>">₹<%= String.format("%.0f", totalDue) %></div>
                <div class="due-msg"><%= totalDue > 0 ? "⚠️ Please pay your pending fines immediately" : "✅ No pending fines — Keep it up!" %></div>
            </div>
            <% if (totalDue > 0) { %>
            <div style="text-align:right;">
                <div style="font-size:12px;color:#888;margin-bottom:4px;"><%= unpaid %> unpaid fine<%= unpaid > 1 ? "s" : "" %></div>
                <div style="font-size:12px;color:#4caf50;"><%= paid %> cleared</div>
            </div>
            <% } %>
        </div>

        <!-- SUMMARY -->
        <div class="summary-bar">
            <span class="badge-paid">✅ Paid: <%= paid %></span>
            <span class="badge-unpaid">❌ Unpaid: <%= unpaid %></span>
            <span class="badge-total">📋 Total: <%= violations.size() %></span>
        </div>

        <!-- VIOLATIONS TABLE -->
        <div class="table-card">
            <div style="overflow-x:auto;">
                <table class="custom-table">
                    <thead><tr><th>#</th><th>Violation ID</th><th>Rule / Offence</th><th>Date</th><th>Fine Amount</th><th>Status</th><th>Action</th></tr></thead>
                    <tbody>
                    <% if (violations.isEmpty()) { %>
                    <tr><td colspan="7">
                        <div class="empty-state">
                            <div style="font-size:56px;margin-bottom:12px;">🎉</div>
                            <h5 style="color:#4caf50;">No Violations Found!</h5>
                            <p style="color:#555;font-size:14px;">This vehicle has no recorded violations.</p>
                        </div>
                    </td></tr>
                    <% } else { int i=1; for (Violation v : violations) {
                        TrafficRule rule = rulesMap.get(v.getRuleId());
                        String ruleName = rule != null ? rule.getRuleName() : "Rule #" + v.getRuleId();
                        double fineAmt  = rule != null ? rule.getFineAmount() : 0;
                    %>
                    <tr>
                        <td style="color:#555;"><%= i++ %></td>
                        <td><span class="vid">#<%= v.getViolationId() %></span></td>
                        <td>
                            <strong style="color:#e0e0e0;"><%= ruleName %></strong>
                            <span class="rule-sub"><%= rule != null ? rule.getPenaltyPoints()+" penalty points" : "" %></span>
                        </td>
                        <td style="font-size:12px;white-space:nowrap;"><%= v.getViolationDate()!=null?v.getViolationDate().toString().substring(0,16):"N/A" %></td>
                        <td>
                            <% if ("PAID".equalsIgnoreCase(v.getPaymentStatus())) { %>
                            <span class="fine-clear">₹<%= String.format("%.0f", fineAmt) %></span>
                            <% } else { %>
                            <span class="fine-due">₹<%= String.format("%.0f", fineAmt) %></span>
                            <% } %>
                        </td>
                        <td>
                            <% if ("PAID".equalsIgnoreCase(v.getPaymentStatus())) { %>
                            <span class="badge-paid">✅ PAID</span>
                            <% } else { %>
                            <span class="badge-unpaid">❌ UNPAID</span>
                            <% } %>
                        </td>
                        <td>
                            <% if ("UNPAID".equalsIgnoreCase(v.getPaymentStatus())) {
                               if (!isGuest) { %>
                            <a href="payment.jsp?violationId=<%= v.getViolationId() %>&amount=<%= fineAmt %>" class="btn-pay">💳 Pay ₹<%= String.format("%.0f", fineAmt) %></a>
                            <% } else { %>
                            <span style="color:#ff9800;font-size:12px;">⚠️ Register to pay</span>
                            <% } } %>
                        </td>
                    </tr>
                    <% } } %>
                    </tbody>
                </table>
            </div>
        </div>
        <% } %>

        <!-- REGISTER CTA for guests -->
        <% if (isGuest && unpaid > 0) { %>
        <div class="register-cta">
            <div>
                <h5>💡 Register to Pay Your Fines Online</h5>
                <p>Create a free account to pay your ₹<%= String.format("%.0f", totalDue) %> fine online using UPI, Card or Net Banking.</p>
            </div>
            <a href="../index.jsp" class="btn-register">Register Now →</a>
        </div>
        <% } %>

    </div>
</div>
<footer>© 2026 RoadSafetyHub | Developed by Varshitha | Vehicle Violation Lookup</footer>
</body>
</html>
