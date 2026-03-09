<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ page import="com.traffic.model.*,com.traffic.service.*,java.util.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getRole().equalsIgnoreCase("owner")) {
        response.sendRedirect(request.getContextPath() + "/index.jsp"); return;
    }
    OwnerService ownerService = new OwnerServiceImpl();
    Owner owner = null;
    for (Owner o : ownerService.getAllOwners()) {
        if (o.getUserId() == user.getUserId()) { owner = o; break; }
    }
    List<Vehicle> myVehicles = new ArrayList<>();
    if (owner != null) myVehicles = new VehicleServiceImpl().getVehiclesByOwnerId(owner.getOwnerId());
    String msg = request.getParameter("msg");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Vehicles – RoadSafetyHub</title>
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
    .page-header{background:linear-gradient(135deg,#0a120a,#0d1e0d);border-bottom:1px solid var(--border);padding:32px;display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:16px;}
    .page-header h1{font-family:'Bebas Neue',sans-serif;font-size:36px;letter-spacing:3px;color:var(--green);}
    .page-header p{color:#888;font-size:14px;margin-top:4px;}
    .btn-green{background:var(--green);color:#fff;font-weight:700;border:none;border-radius:8px;padding:10px 24px;font-size:14px;cursor:pointer;}
    .btn-green:hover{background:#388e3c;}
    .content{padding:32px;}
    .alert-success{background:#0d2218;border:1px solid #4caf50;color:#4caf50;border-radius:8px;padding:12px 18px;margin-bottom:20px;}
    .alert-error{background:#2a0d0d;border:1px solid #f44336;color:#f44336;border-radius:8px;padding:12px 18px;margin-bottom:20px;}
    .warning-card{background:#1a1200;border:1px solid #ff9800;border-radius:12px;padding:20px;color:#ff9800;margin-bottom:20px;}
    .table-card{background:var(--card);border:1px solid var(--border);border-radius:14px;overflow:hidden;}
    .table-card-header{padding:18px 22px;border-bottom:1px solid var(--border);display:flex;justify-content:space-between;align-items:center;}
    .table-card-header span{font-family:'Bebas Neue',sans-serif;font-size:18px;letter-spacing:2px;color:var(--gold);}
    .count-badge{background:#1a2a1a;color:var(--green);border-radius:20px;padding:3px 12px;font-size:13px;}
    .custom-table{width:100%;border-collapse:collapse;}
    .custom-table thead th{background:#0a140a;color:var(--green);font-family:'Bebas Neue',sans-serif;letter-spacing:1px;font-size:13px;padding:14px 16px;text-align:left;border-bottom:1px solid var(--border);}
    .custom-table tbody td{padding:13px 16px;border-bottom:1px solid rgba(255,255,255,0.04);color:#bbb;font-size:14px;vertical-align:middle;}
    .custom-table tbody tr:hover{background:rgba(76,175,80,0.05);}
    .custom-table tbody tr:last-child td{border-bottom:none;}
    .vehicle-badge{background:#1a2a3a;color:#64b5f6;border:1px solid #64b5f6;font-size:11px;padding:3px 10px;border-radius:20px;}
    .type-badge{background:#2a2a2a;color:#aaa;font-size:12px;padding:3px 10px;border-radius:6px;}
    .btn-sm-edit{background:transparent;border:1px solid var(--gold);color:var(--gold);border-radius:6px;padding:5px 12px;font-size:12px;cursor:pointer;margin-right:8px;}
    .btn-sm-edit:hover{background:var(--gold);color:#000;}
    .btn-sm-del{background:transparent;border:1px solid #f44336;color:#f44336;border-radius:6px;padding:5px 12px;font-size:12px;cursor:pointer;}
    .btn-sm-del:hover{background:#f44336;color:#fff;}
    .modal-overlay{display:none;position:fixed;top:0;left:0;right:0;bottom:0;background:rgba(0,0,0,0.75);z-index:2000;align-items:center;justify-content:center;}
    .modal-overlay.show{display:flex;}
    .modal-box{background:#0f1a0f;border:1px solid var(--border);border-radius:16px;padding:32px;width:100%;max-width:440px;position:relative;}
    .modal-box h4{font-family:'Bebas Neue',sans-serif;font-size:22px;letter-spacing:2px;color:var(--gold);margin-bottom:24px;}
    .modal-close{position:absolute;top:16px;right:20px;background:none;border:none;color:#aaa;font-size:20px;cursor:pointer;}
    .form-group{margin-bottom:18px;}
    .form-group label{display:block;color:#aaa;font-size:13px;margin-bottom:6px;}
    .form-group input,.form-group select{width:100%;background:#1a2a1a;border:1px solid #2a4a2a;color:#e0e0e0;border-radius:8px;padding:10px 14px;font-size:14px;font-family:'DM Sans',sans-serif;}
    .form-group input:focus,.form-group select:focus{border-color:var(--green);outline:none;}
    .modal-footer-btns{display:flex;gap:12px;margin-top:24px;}
    .btn-cancel{background:transparent;border:1px solid #555;color:#aaa;border-radius:8px;padding:10px 20px;font-size:14px;cursor:pointer;}
    footer{background:#060e06;color:#444;text-align:center;padding:18px;font-size:12px;border-top:1px solid #1a2a1a;margin-top:40px;}
</style>
</head>
<body>
<nav class="top-nav">
    <a href="dashboard.jsp" class="nav-brand">🚦 RoadSafetyHub</a>
    <div class="nav-links">
        <a href="dashboard.jsp" class="nav-link-btn">🏠 Dashboard</a>
        <a href="myVehicles.jsp" class="nav-link-btn active">🚗 My Vehicles</a>
        <a href="myViolations.jsp" class="nav-link-btn">⚠️ My Violations</a>
        <span class="nav-user">👤 <%= user.getUsername() %> [OWNER]</span>
        <a href="../index.jsp" class="nav-logout">Logout</a>
    </div>
</nav>
<div class="main-wrapper">
    <div class="page-header">
        <div><h1>🚗 My Vehicles</h1><p>Manage your registered vehicles</p></div>
        <% if (owner != null) { %>
        <button class="btn-green" onclick="document.getElementById('addModal').classList.add('show')">+ Add Vehicle</button>
        <% } %>
    </div>
    <div class="content">
        <% if (msg != null) { %><div class="alert-success">✅ <%= msg %></div><% } %>
        <% if (error != null) { %><div class="alert-error">❌ <%= error %></div><% } %>
        <% if (owner == null) { %>
        <div class="warning-card">⚠️ Owner profile not linked. Ask admin to add your profile with User ID: <strong><%= user.getUserId() %></strong></div>
        <% } else { %>
        <div class="table-card">
            <div class="table-card-header">
                <span>Registered Vehicles</span>
                <span class="count-badge"><%= myVehicles.size() %> vehicles</span>
            </div>
            <div style="overflow-x:auto;">
                <table class="custom-table">
                    <thead><tr><th>#</th><th>Vehicle ID</th><th>Vehicle Number</th><th>Type</th><th>Actions</th></tr></thead>
                    <tbody>
                    <% if (myVehicles.isEmpty()) { %>
                    <tr><td colspan="5" style="text-align:center;padding:40px;color:#555;">No vehicles yet. Add your first vehicle!</td></tr>
                    <% } else { int i=1; for(Vehicle v : myVehicles) { %>
                    <tr>
                        <td style="color:#555;"><%= i++ %></td>
                        <td><span class="vehicle-badge">#<%= v.getVehicleId() %></span></td>
                        <td><strong style="color:#fff;font-size:15px;">🚗 <%= v.getVehicleNumber() %></strong></td>
                        <td><span class="type-badge"><%= v.getVehicleType() %></span></td>
                        <td>
                            <button class="btn-sm-edit" onclick="openEdit(<%= v.getVehicleId() %>,'<%= v.getVehicleNumber().replace("'","\\'") %>','<%= v.getVehicleType() %>')">✏️ Edit</button>
                            <form action="../vehicle" method="post" style="display:inline;" onsubmit="return confirm('Remove this vehicle?')">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="vehicleId" value="<%= v.getVehicleId() %>">
                                <button type="submit" class="btn-sm-del">🗑️ Remove</button>
                            </form>
                        </td>
                    </tr>
                    <% } } %>
                    </tbody>
                </table>
            </div>
        </div>
        <% } %>
    </div>
</div>

<% if (owner != null) { %>
<!-- ADD MODAL -->
<div class="modal-overlay" id="addModal">
    <div class="modal-box">
        <button class="modal-close" onclick="document.getElementById('addModal').classList.remove('show')">✕</button>
        <h4>➕ Add Vehicle</h4>
        <form action="../vehicle" method="post">
            <input type="hidden" name="action" value="add">
            <input type="hidden" name="ownerId" value="<%= owner.getOwnerId() %>">
            <div class="form-group"><label>Vehicle Number *</label><input type="text" name="vehicleNumber" required placeholder="e.g. TS09AB1234" style="text-transform:uppercase;"></div>
            <div class="form-group">
                <label>Vehicle Type *</label>
                <select name="vehicleType" required>
                    <option value="">-- Select Type --</option>
                    <option value="Car">Car</option>
                    <option value="Bike">Bike</option>
                    <option value="Truck">Truck</option>
                    <option value="Bus">Bus</option>
                    <option value="Auto">Auto</option>
                    <option value="Van">Van</option>
                </select>
            </div>
            <div class="modal-footer-btns">
                <button type="button" class="btn-cancel" onclick="document.getElementById('addModal').classList.remove('show')">Cancel</button>
                <button type="submit" class="btn-green">Save Vehicle</button>
            </div>
        </form>
    </div>
</div>
<!-- EDIT MODAL -->
<div class="modal-overlay" id="editModal">
    <div class="modal-box">
        <button class="modal-close" onclick="document.getElementById('editModal').classList.remove('show')">✕</button>
        <h4>✏️ Edit Vehicle</h4>
        <form action="../vehicle" method="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="vehicleId" id="editId">
            <div class="form-group"><label>Vehicle Number *</label><input type="text" name="vehicleNumber" id="editNum" required></div>
            <div class="form-group">
                <label>Vehicle Type *</label>
                <select name="vehicleType" id="editType" required>
                    <option value="Car">Car</option>
                    <option value="Bike">Bike</option>
                    <option value="Truck">Truck</option>
                    <option value="Bus">Bus</option>
                    <option value="Auto">Auto</option>
                    <option value="Van">Van</option>
                </select>
            </div>
            <div class="modal-footer-btns">
                <button type="button" class="btn-cancel" onclick="document.getElementById('editModal').classList.remove('show')">Cancel</button>
                <button type="submit" class="btn-green">Update Vehicle</button>
            </div>
        </form>
    </div>
</div>
<% } %>

<footer>© 2026 RoadSafetyHub | Developed by Varshitha | Owner Portal</footer>
<script>
function openEdit(id, num, type) {
    document.getElementById('editId').value = id;
    document.getElementById('editNum').value = num;
    document.getElementById('editType').value = type;
    document.getElementById('editModal').classList.add('show');
}
</script>
</body>
</html>
