<%@ page contentType="text/html;charset=UTF-8" language="java" session="false" isErrorPage="true" %>
<%@ page import="com.skillhub.util.HtmlUtil" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - <%= HtmlUtil.escape(application.getInitParameter("academyName")) %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body class="bg-light min-vh-100 d-flex align-items-center justify-content-center">

<div class="container text-center py-5">
    <%
        Integer statusCode = (Integer) request.getAttribute("jakarta.servlet.error.status_code");
        if (statusCode != null && statusCode == 403) {
    %>
    <div class="display-1 fw-bold text-primary mb-3">403</div>
    <h1 class="h3 fw-semibold mb-2">Access Denied</h1>
    <p class="text-muted mb-4">You do not have permission to open this page.</p>
    <% } else if (statusCode != null && statusCode == 404) { %>
    <div class="display-1 fw-bold text-primary mb-3">404</div>
    <h1 class="h3 fw-semibold mb-2">Page Not Found</h1>
    <p class="text-muted mb-4">The page you are looking for does not exist.</p>
    <% } else { %>
    <div class="display-1 fw-bold text-primary mb-3">500</div>
    <h1 class="h3 fw-semibold mb-2">Server Error</h1>
    <p class="text-muted mb-4">Something went wrong on the server.</p>
    <% } %>
    <a href="<%= request.getContextPath() %>/dashboard" class="btn btn-primary px-4">Go to Dashboard</a>
</div>

</body>
</html>