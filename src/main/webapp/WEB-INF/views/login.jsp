<%@ page contentType="text/html;charset=UTF-8" language="java" session="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - <%= request.getAttribute("academyName") %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<div class="auth-page">
    <div class="auth-card">
        <h1 class="auth-title">Welcome Back</h1>
        <p class="auth-subtitle">Sign in to your SkillHub account</p>

        <% if ("loggedout".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-info">You have been logged out successfully.</div>
        <% } %>
        <% if ("registered".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success">Registration successful! Please log in.</div>
        <% } %>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error"><%= request.getAttribute("error") %></div>
        <% } %>

        <form method="post" action="<%= request.getContextPath() %>/login">
            <div class="form-group">
                <label class="form-label" for="username">Username</label>
                <input type="text" id="username" name="username" class="form-control"
                       value="<%= request.getAttribute("rememberedUser") != null ? request.getAttribute("rememberedUser") : "" %>"
                       required autocomplete="username">
            </div>

            <div class="form-group">
                <label class="form-label" for="password">Password</label>
                <input type="password" id="password" name="password" class="form-control"
                       required autocomplete="current-password">
            </div>

            <div class="form-group">
                <div class="form-check">
                    <% String rememberedUser = (String) request.getAttribute("rememberedUser"); %>
                    <input type="checkbox" id="remember" name="remember" class="form-check-input"
                           <%= (rememberedUser != null && !rememberedUser.isEmpty()) ? "checked" : "" %>>
                    <label class="form-label" for="remember" style="margin-bottom: 0; font-weight: 400;">Remember my username</label>
                </div>
            </div>

            <button type="submit" class="btn btn-primary" style="width: 100%; padding: 12px;">Sign In</button>
        </form>

        <div class="auth-footer">
            <p>Don't have an account? <a href="<%= request.getContextPath() %>/register">Register as a Student</a></p>
        </div>

        <div class="auth-footer" style="margin-top: 16px; padding-top: 16px; border-top: 1px solid #eef2f7; font-size: 0.8rem; color: #999;">
            <p><strong>Demo Accounts:</strong></p>
            <p>Admin: admin / admin123</p>
            <p>Trainer: trainer1 / trainer123</p>
            <p>Student: student1 / student123</p>
        </div>
    </div>
</div>
</body>
</html>
