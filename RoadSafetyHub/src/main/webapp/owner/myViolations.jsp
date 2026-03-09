<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ page import="com.traffic.model.*,com.traffic.service.*,java.util.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getRole().equalsIgnoreCase("owner")) {
        response.sendRedirect(request.getContextPath() + "/index.jsp"); return;
    }
    Owner owner = null;
    for (Owner o : new OwnerServiceImpl().getAllOwners()) {
        if (o.getUserId() == user.getUserId()) { owner = o; break; }
    }
    List<Vehicle> myVehicles = new ArrayList<>();
    List<Violation> myViolations = new ArrayList<>();
    if (owner != null) {
        myVehicles = new VehicleServiceImpl().getVehiclesByOwnerId(owner.getOwnerId());
        Set<Integer> ids = new HashSet<>();
        for (Vehicle v : myVehicles) ids.add(v.getVehicleId());
        for (Violation v : new ViolationServiceImpl().getAllViolations()) {
            if (ids.contains(v.getVehicleId())) myViolations.add(v);
        }
    }
    long paid = myViolations.stream().filter(v -> "PAID".equalsIgnoreCase(v.getPaymentStatus())).count();
    long unpaid = myViolations.size() - paid;
    String msg = request.getParameter("msg");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Violations – RoadSafetyHub</title>
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
    .nav-link-btn:hover,.nav-link-btn.active{color:var(--green);border-color:var(--green);background:rgba(76,175,80,0.08);}
    .nav-user{background:rgba(76,175,80,0.15);border:1px solid var(--green);border-radius:20px;padding:5px 14px;font-size:13px;color:var(--green);}
    .nav-logout{background:transparent;border:1px solid #555;color:#aaa;padding:7px 16px;border-radius:6px;text-decoration:none;font-size:13px;}
    .nav-logout:hover{border-color:#f44336;color:#f44336;}
    .main-wrapper{padding-top:70px;}
    .page-header{background:linear-gradient(135deg,#0a120a,#0d1e0d);border-bottom:1px solid var(--border);padding:32px;}
    .page-header h1{font-family:'Bebas Neue',sans-serif;font-size:36px;letter-spacing:3px;color:var(--green);}
    .page-header p{color:#888;font-size:14px;margin-top:4px;}
    .content{padding:32px;}
    .alert-success{background:#0d2218;border:1px solid #4caf50;color:#4caf50;border-radius:8px;padding:12px 18px;margin-bottom:20px;}
    .alert-error{background:#2a0d0d;border:1px solid #f44336;color:#f44336;border-radius:8px;padding:12px 18px;margin-bottom:20px;}
    .summary-bar{background:var(--card);border:1px solid var(--border);border-radius:12px;padding:16px 20px;margin-bottom:20px;display:flex;gap:16px;flex-wrap:wrap;align-items:center;}
    .badge-paid{background:#0d2218;color:#4caf50;border:1px solid #4caf50;font-size:12px;padding:5px 14px;border-radius:20px;}
    .badge-unpaid{background:#2a0d0d;color:#f44336;border:1px solid #f44336;font-size:12px;padding:5px 14px;border-radius:20px;}
    .badge-total{background:#1a2a1a;color:var(--gold);border:1px solid rgba(255,193,7,0.3);font-size:12px;padding:5px 14px;border-radius:20px;}
    .table-card{background:var(--card);border:1px solid var(--border);border-radius:14px;overflow:hidden;}
    .custom-table{width:100%;border-collapse:collapse;}
    .custom-table thead th{background:#0a140a;color:var(--green);font-family:'Bebas Neue',sans-serif;letter-spacing:1px;font-size:13px;padding:14px 16px;text-align:left;border-bottom:1px solid var(--border);}
    .custom-table tbody td{padding:13px 16px;border-bottom:1px solid rgba(255,255,255,0.04);color:#bbb;font-size:14px;vertical-align:middle;}
    .custom-table tbody tr:hover{background:rgba(76,175,80,0.05);}
    .custom-table tbody tr:last-child td{border-bottom:none;}
    .vid{color:var(--gold);font-weight:700;}
    .btn-pay{background:var(--gold);color:#000;font-weight:700;border:none;border-radius:6px;padding:6px 14px;font-size:12px;text-decoration:none;display:inline-block;}
    .btn-pay:hover{background:#e0a800;color:#000;}
    .empty-state{text-align:center;padding:60px 20px;color:#4caf50;}
    .empty-state .icon{font-size:56px;margin-bottom:16px;}
    footer{background:#060e06;color:#444;text-align:center;padding:18px;font-size:12px;border-top:1px solid #1a2a1a;margin-top:40px;}
</style>
</head>
<body>
<nav class="top-nav">
    <a href="dashboard.jsp" class="nav-brand">🚦 RoadSafetyHub</a>
    <div class="nav-links">
        <a href="dashboard.jsp" class="nav-link-btn">🏠 Dashboard</a>
        <a href="myVehicles.jsp" class="nav-link-btn">🚗 My Vehicles</a>
        <a href="myViolations.jsp" class="nav-link-btn active">⚠️ My Violations</a>
        <span class="nav-user">👤 <%= user.getUsername() %> [OWNER]</span>
        <a href="../index.jsp" class="nav-logout">Logout</a>
    </div>
</nav>
<div class="main-wrapper">
    <div class="page-header">
        <h1>⚠️ My Violations</h1>
        <p>View your traffic violations and pay pending fines</p>
    </div>
    <div class="content">
        <% if (msg != null) { %><div class="alert-success">✅ <%= msg %></div><% } %>
        <% if (error != null) { %><div class="alert-error">❌ <%= error %></div><% } %>
        <div class="summary-bar">
            <span style="color:#888;font-size:13px;">Summary:</span>
            <span class="badge-paid">✅ Paid: <%= paid %></span>
            <span class="badge-unpaid">❌ Pending: <%= unpaid %></span>
            <span class="badge-total">📋 Total: <%= myViolations.size() %></span>
        </div>
        <div class="table-card">
            <div style="overflow-x:auto;">
                <table class="custom-table">
                    <thead><tr><th>#</th><th>ID</th><th>Vehicle</th><th>Rule</th><th>Officer</th><th>Date</th><th>Status</th><th>Action</th></tr></thead>
                    <tbody>
                    <% if (myViolations.isEmpty()) { %>
                    <tr><td colspan="8"><div class="empty-state"><div class="icon">🎉</div><h5>No Violations Found!</h5><p style="color:#555;font-size:14px;">Keep driving safely!</p></div></td></tr>
                    <% } else { int i=1; for(Violation v : myViolations) { %>
                    <tr>
                        <td style="color:#555;"><%= i++ %></td>
                        <td><span class="vid">#<%= v.getViolationId() %></span></td>
                        <td>🚗 <%= v.getVehicleId() %></td>
                        <td>📋 Rule-<%= v.getRuleId() %></td>
                        <td>👮 <%= v.getOfficerId() %></td>
                        <td style="font-size:12px;white-space:nowrap;"><%= v.getViolationDate()!=null?v.getViolationDate().toString().substring(0,16):"N/A" %></td>
                        <td><% if("PAID".equalsIgnoreCase(v.getPaymentStatus())){ %><span class="badge-paid">✅ PAID</span><% }else{ %><span class="badge-unpaid">❌ UNPAID</span><% } %></td>
                        <td>
                            <% if("UNPAID".equalsIgnoreCase(v.getPaymentStatus())){ %>
                            <a href="payment.jsp?violationId=<%= v.getViolationId() %>" class="btn-pay">💳 Pay Fine</a>
                            <% }else{ %><span style="color:#4caf50;font-size:12px;">✔ Cleared</span><% } %>
                        </td>
                    </tr>
                    <% } } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
<footer>© 2026 RoadSafetyHub | Developed by Varshitha | Owner Portal</footer>
</body>
</html>
