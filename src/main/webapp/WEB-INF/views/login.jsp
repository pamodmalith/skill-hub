<%@ page contentType="text/html;charset=UTF-8" language="java" session="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - ${academyName}</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>">
</head>
<body>
<div class="auth-page">
    <div class="auth-card">
        <h1 class="auth-title">Welcome Back</h1>
        <p class="auth-subtitle">Sign in to your SkillHub account</p>

        <c:if test="${param.msg == 'loggedout'}">
            <div class="alert alert-info">You have been logged out successfully.</div>
        </c:if>
        <c:if test="${param.msg == 'registered'}">
            <div class="alert alert-success">Registration successful! Please log in.</div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>

        <form method="post" action="<c:url value='/login'/>">
            <div class="form-group">
                <label class="form-label" for="username">Username</label>
                <input type="text" id="username" name="username" class="form-control"
                       value="${rememberedUser}" required autocomplete="username">
            </div>

            <div class="form-group">
                <label class="form-label" for="password">Password</label>
                <input type="password" id="password" name="password" class="form-control"
                       required autocomplete="current-password">
            </div>

            <div class="form-group">
                <div class="form-check">
                    <input type="checkbox" id="remember" name="remember" class="form-check-input"
                           ${rememberedUser != '' ? 'checked' : ''}>
                    <label class="form-label" for="remember" style="margin-bottom: 0; font-weight: 400;">Remember my username</label>
                </div>
            </div>

            <button type="submit" class="btn btn-primary" style="width: 100%; padding: 12px;">Sign In</button>
        </form>

        <div class="auth-footer">
            <p>Don't have an account? <a href="<c:url value='/register'/>">Register as a Student</a></p>
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