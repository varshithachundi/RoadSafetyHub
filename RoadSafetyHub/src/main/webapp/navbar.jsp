<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.traffic.model.User" %>
<%
    User navUser = (User) session.getAttribute("user");
    String role = (navUser != null) ? navUser.getRole().toLowerCase() : "";
    String username = (navUser != null) ? navUser.getUsername() : "";
%>
<nav class="navbar navbar-expand-lg navbar-dark fixed-top" style="background: rgba(18,18,18,0.97); border-bottom: 2px solid #ffc107; backdrop-filter: blur(10px);">
    <div class="container-fluid px-4">
        <a class="navbar-brand fw-bold" href="#" style="font-family:'Bebas Neue',sans-serif; font-size:26px; letter-spacing:2px; color:#ffc107;">
            🚦 RoadSafetyHub
        </a>
        <button class="navbar-toggler border-warning" type="button" data-bs-toggle="collapse" data-bs-target="#mainNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse justify-content-end" id="mainNav">
            <ul class="navbar-nav align-items-center gap-2">
                <% if (role.equals("admin")) { %>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard.jsp">Dashboard</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/owners.jsp">Owners</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/police.jsp">Police</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/violations.jsp">Violations</a></li>
                <% } else if (role.equals("police")) { %>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/police/dashboard.jsp">Dashboard</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/police/addViolation.jsp">Add Violation</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/police/violationList.jsp">Violations</a></li>
                <% } else if (role.equals("owner")) { %>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/owner/dashboard.jsp">Dashboard</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/owner/myVehicles.jsp">My Vehicles</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/owner/myViolations.jsp">My Violations</a></li>
                <% } %>
                <li class="nav-item ms-2">
                    <span class="badge bg-warning text-dark px-3 py-2" style="font-size:13px;">
                        👤 <%= username %> <span class="ms-1 opacity-75">[<%= role.toUpperCase() %>]</span>
                    </span>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-outline-warning btn-sm">Logout</a>
                </li>
            </ul>
        </div>
    </div>
</nav>
