<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.traffic.model.*" %>
<%@ page import="com.traffic.service.*" %>
<%@ page import="java.util.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getRole().equalsIgnoreCase("owner")) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    OwnerService ownerService = new OwnerServiceImpl();
    List<Owner> allOwners = ownerService.getAllOwners();
    Owner owner = null;
    for (Owner o : allOwners) {
        if (o.getUserId() == user.getUserId()) { owner = o; break; }
    }
    VehicleService vehicleService = new VehicleServiceImpl();
    ViolationService violationService = new ViolationServiceImpl();
    List<Vehicle> myVehicles = new ArrayList<>();
    List<Violation> myViolations = new ArrayList<>();
    if (owner != null) {
        myVehicles = vehicleService.getVehiclesByOwnerId(owner.getOwnerId());
        Set<Integer> myVehicleIds = new HashSet<>();
        for (Vehicle v : myVehicles) myVehicleIds.add(v.getVehicleId());
        for (Violation v : violationService.getAllViolations()) {
            if (myVehicleIds.contains(v.getVehicleId())) myViolations.add(v);
        }
    }
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
    :root { --gold: #ffc107; --dark: #0f0f0f; --card-bg: #1a1a1a; --border: rgba(255,193,7,0.2); --green: #4caf50; }
    body { background: var(--dark); color: #e0e0e0; font-family: 'DM Sans', sans-serif; padding-top: 70px; min-height: 100vh; }
    .page-header { background: #0a1f0a; border-bottom: 2px solid var(--green); padding: 24px 0 18px; margin-bottom: 28px; }
    .page-header h2 { font-family: 'Bebas Neue', sans-serif; font-size: 32px; letter-spacing: 3px; color: var(--green); margin: 0; }
    .card-dark { background: var(--card-bg); border: 1px solid var(--border); border-radius: 12px; }
    .table-dark-custom thead th { background: #222; color: var(--gold); font-family: 'Bebas Neue', sans-serif; letter-spacing: 1.5px; font-size: 14px; border-color: var(--border); }
    .table-dark-custom tbody tr { border-color: #2a2a2a; color: #ccc; transition: background 0.15s; }
    .table-dark-custom tbody tr:hover { background: #222; }
    .table-dark-custom td { border-color: #2a2a2a; vertical-align: middle; }
    .badge-paid { background: #1a3a2a; color: #4caf50; border: 1px solid #4caf50; font-size: 11px; padding: 4px 10px; border-radius: 20px; }
    .badge-unpaid { background: #3a1a1a; color: #f44336; border: 1px solid #f44336; font-size: 11px; padding: 4px 10px; border-radius: 20px; }
    .btn-pay { background: var(--gold); color: #000; font-weight: 600; border: none; border-radius: 6px; font-size: 12px; padding: 5px 14px; }
    .btn-pay:hover { background: #e0a800; }
    .section-title { font-family: 'Bebas Neue', sans-serif; font-size: 20px; letter-spacing: 2px; color: var(--gold); }
    footer { background: #111; color: #555; text-align: center; padding: 16px; font-size: 13px; border-top: 1px solid #222; margin-top: 60px; }
    .summary-bar { background: var(--card-bg); border: 1px solid var(--border); border-radius: 12px; padding: 16px 20px; margin-bottom: 20px; }
</style>
</head>
<body>
<%@ include file="../navbar.jsp" %>

<div class="page-header">
    <div class="container-fluid px-4">
        <h2>⚠️ My Violations</h2>
        <p style="color:#aaa;margin:0;font-size:13px;">View your traffic violations and pay fines</p>
    </div>
</div>

<div class="container-fluid px-4">
    <% if (msg != null) { %><div class="alert mb-3" style="background:#1a3a1a;border:1px solid #4caf50;color:#4caf50;border-radius:8px;">✅ <%= msg %></div><% } %>
    <% if (error != null) { %><div class="alert mb-3" style="background:#3a1a1a;border:1px solid #f44336;color:#f44336;border-radius:8px;">❌ <%= error %></div><% } %>

    <% if (owner == null) { %>
    <div class="alert" style="background:#3a2a1a;border:1px solid #ff9800;color:#ff9800;border-radius:8px;">⚠️ Owner profile not set up. Contact admin.</div>
    <% } else { %>

    <!-- Summary -->
    <div class="summary-bar d-flex flex-wrap gap-3 align-items-center">
        <span style="color:#aaa;font-size:13px;">Summary:</span>
        <span class="badge-paid px-3 py-2" style="font-size:13px;">✅ Paid: <%= myViolations.stream().filter(v -> "PAID".equalsIgnoreCase(v.getPaymentStatus())).count() %></span>
        <span class="badge-unpaid px-3 py-2" style="font-size:13px;">❌ Pending: <%= myViolations.stream().filter(v -> "UNPAID".equalsIgnoreCase(v.getPaymentStatus())).count() %></span>
        <span class="badge px-3 py-2" style="background:#2a2a2a;color:var(--gold);font-size:13px;">📋 Total: <%= myViolations.size() %></span>
    </div>

    <div class="card-dark p-0 overflow-hidden">
        <div class="p-3" style="border-bottom:1px solid var(--border);">
            <span class="section-title mb-0">Violation History</span>
        </div>
        <div class="table-responsive">
            <table class="table table-dark-custom mb-0">
                <thead>
                    <tr><th>#</th><th>Violation ID</th><th>Vehicle ID</th><th>Rule ID</th><th>Officer</th><th>Date</th><th>Status</th><th>Action</th></tr>
                </thead>
                <tbody>
                    <% if (myViolations.isEmpty()) { %>
                    <tr><td colspan="8" class="text-center py-4" style="color:#4caf50;">🎉 No violations found! Keep driving safely.</td></tr>
                    <% } else { int i = 1; for (Violation v : myViolations) { %>
                    <tr>
                        <td><%= i++ %></td>
                        <td><strong style="color:var(--gold);">#<%= v.getViolationId() %></strong></td>
                        <td>🚗 <%= v.getVehicleId() %></td>
                        <td>📋 <%= v.getRuleId() %></td>
                        <td>👮 <%= v.getOfficerId() %></td>
                        <td style="font-size:12px;"><%= v.getViolationDate() != null ? v.getViolationDate().toString().substring(0,16) : "N/A" %></td>
                        <td>
                            <% if ("PAID".equalsIgnoreCase(v.getPaymentStatus())) { %>
                                <span class="badge-paid">✅ PAID</span>
                            <% } else { %>
                                <span class="badge-unpaid">❌ UNPAID</span>
                            <% } %>
                        </td>
                        <td>
                            <% if ("UNPAID".equalsIgnoreCase(v.getPaymentStatus())) { %>
                            <a href="${pageContext.request.contextPath}/owner/payment.jsp?violationId=<%= v.getViolationId() %>"
                               class="btn-pay">💳 Pay Fine</a>
                            <% } else { %>
                            <span style="color:#4caf50;font-size:12px;">✔ Cleared</span>
                            <% } %>
                        </td>
                    </tr>
                    <% } } %>
                </tbody>
            </table>
        </div>
    </div>
    <% } %>
</div>

<footer>© 2026 RoadSafetyHub | Developed by Varshitha</footer>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
