<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ page import="com.traffic.model.*,com.traffic.service.*,java.util.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getRole().equalsIgnoreCase("admin")) {
        response.sendRedirect(request.getContextPath() + "/index.jsp"); return;
    }
    int totalOwners = new OwnerServiceImpl().getAllOwners().size();
    int totalPolice = new PoliceServiceImpl().getAllPoliceOfficers().size();
    int totalVehicles = new VehicleServiceImpl().getAllVehicles().size();
    List<Violation> allV = new ViolationServiceImpl().getAllViolations();
    int totalViolations = allV.size();
    long unpaid = allV.stream().filter(v -> "UNPAID".equalsIgnoreCase(v.getPaymentStatus())).count();
    long paid = totalViolations - unpaid;
    int paidPct = totalViolations > 0 ? (int)((paid * 100) / totalViolations) : 0;
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
    :root{--gold:#ffc107;--dark:#0d0d0d;--card:#1a1a1a;--border:rgba(255,193,7,0.2);}
    *{box-sizing:border-box;margin:0;padding:0;}
    body{background:var(--dark);color:#e0e0e0;font-family:'DM Sans',sans-serif;min-height:100vh;}
    .top-nav{background:rgba(13,13,13,0.98);border-bottom:2px solid var(--gold);padding:14px 28px;display:flex;align-items:center;justify-content:space-between;position:fixed;top:0;left:0;right:0;z-index:1000;backdrop-filter:blur(10px);}
    .nav-brand{font-family:'Bebas Neue',sans-serif;font-size:24px;letter-spacing:3px;color:var(--gold);text-decoration:none;}
    .nav-links{display:flex;align-items:center;gap:8px;flex-wrap:wrap;}
    .nav-link-btn{color:#ccc;text-decoration:none;padding:7px 16px;border-radius:6px;font-size:14px;transition:all 0.2s;border:1px solid transparent;}
    .nav-link-btn:hover,.nav-link-btn.active{color:var(--gold);border-color:var(--gold);background:rgba(255,193,7,0.08);}
    .nav-user{background:rgba(255,193,7,0.15);border:1px solid var(--gold);border-radius:20px;padding:5px 14px;font-size:13px;color:var(--gold);}
    .nav-logout{background:transparent;border:1px solid #555;color:#aaa;padding:7px 16px;border-radius:6px;text-decoration:none;font-size:13px;transition:all 0.2s;}
    .nav-logout:hover{border-color:#f44336;color:#f44336;}
    .main-wrapper{padding-top:70px;}
    .hero-banner{background:linear-gradient(135deg,#0d0d0d,#1a1400);border-bottom:1px solid var(--border);padding:40px 32px 32px;position:relative;overflow:hidden;}
    .hero-banner::before{content:'⚙️';position:absolute;right:40px;top:50%;transform:translateY(-50%);font-size:100px;opacity:0.06;}
    .hero-banner h1{font-family:'Bebas Neue',sans-serif;font-size:42px;letter-spacing:4px;color:var(--gold);margin-bottom:6px;}
    .hero-banner p{color:#888;font-size:15px;}
    .content{padding:32px;}
    .section-title{font-family:'Bebas Neue',sans-serif;font-size:20px;letter-spacing:2px;color:var(--gold);margin-bottom:18px;padding-bottom:10px;border-bottom:1px solid var(--border);}
    .stats-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));gap:20px;margin-bottom:40px;}
    .stat-card{background:var(--card);border:1px solid var(--border);border-radius:14px;padding:28px 24px;position:relative;overflow:hidden;transition:transform 0.2s,border-color 0.2s;}
    .stat-card:hover{transform:translateY(-4px);border-color:var(--gold);}
    .stat-card .accent{position:absolute;top:0;left:0;width:4px;height:100%;background:var(--gold);border-radius:14px 0 0 14px;}
    .stat-card .emoji{font-size:30px;margin-bottom:12px;}
    .stat-card .number{font-family:'Bebas Neue',sans-serif;font-size:52px;color:var(--gold);line-height:1;margin-bottom:4px;}
    .stat-card .label{font-size:12px;color:#555;text-transform:uppercase;letter-spacing:1.5px;}
    .actions-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));gap:16px;margin-bottom:40px;}
    .action-card{background:var(--card);border:1px solid var(--border);border-radius:14px;padding:28px 24px;text-align:center;text-decoration:none;color:#e0e0e0;transition:all 0.2s;display:block;}
    .action-card:hover{border-color:var(--gold);color:var(--gold);transform:translateY(-4px);text-decoration:none;background:#1f1800;}
    .action-card .a-icon{font-size:36px;margin-bottom:12px;}
    .action-card .a-title{font-weight:600;font-size:15px;margin-bottom:4px;}
    .action-card .a-desc{font-size:12px;color:#555;}
    .info-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(300px,1fr));gap:20px;margin-bottom:40px;}
    .info-card{background:var(--card);border:1px solid var(--border);border-radius:14px;padding:24px;}
    .info-card h6{font-family:'Bebas Neue',sans-serif;font-size:16px;letter-spacing:1.5px;color:var(--gold);margin-bottom:16px;}
    .progress-bar-bg{background:#2a2a2a;border-radius:20px;height:10px;overflow:hidden;margin-top:8px;}
    .progress-fill{height:100%;border-radius:20px;background:linear-gradient(90deg,var(--gold),#e0a800);}
    .badge-paid{background:#0d2218;color:#4caf50;border:1px solid #4caf50;font-size:11px;padding:3px 10px;border-radius:20px;}
    .badge-unpaid{background:#2a0d0d;color:#f44336;border:1px solid #f44336;font-size:11px;padding:3px 10px;border-radius:20px;}
    .summary-row{display:flex;justify-content:space-between;align-items:center;padding:10px 0;border-bottom:1px solid #2a2a2a;font-size:14px;}
    .summary-row:last-child{border-bottom:none;}
    footer{background:#080808;color:#444;text-align:center;padding:18px;font-size:12px;border-top:1px solid #1a1a1a;}
</style>
</head>
<body>
<nav class="top-nav">
    <a href="dashboard.jsp" class="nav-brand">🚦 RoadSafetyHub</a>
    <div class="nav-links">
        <a href="dashboard.jsp" class="nav-link-btn active">🏠 Dashboard</a>
        <a href="owners.jsp" class="nav-link-btn">👤 Owners</a>
        <a href="police.jsp" class="nav-link-btn">👮 Police</a>
        <a href="violations.jsp" class="nav-link-btn">⚠️ Violations</a>
        <span class="nav-user">⚙️ <%= user.getUsername() %> [ADMIN]</span>
        <a href="../index.jsp" class="nav-logout">Logout</a>
    </div>
</nav>
<div class="main-wrapper">
    <div class="hero-banner">
        <h1>⚙️ Admin Dashboard</h1>
        <p>Welcome back, <strong style="color:var(--gold);"><%= user.getUsername() %></strong> — Full System Control</p>
    </div>
    <div class="content">
        <div class="section-title">📊 System Overview</div>
        <div class="stats-grid">
            <div class="stat-card"><div class="accent"></div><div class="emoji">👤</div><div class="number"><%= totalOwners %></div><div class="label">Vehicle Owners</div></div>
            <div class="stat-card"><div class="accent"></div><div class="emoji">👮</div><div class="number"><%= totalPolice %></div><div class="label">Police Officers</div></div>
            <div class="stat-card"><div class="accent"></div><div class="emoji">🚗</div><div class="number"><%= totalVehicles %></div><div class="label">Registered Vehicles</div></div>
            <div class="stat-card"><div class="accent"></div><div class="emoji">⚠️</div><div class="number"><%= totalViolations %></div><div class="label">Total Violations</div></div>
        </div>
        <div class="info-grid">
            <div class="info-card">
                <h6>📈 Fine Collection Status</h6>
                <div class="d-flex justify-content-between mb-2">
                    <span class="badge-paid">✅ Paid: <%= paid %></span>
                    <span class="badge-unpaid">❌ Unpaid: <%= unpaid %></span>
                </div>
                <div class="progress-bar-bg"><div class="progress-fill" style="width:<%= paidPct %>%"></div></div>
                <small style="color:#555;font-size:11px;margin-top:6px;display:block;"><%= paidPct %>% fines collected</small>
            </div>
            <div class="info-card">
                <h6>🗂️ Quick Summary</h6>
                <div class="summary-row"><span style="color:#888;">Total Owners</span><strong style="color:var(--gold);"><%= totalOwners %></strong></div>
                <div class="summary-row"><span style="color:#888;">Total Police</span><strong style="color:var(--gold);"><%= totalPolice %></strong></div>
                <div class="summary-row"><span style="color:#888;">Total Vehicles</span><strong style="color:var(--gold);"><%= totalVehicles %></strong></div>
                <div class="summary-row"><span style="color:#888;">Pending Fines</span><strong style="color:#f44336;"><%= unpaid %></strong></div>
            </div>
        </div>
        <div class="section-title">⚡ Quick Actions</div>
        <div class="actions-grid">
            <a href="owners.jsp" class="action-card"><div class="a-icon">👤</div><div class="a-title">Manage Owners</div><div class="a-desc">Add, edit, delete owners</div></a>
            <a href="police.jsp" class="action-card"><div class="a-icon">👮</div><div class="a-title">Manage Police</div><div class="a-desc">Add, edit, delete officers</div></a>
            <a href="violations.jsp" class="action-card"><div class="a-icon">⚠️</div><div class="a-title">View Violations</div><div class="a-desc">All traffic violations</div></a>
            <a href="../index.jsp" class="action-card" style="border-color:rgba(244,67,54,0.3);"><div class="a-icon">🚪</div><div class="a-title">Logout</div><div class="a-desc">Sign out safely</div></a>
        </div>
    </div>
</div>
<footer>© 2026 RoadSafetyHub | Developed by Varshitha | Admin Portal</footer>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
