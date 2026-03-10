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
    long unpaid = 0, paid = 0;
    if (owner != null) {
        myVehicles = new VehicleServiceImpl().getVehiclesByOwnerId(owner.getOwnerId());
        Set<Integer> ids = new HashSet<>();
        for (Vehicle v : myVehicles) ids.add(v.getVehicleId());
        for (Violation v : new ViolationServiceImpl().getAllViolations()) {
            if (ids.contains(v.getVehicleId())) myViolations.add(v);
        }
        for (Violation v : myViolations) {
            if ("UNPAID".equalsIgnoreCase(v.getPaymentStatus())) unpaid++; else paid++;
        }
    }
    String msg = request.getParameter("msg");
    String error = request.getParameter("error");
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
    :root{--gold:#ffc107;--green:#4caf50;--dark:#0a120a;--card:#0f1a0f;--border:rgba(76,175,80,0.25);}
    *{box-sizing:border-box;margin:0;padding:0;}
    body{background:var(--dark);color:#e0e0e0;font-family:'DM Sans',sans-serif;min-height:100vh;}
    .top-nav{background:rgba(10,18,10,0.98);border-bottom:2px solid var(--green);padding:14px 28px;display:flex;align-items:center;justify-content:space-between;position:fixed;top:0;left:0;right:0;z-index:1000;backdrop-filter:blur(10px);}
    .nav-brand{font-family:'Bebas Neue',sans-serif;font-size:24px;letter-spacing:3px;color:var(--gold);text-decoration:none;}
    .nav-links{display:flex;align-items:center;gap:8px;flex-wrap:wrap;}
    .nav-link-btn{color:#ccc;text-decoration:none;padding:7px 16px;border-radius:6px;font-size:14px;transition:all 0.2s;border:1px solid transparent;}
    .nav-link-btn:hover,.nav-link-btn.active{color:var(--green);border-color:var(--green);background:rgba(76,175,80,0.08);}
    .nav-user{background:rgba(76,175,80,0.15);border:1px solid var(--green);border-radius:20px;padding:5px 14px;font-size:13px;color:var(--green);}
    .nav-logout{background:transparent;border:1px solid #555;color:#aaa;padding:7px 16px;border-radius:6px;text-decoration:none;font-size:13px;}
    .nav-logout:hover{border-color:#f44336;color:#f44336;}
    .main-wrapper{padding-top:70px;}
    .hero-banner{background:linear-gradient(135deg,#0a120a,#0d1e0d);border-bottom:1px solid var(--border);padding:40px 32px 32px;position:relative;overflow:hidden;}
    .hero-banner::before{content:'🚗';position:absolute;right:40px;top:50%;transform:translateY(-50%);font-size:100px;opacity:0.07;}
    .hero-banner h1{font-family:'Bebas Neue',sans-serif;font-size:42px;letter-spacing:4px;color:var(--green);margin-bottom:6px;}
    .hero-banner p{color:#888;font-size:15px;}
    .hero-banner strong{color:var(--green);}
    .content{padding:32px;}
    .alert-success{background:#0d2218;border:1px solid #4caf50;color:#4caf50;border-radius:8px;padding:12px 18px;margin-bottom:20px;}
    .alert-error{background:#2a0d0d;border:1px solid #f44336;color:#f44336;border-radius:8px;padding:12px 18px;margin-bottom:20px;}
    .profile-card{background:var(--card);border:1px solid var(--green);border-radius:14px;padding:22px 26px;margin-bottom:32px;display:flex;align-items:center;gap:18px;flex-wrap:wrap;}
    .profile-avatar{width:60px;height:60px;border-radius:50%;background:#1a3a1a;border:2px solid var(--green);display:flex;align-items:center;justify-content:center;font-size:26px;flex-shrink:0;}
    .profile-info h5{color:#fff;margin:0 0 6px;font-size:18px;}
    .profile-info .info-row{color:#888;font-size:13px;}
    .info-val{color:#bbb;}
    .info-missing{color:#ff9800;font-style:italic;}
    .profile-right{margin-left:auto;display:flex;align-items:center;gap:10px;flex-wrap:wrap;}
    .profile-badge{background:rgba(76,175,80,0.15);border:1px solid var(--green);border-radius:20px;padding:6px 16px;color:var(--green);font-size:13px;}
    .badge-incomplete{background:#1a1200;border:1px solid #ff9800;border-radius:20px;padding:4px 12px;color:#ff9800;font-size:11px;}
    .btn-edit-profile{background:transparent;border:1px solid var(--gold);color:var(--gold);border-radius:8px;padding:8px 18px;font-size:13px;cursor:pointer;font-family:'DM Sans',sans-serif;transition:all 0.2s;}
    .btn-edit-profile:hover{background:var(--gold);color:#000;}
    .section-title{font-family:'Bebas Neue',sans-serif;font-size:20px;letter-spacing:2px;color:var(--gold);margin-bottom:18px;padding-bottom:10px;border-bottom:1px solid rgba(255,193,7,0.2);}
    .stats-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));gap:20px;margin-bottom:40px;}
    .stat-card{background:var(--card);border:1px solid var(--border);border-radius:14px;padding:28px 24px;position:relative;overflow:hidden;transition:transform 0.2s;}
    .stat-card:hover{transform:translateY(-4px);border-color:var(--green);}
    .stat-card .accent{position:absolute;top:0;left:0;width:4px;height:100%;background:var(--green);border-radius:14px 0 0 14px;}
    .stat-card .emoji{font-size:30px;margin-bottom:12px;}
    .stat-card .number{font-family:'Bebas Neue',sans-serif;font-size:52px;line-height:1;margin-bottom:4px;}
    .stat-card .label{font-size:12px;color:#555;text-transform:uppercase;letter-spacing:1.5px;}
    .green-num{color:var(--green);} .gold-num{color:var(--gold);} .red-num{color:#f44336;}
    .actions-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));gap:16px;margin-bottom:40px;}
    .action-card{background:var(--card);border:1px solid var(--border);border-radius:14px;padding:28px 20px;text-align:center;text-decoration:none;color:#e0e0e0;transition:all 0.2s;display:block;cursor:pointer;}
    .action-card:hover{border-color:var(--green);color:var(--green);transform:translateY(-4px);background:#0d1e0d;text-decoration:none;}
    .action-card .a-icon{font-size:36px;margin-bottom:12px;}
    .action-card .a-title{font-weight:600;font-size:15px;margin-bottom:4px;}
    .action-card .a-desc{font-size:12px;color:#555;}
    .table-card{background:var(--card);border:1px solid var(--border);border-radius:14px;overflow:hidden;margin-bottom:40px;}
    .table-card-header{padding:18px 22px;border-bottom:1px solid var(--border);display:flex;justify-content:space-between;align-items:center;}
    .table-card-header span{font-family:'Bebas Neue',sans-serif;font-size:18px;letter-spacing:2px;color:var(--gold);}
    .custom-table{width:100%;border-collapse:collapse;}
    .custom-table thead th{background:#0a140a;color:var(--green);font-family:'Bebas Neue',sans-serif;letter-spacing:1px;font-size:13px;padding:14px 16px;text-align:left;border-bottom:1px solid var(--border);}
    .custom-table tbody td{padding:13px 16px;border-bottom:1px solid rgba(255,255,255,0.04);color:#bbb;font-size:14px;}
    .custom-table tbody tr:hover{background:rgba(76,175,80,0.05);}
    .custom-table tbody tr:last-child td{border-bottom:none;}
    .badge-paid{background:#0d2218;color:#4caf50;border:1px solid #4caf50;font-size:11px;padding:3px 10px;border-radius:20px;}
    .badge-unpaid{background:#2a0d0d;color:#f44336;border:1px solid #f44336;font-size:11px;padding:3px 10px;border-radius:20px;}
    .vid{color:var(--gold);font-weight:700;}
    .btn-pay{background:var(--gold);color:#000;font-weight:600;border:none;border-radius:6px;padding:5px 14px;font-size:12px;text-decoration:none;}
    .btn-pay:hover{background:#e0a800;color:#000;}
    /* MODAL */
    .modal-overlay{display:none;position:fixed;top:0;left:0;right:0;bottom:0;background:rgba(0,0,0,0.78);z-index:2000;align-items:center;justify-content:center;padding:20px;}
    .modal-overlay.show{display:flex;}
    .modal-box{background:#0f1a0f;border:1px solid var(--green);border-radius:16px;padding:32px;width:100%;max-width:460px;position:relative;}
    .modal-box h4{font-family:'Bebas Neue',sans-serif;font-size:22px;letter-spacing:2px;color:var(--gold);margin-bottom:24px;}
    .modal-close{position:absolute;top:16px;right:20px;background:none;border:none;color:#aaa;font-size:20px;cursor:pointer;}
    .modal-close:hover{color:#fff;}
    .form-group{margin-bottom:18px;}
    .form-group label{display:block;color:#aaa;font-size:13px;margin-bottom:6px;}
    .form-group input,.form-group textarea{width:100%;background:#1a2a1a;border:1px solid #2a4a2a;color:#e0e0e0;border-radius:8px;padding:10px 14px;font-size:14px;font-family:'DM Sans',sans-serif;}
    .form-group input:focus,.form-group textarea:focus{border-color:var(--green);outline:none;}
    .modal-footer-btns{display:flex;gap:12px;margin-top:24px;}
    .btn-save{background:var(--green);color:#fff;font-weight:700;border:none;border-radius:8px;padding:10px 0;font-size:14px;cursor:pointer;flex:1;}
    .btn-save:hover{background:#388e3c;}
    .btn-cancel{background:transparent;border:1px solid #555;color:#aaa;border-radius:8px;padding:10px 20px;font-size:14px;cursor:pointer;}
    footer{background:#060e06;color:#444;text-align:center;padding:18px;font-size:12px;border-top:1px solid #1a2a1a;}
</style>
</head>
<body>
<nav class="top-nav">
    <a href="dashboard.jsp" class="nav-brand">🚦 RoadSafetyHub</a>
    <div class="nav-links">
        <a href="dashboard.jsp" class="nav-link-btn active">🏠 Dashboard</a>
        <a href="myVehicles.jsp" class="nav-link-btn">🚗 My Vehicles</a>
        <a href="myViolations.jsp" class="nav-link-btn">⚠️ My Violations</a>
        <span class="nav-user">👤 <%= user.getUsername() %> [OWNER]</span>
        <a href="../index.jsp" class="nav-logout">Logout</a>
    </div>
</nav>

<div class="main-wrapper">
    <div class="hero-banner">
        <h1>🚗 Owner Dashboard</h1>
        <p>Welcome back, <strong><%= user.getUsername() %></strong> — Vehicle Owner Portal</p>
    </div>
    <div class="content">
        <% if (msg != null) { %><div class="alert-success">✅ <%= msg %></div><% } %>
        <% if (error != null) { %><div class="alert-error">❌ <%= error %></div><% } %>

        <!-- PROFILE CARD -->
        <% if (owner != null) {
            boolean hasPhone = owner.getMobile() != null && !owner.getMobile().trim().isEmpty();
            boolean hasAddr  = owner.getAddress() != null && !owner.getAddress().trim().isEmpty();
        %>
        <div class="profile-card">
            <div class="profile-avatar">👤</div>
            <div class="profile-info">
                <h5><%= owner.getName() %></h5>
                <div class="info-row">
                    📞 <span class="<%= hasPhone ? "info-val" : "info-missing" %>"><%= hasPhone ? owner.getMobile() : "Add mobile number" %></span>
                    &nbsp;&nbsp;
                    📍 <span class="<%= hasAddr ? "info-val" : "info-missing" %>"><%= hasAddr ? owner.getAddress() : "Add address" %></span>
                </div>
            </div>
            <div class="profile-right">
                <% if (!hasPhone || !hasAddr) { %><span class="badge-incomplete">⚠️ Incomplete</span><% } %>
                <span class="profile-badge">Owner ID: #<%= owner.getOwnerId() %></span>
                <button class="btn-edit-profile" onclick="document.getElementById('editProfileModal').classList.add('show')">✏️ Edit Profile</button>
            </div>
        </div>
        <% } %>

        <!-- STATS -->
        <div class="section-title">📊 My Overview</div>
        <div class="stats-grid">
            <div class="stat-card"><div class="accent"></div><div class="emoji">🚗</div><div class="number green-num"><%= myVehicles.size() %></div><div class="label">My Vehicles</div></div>
            <div class="stat-card"><div class="accent" style="background:var(--gold);"></div><div class="emoji">⚠️</div><div class="number gold-num"><%= myViolations.size() %></div><div class="label">Total Violations</div></div>
            <div class="stat-card"><div class="accent" style="background:#f44336;"></div><div class="emoji">❌</div><div class="number red-num"><%= unpaid %></div><div class="label">Pending Fines</div></div>
            <div class="stat-card"><div class="accent" style="background:#4caf50;"></div><div class="emoji">✅</div><div class="number green-num"><%= paid %></div><div class="label">Fines Paid</div></div>
        </div>

        <!-- ACTIONS -->
        <div class="section-title">⚡ Quick Actions</div>
        <div class="actions-grid">
            <a href="myVehicles.jsp" class="action-card"><div class="a-icon">🚗</div><div class="a-title">My Vehicles</div><div class="a-desc">View & manage vehicles</div></a>
            <a href="myViolations.jsp" class="action-card"><div class="a-icon">⚠️</div><div class="a-title">My Violations</div><div class="a-desc">View and pay fines</div></a>
            <div class="action-card" onclick="document.getElementById('editProfileModal').classList.add('show')"><div class="a-icon">✏️</div><div class="a-title">Edit Profile</div><div class="a-desc">Update phone & address</div></div>
            <a href="../index.jsp" class="action-card" style="border-color:rgba(244,67,54,0.3);"><div class="a-icon">🚪</div><div class="a-title">Logout</div><div class="a-desc">Sign out safely</div></a>
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
                    <thead><tr><th>ID</th><th>Vehicle</th><th>Rule</th><th>Date</th><th>Status</th><th>Action</th></tr></thead>
                    <tbody>
                    <% int cnt=0; for(Violation v : myViolations){ if(cnt++>=5) break; %>
                    <tr>
                        <td><span class="vid">#<%= v.getViolationId() %></span></td>
                        <td>🚗 <%= v.getVehicleId() %></td>
                        <td>📋 Rule-<%= v.getRuleId() %></td>
                        <td style="font-size:12px;"><%= v.getViolationDate()!=null?v.getViolationDate().toString().substring(0,16):"N/A" %></td>
                        <td><% if("PAID".equalsIgnoreCase(v.getPaymentStatus())){ %><span class="badge-paid">✅ PAID</span><% }else{ %><span class="badge-unpaid">❌ UNPAID</span><% } %></td>
                        <td><% if("UNPAID".equalsIgnoreCase(v.getPaymentStatus())){ %><a href="payment.jsp?violationId=<%= v.getViolationId() %>" class="btn-pay">💳 Pay</a><% } %></td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>
        <% } else if(owner != null){ %>
        <div style="background:var(--card);border:1px solid var(--border);border-radius:14px;padding:50px;text-align:center;">
            <div style="font-size:48px;margin-bottom:12px;">🎉</div>
            <h5 style="color:#4caf50;margin-bottom:6px;">No Violations!</h5>
            <p style="color:#555;font-size:14px;">Keep driving safely!</p>
        </div>
        <% } %>
    </div>
</div>

<!-- EDIT PROFILE MODAL -->
<% if (owner != null) { %>
<div class="modal-overlay" id="editProfileModal">
    <div class="modal-box">
        <button class="modal-close" onclick="document.getElementById('editProfileModal').classList.remove('show')">✕</button>
        <h4>✏️ Edit My Profile</h4>
        <form action="../OwnerController" method="post">
            <input type="hidden" name="action" value="updateProfile">
            <input type="hidden" name="ownerId" value="<%= owner.getOwnerId() %>">
            <div class="form-group">
                <label>Full Name *</label>
                <input type="text" name="name" value="<%= owner.getName() %>" required>
            </div>
            <div class="form-group">
                <label>📞 Mobile Number</label>
                <input type="text" name="mobile" maxlength="10" placeholder="10-digit mobile"
                    value="<%= (owner.getMobile()!=null&&!owner.getMobile().trim().isEmpty()) ? owner.getMobile() : "" %>">
            </div>
            <div class="form-group">
                <label>📍 Address</label>
                <textarea name="address" rows="3" placeholder="Your full address"><%= (owner.getAddress()!=null&&!owner.getAddress().trim().isEmpty()) ? owner.getAddress() : "" %></textarea>
            </div>
            <div class="modal-footer-btns">
                <button type="button" class="btn-cancel" onclick="document.getElementById('editProfileModal').classList.remove('show')">Cancel</button>
                <button type="submit" class="btn-save">💾 Save Changes</button>
            </div>
        </form>
    </div>
</div>
<% } %>

<footer>© 2026 RoadSafetyHub | Developed by Varshitha | Owner Portal</footer>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
