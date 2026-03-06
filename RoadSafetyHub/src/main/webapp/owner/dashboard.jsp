<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.traffic.model.User" %>
<%@ page import="com.traffic.service.*" %>
<%@ page import="java.util.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getRole().equalsIgnoreCase("admin")) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    OwnerService ownerService = new OwnerServiceImpl();
    PoliceService policeService = new PoliceServiceImpl();
    VehicleService vehicleService = new VehicleServiceImpl();
    ViolationService violationService = new ViolationServiceImpl();
    int totalOwners = ownerService.getAllOwners().size();
    int totalPolice = policeService.getAllPoliceOfficers().size();
    int totalVehicles = vehicleService.getAllVehicles().size();
    int totalViolations = violationService.getAllViolations().size();
    long unpaidCount = violationService.getAllViolations().stream()
        .filter(v -> "UNPAID".equalsIgnoreCase(v.getPaymentStatus())).count();
    long paidCount = totalViolations - unpaidCount;
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Dashboard – RoadSafetyHub</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet">
<style>
    :root {
        --gold: #ffc107;
        --gold-dark: #e0a800;
        --dark: #0f0f0f;
        --card-bg: #1a1a1a;
        --border: rgba(255,193,7,0.2);
    }
    * { box-sizing: border-box; }
    body {
        background: var(--dark);
        color: #e0e0e0;
        font-family: 'DM Sans', sans-serif;
        padding-top: 70px;
        min-height: 100vh;
    }
    .page-header {
        background: linear-gradient(135deg, #1a1a1a 0%, #222 100%);
        border-bottom: 2px solid var(--gold);
        padding: 28px 0 20px;
        margin-bottom: 32px;
    }
    .page-header h2 {
        font-family: 'Bebas Neue', sans-serif;
        font-size: 36px;
        letter-spacing: 3px;
        color: var(--gold);
        margin: 0;
    }
    .stat-card {
        background: var(--card-bg);
        border: 1px solid var(--border);
        border-radius: 12px;
        padding: 28px 24px;
        transition: transform 0.2s, border-color 0.2s;
        position: relative;
        overflow: hidden;
    }
    .stat-card::before {
        content: '';
        position: absolute;
        top: 0; left: 0;
        width: 4px; height: 100%;
        background: var(--gold);
        border-radius: 12px 0 0 12px;
    }
    .stat-card:hover {
        transform: translateY(-4px);
        border-color: var(--gold);
    }
    .stat-icon {
        font-size: 38px;
        margin-bottom: 10px;
    }
    .stat-number {
        font-family: 'Bebas Neue', sans-serif;
        font-size: 48px;
        color: var(--gold);
        line-height: 1;
    }
    .stat-label {
        font-size: 13px;
        color: #888;
        text-transform: uppercase;
        letter-spacing: 1.5px;
        margin-top: 4px;
    }
    .action-card {
        background: var(--card-bg);
        border: 1px solid var(--border);
        border-radius: 12px;
        padding: 24px;
        text-decoration: none;
        color: #e0e0e0;
        display: block;
        transition: all 0.2s;
        text-align: center;
    }
    .action-card:hover {
        background: #222;
        border-color: var(--gold);
        color: var(--gold);
        transform: translateY(-3px);
        text-decoration: none;
    }
    .action-card .icon { font-size: 32px; margin-bottom: 10px; }
    .action-card .title { font-weight: 600; font-size: 15px; }
    .section-title {
        font-family: 'Bebas Neue', sans-serif;
        font-size: 22px;
        letter-spacing: 2px;
        color: var(--gold);
        margin-bottom: 20px;
        padding-bottom: 8px;
        border-bottom: 1px solid var(--border);
    }
    .badge-paid { background: #1a3a2a; color: #4caf50; border: 1px solid #4caf50; }
    .badge-unpaid { background: #3a1a1a; color: #f44336; border: 1px solid #f44336; }
    .progress-bar-custom {
        background: #2a2a2a;
        border-radius: 20px;
        height: 10px;
        overflow: hidden;
        margin-top: 8px;
    }
    .progress-fill {
        height: 100%;
        border-radius: 20px;
        background: linear-gradient(90deg, var(--gold), var(--gold-dark));
        transition: width 1s ease;
    }
    footer {
        background: #111;
        color: #555;
        text-align: center;
        padding: 16px;
        font-size: 13px;
        border-top: 1px solid #222;
        margin-top: 60px;
    }
    .alert-msg {
        background: #1a3a1a;
        border: 1px solid #4caf50;
        color: #4caf50;
        border-radius: 8px;
        padding: 12px 20px;
    }
</style>
</head>
<body>
<%@ include file="../navbar.jsp" %>

<div class="page-header">
    <div class="container-fluid px-4">
        <h2>⚙️ Admin Dashboard</h2>
        <p class="text-muted mb-0" style="font-size:14px;">Welcome back, <strong class="text-warning"><%= user.getUsername() %></strong> — Full system control</p>
    </div>
</div>

<div class="container-fluid px-4">
    <% String msg = request.getParameter("msg"); if (msg != null) { %>
    <div class="alert-msg mb-4">✅ <%= msg %></div>
    <% } %>

    <!-- Stats Row -->
    <p class="section-title">📊 System Overview</p>
    <div class="row g-3 mb-5">
        <div class="col-6 col-md-3">
            <div class="stat-card">
                <div class="stat-icon">👤</div>
                <div class="stat-number"><%= totalOwners %></div>
                <div class="stat-label">Vehicle Owners</div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="stat-card">
                <div class="stat-icon">👮</div>
                <div class="stat-number"><%= totalPolice %></div>
                <div class="stat-label">Police Officers</div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="stat-card">
                <div class="stat-icon">🚗</div>
                <div class="stat-number"><%= totalVehicles %></div>
                <div class="stat-label">Registered Vehicles</div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="stat-card">
                <div class="stat-icon">⚠️</div>
                <div class="stat-number"><%= totalViolations %></div>
                <div class="stat-label">Total Violations</div>
            </div>
        </div>
    </div>

    <!-- Violation Status -->
    <div class="row g-3 mb-5">
        <div class="col-md-6">
            <div class="stat-card">
                <p class="section-title mb-3">📈 Violation Payment Status</p>
                <div class="d-flex justify-content-between mb-2">
                    <span><span class="badge badge-paid px-2 py-1 me-2">PAID</span> <%= paidCount %> violations</span>
                    <span><span class="badge badge-unpaid px-2 py-1 me-2">UNPAID</span> <%= unpaidCount %> violations</span>
                </div>
                <% int paidPct = totalViolations > 0 ? (int)((paidCount * 100) / totalViolations) : 0; %>
                <div class="progress-bar-custom">
                    <div class="progress-fill" style="width:<%= paidPct %>%"></div>
                </div>
                <small class="text-muted mt-2 d-block"><%= paidPct %>% fines collected</small>
            </div>
        </div>
        <div class="col-md-6">
            <div class="stat-card">
                <p class="section-title mb-3">🗂️ Quick Summary</p>
                <table class="table table-dark table-sm mb-0" style="background:transparent;">
                    <tbody>
                        <tr><td class="text-muted">Total Owners</td><td class="text-warning fw-bold"><%= totalOwners %></td></tr>
                        <tr><td class="text-muted">Total Police</td><td class="text-warning fw-bold"><%= totalPolice %></td></tr>
                        <tr><td class="text-muted">Total Vehicles</td><td class="text-warning fw-bold"><%= totalVehicles %></td></tr>
                        <tr><td class="text-muted">Pending Fines</td><td class="text-danger fw-bold"><%= unpaidCount %></td></tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Quick Actions -->
    <p class="section-title">⚡ Quick Actions</p>
    <div class="row g-3 mb-5">
        <div class="col-6 col-md-3">
            <a href="${pageContext.request.contextPath}/admin/owners.jsp" class="action-card">
                <div class="icon">👤</div>
                <div class="title">Manage Owners</div>
            </a>
        </div>
        <div class="col-6 col-md-3">
            <a href="${pageContext.request.contextPath}/admin/police.jsp" class="action-card">
                <div class="icon">👮</div>
                <div class="title">Manage Police</div>
            </a>
        </div>
        <div class="col-6 col-md-3">
            <a href="${pageContext.request.contextPath}/admin/violations.jsp" class="action-card">
                <div class="icon">⚠️</div>
                <div class="title">View Violations</div>
            </a>
        </div>
        <div class="col-6 col-md-3">
            <a href="${pageContext.request.contextPath}/index.jsp" class="action-card">
                <div class="icon">🚪</div>
                <div class="title">Logout</div>
            </a>
        </div>
    </div>
</div>

<footer>© 2026 RoadSafetyHub | Developed by Varshitha</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
