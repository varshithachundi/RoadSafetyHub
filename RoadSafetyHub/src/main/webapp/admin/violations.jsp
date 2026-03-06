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
    ViolationService violationService = new ViolationServiceImpl();
    List<Violation> violations = violationService.getAllViolations();
    String msg = request.getParameter("msg");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Violations – RoadSafetyHub</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet">
<style>
    :root { --gold: #ffc107; --dark: #0f0f0f; --card-bg: #1a1a1a; --border: rgba(255,193,7,0.2); }
    body { background: var(--dark); color: #e0e0e0; font-family: 'DM Sans', sans-serif; padding-top: 70px; min-height: 100vh; }
    .page-header { background: #1a1a1a; border-bottom: 2px solid var(--gold); padding: 24px 0 18px; margin-bottom: 28px; }
    .page-header h2 { font-family: 'Bebas Neue', sans-serif; font-size: 32px; letter-spacing: 3px; color: var(--gold); margin: 0; }
    .card-dark { background: var(--card-bg); border: 1px solid var(--border); border-radius: 12px; }
    .table-dark-custom thead th { background: #222; color: var(--gold); font-family: 'Bebas Neue', sans-serif; letter-spacing: 1.5px; font-size: 15px; border-color: var(--border); }
    .table-dark-custom tbody tr { border-color: #2a2a2a; color: #ccc; }
    .table-dark-custom tbody tr:hover { background: #222; }
    .table-dark-custom td { border-color: #2a2a2a; vertical-align: middle; }
    .badge-paid { background: #1a3a2a; color: #4caf50; border: 1px solid #4caf50; font-size: 11px; padding: 4px 10px; border-radius: 20px; }
    .badge-unpaid { background: #3a1a1a; color: #f44336; border: 1px solid #f44336; font-size: 11px; padding: 4px 10px; border-radius: 20px; }
    .section-title { font-family: 'Bebas Neue', sans-serif; font-size: 20px; letter-spacing: 2px; color: var(--gold); }
    footer { background: #111; color: #555; text-align: center; padding: 16px; font-size: 13px; border-top: 1px solid #222; margin-top: 60px; }
    .filter-bar input, .filter-bar select {
        background: #2a2a2a; border: 1px solid #444; color: #e0e0e0; border-radius: 8px; padding: 8px 12px; font-size: 13px;
    }
    .filter-bar input:focus, .filter-bar select:focus { border-color: var(--gold); outline: none; }
</style>
</head>
<body>
<%@ include file="../navbar.jsp" %>

<div class="page-header">
    <div class="container-fluid px-4">
        <h2>⚠️ All Violations</h2>
        <p class="text-muted mb-0" style="font-size:13px;">View and manage all traffic violations in the system</p>
    </div>
</div>

<div class="container-fluid px-4">
    <% if (msg != null) { %><div class="alert mb-3" style="background:#1a3a1a;border:1px solid #4caf50;color:#4caf50;border-radius:8px;">✅ <%= msg %></div><% } %>
    <% if (error != null) { %><div class="alert mb-3" style="background:#3a1a1a;border:1px solid #f44336;color:#f44336;border-radius:8px;">❌ <%= error %></div><% } %>

    <!-- Summary badges -->
    <div class="d-flex gap-3 mb-4 flex-wrap">
        <span class="badge-paid px-3 py-2" style="font-size:13px;">
            ✅ Paid: <%= violations.stream().filter(v -> "PAID".equalsIgnoreCase(v.getPaymentStatus())).count() %>
        </span>
        <span class="badge-unpaid px-3 py-2" style="font-size:13px;">
            ❌ Unpaid: <%= violations.stream().filter(v -> "UNPAID".equalsIgnoreCase(v.getPaymentStatus())).count() %>
        </span>
        <span class="badge px-3 py-2" style="background:#2a2a2a;color:var(--gold);font-size:13px;">
            📋 Total: <%= violations.size() %>
        </span>
    </div>

    <!-- Filter bar -->
    <div class="filter-bar d-flex gap-2 mb-3 flex-wrap">
        <input type="text" id="searchInput" onkeyup="filterTable()" placeholder="🔍 Search by Vehicle ID, Rule, Officer...">
        <select id="statusFilter" onchange="filterTable()">
            <option value="">All Status</option>
            <option value="PAID">PAID</option>
            <option value="UNPAID">UNPAID</option>
        </select>
    </div>

    <div class="card-dark p-0 overflow-hidden">
        <div class="table-responsive">
            <table class="table table-dark-custom mb-0" id="violationsTable">
                <thead>
                    <tr>
                        <th>#</th><th>Violation ID</th><th>Vehicle ID</th><th>Rule ID</th><th>Officer ID</th><th>Date</th><th>Status</th><th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (violations.isEmpty()) { %>
                    <tr><td colspan="8" class="text-center text-muted py-4">No violations recorded yet.</td></tr>
                    <% } else { int i = 1; for (Violation v : violations) { %>
                    <tr>
                        <td><%= i++ %></td>
                        <td><strong style="color:var(--gold);">#<%= v.getViolationId() %></strong></td>
                        <td>🚗 <%= v.getVehicleId() %></td>
                        <td>📋 <%= v.getRuleId() %></td>
                        <td>👮 <%= v.getOfficerId() %></td>
                        <td style="font-size:12px;"><%= v.getViolationDate() != null ? v.getViolationDate().toString().substring(0,16) : "N/A" %></td>
                        <td>
                            <% if ("PAID".equalsIgnoreCase(v.getPaymentStatus())) { %>
                                <span class="badge-paid">✅ PAID</span>
                            <% } else { %>
                                <span class="badge-unpaid">❌ UNPAID</span>
                            <% } %>
                        </td>
                        <td>
                            <form action="${pageContext.request.contextPath}/ViolationController" method="post" style="display:inline"
                                  onsubmit="return confirm('Delete violation #<%= v.getViolationId() %>?')">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="violationId" value="<%= v.getViolationId() %>">
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

<footer>© 2026 RoadSafetyHub | Developed by Varshitha</footer>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
function filterTable() {
    const search = document.getElementById('searchInput').value.toLowerCase();
    const status = document.getElementById('statusFilter').value.toLowerCase();
    const rows = document.querySelectorAll('#violationsTable tbody tr');
    rows.forEach(row => {
        const text = row.textContent.toLowerCase();
        const matchSearch = text.includes(search);
        const matchStatus = !status || text.includes(status);
        row.style.display = matchSearch && matchStatus ? '' : 'none';
    });
}
</script>
</body>
</html>
