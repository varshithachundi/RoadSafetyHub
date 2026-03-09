<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ page import="com.traffic.model.*,com.traffic.service.*,java.util.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getRole().equalsIgnoreCase("admin")) {
        response.sendRedirect(request.getContextPath() + "/index.jsp"); return;
    }
    List<PoliceOfficer> officers = new PoliceServiceImpl().getAllPoliceOfficers();
    String msg = request.getParameter("msg");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Police – RoadSafetyHub</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet">
<style>
    :root{--gold:#ffc107;--dark:#0d0d0d;--card:#1a1a1a;--border:rgba(255,193,7,0.2);}
    *{box-sizing:border-box;margin:0;padding:0;}
    body{background:var(--dark);color:#e0e0e0;font-family:'DM Sans',sans-serif;min-height:100vh;}
    .top-nav{background:rgba(13,13,13,0.98);border-bottom:2px solid var(--gold);padding:14px 28px;display:flex;align-items:center;justify-content:space-between;position:fixed;top:0;left:0;right:0;z-index:1000;}
    .nav-brand{font-family:'Bebas Neue',sans-serif;font-size:24px;letter-spacing:3px;color:var(--gold);text-decoration:none;}
    .nav-links{display:flex;align-items:center;gap:8px;flex-wrap:wrap;}
    .nav-link-btn{color:#ccc;text-decoration:none;padding:7px 16px;border-radius:6px;font-size:14px;transition:all 0.2s;border:1px solid transparent;}
    .nav-link-btn:hover,.nav-link-btn.active{color:var(--gold);border-color:var(--gold);background:rgba(255,193,7,0.08);}
    .nav-user{background:rgba(255,193,7,0.15);border:1px solid var(--gold);border-radius:20px;padding:5px 14px;font-size:13px;color:var(--gold);}
    .nav-logout{background:transparent;border:1px solid #555;color:#aaa;padding:7px 16px;border-radius:6px;text-decoration:none;font-size:13px;}
    .nav-logout:hover{border-color:#f44336;color:#f44336;}
    .main-wrapper{padding-top:70px;}
    .page-header{background:linear-gradient(135deg,#0d0d0d,#1a1400);border-bottom:1px solid var(--border);padding:32px;display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:16px;}
    .page-header h1{font-family:'Bebas Neue',sans-serif;font-size:36px;letter-spacing:3px;color:var(--gold);}
    .page-header p{color:#888;font-size:14px;margin-top:4px;}
    .btn-gold{background:var(--gold);color:#000;font-weight:700;border:none;border-radius:8px;padding:10px 24px;font-size:14px;cursor:pointer;}
    .btn-gold:hover{background:#e0a800;}
    .content{padding:32px;}
    .alert-success{background:#0d2218;border:1px solid #4caf50;color:#4caf50;border-radius:8px;padding:12px 18px;margin-bottom:20px;}
    .alert-error{background:#2a0d0d;border:1px solid #f44336;color:#f44336;border-radius:8px;padding:12px 18px;margin-bottom:20px;}
    .table-card{background:var(--card);border:1px solid var(--border);border-radius:14px;overflow:hidden;}
    .table-card-header{padding:18px 22px;border-bottom:1px solid var(--border);display:flex;justify-content:space-between;align-items:center;}
    .table-card-header span{font-family:'Bebas Neue',sans-serif;font-size:18px;letter-spacing:2px;color:var(--gold);}
    .count-badge{background:#2a2a2a;color:var(--gold);border-radius:20px;padding:3px 12px;font-size:13px;}
    .custom-table{width:100%;border-collapse:collapse;}
    .custom-table thead th{background:#111;color:var(--gold);font-family:'Bebas Neue',sans-serif;letter-spacing:1px;font-size:13px;padding:14px 16px;text-align:left;border-bottom:1px solid var(--border);}
    .custom-table tbody td{padding:13px 16px;border-bottom:1px solid rgba(255,255,255,0.04);color:#bbb;font-size:14px;vertical-align:middle;}
    .custom-table tbody tr:hover{background:rgba(255,193,7,0.04);}
    .custom-table tbody tr:last-child td{border-bottom:none;}
    .police-badge{background:#1a2a3a;color:#2196f3;border:1px solid #2196f3;font-size:11px;padding:3px 10px;border-radius:20px;}
    .btn-sm-edit{background:transparent;border:1px solid var(--gold);color:var(--gold);border-radius:6px;padding:5px 12px;font-size:12px;cursor:pointer;transition:all 0.2s;margin-right:8px;}
    .btn-sm-edit:hover{background:var(--gold);color:#000;}
    .btn-sm-del{background:transparent;border:1px solid #f44336;color:#f44336;border-radius:6px;padding:5px 12px;font-size:12px;cursor:pointer;transition:all 0.2s;}
    .btn-sm-del:hover{background:#f44336;color:#fff;}
    .modal-overlay{display:none;position:fixed;top:0;left:0;right:0;bottom:0;background:rgba(0,0,0,0.7);z-index:2000;align-items:center;justify-content:center;}
    .modal-overlay.show{display:flex;}
    .modal-box{background:#1a1a1a;border:1px solid var(--border);border-radius:16px;padding:32px;width:100%;max-width:480px;position:relative;}
    .modal-box h4{font-family:'Bebas Neue',sans-serif;font-size:22px;letter-spacing:2px;color:var(--gold);margin-bottom:24px;}
    .modal-close{position:absolute;top:16px;right:20px;background:none;border:none;color:#aaa;font-size:20px;cursor:pointer;}
    .form-group{margin-bottom:18px;}
    .form-group label{display:block;color:#aaa;font-size:13px;margin-bottom:6px;}
    .form-group input{width:100%;background:#2a2a2a;border:1px solid #444;color:#e0e0e0;border-radius:8px;padding:10px 14px;font-size:14px;}
    .form-group input:focus{border-color:var(--gold);outline:none;background:#333;}
    .modal-footer-btns{display:flex;gap:12px;margin-top:24px;}
    .btn-cancel{background:transparent;border:1px solid #555;color:#aaa;border-radius:8px;padding:10px 20px;font-size:14px;cursor:pointer;}
    footer{background:#080808;color:#444;text-align:center;padding:18px;font-size:12px;border-top:1px solid #1a1a1a;margin-top:40px;}
</style>
</head>
<body>
<nav class="top-nav">
    <a href="dashboard.jsp" class="nav-brand">🚦 RoadSafetyHub</a>
    <div class="nav-links">
        <a href="dashboard.jsp" class="nav-link-btn">🏠 Dashboard</a>
        <a href="owners.jsp" class="nav-link-btn">👤 Owners</a>
        <a href="police.jsp" class="nav-link-btn active">👮 Police</a>
        <a href="violations.jsp" class="nav-link-btn">⚠️ Violations</a>
        <span class="nav-user">⚙️ <%= user.getUsername() %> [ADMIN]</span>
        <a href="../index.jsp" class="nav-logout">Logout</a>
    </div>
</nav>
<div class="main-wrapper">
    <div class="page-header">
        <div><h1>👮 Police Officers</h1><p>Manage all registered police officers</p></div>
        <button class="btn-gold" onclick="document.getElementById('addModal').classList.add('show')">+ Add Officer</button>
    </div>
    <div class="content">
        <% if (msg != null) { %><div class="alert-success">✅ <%= msg %></div><% } %>
        <% if (error != null) { %><div class="alert-error">❌ <%= error %></div><% } %>
        <div class="table-card">
            <div class="table-card-header">
                <span>All Officers</span>
                <span class="count-badge"><%= officers.size() %> total</span>
            </div>
            <div style="overflow-x:auto;">
                <table class="custom-table">
                    <thead><tr><th>#</th><th>Officer ID</th><th>Name</th><th>Badge Number</th><th>User ID</th><th>Actions</th></tr></thead>
                    <tbody>
                    <% if (officers.isEmpty()) { %>
                    <tr><td colspan="6" style="text-align:center;padding:40px;color:#555;">No officers found.</td></tr>
                    <% } else { int i=1; for(PoliceOfficer p : officers) { %>
                    <tr>
                        <td style="color:#555;"><%= i++ %></td>
                        <td><span class="police-badge">#<%= p.getOfficerId() %></span></td>
                        <td><strong style="color:#fff;"><%= p.getName() %></strong></td>
                        <td>🪪 <span style="color:var(--gold);font-weight:600;"><%= p.getBadgeNumber()!=null?p.getBadgeNumber():"N/A" %></span></td>
                        <td style="color:#888;"><%= p.getUserId() %></td>
                        <td>
                            <button class="btn-sm-edit" onclick="openEdit(<%= p.getOfficerId() %>,'<%= p.getName().replace("'","\\'") %>','<%= p.getBadgeNumber()!=null?p.getBadgeNumber():"" %>')">✏️ Edit</button>
                            <form action="../PoliceController" method="post" style="display:inline;" onsubmit="return confirm('Delete this officer?')">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="officerId" value="<%= p.getOfficerId() %>">
                                <button type="submit" class="btn-sm-del">🗑️ Delete</button>
                            </form>
                        </td>
                    </tr>
                    <% } } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- ADD MODAL -->
<div class="modal-overlay" id="addModal">
    <div class="modal-box">
        <button class="modal-close" onclick="document.getElementById('addModal').classList.remove('show')">✕</button>
        <h4>➕ Add Police Officer</h4>
        <form action="../PoliceController" method="post">
            <input type="hidden" name="action" value="add">
            <div class="form-group"><label>Officer Name *</label><input type="text" name="name" required placeholder="e.g. Suresh Reddy"></div>
            <div class="form-group"><label>Badge Number *</label><input type="text" name="badgeNumber" required placeholder="e.g. HYD-2024-001"></div>
            <div class="form-group"><label>User ID *</label><input type="number" name="userId" required placeholder="From users table"></div>
            <div class="modal-footer-btns">
                <button type="button" class="btn-cancel" onclick="document.getElementById('addModal').classList.remove('show')">Cancel</button>
                <button type="submit" class="btn-gold">Save Officer</button>
            </div>
        </form>
    </div>
</div>

<!-- EDIT MODAL -->
<div class="modal-overlay" id="editModal">
    <div class="modal-box">
        <button class="modal-close" onclick="document.getElementById('editModal').classList.remove('show')">✕</button>
        <h4>✏️ Edit Officer</h4>
        <form action="../PoliceController" method="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="officerId" id="editId">
            <div class="form-group"><label>Officer Name *</label><input type="text" name="name" id="editName" required></div>
            <div class="form-group"><label>Badge Number *</label><input type="text" name="badgeNumber" id="editBadge" required></div>
            <div class="modal-footer-btns">
                <button type="button" class="btn-cancel" onclick="document.getElementById('editModal').classList.remove('show')">Cancel</button>
                <button type="submit" class="btn-gold">Update Officer</button>
            </div>
        </form>
    </div>
</div>

<footer>© 2026 RoadSafetyHub | Developed by Varshitha | Admin Portal</footer>
<script>
function openEdit(id, name, badge) {
    document.getElementById('editId').value = id;
    document.getElementById('editName').value = name;
    document.getElementById('editBadge').value = badge;
    document.getElementById('editModal').classList.add('show');
}
</script>
</body>
</html>
