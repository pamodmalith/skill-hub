<%@ page contentType="text/html;charset=UTF-8" language="java" session="false" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - <%= application.getInitParameter("academyName") %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
          rel="stylesheet"
          integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB"
          crossorigin="anonymous">
</head>
<body class="bg-light min-vh-100 d-flex align-items-center justify-content-center">

<div class="container text-center py-5">
    <%
        Integer statusCode = (Integer) request.getAttribute("jakarta.servlet.error.status_code");
        if (statusCode != null && statusCode == 403) {
    %>
        <div class="display-1 fw-bold text-primary mb-3">403</div>
        <h1 class="h3 fw-semibold mb-2">Access Denied</h1>
        <p class="text-muted mb-4">You don't have permission to access this resource.<br>
            Please contact the administrator if you believe this is an error.</p>
    <% } else if (statusCode != null && statusCode == 404) { %>
        <div class="display-1 fw-bold text-primary mb-3">404</div>
        <h1 class="h3 fw-semibold mb-2">Page Not Found</h1>
        <p class="text-muted mb-4">The page you're looking for doesn't exist or has been moved.</p>
    <% } else { %>
        <div class="display-1 fw-bold text-primary mb-3">500</div>
        <h1 class="h3 fw-semibold mb-2">Server Error</h1>
        <p class="text-muted mb-4">Something went wrong on our end. Please try again later.</p>
    <% } %>
    <a href="<%= request.getContextPath() %>/login" class="btn btn-primary px-4">Go to Login</a>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI"
        crossorigin="anonymous"></script>
</body>
</html>
