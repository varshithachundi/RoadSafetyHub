<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ page import="com.traffic.model.*,com.traffic.service.*,java.util.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getRole().equalsIgnoreCase("police")) {
        response.sendRedirect(request.getContextPath() + "/index.jsp"); return;
    }
    List<Violation> violations = new ViolationServiceImpl().getAllViolations();
    long paid = violations.stream().filter(v -> "PAID".equalsIgnoreCase(v.getPaymentStatus())).count();
    long unpaid = violations.size() - paid;
    String msg = request.getParameter("msg");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Violation List – RoadSafetyHub</title>
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
    .page-header{background:linear-gradient(135deg,#0a0f1a,#0d1b2e);border-bottom:1px solid var(--border);padding:32px;display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:16px;}
    .page-header h1{font-family:'Bebas Neue',sans-serif;font-size:36px;letter-spacing:3px;color:var(--blue);}
    .page-header p{color:#888;font-size:14px;margin-top:4px;}
    .btn-blue{background:var(--blue);color:#fff;font-weight:700;border:none;border-radius:8px;padding:10px 24px;font-size:14px;text-decoration:none;display:inline-block;}
    .btn-blue:hover{background:#1976d2;color:#fff;}
    .content{padding:32px;}
    .alert-success{background:#0d2218;border:1px solid #4caf50;color:#4caf50;border-radius:8px;padding:12px 18px;margin-bottom:20px;}
    .alert-error{background:#2a0d0d;border:1px solid #f44336;color:#f44336;border-radius:8px;padding:12px 18px;margin-bottom:20px;}
    .summary-bar{display:flex;gap:16px;flex-wrap:wrap;margin-bottom:20px;align-items:center;}
    .badge-paid{background:#0d2218;color:#4caf50;border:1px solid #4caf50;font-size:12px;padding:5px 14px;border-radius:20px;}
    .badge-unpaid{background:#2a0d0d;color:#f44336;border:1px solid #f44336;font-size:12px;padding:5px 14px;border-radius:20px;}
    .badge-total{background:#1a2235;color:var(--blue);border:1px solid var(--border);font-size:12px;padding:5px 14px;border-radius:20px;}
    .filter-input{background:#1a2235;border:1px solid #2a3a55;color:#e0e0e0;border-radius:8px;padding:8px 14px;font-size:13px;margin-left:auto;}
    .filter-input:focus{border-color:var(--blue);outline:none;}
    .table-card{background:var(--card);border:1px solid var(--border);border-radius:14px;overflow:hidden;}
    .custom-table{width:100%;border-collapse:collapse;}
    .custom-table thead th{background:#0d1520;color:var(--blue);font-family:'Bebas Neue',sans-serif;letter-spacing:1px;font-size:13px;padding:14px 16px;text-align:left;border-bottom:1px solid var(--border);}
    .custom-table tbody td{padding:13px 16px;border-bottom:1px solid rgba(255,255,255,0.04);color:#bbb;font-size:14px;vertical-align:middle;}
    .custom-table tbody tr:hover{background:rgba(33,150,243,0.05);}
    .custom-table tbody tr:last-child td{border-bottom:none;}
    .vid{color:var(--gold);font-weight:700;}
    footer{background:#080c14;color:#444;text-align:center;padding:18px;font-size:12px;border-top:1px solid #1a2030;margin-top:40px;}
</style>
</head>
<body>
<nav class="top-nav">
    <a href="dashboard.jsp" class="nav-brand">🚦 RoadSafetyHub</a>
    <div class="nav-links">
        <a href="dashboard.jsp" class="nav-link-btn">🏠 Dashboard</a>
        <a href="addViolation.jsp" class="nav-link-btn">➕ Add Violation</a>
        <a href="violationList.jsp" class="nav-link-btn active">📋 Violations</a>
        <span class="nav-user">👮 <%= user.getUsername() %> [POLICE]</span>
        <a href="../index.jsp" class="nav-logout">Logout</a>
    </div>
</nav>
<div class="main-wrapper">
    <div class="page-header">
        <div><h1>📋 Violation List</h1><p>All recorded traffic violations</p></div>
        <a href="addViolation.jsp" class="btn-blue">+ Add Violation</a>
    </div>
    <div class="content">
        <% if (msg != null) { %><div class="alert-success">✅ <%= msg %></div><% } %>
        <% if (error != null) { %><div class="alert-error">❌ <%= error %></div><% } %>
        <div class="summary-bar">
            <span class="badge-paid">✅ Paid: <%= paid %></span>
            <span class="badge-unpaid">❌ Unpaid: <%= unpaid %></span>
            <span class="badge-total">📋 Total: <%= violations.size() %></span>
            <input type="text" class="filter-input" id="searchBox" onkeyup="filterTable()" placeholder="🔍 Search...">
        </div>
        <div class="table-card">
            <div style="overflow-x:auto;">
                <table class="custom-table" id="vTable">
                    <thead><tr><th>#</th><th>ID</th><th>Vehicle</th><th>Rule</th><th>Officer</th><th>Date & Time</th><th>Status</th></tr></thead>
                    <tbody>
                    <% if (violations.isEmpty()) { %>
                    <tr><td colspan="7" style="text-align:center;padding:40px;color:#555;">No violations recorded yet.</td></tr>
                    <% } else { int i=1; for(Violation v : violations) { %>
                    <tr>
                        <td style="color:#555;"><%= i++ %></td>
                        <td><span class="vid">#<%= v.getViolationId() %></span></td>
                        <td>🚗 <%= v.getVehicleId() %></td>
                        <td>📋 Rule-<%= v.getRuleId() %></td>
                        <td>👮 <%= v.getOfficerId() %></td>
                        <td style="font-size:12px;white-space:nowrap;"><%= v.getViolationDate()!=null?v.getViolationDate().toString().substring(0,16):"N/A" %></td>
                        <td><% if("PAID".equalsIgnoreCase(v.getPaymentStatus())){ %><span style="background:#0d2218;color:#4caf50;border:1px solid #4caf50;font-size:11px;padding:3px 10px;border-radius:20px;">✅ PAID</span><% }else{ %><span style="background:#2a0d0d;color:#f44336;border:1px solid #f44336;font-size:11px;padding:3px 10px;border-radius:20px;">❌ UNPAID</span><% } %></td>
                    </tr>
                    <% } } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
<footer>© 2026 RoadSafetyHub | Developed by Varshitha | Police Portal</footer>
<script>
function filterTable(){
    const q=document.getElementById('searchBox').value.toLowerCase();
    document.querySelectorAll('#vTable tbody tr').forEach(r=>{r.style.display=r.textContent.toLowerCase().includes(q)?'':'none';});
}
</script>
</body>
</html>
