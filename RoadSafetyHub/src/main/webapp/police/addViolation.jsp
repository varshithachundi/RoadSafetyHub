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
    VehicleService vehicleService = new VehicleServiceImpl();
    PoliceService policeService = new PoliceServiceImpl();
    List<Vehicle> vehicles = vehicleService.getAllVehicles();
    List<PoliceOfficer> officers = policeService.getAllPoliceOfficers();

    // Hardcoded traffic rules to match trafficrules table
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
    :root { --gold: #ffc107; --dark: #0f0f0f; --card-bg: #1a1a1a; --border: rgba(255,193,7,0.2); }
    body { background: var(--dark); color: #e0e0e0; font-family: 'DM Sans', sans-serif; padding-top: 70px; min-height: 100vh; }
    .page-header { background: #0d1b2a; border-bottom: 2px solid #2196f3; padding: 24px 0 18px; margin-bottom: 36px; }
    .page-header h2 { font-family: 'Bebas Neue', sans-serif; font-size: 32px; letter-spacing: 3px; color: #2196f3; margin: 0; }
    .form-card { background: var(--card-bg); border: 1px solid var(--border); border-radius: 16px; padding: 36px; max-width: 600px; margin: 0 auto; }
    .form-card h4 { font-family: 'Bebas Neue', sans-serif; font-size: 22px; letter-spacing: 2px; color: var(--gold); margin-bottom: 28px; }
    label { color: #aaa; font-size: 13px; font-weight: 500; margin-bottom: 5px; display: block; }
    .form-control-dark, .form-select-dark {
        background: #2a2a2a; border: 1px solid #444; color: #e0e0e0; border-radius: 8px;
        padding: 10px 14px; width: 100%; font-size: 14px; transition: border-color 0.2s;
    }
    .form-control-dark:focus, .form-select-dark:focus {
        background: #333; border-color: var(--gold); color: #fff; outline: none;
        box-shadow: 0 0 0 3px rgba(255,193,7,0.15);
    }
    .form-select-dark option { background: #2a2a2a; }
    .btn-gold { background: var(--gold); color: #000; font-weight: 700; border: none; border-radius: 8px; padding: 12px 32px; font-size: 15px; width: 100%; transition: background 0.2s; }
    .btn-gold:hover { background: #e0a800; }
    .btn-back { background: transparent; border: 1px solid #444; color: #aaa; border-radius: 8px; padding: 12px 24px; font-size: 14px; text-decoration: none; display: inline-block; transition: all 0.2s; }
    .btn-back:hover { border-color: var(--gold); color: var(--gold); }
    footer { background: #111; color: #555; text-align: center; padding: 16px; font-size: 13px; border-top: 1px solid #222; margin-top: 60px; }
    .divider { height: 1px; background: var(--border); margin: 24px 0; }
</style>
</head>
<body>
<%@ include file="../navbar.jsp" %>

<div class="page-header">
    <div class="container-fluid px-4">
        <h2>➕ Add Violation</h2>
        <p style="color:#aaa;margin:0;font-size:13px;">Record a new traffic violation</p>
    </div>
</div>

<div class="container px-4 pb-5">
    <% if (error != null) { %>
    <div class="alert mb-4" style="background:#3a1a1a;border:1px solid #f44336;color:#f44336;border-radius:8px;max-width:600px;margin:0 auto 20px;">
        ❌ <%= error %>
    </div>
    <% } %>
    <% if (msg != null) { %>
    <div class="alert mb-4" style="background:#1a3a1a;border:1px solid #4caf50;color:#4caf50;border-radius:8px;max-width:600px;margin:0 auto 20px;">
        ✅ <%= msg %>
    </div>
    <% } %>

    <div class="form-card">
        <h4>🚦 Violation Details</h4>

        <form action="${pageContext.request.contextPath}/ViolationController" method="post">
            <input type="hidden" name="action" value="add">

            <div class="mb-4">
                <label>🚗 Select Vehicle *</label>
                <select name="vehicleId" class="form-select-dark" required>
                    <option value="">-- Select Vehicle --</option>
                    <% for (Vehicle v : vehicles) { %>
                    <option value="<%= v.getVehicleId() %>">
                        <%= v.getVehicleNumber() %> (<%= v.getVehicleType() %>)
                    </option>
                    <% } %>
                </select>
            </div>

            <div class="mb-4">
                <label>📋 Rule Violated (Rule ID) *</label>
                <input type="number" name="ruleId" class="form-control-dark" required min="1" placeholder="Enter Rule ID from trafficrules table">
                <small style="color:#666;font-size:11px;">Tip: Check the trafficrules table for valid rule IDs</small>
            </div>

            <div class="mb-4">
                <label>👮 Issuing Officer *</label>
                <select name="officerId" class="form-select-dark" required>
                    <option value="">-- Select Officer --</option>
                    <% for (PoliceOfficer p : officers) { %>
                    <option value="<%= p.getOfficerId() %>">
                        <%= p.getName() %> (Badge: <%= p.getBadgeNumber() %>)
                    </option>
                    <% } %>
                </select>
            </div>

            <div class="divider"></div>

            <div class="d-flex gap-3">
                <a href="${pageContext.request.contextPath}/police/dashboard.jsp" class="btn-back">← Back</a>
                <button type="submit" class="btn-gold">🚦 Submit Violation</button>
            </div>
        </form>
    </div>
</div>

<footer>© 2026 RoadSafetyHub | Developed by Varshitha</footer>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
