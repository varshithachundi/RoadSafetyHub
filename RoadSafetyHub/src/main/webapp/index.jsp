<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>RoadSafetyHub – Traffic Management System</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet">
<style>
    :root { --gold: #ffc107; --dark: #0a0a0a; --card: #141414; --border: rgba(255,193,7,0.2); }
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { background: var(--dark); color: #e0e0e0; font-family: 'DM Sans', sans-serif; min-height: 100vh; overflow-x: hidden; }

    /* NAV */
    .top-nav { background: rgba(10,10,10,0.95); border-bottom: 1px solid var(--border); padding: 16px 40px; display: flex; align-items: center; justify-content: space-between; position: fixed; top: 0; left: 0; right: 0; z-index: 100; backdrop-filter: blur(12px); }
    .nav-brand { font-family: 'Bebas Neue', sans-serif; font-size: 26px; letter-spacing: 4px; color: var(--gold); text-decoration: none; }
    .nav-right { display: flex; gap: 12px; }
    .btn-outline-gold { background: transparent; border: 1px solid var(--gold); color: var(--gold); padding: 8px 22px; border-radius: 8px; font-size: 14px; cursor: pointer; font-family: 'DM Sans', sans-serif; transition: all 0.2s; }
    .btn-outline-gold:hover { background: var(--gold); color: #000; }
    .btn-solid-gold { background: var(--gold); border: 1px solid var(--gold); color: #000; padding: 8px 22px; border-radius: 8px; font-size: 14px; font-weight: 700; cursor: pointer; font-family: 'DM Sans', sans-serif; transition: all 0.2s; }
    .btn-solid-gold:hover { background: #e0a800; }

    /* HERO */
    .hero { min-height: 100vh; display: flex; align-items: center; justify-content: center; text-align: center; padding: 100px 20px 60px; position: relative; overflow: hidden; }
    .hero::before { content: ''; position: absolute; top: 0; left: 0; right: 0; bottom: 0; background: radial-gradient(ellipse at center top, rgba(255,193,7,0.08) 0%, transparent 60%); pointer-events: none; }
    .hero-content { position: relative; z-index: 1; max-width: 800px; }
    .hero-badge { display: inline-block; background: rgba(255,193,7,0.12); border: 1px solid rgba(255,193,7,0.4); color: var(--gold); font-size: 12px; letter-spacing: 2px; padding: 6px 18px; border-radius: 20px; margin-bottom: 28px; text-transform: uppercase; }
    .hero-title { font-family: 'Bebas Neue', sans-serif; font-size: clamp(56px, 10vw, 100px); letter-spacing: 6px; line-height: 1; margin-bottom: 20px; color: #fff; }
    .hero-title span { color: var(--gold); }
    .hero-subtitle { font-size: 17px; color: #888; line-height: 1.7; max-width: 560px; margin: 0 auto 40px; }
    .hero-btns { display: flex; gap: 16px; justify-content: center; flex-wrap: wrap; }
    .btn-hero-primary { background: var(--gold); color: #000; font-weight: 700; border: none; padding: 14px 40px; border-radius: 10px; font-size: 16px; cursor: pointer; font-family: 'DM Sans', sans-serif; transition: all 0.2s; }
    .btn-hero-primary:hover { background: #e0a800; transform: translateY(-2px); }
    .btn-hero-secondary { background: transparent; color: #ccc; border: 1px solid #444; padding: 14px 40px; border-radius: 10px; font-size: 16px; cursor: pointer; font-family: 'DM Sans', sans-serif; transition: all 0.2s; }
    .btn-hero-secondary:hover { border-color: var(--gold); color: var(--gold); }

    /* ALERT */
    .alert-banner { position: fixed; top: 70px; left: 50%; transform: translateX(-50%); z-index: 200; padding: 12px 24px; border-radius: 8px; font-size: 14px; white-space: nowrap; }
    .alert-success { background: #0d2218; border: 1px solid #4caf50; color: #4caf50; }
    .alert-error { background: #2a0d0d; border: 1px solid #f44336; color: #f44336; }

    /* FEATURES */
    .features { padding: 80px 40px; background: #0d0d0d; border-top: 1px solid var(--border); }
    .features h2 { font-family: 'Bebas Neue', sans-serif; font-size: 42px; letter-spacing: 4px; color: var(--gold); text-align: center; margin-bottom: 50px; }
    .features-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 24px; max-width: 1100px; margin: 0 auto; }
    .feature-card { background: var(--card); border: 1px solid var(--border); border-radius: 14px; padding: 30px 24px; text-align: center; transition: transform 0.2s, border-color 0.2s; }
    .feature-card:hover { transform: translateY(-4px); border-color: var(--gold); }
    .feature-card .icon { font-size: 40px; margin-bottom: 14px; }
    .feature-card h4 { font-weight: 600; font-size: 17px; margin-bottom: 8px; color: #fff; }
    .feature-card p { color: #666; font-size: 13px; line-height: 1.6; }

    /* ROLES */
    .roles { padding: 80px 40px; }
    .roles h2 { font-family: 'Bebas Neue', sans-serif; font-size: 42px; letter-spacing: 4px; color: var(--gold); text-align: center; margin-bottom: 50px; }
    .roles-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 24px; max-width: 960px; margin: 0 auto; }
    .role-card { border-radius: 14px; padding: 32px 26px; text-align: center; border: 1px solid; }
    .role-card.admin { background: #1a1400; border-color: rgba(255,193,7,0.4); }
    .role-card.police { background: #0a1020; border-color: rgba(33,150,243,0.4); }
    .role-card.owner { background: #0a150a; border-color: rgba(76,175,80,0.4); }
    .role-card .r-icon { font-size: 48px; margin-bottom: 14px; }
    .role-card h4 { font-family: 'Bebas Neue', sans-serif; font-size: 22px; letter-spacing: 2px; margin-bottom: 10px; }
    .role-card.admin h4 { color: var(--gold); }
    .role-card.police h4 { color: #2196f3; }
    .role-card.owner h4 { color: #4caf50; }
    .role-card p { color: #666; font-size: 13px; line-height: 1.7; }

    /* MODAL */
    .modal-overlay { display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0,0,0,0.8); z-index: 500; align-items: center; justify-content: center; padding: 20px; }
    .modal-overlay.show { display: flex; }
    .modal-box { background: var(--card); border: 1px solid var(--border); border-radius: 18px; padding: 40px; width: 100%; max-width: 420px; position: relative; }
    .modal-box h3 { font-family: 'Bebas Neue', sans-serif; font-size: 28px; letter-spacing: 3px; color: var(--gold); margin-bottom: 28px; text-align: center; }
    .modal-close { position: absolute; top: 16px; right: 20px; background: none; border: none; color: #666; font-size: 22px; cursor: pointer; line-height: 1; }
    .modal-close:hover { color: #fff; }
    .form-group { margin-bottom: 18px; }
    .form-group label { display: block; color: #888; font-size: 12px; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 7px; }
    .form-group input, .form-group select { width: 100%; background: #1e1e1e; border: 1px solid #333; color: #e0e0e0; border-radius: 8px; padding: 12px 14px; font-size: 14px; font-family: 'DM Sans', sans-serif; transition: border-color 0.2s; }
    .form-group input:focus, .form-group select:focus { border-color: var(--gold); outline: none; background: #222; }
    .form-group select option { background: #1e1e1e; }
    .btn-form { width: 100%; background: var(--gold); color: #000; font-weight: 700; border: none; border-radius: 8px; padding: 13px; font-size: 15px; cursor: pointer; font-family: 'DM Sans', sans-serif; transition: background 0.2s; margin-top: 6px; }
    .btn-form:hover { background: #e0a800; }
    .modal-switch { text-align: center; margin-top: 18px; font-size: 13px; color: #666; }
    .modal-switch a { color: var(--gold); text-decoration: none; cursor: pointer; }
    .modal-switch a:hover { text-decoration: underline; }
    .divider { display: flex; align-items: center; gap: 10px; margin: 20px 0; }
    .divider span { color: #444; font-size: 12px; }
    .divider::before, .divider::after { content: ''; flex: 1; height: 1px; background: #2a2a2a; }

    footer { background: #080808; color: #444; text-align: center; padding: 24px; font-size: 12px; border-top: 1px solid #1a1a1a; }
    footer strong { color: var(--gold); }
</style>
</head>
<body>

<!-- NAV -->
<nav class="top-nav">
    <a href="index.jsp" class="nav-brand">🚦 RoadSafetyHub</a>
    <div class="nav-right">
        <button class="btn-outline-gold" onclick="openModal('loginModal')">Login</button>
        <button class="btn-solid-gold" onclick="openModal('registerModal')">Register</button>
    </div>
</nav>

<!-- ALERTS -->
<%
    String msg = request.getParameter("msg");
    String error = request.getParameter("error");
%>
<% if (msg != null) { %>
<div class="alert-banner alert-success">✅ <%= msg %></div>
<% } %>
<% if (error != null) { %>
<div class="alert-banner alert-error">❌ <%= error %></div>
<% } %>

<!-- HERO -->
<section class="hero">
    <div class="hero-content">
        <div class="hero-badge">🚦 Smart Traffic Management System</div>
        <h1 class="hero-title">ROAD<span>SAFETY</span><br>HUB</h1>
        <p class="hero-subtitle">A unified platform for managing traffic violations, vehicle registrations, and fine payments — built for admins, police, and vehicle owners.</p>
        <div class="hero-btns">
            <button class="btn-hero-primary" onclick="openModal('loginModal')">🔑 Login to Portal</button>
            <button class="btn-hero-secondary" onclick="openModal('registerModal')">📝 Create Account</button>
        </div>
    </div>
</section>

<!-- FEATURES -->
<section class="features">
    <h2>⚡ Key Features</h2>
    <div class="features-grid">
        <div class="feature-card">
            <div class="icon">🚗</div>
            <h4>Vehicle Management</h4>
            <p>Register, update and track vehicles. Complete ownership records with history.</p>
        </div>
        <div class="feature-card">
            <div class="icon">⚠️</div>
            <h4>Violation Tracking</h4>
            <p>Police can record violations on the spot. Real-time status tracking for all parties.</p>
        </div>
        <div class="feature-card">
            <div class="icon">💳</div>
            <h4>Online Fine Payment</h4>
            <p>Pay traffic fines online via UPI, card, or net banking. Instant receipt generation.</p>
        </div>
        <div class="feature-card">
            <div class="icon">📊</div>
            <h4>Admin Dashboard</h4>
            <p>Full system control. Manage users, view analytics, oversee all violations and payments.</p>
        </div>
    </div>
</section>

<!-- ROLES -->
<section class="roles">
    <h2>👥 User Roles</h2>
    <div class="roles-grid">
        <div class="role-card admin">
            <div class="r-icon">⚙️</div>
            <h4>Admin</h4>
            <p>Full system access. Manage owners, police officers, view all violations and system analytics.</p>
        </div>
        <div class="role-card police">
            <div class="r-icon">👮</div>
            <h4>Police Officer</h4>
            <p>Record new violations, view all traffic violations, track fine payment statuses.</p>
        </div>
        <div class="role-card owner">
            <div class="r-icon">🚗</div>
            <h4>Vehicle Owner</h4>
            <p>View registered vehicles, check violations on your vehicles, pay fines online.</p>
        </div>
    </div>
</section>

<footer>© 2026 <strong>RoadSafetyHub</strong> | Developed by Varshitha | Traffic Management System</footer>

<!-- LOGIN MODAL -->
<div class="modal-overlay" id="loginModal">
    <div class="modal-box">
        <button class="modal-close" onclick="closeModal('loginModal')">✕</button>
        <h3>🔑 LOGIN</h3>

        <!-- TABS -->
        <div style="display:flex;gap:0;margin-bottom:24px;border:1px solid #333;border-radius:8px;overflow:hidden;">
            <button id="tab-cred" onclick="switchTab('cred')"
                style="flex:1;padding:10px;background:#1e1e1e;color:var(--gold);border:none;font-family:'DM Sans',sans-serif;font-size:13px;cursor:pointer;border-right:1px solid #333;">
                🔐 Username Login
            </button>
            <button id="tab-vehicle" onclick="switchTab('vehicle')"
                style="flex:1;padding:10px;background:#141414;color:#888;border:none;font-family:'DM Sans',sans-serif;font-size:13px;cursor:pointer;">
                🚗 Vehicle Number
            </button>
        </div>

        <!-- USERNAME LOGIN -->
        <div id="panel-cred">
            <form action="UserController" method="post">
                <input type="hidden" name="action" value="login">
                <div class="form-group">
                    <label>Username</label>
                    <input type="text" name="username" required placeholder="Enter your username">
                </div>
                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password" required placeholder="Enter your password">
                </div>
                <button type="submit" class="btn-form">Login →</button>
            </form>
        </div>

        <!-- VEHICLE NUMBER LOGIN -->
        <div id="panel-vehicle" style="display:none;">
            <div style="background:#1a1200;border:1px solid rgba(255,193,7,0.3);border-radius:8px;padding:12px 14px;margin-bottom:18px;font-size:13px;color:#aaa;line-height:1.6;">
                🚗 Enter your <strong style="color:var(--gold);">vehicle registration number</strong> to instantly view all violations — no account needed.
            </div>
            <form action="UserController" method="post">
                <input type="hidden" name="action" value="vehicleLogin">
                <div class="form-group">
                    <label>Vehicle Number</label>
                    <input type="text" name="vehicleNumber" required placeholder="e.g. TS09AB1234"
                        style="text-transform:uppercase;letter-spacing:2px;font-size:16px;font-weight:600;">
                </div>
                <button type="submit" class="btn-form" style="background:#e65100;">🔍 Check Violations →</button>
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
        <h3>📝 REGISTER</h3>
        <form action="UserController" method="post">
            <input type="hidden" name="action" value="register">
            <div class="form-group">
                <label>Username</label>
                <input type="text" name="username" required placeholder="Choose a username">
            </div>
            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" required placeholder="Choose a password">
            </div>
            <div class="form-group">
                <label>Role</label>
                <select name="role" required>
                    <option value="">-- Select Role --</option>
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
    document.getElementById('tab-cred').style.background = isCred ? '#1e1e1e' : '#141414';
    document.getElementById('tab-cred').style.color = isCred ? 'var(--gold)' : '#888';
    document.getElementById('tab-vehicle').style.background = isCred ? '#141414' : '#1e1e1e';
    document.getElementById('tab-vehicle').style.color = isCred ? '#888' : 'var(--gold)';
}
// Close on outside click
document.querySelectorAll('.modal-overlay').forEach(m => {
    m.addEventListener('click', function(e) { if (e.target === this) this.classList.remove('show'); });
});
// Auto-open modal if error/msg
<% if (error != null) { %>openModal('loginModal');<% } %>
<% if (msg != null && msg.contains("Registration")) { %>openModal('loginModal');<% } %>
// Hide alert after 4s
setTimeout(() => { const a = document.querySelector('.alert-banner'); if(a) a.style.display='none'; }, 4000);
</script>
</body>
</html>
