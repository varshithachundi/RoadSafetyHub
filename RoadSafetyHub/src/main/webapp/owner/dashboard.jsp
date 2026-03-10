<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
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
    long unpaid = 0, paid = 0;

    if (owner != null) {
        myVehicles = vehicleService.getVehiclesByOwnerId(owner.getOwnerId());
        Set<Integer> myVehicleIds = new HashSet<>();
        for (Vehicle v : myVehicles) myVehicleIds.add(v.getVehicleId());
        for (Violation v : violationService.getAllViolations()) {
            if (myVehicleIds.contains(v.getVehicleId())) myViolations.add(v);
        }
        for (Violation v : myViolations) {
            if ("UNPAID".equalsIgnoreCase(v.getPaymentStatus())) unpaid++;
            else paid++;
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Owner Dashboard – RoadSafetyHub</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet">
<style>
    :root { --gold: #ffc107; --green: #4caf50; --dark: #0a120a; --card-bg: #0f1a0f; --border: rgba(76,175,80,0.25); }
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { background: var(--dark); color: #e0e0e0; font-family: 'DM Sans', sans-serif; min-height: 100vh; }

    /* NAVBAR */
    .top-nav {
        background: rgba(10,18,10,0.98);
        border-bottom: 2px solid var(--green);
        padding: 14px 28px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        position: fixed;
        top: 0; left: 0; right: 0;
        z-index: 1000;
        backdrop-filter: blur(10px);
    }
    .nav-brand { font-family: 'Bebas Neue', sans-serif; font-size: 24px; letter-spacing: 3px; color: var(--gold); text-decoration: none; }
    .nav-links { display: flex; align-items: center; gap: 8px; flex-wrap: wrap; }
    .nav-link-btn { color: #ccc; text-decoration: none; padding: 7px 16px; border-radius: 6px; font-size: 14px; transition: all 0.2s; border: 1px solid transparent; }
    .nav-link-btn:hover { color: var(--green); border-color: var(--green); background: rgba(76,175,80,0.08); }
    .nav-link-btn.active { color: var(--green); border-color: var(--green); background: rgba(76,175,80,0.12); }
    .nav-user { background: rgba(76,175,80,0.15); border: 1px solid var(--green); border-radius: 20px; padding: 5px 14px; font-size: 13px; color: var(--green); }
    .nav-logout { background: transparent; border: 1px solid #555; color: #aaa; padding: 7px 16px; border-radius: 6px; text-decoration: none; font-size: 13px; transition: all 0.2s; }
    .nav-logout:hover { border-color: #f44336; color: #f44336; }

    .main-wrapper { padding-top: 70px; }

    /* HERO */
    .hero-banner {
        background: linear-gradient(135deg, #0a120a 0%, #0d1e0d 50%, #0a1a0a 100%);
        border-bottom: 1px solid var(--border);
        padding: 40px 32px 32px;
        position: relative;
        overflow: hidden;
    }
    .hero-banner::before { content: '🚗'; position: absolute; right: 40px; top: 50%; transform: translateY(-50%); font-size: 100px; opacity: 0.07; }
    .hero-banner h1 { font-family: 'Bebas Neue', sans-serif; font-size: 42px; letter-spacing: 4px; color: var(--green); margin-bottom: 6px; }
    .hero-banner p { color: #888; font-size: 15px; }
    .hero-banner strong { color: var(--green); }

    /* PROFILE CARD */
    .profile-card {
        background: var(--card-bg);
        border: 1px solid var(--green);
        border-radius: 14px;
        padding: 22px 26px;
        margin-bottom: 32px;
        display: flex;
        align-items: center;
        gap: 18px;
        flex-wrap: wrap;
    }
    .profile-avatar { width: 60px; height: 60px; border-radius: 50%; background: #1a3a1a; border: 2px solid var(--green); display: flex; align-items: center; justify-content: center; font-size: 26px; flex-shrink: 0; }
    .profile-info h5 { color: #fff; margin: 0 0 4px; font-size: 18px; }
    .profile-info p { color: #777; font-size: 13px; margin: 0; }
    .profile-badge { margin-left: auto; background: rgba(76,175,80,0.15); border: 1px solid var(--green); border-radius: 20px; padding: 6px 16px; color: var(--green); font-size: 13px; white-space: nowrap; }

    .warning-card { background: #1a1200; border: 1px solid #ff9800; border-radius: 14px; padding: 22px 26px; margin-bottom: 32px; color: #ff9800; }
    .warning-card h5 { margin-bottom: 8px; }

    /* CONTENT */
    .content { padding: 32px; }

    /* STATS */
    .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-bottom: 40px; }
    .stat-card { background: var(--card-bg); border: 1px solid var(--border); border-radius: 14px; padding: 28px 24px; position: relative; overflow: hidden; transition: transform 0.2s, border-color 0.2s; }
    .stat-card:hover { transform: translateY(-4px); border-color: var(--green); }
    .stat-card .accent { position: absolute; top: 0; left: 0; width: 4px; height: 100%; background: var(--green); border-radius: 14px 0 0 14px; }
    .stat-card .emoji { font-size: 30px; margin-bottom: 12px; }
    .stat-card .number { font-family: 'Bebas Neue', sans-serif; font-size: 52px; line-height: 1; margin-bottom: 4px; }
    .stat-card .label { font-size: 12px; color: #555; text-transform: uppercase; letter-spacing: 1.5px; }
    .green-num { color: var(--green); }
    .gold-num { color: var(--gold); }
    .red-num { color: #f44336; }

    /* SECTION TITLE */
    .section-title { font-family: 'Bebas Neue', sans-serif; font-size: 20px; letter-spacing: 2px; color: var(--gold); margin-bottom: 18px; padding-bottom: 10px; border-bottom: 1px solid rgba(255,193,7,0.2); }

    /* ACTIONS */
    .actions-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 16px; margin-bottom: 40px; }
    .action-card { background: var(--card-bg); border: 1px solid var(--border); border-radius: 14px; padding: 32px 24px; text-align: center; text-decoration: none; color: #e0e0e0; transition: all 0.2s; display: block; }
    .action-card:hover { border-color: var(--green); color: var(--green); transform: translateY(-4px); background: #0d1e0d; text-decoration: none; }
    .action-card .a-icon { font-size: 40px; margin-bottom: 14px; }
    .action-card .a-title { font-weight: 600; font-size: 16px; margin-bottom: 4px; }
    .action-card .a-desc { font-size: 12px; color: #555; }

    /* TABLE */
    .table-card { background: var(--card-bg); border: 1px solid var(--border); border-radius: 14px; overflow: hidden; margin-bottom: 40px; }
    .table-card-header { padding: 18px 22px; border-bottom: 1px solid var(--border); display: flex; justify-content: space-between; align-items: center; }
    .table-card-header span { font-family: 'Bebas Neue', sans-serif; font-size: 18px; letter-spacing: 2px; color: var(--gold); }
    .custom-table { width: 100%; border-collapse: collapse; }
    .custom-table thead th { background: #0a140a; color: var(--green); font-family: 'Bebas Neue', sans-serif; letter-spacing: 1px; font-size: 13px; padding: 14px 16px; text-align: left; border-bottom: 1px solid var(--border); }
    .custom-table tbody td { padding: 13px 16px; border-bottom: 1px solid rgba(255,255,255,0.04); color: #bbb; font-size: 14px; }
    .custom-table tbody tr:hover { background: rgba(76,175,80,0.05); }
    .custom-table tbody tr:last-child td { border-bottom: none; }
    .badge-paid { background: #0d2218; color: #4caf50; border: 1px solid #4caf50; font-size: 11px; padding: 3px 10px; border-radius: 20px; }
    .badge-unpaid { background: #2a0d0d; color: #f44336; border: 1px solid #f44336; font-size: 11px; padding: 3px 10px; border-radius: 20px; }
    .vid { color: var(--gold); font-weight: 700; }
    .btn-pay { background: var(--gold); color: #000; font-weight: 600; border: none; border-radius: 6px; padding: 5px 14px; font-size: 12px; text-decoration: none; }
    .btn-pay:hover { background: #e0a800; color: #000; }

    footer { background: #060e06; color: #444; text-align: center; padding: 18px; font-size: 12px; border-top: 1px solid #1a2a1a; }
</style>
</head>
<body>

<!-- NAVBAR -->
<nav class="top-nav">
    <a href="#" class="nav-brand">🚦 RoadSafetyHub</a>
    <div class="nav-links">
        <a href="dashboard.jsp" class="nav-link-btn active">🏠 Dashboard</a>
        <a href="myVehicles.jsp" class="nav-link-btn">🚗 My Vehicles</a>
        <a href="myViolations.jsp" class="nav-link-btn">⚠️ My Violations</a>
        <span class="nav-user">👤 <%= user.getUsername() %> [OWNER]</span>
        <a href="../index.jsp" class="nav-logout">Logout</a>
    </div>
</nav>

<div class="main-wrapper">

    <!-- HERO -->
    <div class="hero-banner">
        <h1>🚗 Owner Dashboard</h1>
        <p>Welcome back, <strong><%= user.getUsername() %></strong> — Vehicle Owner Portal</p>
    </div>

    <div class="content">

        <!-- PROFILE / WARNING -->
        <% if (owner != null) { %>
        <div class="profile-card">
            <div class="profile-avatar">👤</div>
            <div class="profile-info">
                <h5><%= owner.getName() %></h5>
                <p>📞 <%= (owner.getMobile() != null && !owner.getMobile().isEmpty()) ? owner.getMobile() : "N/A" %>
                &nbsp;|&nbsp; 📍 <%= (owner.getAddress() != null && !owner.getAddress().isEmpty()) ? owner.getAddress() : "N/A" %></p>
            </div>
            <div class="profile-badge">Owner ID: #<%= owner.getOwnerId() %></div>
        </div>
        <% } else { %>
        <div class="profile-card">
            <div class="profile-avatar">👤</div>
            <div class="profile-info">
                <h5><%= user.getUsername() %></h5>
                <p style="color:#ff9800;">⚠️ Profile loading... Please refresh or re-login.</p>
            </div>
        </div>
        <% } %>

        <!-- STATS -->
        <div class="section-title">📊 My Overview</div>
        <div class="stats-grid">
            <div class="stat-card">
                <div class="accent"></div>
                <div class="emoji">🚗</div>
                <div class="number green-num"><%= myVehicles.size() %></div>
                <div class="label">My Vehicles</div>
            </div>
            <div class="stat-card">
                <div class="accent" style="background:var(--gold);"></div>
                <div class="emoji">⚠️</div>
                <div class="number gold-num"><%= myViolations.size() %></div>
                <div class="label">Total Violations</div>
            </div>
            <div class="stat-card">
                <div class="accent" style="background:#f44336;"></div>
                <div class="emoji">❌</div>
                <div class="number red-num"><%= unpaid %></div>
                <div class="label">Pending Fines</div>
            </div>
            <div class="stat-card">
                <div class="accent" style="background:#4caf50;"></div>
                <div class="emoji">✅</div>
                <div class="number green-num"><%= paid %></div>
                <div class="label">Fines Paid</div>
            </div>
        </div>

        <!-- QUICK ACTIONS -->
        <div class="section-title">⚡ Quick Actions</div>
        <div class="actions-grid">
            <a href="myVehicles.jsp" class="action-card">
                <div class="a-icon">🚗</div>
                <div class="a-title">My Vehicles</div>
                <div class="a-desc">View & manage your vehicles</div>
            </a>
            <a href="myViolations.jsp" class="action-card">
                <div class="a-icon">⚠️</div>
                <div class="a-title">My Violations</div>
                <div class="a-desc">View and pay your fines</div>
            </a>
            <a href="../index.jsp" class="action-card" style="border-color:rgba(244,67,54,0.3);">
                <div class="a-icon">🚪</div>
                <div class="a-title">Logout</div>
                <div class="a-desc">Sign out safely</div>
            </a>
        </div>

        <!-- RECENT VIOLATIONS -->
        <% if (!myViolations.isEmpty()) { %>
        <div class="section-title">🕐 Recent Violations</div>
        <div class="table-card">
            <div class="table-card-header">
                <span>Latest Fines</span>
                <a href="myViolations.jsp" style="color:var(--green);font-size:13px;text-decoration:none;">View All →</a>
            </div>
            <div style="overflow-x:auto;">
                <table class="custom-table">
                    <thead>
                        <tr><th>ID</th><th>Vehicle</th><th>Rule</th><th>Date</th><th>Status</th><th>Action</th></tr>
                    </thead>
                    <tbody>
                        <% int cnt = 0; for (Violation v : myViolations) { if (cnt++ >= 5) break; %>
                        <tr>
                            <td><span class="vid">#<%= v.getViolationId() %></span></td>
                            <td>🚗 <%= v.getVehicleId() %></td>
                            <td>📋 Rule-<%= v.getRuleId() %></td>
                            <td style="font-size:12px;"><%= v.getViolationDate() != null ? v.getViolationDate().toString().substring(0,16) : "N/A" %></td>
                            <td><% if ("PAID".equalsIgnoreCase(v.getPaymentStatus())) { %><span class="badge-paid">✅ PAID</span><% } else { %><span class="badge-unpaid">❌ UNPAID</span><% } %></td>
                            <td>
                                <% if ("UNPAID".equalsIgnoreCase(v.getPaymentStatus())) { %>
                                <a href="payment.jsp?violationId=<%= v.getViolationId() %>" class="btn-pay">💳 Pay Now</a>
                                <% } %>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
        <% } else if (owner != null) { %>
        <div style="background:var(--card-bg);border:1px solid var(--border);border-radius:14px;padding:40px;text-align:center;color:#4caf50;">
            <div style="font-size:48px;margin-bottom:12px;">🎉</div>
            <h5 style="color:#4caf50;">No Violations Found!</h5>
            <p style="color:#555;font-size:14px;margin:0;">Keep driving safely!</p>
        </div>
        <% } %>

    </div>
</div>

<footer>© 2026 RoadSafetyHub | Developed by Varshitha | Owner Portal</footer>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
