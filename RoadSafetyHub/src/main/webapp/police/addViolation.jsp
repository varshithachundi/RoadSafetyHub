<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ page import="com.traffic.model.*,com.traffic.service.*,java.util.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getRole().equalsIgnoreCase("police")) {
        response.sendRedirect(request.getContextPath() + "/index.jsp"); return;
    }
    List<Vehicle> vehicles = new VehicleServiceImpl().getAllVehicles();
    List<PoliceOfficer> officers = new PoliceServiceImpl().getAllPoliceOfficers();
    String error = request.getParameter("error");
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Violation – RoadSafetyHub</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet">
<style>
    :root{--gold:#ffc107;--blue:#2196f3;--dark:#0a0f1a;--card:#111827;--border:rgba(33,150,243,0.25);}
    *{box-sizing:border-box;margin:0;padding:0;}
    body{background:var(--dark);color:#e0e0e0;font-family:'DM Sans',sans-serif;min-height:100vh;}
    .top-nav{background:rgba(10,15,26,0.98);border-bottom:2px solid var(--blue);padding:14px 28px;display:flex;align-items:center;justify-content:space-between;position:fixed;top:0;left:0;right:0;z-index:1000;}
    .nav-brand{font-family:'Bebas Neue',sans-serif;font-size:24px;letter-spacing:3px;color:var(--gold);text-decoration:none;}
    .nav-links{display:flex;align-items:center;gap:8px;flex-wrap:wrap;}
    .nav-link-btn{color:#ccc;text-decoration:none;padding:7px 16px;border-radius:6px;font-size:14px;border:1px solid transparent;transition:all 0.2s;}
    .nav-link-btn:hover,.nav-link-btn.active{color:var(--blue);border-color:var(--blue);background:rgba(33,150,243,0.08);}
    .nav-user{background:rgba(33,150,243,0.15);border:1px solid var(--blue);border-radius:20px;padding:5px 14px;font-size:13px;color:var(--blue);}
    .nav-logout{background:transparent;border:1px solid #555;color:#aaa;padding:7px 16px;border-radius:6px;text-decoration:none;font-size:13px;}
    .nav-logout:hover{border-color:#f44336;color:#f44336;}
    .main-wrapper{padding-top:70px;}
    .page-header{background:linear-gradient(135deg,#0a0f1a,#0d1b2e);border-bottom:1px solid var(--border);padding:32px;}
    .page-header h1{font-family:'Bebas Neue',sans-serif;font-size:36px;letter-spacing:3px;color:var(--blue);}
    .page-header p{color:#888;font-size:14px;margin-top:4px;}
    .content{padding:32px;display:flex;justify-content:center;}
    .form-card{background:var(--card);border:1px solid var(--border);border-radius:16px;padding:36px;width:100%;max-width:580px;}
    .form-card h4{font-family:'Bebas Neue',sans-serif;font-size:22px;letter-spacing:2px;color:var(--gold);margin-bottom:28px;}
    .form-group{margin-bottom:22px;}
    .form-group label{display:block;color:#aaa;font-size:13px;margin-bottom:7px;}
    .form-group input,.form-group select{width:100%;background:#1a2235;border:1px solid #2a3a55;color:#e0e0e0;border-radius:8px;padding:11px 14px;font-size:14px;transition:border-color 0.2s;font-family:'DM Sans',sans-serif;}
    .form-group input:focus,.form-group select:focus{border-color:var(--blue);outline:none;background:#1e2a40;}
    .form-group select option{background:#1a2235;}
    .form-group small{color:#555;font-size:11px;margin-top:5px;display:block;}
    .divider{height:1px;background:var(--border);margin:24px 0;}
    .btn-row{display:flex;gap:12px;}
    .btn-submit{background:var(--blue);color:#fff;font-weight:700;border:none;border-radius:8px;padding:12px 32px;font-size:15px;flex:1;cursor:pointer;transition:background 0.2s;}
    .btn-submit:hover{background:#1976d2;}
    .btn-back{background:transparent;border:1px solid #444;color:#aaa;border-radius:8px;padding:12px 20px;font-size:14px;text-decoration:none;display:inline-flex;align-items:center;}
    .btn-back:hover{border-color:var(--gold);color:var(--gold);}
    .alert-success{background:#0d2218;border:1px solid #4caf50;color:#4caf50;border-radius:8px;padding:12px 18px;margin-bottom:20px;}
    .alert-error{background:#2a0d0d;border:1px solid #f44336;color:#f44336;border-radius:8px;padding:12px 18px;margin-bottom:20px;}
    footer{background:#080c14;color:#444;text-align:center;padding:18px;font-size:12px;border-top:1px solid #1a2030;margin-top:40px;}
</style>
</head>
<body>
<nav class="top-nav">
    <a href="dashboard.jsp" class="nav-brand">🚦 RoadSafetyHub</a>
    <div class="nav-links">
        <a href="dashboard.jsp" class="nav-link-btn">🏠 Dashboard</a>
        <a href="addViolation.jsp" class="nav-link-btn active">➕ Add Violation</a>
        <a href="violationList.jsp" class="nav-link-btn">📋 Violations</a>
        <span class="nav-user">👮 <%= user.getUsername() %> [POLICE]</span>
        <a href="../index.jsp" class="nav-logout">Logout</a>
    </div>
</nav>
<div class="main-wrapper">
    <div class="page-header">
        <h1>➕ Add Violation</h1>
        <p>Record a new traffic violation in the system</p>
    </div>
    <div class="content">
        <div class="form-card">
            <% if (msg != null) { %><div class="alert-success">✅ <%= msg %></div><% } %>
            <% if (error != null) { %><div class="alert-error">❌ <%= error %></div><% } %>
            <h4>🚦 Violation Details</h4>
            <form action="../ViolationController" method="post">
                <input type="hidden" name="action" value="add">
                <div class="form-group">
                    <label>🚗 Select Vehicle *</label>
                    <select name="vehicleId" required>
                        <option value="">-- Select Vehicle --</option>
                        <% for(Vehicle v : vehicles) { %>
                        <option value="<%= v.getVehicleId() %>"><%= v.getVehicleNumber() %> (<%= v.getVehicleType() %>)</option>
                        <% } %>
                    </select>
                </div>
                <div class="form-group">
                    <label>📋 Rule ID *</label>
                    <input type="number" name="ruleId" required min="1" placeholder="Enter Rule ID from trafficrules table">
                    <small>Check your trafficrules table for valid rule IDs and fine amounts</small>
                </div>
                <div class="form-group">
                    <label>👮 Issuing Officer *</label>
                    <select name="officerId" required>
                        <option value="">-- Select Officer --</option>
                        <% for(PoliceOfficer p : officers) { %>
                        <option value="<%= p.getOfficerId() %>"><%= p.getName() %> (Badge: <%= p.getBadgeNumber() %>)</option>
                        <% } %>
                    </select>
                </div>
                <div class="divider"></div>
                <div class="btn-row">
                    <a href="dashboard.jsp" class="btn-back">← Back</a>
                    <button type="submit" class="btn-submit">🚦 Submit Violation</button>
                </div>
            </form>
        </div>
    </div>
</div>
<footer>© 2026 RoadSafetyHub | Developed by Varshitha | Police Portal</footer>
</body>
</html>
