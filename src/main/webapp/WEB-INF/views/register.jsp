<%@ page contentType="text/html;charset=UTF-8" language="java" session="false" %>
<%@ page import="com.skillhub.util.HtmlUtil" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Register - <%= HtmlUtil.escape(application.getInitParameter("academyName")) %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body class="bg-primary">

<main class="container d-flex align-items-center justify-content-center min-vh-100 py-4">
    <div class="card shadow col-12 col-md-6 col-lg-4">
        <div class="card-body p-4">
            <h1 class="h4 fw-bold text-center mb-1 text-primary">Create Account</h1>
            <p class="text-muted text-center mb-4 small">Register as a student to start learning</p>

            <%
                if (request.getAttribute("error") != null) {
            %>
            <div class="alert alert-danger" role="alert"><%= HtmlUtil.escape((String) request.getAttribute("error")) %></div>
            <%
                }
            %>

            <form method="post" action="<%= request.getContextPath() %>/register">
                <div class="mb-3">
                    <label class="form-label fw-medium" for="username">Username</label>
                    <input type="text" id="username" name="username" class="form-control"
                           value="<%= HtmlUtil.escape((String) request.getAttribute("formUsername")) %>"
                           required autocomplete="username" minlength="3" maxlength="20"
                           placeholder="3–20 characters">
                </div>

                <div class="mb-3">
                    <label class="form-label fw-medium" for="fullName">Full Name</label>
                    <input type="text" id="fullName" name="fullName" class="form-control"
                           value="<%= HtmlUtil.escape((String) request.getAttribute("formFullName")) %>"
                           required autocomplete="name" maxlength="60"
                           placeholder="Your full name">
                </div>

                <div class="mb-3">
                    <label class="form-label fw-medium" for="email">Email</label>
                    <input type="email" id="email" name="email" class="form-control"
                           value="<%= HtmlUtil.escape((String) request.getAttribute("formEmail")) %>"
                           required autocomplete="email" maxlength="100"
                           placeholder="you@example.com">
                </div>

                <div class="mb-3">
                    <label class="form-label fw-medium" for="password">Password</label>
                    <input type="password" id="password" name="password" class="form-control"
                           required autocomplete="new-password" minlength="4"
                           placeholder="At least 4 characters">
                </div>

                <div class="mb-3">
                    <label class="form-label fw-medium" for="confirmPassword">Confirm Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-control"
                           required autocomplete="new-password"
                           placeholder="Repeat your password">
                </div>

                <button type="submit" class="btn btn-primary w-100 mt-2">Create Account</button>
            </form>

            <p class="text-center text-muted small mt-3 mb-0">
                Already have an account?
                <a href="<%= request.getContextPath() %>/login">Sign In</a>
            </p>
        </div>
    </div>
</main>

<script src="<%= request.getContextPath() %>/js/bootstrap.bundle.min.js"></script>
</body>
</html>
