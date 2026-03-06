<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.traffic.model.*" %>
<%@ page import="com.traffic.service.*" %>
<%@ page import="java.util.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.getRole().equalsIgnoreCase("police")) {
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
<title>Violation List – RoadSafetyHub</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet">
<style>
    :root { --gold: #ffc107; --dark: #0f0f0f; --card-bg: #1a1a1a; --border: rgba(255,193,7,0.2); --blue: #2196f3; }
    body { background: var(--dark); color: #e0e0e0; font-family: 'DM Sans', sans-serif; padding-top: 70px; min-height: 100vh; }
    .page-header { background: #0d1b2a; border-bottom: 2px solid var(--blue); padding: 24px 0 18px; margin-bottom: 28px; }
    .page-header h2 { font-family: 'Bebas Neue', sans-serif; font-size: 32px; letter-spacing: 3px; color: var(--blue); margin: 0; }
    .card-dark { background: var(--card-bg); border: 1px solid var(--border); border-radius: 12px; }
    .table-dark-custom thead th { background: #222; color: var(--gold); font-family: 'Bebas Neue', sans-serif; letter-spacing: 1.5px; font-size: 14px; border-color: var(--border); }
    .table-dark-custom tbody tr { border-color: #2a2a2a; color: #ccc; transition: background 0.15s; }
    .table-dark-custom tbody tr:hover { background: #222; }
    .table-dark-custom td { border-color: #2a2a2a; vertical-align: middle; }
    .badge-paid { background: #1a3a2a; color: #4caf50; border: 1px solid #4caf50; font-size: 11px; padding: 3px 8px; border-radius: 20px; }
    .badge-unpaid { background: #3a1a1a; color: #f44336; border: 1px solid #f44336; font-size: 11px; padding: 3px 8px; border-radius: 20px; }
    .btn-gold { background: var(--gold); color: #000; font-weight: 600; border: none; border-radius: 6px; }
    .btn-gold:hover { background: #e0a800; color: #000; }
    .section-title { font-family: 'Bebas Neue', sans-serif; font-size: 20px; letter-spacing: 2px; color: var(--gold); }
    .filter-input { background: #2a2a2a; border: 1px solid #444; color: #e0e0e0; border-radius: 8px; padding: 8px 12px; font-size: 13px; }
    .filter-input:focus { border-color: var(--blue); outline: none; }
    footer { background: #111; color: #555; text-align: center; padding: 16px; font-size: 13px; border-top: 1px solid #222; margin-top: 60px; }
</style>
</head>
<body>
<%@ include file="../navbar.jsp" %>

<div class="page-header">
    <div class="container-fluid px-4 d-flex justify-content-between align-items-center flex-wrap gap-2">
        <div>
            <h2>📋 Violation List</h2>
            <p style="color:#aaa;margin:0;font-size:13px;">All recorded traffic violations</p>
        </div>
        <a href="${pageContext.request.contextPath}/police/addViolation.jsp" class="btn btn-gold px-4">+ Add Violation</a>
    </div>
</div>

<div class="container-fluid px-4">
    <% if (msg != null) { %><div class="alert mb-3" style="background:#1a3a1a;border:1px solid #4caf50;color:#4caf50;border-radius:8px;">✅ <%= msg %></div><% } %>
    <% if (error != null) { %><div class="alert mb-3" style="background:#3a1a1a;border:1px solid #f44336;color:#f44336;border-radius:8px;">❌ <%= error %></div><% } %>

    <div class="d-flex gap-3 mb-4 flex-wrap align-items-center">
        <span class="badge-paid px-3 py-2" style="font-size:13px;">✅ Paid: <%= violations.stream().filter(v -> "PAID".equalsIgnoreCase(v.getPaymentStatus())).count() %></span>
        <span class="badge-unpaid px-3 py-2" style="font-size:13px;">❌ Unpaid: <%= violations.stream().filter(v -> "UNPAID".equalsIgnoreCase(v.getPaymentStatus())).count() %></span>
        <input type="text" class="filter-input" id="searchBox" onkeyup="filterTable()" placeholder="🔍 Search violations...">
    </div>

    <div class="card-dark p-0 overflow-hidden">
        <div class="table-responsive">
            <table class="table table-dark-custom mb-0" id="vTable">
                <thead>
                    <tr><th>#</th><th>Violation ID</th><th>Vehicle ID</th><th>Rule ID</th><th>Officer ID</th><th>Date & Time</th><th>Payment Status</th></tr>
                </thead>
                <tbody>
                    <% if (violations.isEmpty()) { %>
                    <tr><td colspan="7" class="text-center text-muted py-4">No violations recorded yet.</td></tr>
                    <% } else { int i = 1; for (Violation v : violations) { %>
                    <tr>
                        <td><%= i++ %></td>
                        <td><strong style="color:var(--gold);">#<%= v.getViolationId() %></strong></td>
                        <td>🚗 <%= v.getVehicleId() %></td>
                        <td>📋 Rule-<%= v.getRuleId() %></td>
                        <td>👮 <%= v.getOfficerId() %></td>
                        <td style="font-size:12px;white-space:nowrap;"><%= v.getViolationDate() != null ? v.getViolationDate().toString().substring(0,16) : "N/A" %></td>
                        <td>
                            <% if ("PAID".equalsIgnoreCase(v.getPaymentStatus())) { %>
                                <span class="badge-paid">✅ PAID</span>
                            <% } else { %>
                                <span class="badge-unpaid">❌ UNPAID</span>
                            <% } %>
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
    const q = document.getElementById('searchBox').value.toLowerCase();
    document.querySelectorAll('#vTable tbody tr').forEach(r => {
        r.style.display = r.textContent.toLowerCase().includes(q) ? '' : 'none';
    });
}
</script>
</body>
</html>
