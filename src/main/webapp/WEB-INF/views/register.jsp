<%@ page contentType="text/html;charset=UTF-8" language="java" session="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - <%= request.getAttribute("academyName") %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<div class="auth-page">
    <div class="auth-card">
        <h1 class="auth-title">Create Account</h1>
        <p class="auth-subtitle">Register as a student to start learning</p>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error"><%= request.getAttribute("error") %></div>
        <% } %>

        <form method="post" action="<%= request.getContextPath() %>/register">
            <div class="form-group">
                <label class="form-label" for="username">Username</label>
                <input type="text" id="username" name="username" class="form-control"
                       required autocomplete="username" minlength="3" maxlength="30">
            </div>

            <div class="form-group">
                <label class="form-label" for="fullName">Full Name</label>
                <input type="text" id="fullName" name="fullName" class="form-control"
                       required autocomplete="name" maxlength="100">
            </div>

            <div class="form-group">
                <label class="form-label" for="email">Email</label>
                <input type="email" id="email" name="email" class="form-control"
                       required autocomplete="email" maxlength="100">
            </div>

            <div class="form-group">
                <label class="form-label" for="password">Password</label>
                <input type="password" id="password" name="password" class="form-control"
                       required autocomplete="new-password" minlength="6">
            </div>

            <div class="form-group">
                <label class="form-label" for="confirmPassword">Confirm Password</label>
                <input type="password" id="confirmPassword" name="confirmPassword" class="form-control"
                       required autocomplete="new-password">
            </div>

            <button type="submit" class="btn btn-primary" style="width: 100%; padding: 12px;">Create Account</button>
        </form>

        <div class="auth-footer">
            <p>Already have an account? <a href="<%= request.getContextPath() %>/login">Sign In</a></p>
        </div>
    </div>
</div>
</body>
</html>
