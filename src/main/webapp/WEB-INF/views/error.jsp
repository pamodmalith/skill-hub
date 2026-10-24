<%@ page contentType="text/html;charset=UTF-8" language="java" session="false" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - <%= request.getAttribute("academyName") %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<div class="error-page">
    <%
        Integer statusCode = (Integer) request.getAttribute("jakarta.servlet.error.status_code");
        if (statusCode != null && statusCode == 403) {
    %>
        <div class="error-code">403</div>
        <h1 class="error-message">Access Denied</h1>
        <p class="error-description">You don't have permission to access this resource. Please contact the administrator if you believe this is an error.</p>
    <% } else if (statusCode != null && statusCode == 404) { %>
        <div class="error-code">404</div>
        <h1 class="error-message">Page Not Found</h1>
        <p class="error-description">The page you're looking for doesn't exist or has been moved.</p>
    <% } else { %>
        <div class="error-code">500</div>
        <h1 class="error-message">Server Error</h1>
        <p class="error-description">Something went wrong on our end. Please try again later.</p>
    <% } %>

    <a href="<%= request.getContextPath() %>/login" class="btn btn-primary">Go to Login</a>
</div>
</body>
</html>
