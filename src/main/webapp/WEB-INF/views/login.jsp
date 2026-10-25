<%@ page contentType="text/html;charset=UTF-8" language="java" session="false" %>
<%@ page import="com.skillhub.util.HtmlUtil" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - <%= HtmlUtil.escape(application.getInitParameter("academyName")) %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body class="auth-page">
<div class="auth-card">
    <h1 class="auth-title"><%= HtmlUtil.escape(application.getInitParameter("academyName")) %></h1>
    <p class="auth-subtitle">Sign in to your account</p>

    <%
        String registered = request.getParameter("registered");
        if ("true".equals(registered)) {
    %>
    <div class="alert alert-success">Registration successful. Please log in.</div>
    <%
        }
        String loggedOut = request.getParameter("loggedOut");
        if ("true".equals(loggedOut)) {
    %>
    <div class="alert alert-success">You have been logged out.</div>
    <%
        }
        if (request.getAttribute("error") != null) {
    %>
    <div class="alert alert-error"><%= HtmlUtil.escape((String) request.getAttribute("error")) %></div>
    <%
        }
    %>

    <form method="post" action="<%= request.getContextPath() %>/login">
        <div class="form-group">
            <label class="form-label" for="username">Username</label>
            <input type="text" id="username" name="username" class="form-control"
                   value="<%= HtmlUtil.escape((String) request.getAttribute("savedUsername")) %>"
                   required autocomplete="username">
        </div>

        <div class="form-group">
            <label class="form-label" for="password">Password</label>
            <input type="password" id="password" name="password" class="form-control"
                   required autocomplete="current-password">
        </div>

        <div class="form-group form-check">
            <input type="checkbox" id="remember" name="remember" class="form-check-input">
            <label class="form-check-label" for="remember">Remember my username</label>
        </div>

        <button type="submit" class="btn btn-primary" style="width: 100%;">Sign In</button>
    </form>

    <p class="auth-footer">
        Don't have an account?
        <a href="<%= request.getContextPath() %>/register">Register as a Student</a>
    </p>
</div>
</body>
</html>