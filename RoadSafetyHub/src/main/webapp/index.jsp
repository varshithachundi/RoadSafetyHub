<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Road Safety Hub</title>
<meta name="viewport" content="width=device-width, initial-scale=1">

<!-- Bootstrap CSS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">

<style>
body {
	margin: 0;
	padding: 0;
	font-family: Arial, Helvetica, sans-serif;
}

/* Background Section */
.bg-image {
	background: url('road.png') no-repeat center center/cover;
	height: 100vh;
	position: relative;
	color: white;
}

/* Dark Overlay */
.overlay {
	background: rgba(0, 0, 0, 0.3);
	height: 100%;
	width: 100%;
}

/* Hero Section */
.hero-content {
	height: 90vh;
	display: flex;
	flex-direction: column;
	justify-content: center;
	align-items: center;
	text-align: center;
	padding: 20px;
}

.hero-content h1 {
	font-size: 48px;
	font-weight: bold;
}

.hero-content p {
	max-width: 750px;
	margin-top: 20px;
	font-size: 18px;
}

/* Buttons */
.btn-cta {
	margin-top: 25px;
	padding: 10px 30px;
	font-size: 18px;
}

/* Navbar */
.navbar-custom {
	background: rgba(0, 0, 0, 0.6);
}

.navbar-brand {
	color: white !important;
	font-weight: bold;
	font-size: 24px;
}

/* Login Button */
.btn-login {
	background-color: #ffc107;
	border: none;
}

.btn-login:hover {
	background-color: #e0a800;
}

/* Footer */
footer {
	background: #212529;
	color: white;
	text-align: center;
	padding: 15px;
}

/* Blur Effect */
.blur {
	filter: blur(5px);
}

/* Modal Switch Link */
.switch-link {
	color: #ffc107;
	cursor: pointer;
	font-weight: bold;
}

.switch-link:hover {
	text-decoration: underline;
}
</style>
</head>

<body>

	<div id="mainContent" class="bg-image">
		<div class="overlay">
			<!-- Navbar -->
			<nav class="navbar navbar-expand-lg navbar-custom fixed-top">
				<div class="container-fluid">
					<a class="navbar-brand" href="#">RoadSafetyHub</a>
					<button class="navbar-toggler bg-light" type="button"
						data-bs-toggle="collapse" data-bs-target="#navbarContent">
						<span class="navbar-toggler-icon"></span>
					</button>
					<div class="collapse navbar-collapse justify-content-end"
						id="navbarContent">
						<button class="btn btn-login" data-bs-toggle="modal"
							data-bs-target="#authModal">Login / Register</button>
					</div>
				</div>
			</nav>
			<!-- Hero Section -->
			<div class="hero-content">
				<h1>Ensuring Safer Roads Through Digital Enforcement</h1>
				<p>Transforming road safety through smart digital enforcement.
					RoadSafetyHub simplifies violation tracking, fine management, and
					monitoring to create a safer and more accountable traffic
					ecosystem.</p>
				<a href="#" class="btn btn-warning btn-cta"> Get Started </a>

			</div>

		</div>

	</div>


	<!-- Footer -->

	<footer> © 2026 RoadSafetyHub | Developed by Varshitha </footer>


	<!-- ================= MODAL ================= -->

	<div class="modal fade" id="authModal" tabindex="-1">

		<div class="modal-dialog modal-dialog-centered">

			<div class="modal-content p-4">

				<div class="modal-body">


					<!-- LOGIN FORM -->

					<div id="loginForm">

						<h4 class="text-center mb-3">Login</h4>

						<form action="UserController" method="post">
							<input type="hidden" name="action" value="login">
							<div class="mb-3">
								<label>User Name</label> <input type="text" name="username"
									class="form-control" required>
							</div>

							<div class="mb-3">
								<label>Password</label> <input type="password" name="password"
									class="form-control" required>
							</div>

							<button type="submit" class="btn btn-warning w-100">
								Login</button>

						</form>

						<p class="text-center mt-3">

							New user? <span class="switch-link" onclick="showRegister()">
								Register here </span>

						</p>

					</div>


					<!-- REGISTER FORM -->

					<div id="registerForm" style="display: none;">

						<h4 class="text-center mb-3">Register</h4>

						<form action="UserController" method="post">
							<input type="hidden" name="action" value="register">

							<div class="mb-3">
								<label>First Name</label> <input type="text" name="firstname"
									class="form-control" required>
							</div>

							<div class="mb-3">
								<label>Last Name</label> <input type="text" name="lastname"
									class="form-control" required>
							</div>

							<div class="mb-3">
								<label>User Name</label> <input type="text" name="username"
									class="form-control" required>
							</div>

							<div class="mb-3">
								<label>Password</label> <input type="password" name="password"
									class="form-control" required>
							</div>

							<div class="mb-3">

								<label class="form-label">Role</label> <select name="role"
									class="form-select" required>

									<option value="">-- Select Role --</option>

									<option value="ADMIN">Admin</option>

									<option value="OWNER">Owner</option>

									<option value="POLICE">Police</option>

								</select>

							</div>

							<button type="submit" class="btn btn-warning w-100">

								Register</button>

						</form>

						<p class="text-center mt-3">

							Already registered? <span class="switch-link"
								onclick="showLogin()"> Login here </span>

						</p>

					</div>

				</div>

			</div>

		</div>

	</div>


	<!-- Bootstrap JS -->

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>


	<!-- Scripts -->

	<script>
		const modal = document.getElementById('authModal');
		const mainContent = document.getElementById('mainContent');

		modal.addEventListener('show.bs.modal', function() {
			mainContent.classList.add('blur');
		});

		modal.addEventListener('hidden.bs.modal', function() {
			mainContent.classList.remove('blur');
		});

		function showRegister() {

			document.getElementById('loginForm').style.display = "none";
			document.getElementById('registerForm').style.display = "block";

		}

		function showLogin() {

			document.getElementById('registerForm').style.display = "none";
			document.getElementById('loginForm').style.display = "block";

		}
	</script>

</body>

</html>