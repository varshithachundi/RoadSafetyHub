<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>RoadSafetyHub – Traffic Management System</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=DM+Sans:wght@400;500;600;700&family=Outfit:wght@400;600;700;900&display=swap" rel="stylesheet">
<style>
    :root {
        --primary: #ff6b00;
        --primary-light: #ff8c38;
        --accent: #ffc107;
        --green: #00b894;
        --blue: #0984e3;
        --red: #d63031;
        --bg: #f0f4ff;
        --surface: #ffffff;
        --surface2: #f7f9ff;
        --text: #1a1a2e;
        --text2: #4a4a6a;
        --text3: #8888aa;
        --border: rgba(0,0,0,0.08);
        --shadow: 0 8px 32px rgba(0,0,0,0.10);
        --shadow-lg: 0 20px 60px rgba(0,0,0,0.15);
    }
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { background: var(--bg); color: var(--text); font-family: 'DM Sans', sans-serif; min-height: 100vh; overflow-x: hidden; }

    /* NAV */
    .top-nav {
        background: rgba(255,255,255,0.92); border-bottom: 1px solid var(--border);
        padding: 14px 40px; display: flex; align-items: center; justify-content: space-between;
        position: fixed; top: 0; left: 0; right: 0; z-index: 100;
        backdrop-filter: blur(16px); box-shadow: 0 2px 20px rgba(0,0,0,0.06);
    }
    .nav-brand { display: flex; align-items: center; gap: 10px; text-decoration: none; }
    .nav-logo-box {
        width: 38px; height: 38px; border-radius: 10px;
        background: linear-gradient(135deg, #ff6b00, #ffc107);
        display: flex; align-items: center; justify-content: center;
        font-size: 20px; box-shadow: 0 4px 12px rgba(255,107,0,0.35);
    }
    .nav-brand-text { font-family: 'Bebas Neue', sans-serif; font-size: 22px; letter-spacing: 3px; color: var(--text); }
    .nav-brand-text span { color: var(--primary); }
    .nav-right { display: flex; gap: 10px; }
    .btn-nav-outline { background: transparent; border: 1.5px solid var(--primary); color: var(--primary); padding: 8px 22px; border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer; font-family: 'DM Sans', sans-serif; transition: all 0.2s; }
    .btn-nav-outline:hover { background: var(--primary); color: #fff; }
    .btn-nav-solid { background: linear-gradient(135deg, var(--primary), var(--primary-light)); border: none; color: #fff; padding: 8px 22px; border-radius: 8px; font-size: 14px; font-weight: 700; cursor: pointer; font-family: 'DM Sans', sans-serif; transition: all 0.2s; box-shadow: 0 4px 14px rgba(255,107,0,0.35); }
    .btn-nav-solid:hover { transform: translateY(-1px); box-shadow: 0 6px 20px rgba(255,107,0,0.45); }

    /* HERO */
    .hero {
        min-height: 100vh; display: flex; align-items: center; justify-content: center;
        text-align: center; padding: 100px 20px 60px; position: relative; overflow: hidden;
        background: linear-gradient(160deg, #fff8f0 0%, #f0f4ff 50%, #f0fff8 100%);
    }
    .blob1 { position: absolute; width: 700px; height: 700px; border-radius: 50%; background: radial-gradient(circle, rgba(255,107,0,0.10) 0%, transparent 70%); top: -150px; right: -150px; pointer-events: none; }
    .blob2 { position: absolute; width: 600px; height: 600px; border-radius: 50%; background: radial-gradient(circle, rgba(0,184,148,0.08) 0%, transparent 70%); bottom: -100px; left: -100px; pointer-events: none; }
    .blob3 { position: absolute; width: 400px; height: 400px; border-radius: 50%; background: radial-gradient(circle, rgba(9,132,227,0.07) 0%, transparent 70%); top: 30%; left: 10%; pointer-events: none; }
    .hero-content { position: relative; z-index: 1; max-width: 820px; }
    .hero-badge { display: inline-flex; align-items: center; gap: 8px; background: linear-gradient(135deg, #fff3e0, #fff8f0); border: 1.5px solid rgba(255,107,0,0.3); color: var(--primary); font-size: 12px; font-weight: 700; letter-spacing: 2px; padding: 7px 18px; border-radius: 30px; margin-bottom: 28px; text-transform: uppercase; box-shadow: 0 4px 14px rgba(255,107,0,0.12); }
    .hero-tagline { font-size: 12px; font-weight: 700; letter-spacing: 4px; color: var(--text3); text-transform: uppercase; margin-bottom: 14px; }
    .hero-title { font-family: 'Outfit', sans-serif; font-weight: 900; font-size: clamp(52px, 10vw, 96px); line-height: 1; margin-bottom: 22px; color: var(--text); letter-spacing: -2px; }
    .hero-title .hl1 { background: linear-gradient(135deg, #ff6b00, #ffc107); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }
    .hero-title .hl2 { background: linear-gradient(135deg, #0984e3, #00b894); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }
    .hero-subtitle { font-size: 17px; color: var(--text2); line-height: 1.7; max-width: 560px; margin: 0 auto 44px; }
    .hero-btns { display: flex; gap: 16px; justify-content: center; flex-wrap: wrap; margin-bottom: 60px; }
    .btn-hero-primary { background: linear-gradient(135deg, var(--primary), var(--primary-light)); color: #fff; font-weight: 700; border: none; padding: 15px 40px; border-radius: 12px; font-size: 16px; cursor: pointer; font-family: 'DM Sans', sans-serif; box-shadow: 0 8px 24px rgba(255,107,0,0.35); transition: all 0.2s; }
    .btn-hero-primary:hover { transform: translateY(-3px); box-shadow: 0 12px 32px rgba(255,107,0,0.45); }
    .btn-hero-secondary { background: #fff; color: var(--text); border: 1.5px solid var(--border); padding: 15px 40px; border-radius: 12px; font-size: 16px; font-weight: 600; cursor: pointer; font-family: 'DM Sans', sans-serif; box-shadow: 0 4px 16px rgba(0,0,0,0.06); transition: all 0.2s; }
    .btn-hero-secondary:hover { border-color: var(--primary); color: var(--primary); transform: translateY(-3px); }
    .stats-card { background: #fff; border: 1px solid var(--border); border-radius: 18px; box-shadow: var(--shadow); display: inline-flex; flex-wrap: wrap; overflow: hidden; }
    .stat-item { padding: 18px 36px; text-align: center; border-right: 1px solid var(--border); }
    .stat-item:last-child { border-right: none; }
    .stat-num { font-family: 'Outfit', sans-serif; font-size: 32px; font-weight: 900; color: var(--primary); line-height: 1; }
    .stat-label { font-size: 11px; color: var(--text3); margin-top: 4px; text-transform: uppercase; letter-spacing: 1px; }

    /* ALERT */
    .alert-banner { position: fixed; top: 74px; left: 50%; transform: translateX(-50%); z-index: 200; padding: 12px 24px; border-radius: 10px; font-size: 14px; white-space: nowrap; box-shadow: var(--shadow); }
    .alert-success { background: #e8f8f3; border: 1.5px solid #00b894; color: #00836b; }
    .alert-error { background: #ffeaea; border: 1.5px solid #d63031; color: #c0392b; }

    /* FEATURES */
    .features { padding: 90px 40px; background: linear-gradient(180deg, #f0f4ff 0%, #fff 100%); }
    .section-label { text-align: center; font-size: 11px; font-weight: 700; letter-spacing: 3px; color: var(--primary); text-transform: uppercase; margin-bottom: 10px; }
    .section-title { font-family: 'Outfit', sans-serif; font-weight: 900; font-size: 40px; color: var(--text); text-align: center; margin-bottom: 10px; letter-spacing: -1px; }
    .section-sub { text-align: center; color: var(--text3); font-size: 15px; margin-bottom: 52px; }
    .features-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 24px; max-width: 1100px; margin: 0 auto; }
    .feature-card { background: #fff; border: 1.5px solid var(--border); border-radius: 18px; padding: 32px 24px; text-align: center; transition: transform 0.25s, box-shadow 0.25s, border-color 0.25s; box-shadow: 0 4px 16px rgba(0,0,0,0.05); }
    .feature-card:hover { transform: translateY(-6px); box-shadow: var(--shadow-lg); border-color: var(--primary); }
    .f-icon-wrap { width: 66px; height: 66px; border-radius: 18px; margin: 0 auto 18px; display: flex; align-items: center; justify-content: center; font-size: 32px; }
    .fc1 .f-icon-wrap { background: linear-gradient(135deg, #fff3e0, #ffe0b2); }
    .fc2 .f-icon-wrap { background: linear-gradient(135deg, #fce4ec, #ffcdd2); }
    .fc3 .f-icon-wrap { background: linear-gradient(135deg, #e8f5e9, #c8e6c9); }
    .fc4 .f-icon-wrap { background: linear-gradient(135deg, #e3f2fd, #bbdefb); }
    .feature-card h4 { font-family: 'Outfit', sans-serif; font-weight: 700; font-size: 17px; margin-bottom: 8px; color: var(--text); }
    .feature-card p { color: var(--text3); font-size: 13px; line-height: 1.7; }

    /* HOW IT WORKS */
    .how { padding: 90px 40px; background: #fff; }
    .steps { display: flex; gap: 0; max-width: 900px; margin: 0 auto; flex-wrap: wrap; justify-content: center; }
    .step { flex: 1; min-width: 180px; text-align: center; padding: 20px; position: relative; }
    .step:not(:last-child)::after { content: '→'; position: absolute; right: -10px; top: 26px; font-size: 22px; color: var(--primary); opacity: 0.35; }
    .step-num { width: 54px; height: 54px; border-radius: 16px; background: linear-gradient(135deg, var(--primary), var(--primary-light)); color: #fff; font-family: 'Outfit', sans-serif; font-weight: 900; font-size: 22px; display: flex; align-items: center; justify-content: center; margin: 0 auto 14px; box-shadow: 0 6px 18px rgba(255,107,0,0.3); }
    .step h5 { font-weight: 700; font-size: 15px; color: var(--text); margin-bottom: 6px; }
    .step p { font-size: 12px; color: var(--text3); line-height: 1.6; }

    /* ROLES */
    .roles { padding: 90px 40px; background: var(--surface2); }
    .roles-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 24px; max-width: 980px; margin: 0 auto; }
    .role-card { border-radius: 20px; padding: 36px 28px; text-align: center; border: 1.5px solid; box-shadow: 0 4px 20px rgba(0,0,0,0.06); transition: transform 0.25s, box-shadow 0.25s; }
    .role-card:hover { transform: translateY(-6px); box-shadow: var(--shadow-lg); }
    .role-card.admin { background: linear-gradient(135deg, #fffbea, #fff8e1); border-color: rgba(255,193,7,0.4); }
    .role-card.police { background: linear-gradient(135deg, #eff6ff, #dbeafe); border-color: rgba(9,132,227,0.3); }
    .role-card.owner { background: linear-gradient(135deg, #f0fdf4, #dcfce7); border-color: rgba(0,184,148,0.35); }
    .r-badge { display: inline-flex; align-items: center; justify-content: center; width: 70px; height: 70px; border-radius: 20px; font-size: 36px; margin-bottom: 18px; }
    .role-card.admin .r-badge { background: linear-gradient(135deg, #ffc107, #ff8f00); }
    .role-card.police .r-badge { background: linear-gradient(135deg, #0984e3, #0052d4); }
    .role-card.owner .r-badge { background: linear-gradient(135deg, #00b894, #00796b); }
    .role-card h4 { font-family: 'Outfit', sans-serif; font-size: 22px; font-weight: 800; margin-bottom: 10px; }
    .role-card.admin h4 { color: #e65100; }
    .role-card.police h4 { color: #0052d4; }
    .role-card.owner h4 { color: #00796b; }
    .role-card p { color: var(--text2); font-size: 14px; line-height: 1.7; }
    .role-access { margin-top: 18px; display: flex; flex-wrap: wrap; gap: 6px; justify-content: center; }
    .access-tag { font-size: 11px; font-weight: 600; padding: 4px 10px; border-radius: 20px; }
    .admin .access-tag { background: rgba(255,193,7,0.2); color: #b45309; }
    .police .access-tag { background: rgba(9,132,227,0.15); color: #1d4ed8; }
    .owner .access-tag { background: rgba(0,184,148,0.15); color: #065f46; }

    /* MODAL */
    .modal-overlay { display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(20,20,40,0.55); z-index: 500; align-items: center; justify-content: center; padding: 20px; backdrop-filter: blur(6px); }
    .modal-overlay.show { display: flex; }
    .modal-box { background: #fff; border: 1px solid var(--border); border-radius: 22px; padding: 40px; width: 100%; max-width: 420px; position: relative; box-shadow: 0 32px 80px rgba(0,0,0,0.18); animation: modal-in 0.22s ease; }
    @keyframes modal-in { from { transform: translateY(18px) scale(0.97); opacity: 0; } to { transform: none; opacity: 1; } }
    .modal-box h3 { font-family: 'Outfit', sans-serif; font-weight: 900; font-size: 26px; color: var(--text); margin-bottom: 6px; }
    .modal-sub { color: var(--text3); font-size: 13px; margin-bottom: 26px; }
    .modal-close { position: absolute; top: 18px; right: 20px; background: #f5f5f5; border: none; color: #888; font-size: 15px; cursor: pointer; width: 30px; height: 30px; border-radius: 8px; display: flex; align-items: center; justify-content: center; transition: background 0.2s; }
    .modal-close:hover { background: #ffe0d0; color: var(--primary); }
    .form-group { margin-bottom: 16px; }
    .form-group label { display: block; color: var(--text2); font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 7px; }
    .form-group input, .form-group select { width: 100%; background: var(--surface2); border: 1.5px solid #e8e8f0; color: var(--text); border-radius: 10px; padding: 12px 14px; font-size: 14px; font-family: 'DM Sans', sans-serif; transition: border-color 0.2s; }
    .form-group input:focus, .form-group select:focus { border-color: var(--primary); outline: none; background: #fff; box-shadow: 0 0 0 3px rgba(255,107,0,0.10); }
    .btn-form { width: 100%; background: linear-gradient(135deg, var(--primary), var(--primary-light)); color: #fff; font-weight: 700; border: none; border-radius: 10px; padding: 13px; font-size: 15px; cursor: pointer; font-family: 'DM Sans', sans-serif; box-shadow: 0 6px 20px rgba(255,107,0,0.28); transition: all 0.2s; margin-top: 6px; }
    .btn-form:hover { transform: translateY(-2px); box-shadow: 0 10px 28px rgba(255,107,0,0.38); }
    .modal-switch { text-align: center; margin-top: 18px; font-size: 13px; color: var(--text3); }
    .modal-switch a { color: var(--primary); text-decoration: none; cursor: pointer; font-weight: 600; }
    .modal-switch a:hover { text-decoration: underline; }
    .divider { display: flex; align-items: center; gap: 10px; margin: 20px 0; }
    .divider span { color: #ccc; font-size: 12px; }
    .divider::before, .divider::after { content: ''; flex: 1; height: 1px; background: #f0f0f0; }
    .tab-row { display: flex; background: #f5f5fa; border-radius: 10px; padding: 4px; gap: 4px; margin-bottom: 22px; }
    .tab-btn { flex: 1; padding: 9px; border: none; border-radius: 7px; font-size: 13px; font-weight: 600; cursor: pointer; font-family: 'DM Sans', sans-serif; transition: all 0.2s; color: var(--text3); background: transparent; }
    .tab-btn.active { background: #fff; color: var(--primary); box-shadow: 0 2px 8px rgba(0,0,0,0.10); }
    .vehicle-hint { background: linear-gradient(135deg, #fff8f0, #fff3e0); border: 1.5px solid rgba(255,107,0,0.25); border-radius: 10px; padding: 12px 14px; margin-bottom: 18px; font-size: 13px; color: var(--text2); line-height: 1.6; }

    footer { background: var(--text); color: #666; text-align: center; padding: 28px; font-size: 13px; }
    footer strong { color: var(--primary); }
    .footer-logo { font-family: 'Bebas Neue', sans-serif; font-size: 22px; letter-spacing: 3px; color: #fff; margin-bottom: 8px; }
</style>
</head>
<body>

<!-- NAV -->
<nav class="top-nav">
    <a href="index.jsp" class="nav-brand">
        <div class="nav-logo-box">🚦</div>
        <span class="nav-brand-text">ROAD<span>SAFETY</span>HUB</span>
    </a>
    <div class="nav-right">
        <button class="btn-nav-outline" onclick="openModal('loginModal')">Login</button>
        <button class="btn-nav-solid" onclick="openModal('registerModal')">Register →</button>
    </div>
</nav>

<%
    String msg = request.getParameter("msg");
    String error = request.getParameter("error");
%>
<% if (msg != null) { %><div class="alert-banner alert-success">✅ <%= msg %></div><% } %>
<% if (error != null) { %><div class="alert-banner alert-error">❌ <%= error %></div><% } %>

<!-- HERO -->
<section class="hero">
    <div class="blob1"></div><div class="blob2"></div><div class="blob3"></div>
    <div class="hero-content">
        <div class="hero-badge">🚦 Smart Traffic Management System</div>
        <p class="hero-tagline">India's Modern Road Safety Platform</p>
        <h1 class="hero-title">
            <span class="hl1">Road</span><span class="hl2">Safety</span><br>Hub
        </h1>
        <p class="hero-subtitle">A unified platform for managing traffic violations, vehicle registrations, and fine payments — built for admins, police, and vehicle owners.</p>
        <div class="hero-btns">
            <button class="btn-hero-primary" onclick="openModal('loginModal')">🔑 Login to Portal</button>
            <button class="btn-hero-secondary" onclick="openModal('registerModal')">📝 Create Account</button>
        </div>
        <div class="stats-card">
            <div class="stat-item"><div class="stat-num">3</div><div class="stat-label">User Roles</div></div>
            <div class="stat-item"><div class="stat-num">7+</div><div class="stat-label">Violation Types</div></div>
            <div class="stat-item"><div class="stat-num">4</div><div class="stat-label">Payment Methods</div></div>
            <div class="stat-item"><div class="stat-num">100%</div><div class="stat-label">Online</div></div>
        </div>
    </div>
</section>

<!-- FEATURES -->
<section class="features">
    <div class="section-label">⚡ What We Offer</div>
    <h2 class="section-title">Key Features</h2>
    <p class="section-sub">Everything you need to manage road safety in one place</p>
    <div class="features-grid">
        <div class="feature-card fc1"><div class="f-icon-wrap">🚗</div><h4>Vehicle Management</h4><p>Register, update and track vehicles. Complete ownership records with full history.</p></div>
        <div class="feature-card fc2"><div class="f-icon-wrap">⚠️</div><h4>Violation Tracking</h4><p>Police can record violations instantly. Real-time status tracking for all parties.</p></div>
        <div class="feature-card fc3"><div class="f-icon-wrap">💳</div><h4>Online Fine Payment</h4><p>Pay traffic fines via UPI, card, or net banking. Instant fine clearance.</p></div>
        <div class="feature-card fc4"><div class="f-icon-wrap">📊</div><h4>Admin Dashboard</h4><p>Full system control. Manage users, oversee all violations and payments.</p></div>
    </div>
</section>

<!-- HOW IT WORKS -->
<section class="how">
    <div class="section-label">🔄 Process</div>
    <h2 class="section-title">How It Works</h2>
    <p class="section-sub">Simple 4-step process from violation to payment</p>
    <div class="steps">
        <div class="step"><div class="step-num">1</div><h5>Police Records</h5><p>Officer records violation with vehicle & rule details</p></div>
        <div class="step"><div class="step-num">2</div><h5>Owner Notified</h5><p>Vehicle owner can check fines by vehicle number</p></div>
        <div class="step"><div class="step-num">3</div><h5>Pay Online</h5><p>Choose UPI, Card or Net Banking to pay fine</p></div>
        <div class="step"><div class="step-num">4</div><h5>Fine Cleared</h5><p>Violation marked PAID instantly in the system</p></div>
    </div>
</section>

<!-- ROLES -->
<section class="roles">
    <div class="section-label">👥 Portals</div>
    <h2 class="section-title">User Roles</h2>
    <p class="section-sub">Three dedicated dashboards for every stakeholder</p>
    <div class="roles-grid">
        <div class="role-card admin">
            <div class="r-badge">⚙️</div><h4>Admin</h4>
            <p>Full system access. Manage owners, police officers, view all violations and analytics.</p>
            <div class="role-access"><span class="access-tag">Manage Users</span><span class="access-tag">All Violations</span><span class="access-tag">Reports</span></div>
        </div>
        <div class="role-card police">
            <div class="r-badge">👮</div><h4>Police Officer</h4>
            <p>Record new violations, view all traffic violations, track fine payment statuses.</p>
            <div class="role-access"><span class="access-tag">Add Violation</span><span class="access-tag">View Records</span><span class="access-tag">Track Fines</span></div>
        </div>
        <div class="role-card owner">
            <div class="r-badge">🚗</div><h4>Vehicle Owner</h4>
            <p>View registered vehicles, check violations, and pay fines online instantly.</p>
            <div class="role-access"><span class="access-tag">My Vehicles</span><span class="access-tag">Pay Fines</span><span class="access-tag">History</span></div>
        </div>
    </div>
</section>

<footer>
    <div class="footer-logo">🚦 ROADSAFETYHUB</div>
    © 2026 <strong>RoadSafetyHub</strong> | Developed by Varshitha | Traffic Management System
</footer>

<!-- LOGIN MODAL -->
<div class="modal-overlay" id="loginModal">
    <div class="modal-box">
        <button class="modal-close" onclick="closeModal('loginModal')">✕</button>
        <h3>Welcome back 👋</h3>
        <p class="modal-sub">Sign in to your RoadSafetyHub account</p>
        <div class="tab-row">
            <button class="tab-btn active" id="tab-cred" onclick="switchTab('cred')">🔐 Username Login</button>
            <button class="tab-btn" id="tab-vehicle" onclick="switchTab('vehicle')">🚗 Vehicle Number</button>
        </div>
        <div id="panel-cred">
            <form action="UserController" method="post">
                <input type="hidden" name="action" value="login">
                <div class="form-group"><label>Username</label><input type="text" name="username" required placeholder="Enter your username"></div>
                <div class="form-group"><label>Password</label><input type="password" name="password" required placeholder="Enter your password"></div>
                <button type="submit" class="btn-form">Login →</button>
            </form>
        </div>
        <div id="panel-vehicle" style="display:none;">
            <div class="vehicle-hint">🚗 Enter your <strong>vehicle registration number</strong> to instantly view all violations — no account needed.</div>
            <form action="UserController" method="post">
                <input type="hidden" name="action" value="vehicleLogin">
                <div class="form-group"><label>Vehicle Number</label><input type="text" name="vehicleNumber" required placeholder="e.g. TS09AB1234" style="text-transform:uppercase;letter-spacing:2px;font-size:16px;font-weight:700;"></div>
                <button type="submit" class="btn-form" style="background:linear-gradient(135deg,#e65100,#ff8f00);">🔍 Check Violations →</button>
            </form>
        </div>
        <div class="divider"><span>OR</span></div>
        <div class="modal-switch">Don't have an account? <a onclick="switchModal('loginModal','registerModal')">Register here</a></div>
    </div>
</div>

<!-- REGISTER MODAL -->
<div class="modal-overlay" id="registerModal">
    <div class="modal-box">
        <button class="modal-close" onclick="closeModal('registerModal')">✕</button>
        <h3>Create Account 🚀</h3>
        <p class="modal-sub">Join RoadSafetyHub — it's free</p>
        <form action="UserController" method="post">
            <input type="hidden" name="action" value="register">
            <div class="form-group"><label>Username</label><input type="text" name="username" required placeholder="Choose a username"></div>
            <div class="form-group"><label>Password</label><input type="password" name="password" required placeholder="Choose a strong password"></div>
            <div class="form-group">
                <label>Role</label>
                <select name="role" required>
                    <option value="">-- Select your role --</option>
                    <option value="admin">⚙️ Admin</option>
                    <option value="police">👮 Police Officer</option>
                    <option value="owner">🚗 Vehicle Owner</option>
                </select>
            </div>
            <button type="submit" class="btn-form">Create Account →</button>
        </form>
        <div class="divider"><span>OR</span></div>
        <div class="modal-switch">Already have an account? <a onclick="switchModal('registerModal','loginModal')">Login here</a></div>
    </div>
</div>

<script>
function openModal(id) { document.getElementById(id).classList.add('show'); }
function closeModal(id) { document.getElementById(id).classList.remove('show'); }
function switchModal(from, to) { closeModal(from); openModal(to); }
function switchTab(tab) {
    const isCred = tab === 'cred';
    document.getElementById('panel-cred').style.display = isCred ? 'block' : 'none';
    document.getElementById('panel-vehicle').style.display = isCred ? 'none' : 'block';
    document.getElementById('tab-cred').className = 'tab-btn' + (isCred ? ' active' : '');
    document.getElementById('tab-vehicle').className = 'tab-btn' + (!isCred ? ' active' : '');
}
document.querySelectorAll('.modal-overlay').forEach(m => {
    m.addEventListener('click', function(e) { if (e.target === this) this.classList.remove('show'); });
});
<% if (error != null) { %>openModal('loginModal');<% } %>
<% if (msg != null && msg.contains("Registration")) { %>openModal('loginModal');<% } %>
setTimeout(() => { const a = document.querySelector('.alert-banner'); if(a) a.style.display='none'; }, 4000);
</script>
</body>
</html>
