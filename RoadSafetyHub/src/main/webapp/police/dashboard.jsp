<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ page import="com.traffic.model.*" %>
<%@ page import="com.traffic.service.*" %>
<%@ page import="java.util.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getRole().equalsIgnoreCase("police")) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    ViolationService violationService = new ViolationServiceImpl();
    VehicleService vehicleService = new VehicleServiceImpl();
    List<Violation> allViolations = violationService.getAllViolations();
    int totalVehicles = vehicleService.getAllVehicles().size();
    long unpaid = 0, paid = 0;
    for (Violation v : allViolations) {
        if ("UNPAID".equalsIgnoreCase(v.getPaymentStatus())) unpaid++;
        else paid++;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Police Dashboard – RoadSafetyHub</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet">
<style>
    :root { --gold: #ffc107; --blue: #2196f3; --dark: #0a0f1a; --card-bg: #111827; --border: rgba(33,150,243,0.25); }
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { background: var(--dark); color: #e0e0e0; font-family: 'DM Sans', sans-serif; min-height: 100vh; }

    /* NAVBAR */
    .top-nav {
        background: rgba(10,15,26,0.98);
        border-bottom: 2px solid var(--blue);
        padding: 14px 28px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        position: fixed;
        top: 0; left: 0; right: 0;
        z-index: 1000;
        backdrop-filter: blur(10px);
    }
    .nav-brand {
        font-family: 'Bebas Neue', sans-serif;
        font-size: 24px;
        letter-spacing: 3px;
        color: var(--gold);
        text-decoration: none;
    }
    .nav-links { display: flex; align-items: center; gap: 8px; flex-wrap: wrap; }
    .nav-link-btn {
        color: #ccc;
        text-decoration: none;
        padding: 7px 16px;
        border-radius: 6px;
        font-size: 14px;
        transition: all 0.2s;
        border: 1px solid transparent;
    }
    .nav-link-btn:hover { color: var(--blue); border-color: var(--blue); background: rgba(33,150,243,0.08); }
    .nav-link-btn.active { color: var(--blue); border-color: var(--blue); background: rgba(33,150,243,0.12); }
    .nav-user { background: rgba(33,150,243,0.15); border: 1px solid var(--blue); border-radius: 20px; padding: 5px 14px; font-size: 13px; color: var(--blue); }
    .nav-logout { background: transparent; border: 1px solid #555; color: #aaa; padding: 7px 16px; border-radius: 6px; text-decoration: none; font-size: 13px; transition: all 0.2s; }
    .nav-logout:hover { border-color: #f44336; color: #f44336; }

    /* LAYOUT */
    .main-wrapper { padding-top: 70px; }

    /* HERO BANNER */
    .hero-banner {
        background: linear-gradient(135deg, #0a0f1a 0%, #0d1b2e 50%, #0a1628 100%);
        border-bottom: 1px solid var(--border);
        padding: 40px 32px 32px;
        position: relative;
        overflow: hidden;
    }
    .hero-banner::before {
        content: '👮';
        position: absolute;
        right: 40px;
        top: 50%;
        transform: translateY(-50%);
        font-size: 100px;
        opacity: 0.07;
    }
    .hero-banner h1 {
        font-family: 'Bebas Neue', sans-serif;
        font-size: 42px;
        letter-spacing: 4px;
        color: var(--blue);
        margin-bottom: 6px;
    }
    .hero-banner p { color: #888; font-size: 15px; }
    .hero-banner strong { color: var(--blue); }

    /* CONTENT */
    .content { padding: 32px; }

    /* STAT CARDS */
    .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-bottom: 40px; }
    .stat-card {
        background: var(--card-bg);
        border: 1px solid var(--border);
        border-radius: 14px;
        padding: 28px 24px;
        position: relative;
        overflow: hidden;
        transition: transform 0.2s, border-color 0.2s;
    }
    .stat-card:hover { transform: translateY(-4px); border-color: var(--blue); }
    .stat-card .accent { position: absolute; top: 0; left: 0; width: 4px; height: 100%; background: var(--blue); border-radius: 14px 0 0 14px; }
    .stat-card .emoji { font-size: 30px; margin-bottom: 12px; }
    .stat-card .number { font-family: 'Bebas Neue', sans-serif; font-size: 52px; line-height: 1; margin-bottom: 4px; }
    .stat-card .label { font-size: 12px; color: #666; text-transform: uppercase; letter-spacing: 1.5px; }
    .stat-card.blue .number { color: var(--blue); }
    .stat-card.gold .number { color: var(--gold); }
    .stat-card.red .number { color: #f44336; }
    .stat-card.green .number { color: #4caf50; }

    /* SECTION TITLE */
    .section-title {
        font-family: 'Bebas Neue', sans-serif;
        font-size: 20px;
        letter-spacing: 2px;
        color: var(--gold);
        margin-bottom: 18px;
        padding-bottom: 10px;
        border-bottom: 1px solid rgba(255,193,7,0.2);
    }

    /* ACTION CARDS */
    .actions-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 16px; margin-bottom: 40px; }
    .action-card {
        background: var(--card-bg);
        border: 1px solid var(--border);
        border-radius: 14px;
        padding: 32px 24px;
        text-align: center;
        text-decoration: none;
        color: #e0e0e0;
        transition: all 0.2s;
        display: block;
    }
    .action-card:hover { border-color: var(--blue); color: var(--blue); transform: translateY(-4px); background: #131d2e; text-decoration: none; }
    .action-card .a-icon { font-size: 40px; margin-bottom: 14px; }
    .action-card .a-title { font-weight: 600; font-size: 16px; margin-bottom: 4px; }
    .action-card .a-desc { font-size: 12px; color: #666; }

    /* TABLE */
    .table-card { background: var(--card-bg); border: 1px solid var(--border); border-radius: 14px; overflow: hidden; margin-bottom: 40px; }
    .table-card-header { padding: 18px 22px; border-bottom: 1px solid var(--border); display: flex; justify-content: space-between; align-items: center; }
    .table-card-header span { font-family: 'Bebas Neue', sans-serif; font-size: 18px; letter-spacing: 2px; color: var(--gold); }
    .custom-table { width: 100%; border-collapse: collapse; }
    .custom-table thead th { background: #0d1520; color: var(--blue); font-family: 'Bebas Neue', sans-serif; letter-spacing: 1px; font-size: 13px; padding: 14px 16px; text-align: left; border-bottom: 1px solid var(--border); }
    .custom-table tbody td { padding: 13px 16px; border-bottom: 1px solid rgba(255,255,255,0.04); color: #bbb; font-size: 14px; }
    .custom-table tbody tr:hover { background: rgba(33,150,243,0.05); }
    .custom-table tbody tr:last-child td { border-bottom: none; }
    .badge-paid { background: #0d2218; color: #4caf50; border: 1px solid #4caf50; font-size: 11px; padding: 3px 10px; border-radius: 20px; }
    .badge-unpaid { background: #2a0d0d; color: #f44336; border: 1px solid #f44336; font-size: 11px; padding: 3px 10px; border-radius: 20px; }
    .vid { color: var(--gold); font-weight: 700; }

    footer { background: #080c14; color: #444; text-align: center; padding: 18px; font-size: 12px; border-top: 1px solid #1a2030; }
</style>
</head>
<body>

<!-- NAVBAR -->
<nav class="top-nav">
    <a href="#" class="nav-brand">🚦 RoadSafetyHub</a>
    <div class="nav-links">
        <a href="dashboard.jsp" class="nav-link-btn active">🏠 Dashboard</a>
        <a href="addViolation.jsp" class="nav-link-btn">➕ Add Violation</a>
        <a href="violationList.jsp" class="nav-link-btn">📋 Violations</a>
        <span class="nav-user">👮 <%= user.getUsername() %> [POLICE]</span>
        <a href="../index.jsp" class="nav-logout">Logout</a>
    </div>
</nav>

<div class="main-wrapper">

    <!-- HERO -->
    <div class="hero-banner">
        <h1>👮 Police Dashboard</h1>
        <p>Welcome back, <strong><%= user.getUsername() %></strong> — Traffic Enforcement Officer</p>
    </div>

    <div class="content">

        <!-- STATS -->
        <div class="section-title">📊 Today's Overview</div>
        <div class="stats-grid">
            <div class="stat-card blue">
                <div class="accent"></div>
                <div class="emoji">⚠️</div>
                <div class="number"><%= allViolations.size() %></div>
                <div class="label">Total Violations</div>
            </div>
            <div class="stat-card red">
                <div class="accent" style="background:#f44336;"></div>
                <div class="emoji">❌</div>
                <div class="number"><%= unpaid %></div>
                <div class="label">Unpaid Fines</div>
            </div>
            <div class="stat-card green">
                <div class="accent" style="background:#4caf50;"></div>
                <div class="emoji">✅</div>
                <div class="number"><%= paid %></div>
                <div class="label">Paid Fines</div>
            </div>
            <div class="stat-card gold">
                <div class="accent" style="background:var(--gold);"></div>
                <div class="emoji">🚗</div>
                <div class="number"><%= totalVehicles %></div>
                <div class="label">Registered Vehicles</div>
            </div>
        </div>

        <!-- QUICK ACTIONS -->
        <div class="section-title">⚡ Quick Actions</div>
        <div class="actions-grid">
            <a href="addViolation.jsp" class="action-card">
                <div class="a-icon">➕</div>
                <div class="a-title">Add Violation</div>
                <div class="a-desc">Record a new traffic violation</div>
            </a>
            <a href="violationList.jsp" class="action-card">
                <div class="a-icon">📋</div>
                <div class="a-title">View All Violations</div>
                <div class="a-desc">Browse all recorded violations</div>
            </a>
            <a href="../index.jsp" class="action-card" style="border-color:rgba(244,67,54,0.3);">
                <div class="a-icon">🚪</div>
                <div class="a-title">Logout</div>
                <div class="a-desc">Sign out safely</div>
            </a>
        </div>

        <!-- RECENT VIOLATIONS TABLE -->
        <div class="section-title">🕐 Recent Violations</div>
        <div class="table-card">
            <div class="table-card-header">
                <span>Latest Records</span>
                <a href="violationList.jsp" style="color:var(--blue);font-size:13px;text-decoration:none;">View All →</a>
            </div>
            <div style="overflow-x:auto;">
                <table class="custom-table">
                    <thead>
                        <tr><th>ID</th><th>Vehicle</th><th>Rule</th><th>Officer</th><th>Date</th><th>Status</th></tr>
                    </thead>
                    <tbody>
                        <% if (allViolations.isEmpty()) { %>
                        <tr><td colspan="6" style="text-align:center;padding:30px;color:#555;">No violations recorded yet.</td></tr>
                        <% } else { int count = 0; for (Violation v : allViolations) { if (count++ >= 6) break; %>
                        <tr>
                            <td><span class="vid">#<%= v.getViolationId() %></span></td>
                            <td>🚗 <%= v.getVehicleId() %></td>
                            <td>📋 Rule-<%= v.getRuleId() %></td>
                            <td>👮 <%= v.getOfficerId() %></td>
                            <td style="font-size:12px;"><%= v.getViolationDate() != null ? v.getViolationDate().toString().substring(0,16) : "N/A" %></td>
                            <td><% if ("PAID".equalsIgnoreCase(v.getPaymentStatus())) { %><span class="badge-paid">✅ PAID</span><% } else { %><span class="badge-unpaid">❌ UNPAID</span><% } %></td>
                        </tr>
                        <% } } %>
                    </tbody>
                </table>
            </div>
        </div>

    </div>
</div>

<footer>© 2026 RoadSafetyHub | Developed by Varshitha | Police Portal</footer>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
