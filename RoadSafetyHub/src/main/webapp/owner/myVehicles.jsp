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
    List<Vehicle> myVehicles = new ArrayList<>();
    if (owner != null) {
        myVehicles = vehicleService.getVehiclesByOwnerId(owner.getOwnerId());
    }
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
    :root { --gold: #ffc107; --dark: #0f0f0f; --card-bg: #1a1a1a; --border: rgba(255,193,7,0.2); --green: #4caf50; }
    body { background: var(--dark); color: #e0e0e0; font-family: 'DM Sans', sans-serif; padding-top: 70px; min-height: 100vh; }
    .page-header { background: #0a1f0a; border-bottom: 2px solid var(--green); padding: 24px 0 18px; margin-bottom: 28px; }
    .page-header h2 { font-family: 'Bebas Neue', sans-serif; font-size: 32px; letter-spacing: 3px; color: var(--green); margin: 0; }
    .card-dark { background: var(--card-bg); border: 1px solid var(--border); border-radius: 12px; }
    .table-dark-custom thead th { background: #222; color: var(--gold); font-family: 'Bebas Neue', sans-serif; letter-spacing: 1.5px; font-size: 14px; border-color: var(--border); }
    .table-dark-custom tbody tr { border-color: #2a2a2a; color: #ccc; transition: background 0.15s; }
    .table-dark-custom tbody tr:hover { background: #222; }
    .table-dark-custom td { border-color: #2a2a2a; vertical-align: middle; }
    .btn-gold { background: var(--gold); color: #000; font-weight: 600; border: none; }
    .btn-gold:hover { background: #e0a800; color: #000; }
    .section-title { font-family: 'Bebas Neue', sans-serif; font-size: 20px; letter-spacing: 2px; color: var(--gold); }
    .form-control-dark { background: #2a2a2a; border: 1px solid #444; color: #e0e0e0; border-radius: 8px; }
    .form-control-dark:focus { background: #333; border-color: var(--gold); color: #fff; box-shadow: 0 0 0 3px rgba(255,193,7,0.15); }
    .form-select-dark { background: #2a2a2a; border: 1px solid #444; color: #e0e0e0; border-radius: 8px; }
    .form-select-dark:focus { background: #333; border-color: var(--gold); color: #fff; box-shadow: 0 0 0 3px rgba(255,193,7,0.15); }
    .modal-dark .modal-content { background: #1a1a1a; border: 1px solid var(--border); color: #e0e0e0; }
    .modal-dark .modal-header { border-bottom: 1px solid var(--border); }
    .modal-dark .modal-footer { border-top: 1px solid var(--border); }
    .modal-dark .modal-title { font-family: 'Bebas Neue', sans-serif; font-size: 22px; letter-spacing: 2px; color: var(--gold); }
    .vehicle-badge { background: #1a2a3a; color: #64b5f6; border: 1px solid #64b5f6; font-size: 11px; padding: 4px 10px; border-radius: 20px; }
    label { color: #aaa; font-size: 13px; margin-bottom: 4px; }
    footer { background: #111; color: #555; text-align: center; padding: 16px; font-size: 13px; border-top: 1px solid #222; margin-top: 60px; }
</style>
</head>
<body>
<%@ include file="../navbar.jsp" %>

<div class="page-header">
    <div class="container-fluid px-4 d-flex justify-content-between align-items-center flex-wrap gap-2">
        <div>
            <h2>🚗 My Vehicles</h2>
            <p style="color:#aaa;margin:0;font-size:13px;">Manage your registered vehicles</p>
        </div>
        <% if (owner != null) { %>
        <button class="btn btn-gold px-4" data-bs-toggle="modal" data-bs-target="#addVehicleModal">+ Add Vehicle</button>
        <% } %>
    </div>
</div>

<div class="container-fluid px-4">
    <% if (msg != null) { %><div class="alert mb-3" style="background:#1a3a1a;border:1px solid #4caf50;color:#4caf50;border-radius:8px;">✅ <%= msg %></div><% } %>
    <% if (error != null) { %><div class="alert mb-3" style="background:#3a1a1a;border:1px solid #f44336;color:#f44336;border-radius:8px;">❌ <%= error %></div><% } %>
    <% if (owner == null) { %>
    <div class="alert" style="background:#3a2a1a;border:1px solid #ff9800;color:#ff9800;border-radius:8px;">⚠️ Owner profile not set up. Contact admin to register your profile first.</div>
    <% } else { %>

    <div class="card-dark p-0 overflow-hidden">
        <div class="p-3" style="border-bottom:1px solid var(--border);">
            <span class="section-title mb-0">Registered Vehicles <span class="ms-2 badge" style="background:#2a2a2a;color:var(--gold);font-size:14px;"><%= myVehicles.size() %></span></span>
        </div>
        <div class="table-responsive">
            <table class="table table-dark-custom mb-0">
                <thead>
                    <tr><th>#</th><th>Vehicle ID</th><th>Vehicle Number</th><th>Type</th><th>Actions</th></tr>
                </thead>
                <tbody>
                    <% if (myVehicles.isEmpty()) { %>
                    <tr><td colspan="5" class="text-center text-muted py-4">No vehicles registered yet. Add your first vehicle!</td></tr>
                    <% } else { int i = 1; for (Vehicle v : myVehicles) { %>
                    <tr>
                        <td><%= i++ %></td>
                        <td><span class="vehicle-badge">#<%= v.getVehicleId() %></span></td>
                        <td><strong style="color:#fff;font-size:15px;">🚗 <%= v.getVehicleNumber() %></strong></td>
                        <td><span class="badge" style="background:#2a2a2a;color:#aaa;"><%= v.getVehicleType() %></span></td>
                        <td>
                            <button class="btn btn-sm btn-outline-warning me-1"
                                onclick="openEdit(<%= v.getVehicleId() %>,'<%= v.getVehicleNumber().replace("'","\\'") %>','<%= v.getVehicleType().replace("'","\\'") %>')">
                                ✏️ Edit
                            </button>
                            <form action="${pageContext.request.contextPath}/vehicle" method="post" style="display:inline"
                                  onsubmit="return confirm('Remove this vehicle?')">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="vehicleId" value="<%= v.getVehicleId() %>">
                                <button type="submit" class="btn btn-sm btn-outline-danger">🗑️ Remove</button>
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

<!-- Add Vehicle Modal -->
<% if (owner != null) { %>
<div class="modal fade modal-dark" id="addVehicleModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content p-2">
            <div class="modal-header">
                <h5 class="modal-title">➕ Add New Vehicle</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/vehicle" method="post">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="ownerId" value="<%= owner.getOwnerId() %>">
                <div class="modal-body">
                    <div class="mb-3">
                        <label>Vehicle Number *</label>
                        <input type="text" name="vehicleNumber" class="form-control form-control-dark" required placeholder="e.g. TS09AB1234" style="text-transform:uppercase;">
                    </div>
                    <div class="mb-3">
                        <label>Vehicle Type *</label>
                        <select name="vehicleType" class="form-select form-select-dark" required>
                            <option value="">-- Select Type --</option>
                            <option value="Car">Car</option>
                            <option value="Bike">Bike</option>
                            <option value="Truck">Truck</option>
                            <option value="Bus">Bus</option>
                            <option value="Auto">Auto</option>
                            <option value="Van">Van</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-gold px-4">Save Vehicle</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Vehicle Modal -->
<div class="modal fade modal-dark" id="editVehicleModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content p-2">
            <div class="modal-header">
                <h5 class="modal-title">✏️ Edit Vehicle</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/vehicle" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="vehicleId" id="editVehicleId">
                <div class="modal-body">
                    <div class="mb-3">
                        <label>Vehicle Number *</label>
                        <input type="text" name="vehicleNumber" id="editVehicleNumber" class="form-control form-control-dark" required>
                    </div>
                    <div class="mb-3">
                        <label>Vehicle Type *</label>
                        <select name="vehicleType" id="editVehicleType" class="form-select form-select-dark" required>
                            <option value="Car">Car</option>
                            <option value="Bike">Bike</option>
                            <option value="Truck">Truck</option>
                            <option value="Bus">Bus</option>
                            <option value="Auto">Auto</option>
                            <option value="Van">Van</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-gold px-4">Update Vehicle</button>
                </div>
            </form>
        </div>
    </div>
</div>
<% } %>

<footer>© 2026 RoadSafetyHub | Developed by Varshitha</footer>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
function openEdit(id, number, type) {
    document.getElementById('editVehicleId').value = id;
    document.getElementById('editVehicleNumber').value = number;
    document.getElementById('editVehicleType').value = type;
    new bootstrap.Modal(document.getElementById('editVehicleModal')).show();
}
</script>
</body>
</html>
