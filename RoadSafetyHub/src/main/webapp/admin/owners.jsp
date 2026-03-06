<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.traffic.model.*" %>
<%@ page import="com.traffic.service.*" %>
<%@ page import="java.util.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getRole().equalsIgnoreCase("admin")) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    OwnerService ownerService = new OwnerServiceImpl();
    List<Owner> owners = ownerService.getAllOwners();
    String msg = request.getParameter("msg");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Owners – RoadSafetyHub</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet">
<style>
    :root { --gold: #ffc107; --dark: #0f0f0f; --card-bg: #1a1a1a; --border: rgba(255,193,7,0.2); }
    body { background: var(--dark); color: #e0e0e0; font-family: 'DM Sans', sans-serif; padding-top: 70px; min-height: 100vh; }
    .page-header { background: #1a1a1a; border-bottom: 2px solid var(--gold); padding: 24px 0 18px; margin-bottom: 28px; }
    .page-header h2 { font-family: 'Bebas Neue', sans-serif; font-size: 32px; letter-spacing: 3px; color: var(--gold); margin: 0; }
    .card-dark { background: var(--card-bg); border: 1px solid var(--border); border-radius: 12px; }
    .table-dark-custom { color: #ccc; }
    .table-dark-custom thead th { background: #222; color: var(--gold); font-family: 'Bebas Neue', sans-serif; letter-spacing: 1.5px; font-size: 15px; border-color: var(--border); }
    .table-dark-custom tbody tr { border-color: #2a2a2a; transition: background 0.15s; }
    .table-dark-custom tbody tr:hover { background: #222; }
    .table-dark-custom td { border-color: #2a2a2a; vertical-align: middle; }
    .btn-gold { background: var(--gold); color: #000; font-weight: 600; border: none; }
    .btn-gold:hover { background: #e0a800; color: #000; }
    .section-title { font-family: 'Bebas Neue', sans-serif; font-size: 20px; letter-spacing: 2px; color: var(--gold); }
    .form-control-dark { background: #2a2a2a; border: 1px solid #444; color: #e0e0e0; border-radius: 8px; }
    .form-control-dark:focus { background: #333; border-color: var(--gold); color: #fff; box-shadow: 0 0 0 3px rgba(255,193,7,0.15); }
    .modal-dark .modal-content { background: #1a1a1a; border: 1px solid var(--border); color: #e0e0e0; }
    .modal-dark .modal-header { border-bottom: 1px solid var(--border); }
    .modal-dark .modal-footer { border-top: 1px solid var(--border); }
    .modal-dark .modal-title { font-family: 'Bebas Neue', sans-serif; font-size: 22px; letter-spacing: 2px; color: var(--gold); }
    .badge-owner { background: #1a3a2a; color: #4caf50; border: 1px solid #4caf50; font-size: 11px; padding: 4px 8px; border-radius: 20px; }
    footer { background: #111; color: #555; text-align: center; padding: 16px; font-size: 13px; border-top: 1px solid #222; margin-top: 60px; }
    label { color: #aaa; font-size: 13px; margin-bottom: 4px; }
</style>
</head>
<body>
<%@ include file="../navbar.jsp" %>

<div class="page-header">
    <div class="container-fluid px-4 d-flex justify-content-between align-items-center flex-wrap gap-2">
        <div>
            <h2>👤 Vehicle Owners</h2>
            <p class="text-muted mb-0" style="font-size:13px;">Manage all registered vehicle owners</p>
        </div>
        <button class="btn btn-gold px-4" data-bs-toggle="modal" data-bs-target="#addOwnerModal">+ Add Owner</button>
    </div>
</div>

<div class="container-fluid px-4">
    <% if (msg != null) { %><div class="alert" style="background:#1a3a1a;border:1px solid #4caf50;color:#4caf50;border-radius:8px;" role="alert">✅ <%= msg %></div><% } %>
    <% if (error != null) { %><div class="alert" style="background:#3a1a1a;border:1px solid #f44336;color:#f44336;border-radius:8px;" role="alert">❌ <%= error %></div><% } %>

    <div class="card-dark p-0 overflow-hidden">
        <div class="p-3 d-flex justify-content-between align-items-center" style="border-bottom:1px solid var(--border);">
            <span class="section-title mb-0">All Owners <span class="ms-2 badge" style="background:#2a2a2a;color:var(--gold);font-size:14px;"><%= owners.size() %></span></span>
        </div>
        <div class="table-responsive">
            <table class="table table-dark-custom mb-0">
                <thead>
                    <tr>
                        <th>#</th><th>Owner ID</th><th>Name</th><th>Mobile</th><th>Address</th><th>User ID</th><th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (owners.isEmpty()) { %>
                    <tr><td colspan="7" class="text-center text-muted py-4">No owners found. Add one to get started.</td></tr>
                    <% } else { int i = 1; for (Owner o : owners) { %>
                    <tr>
                        <td><%= i++ %></td>
                        <td><span class="badge-owner">#<%= o.getOwnerId() %></span></td>
                        <td><strong style="color:#fff;"><%= o.getName() %></strong></td>
                        <td>📞 <%= o.getMobile() != null ? o.getMobile() : "N/A" %></td>
                        <td style="max-width:200px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;" title="<%= o.getAddress() != null ? o.getAddress() : "" %>">
                            <%= o.getAddress() != null ? o.getAddress() : "N/A" %>
                        </td>
                        <td><%= o.getUserId() %></td>
                        <td>
                            <button class="btn btn-sm btn-outline-warning me-1"
                                onclick="openEdit(<%= o.getOwnerId() %>,'<%= o.getName().replace("'","\\'") %>','<%= o.getMobile() != null ? o.getMobile() : "" %>','<%= o.getAddress() != null ? o.getAddress().replace("'","\\'") : "" %>')">
                                ✏️ Edit
                            </button>
                            <form action="${pageContext.request.contextPath}/OwnerController" method="post" style="display:inline"
                                  onsubmit="return confirm('Delete this owner?')">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="ownerId" value="<%= o.getOwnerId() %>">
                                <button type="submit" class="btn btn-sm btn-outline-danger">🗑️ Delete</button>
                            </form>
                        </td>
                    </tr>
                    <% } } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Add Owner Modal -->
<div class="modal fade modal-dark" id="addOwnerModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content p-2">
            <div class="modal-header">
                <h5 class="modal-title">➕ Add New Owner</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/OwnerController" method="post">
                <input type="hidden" name="action" value="add">
                <div class="modal-body">
                    <div class="mb-3">
                        <label>Full Name *</label>
                        <input type="text" name="name" class="form-control form-control-dark" required placeholder="e.g. Ravi Kumar">
                    </div>
                    <div class="mb-3">
                        <label>Mobile Number</label>
                        <input type="text" name="mobile" class="form-control form-control-dark" maxlength="10" placeholder="10-digit mobile">
                    </div>
                    <div class="mb-3">
                        <label>Address</label>
                        <textarea name="address" class="form-control form-control-dark" rows="2" placeholder="Full address"></textarea>
                    </div>
                    <div class="mb-3">
                        <label>User ID (from users table) *</label>
                        <input type="number" name="userId" class="form-control form-control-dark" required placeholder="e.g. 5">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-gold px-4">Save Owner</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Owner Modal -->
<div class="modal fade modal-dark" id="editOwnerModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content p-2">
            <div class="modal-header">
                <h5 class="modal-title">✏️ Edit Owner</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/OwnerController" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="ownerId" id="editOwnerId">
                <div class="modal-body">
                    <div class="mb-3">
                        <label>Full Name *</label>
                        <input type="text" name="name" id="editName" class="form-control form-control-dark" required>
                    </div>
                    <div class="mb-3">
                        <label>Mobile Number</label>
                        <input type="text" name="mobile" id="editMobile" class="form-control form-control-dark" maxlength="10">
                    </div>
                    <div class="mb-3">
                        <label>Address</label>
                        <textarea name="address" id="editAddress" class="form-control form-control-dark" rows="2"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-gold px-4">Update Owner</button>
                </div>
            </form>
        </div>
    </div>
</div>

<footer>© 2026 RoadSafetyHub | Developed by Varshitha</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
function openEdit(id, name, mobile, address) {
    document.getElementById('editOwnerId').value = id;
    document.getElementById('editName').value = name;
    document.getElementById('editMobile').value = mobile;
    document.getElementById('editAddress').value = address;
    new bootstrap.Modal(document.getElementById('editOwnerModal')).show();
}
</script>
</body>
</html>
