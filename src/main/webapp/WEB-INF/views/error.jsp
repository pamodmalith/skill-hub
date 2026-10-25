<%@ page contentType="text/html;charset=UTF-8" language="java" session="false" isErrorPage="true" %>
<%@ page import="com.skillhub.util.HtmlUtil" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Error - <%= HtmlUtil.escape(application.getInitParameter("academyName")) %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body class="d-flex align-items-center justify-content-center" style="min-height: 100vh;">

<div class="container text-center py-5" style="max-width: 480px;">
    <%
        Integer statusCode = (Integer) request.getAttribute("jakarta.servlet.error.status_code");
        if (statusCode != null && statusCode == 403) {
    %>
    <div class="error-code">403</div>
    <div class="error-icon">&#128683;</div>
    <h1 class="h3 fw-bold mb-2">Access Denied</h1>
    <p class="text-muted mb-4">You do not have permission to view this page.</p>
    <% } else if (statusCode != null && statusCode == 404) { %>
    <div class="error-code">404</div>
    <div class="error-icon">&#128269;</div>
    <h1 class="h3 fw-bold mb-2">Page Not Found</h1>
    <p class="text-muted mb-4">The page you are looking for does not exist.</p>
    <% } else { %>
    <div class="error-code">500</div>
    <div class="error-icon">&#9888;</div>
    <h1 class="h3 fw-bold mb-2">Server Error</h1>
    <p class="text-muted mb-4">Something went wrong on our end. Please try again later.</p>
    <% } %>
    <a href="<%= request.getContextPath() %>/dashboard" class="btn btn-primary px-4">Go to Dashboard</a>
</div>

<script src="<%= request.getContextPath() %>/js/bootstrap.bundle.min.js"></script>
</body>
</html>
