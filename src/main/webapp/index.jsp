<%@ page contentType="text/html;charset=UTF-8" language="java" session="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= application.getInitParameter("academyName") %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<div class="auth-page">
    <div class="auth-card" style="text-align: center;">
        <h1 class="auth-title" style="color: #2c7be5;"><%= application.getInitParameter("academyName") %></h1>
        <p class="auth-subtitle">Professional Training Portal</p>

        <div style="margin: 32px 0; padding: 24px; background: #f9fafb; border-radius: 8px;">
            <p style="margin-bottom: 16px;">Welcome to the SkillHub Training Portal.</p>
            <p style="margin-bottom: 24px;">Please sign in to access your dashboard, or register as a new student.</p>
            <div style="display: flex; gap: 12px; justify-content: center; flex-wrap: wrap;">
                <a href="<%= request.getContextPath() %>/login" class="btn btn-primary" style="min-width: 140px;">Sign In</a>
                <a href="<%= request.getContextPath() %>/register" class="btn btn-secondary" style="min-width: 140px;">Register</a>
            </div>
        </div>

        <div style="font-size: 0.8rem; color: #999;">
            <p>Demo Accounts:</p>
            <p>Admin: admin / admin123</p>
            <p>Trainer: trainer1 / trainer123</p>
            <p>Student: student1 / student123</p>
        </div>
    </div>
</div>
</body>
</html>
