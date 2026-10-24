<%@ page contentType="text/html;charset=UTF-8" language="java" session="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= application.getInitParameter("academyName") %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
          rel="stylesheet"
          integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB"
          crossorigin="anonymous">
</head>
<body class="bg-light min-vh-100 d-flex align-items-center justify-content-center">

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-12 col-sm-8 col-md-6 col-lg-5">
            <div class="card shadow-sm border-0 text-center">
                <div class="card-body p-5">
                    <h1 class="h3 fw-bold text-primary mb-1">
                        <%= application.getInitParameter("academyName") %>
                    </h1>
                    <p class="text-muted mb-4">Professional Training Portal</p>

                    <div class="bg-light rounded p-4 mb-4">
                        <p class="mb-2">Welcome to the SkillHub Training Portal.</p>
                        <p class="mb-4 text-muted">Please sign in to access your dashboard, or register as a new student.</p>
                        <div class="d-flex gap-3 justify-content-center flex-wrap">
                            <a href="<%= request.getContextPath() %>/login" class="btn btn-primary px-4">Sign In</a>
                            <a href="<%= request.getContextPath() %>/register" class="btn btn-outline-secondary px-4">Register</a>
                        </div>
                    </div>

                    <div class="text-muted small">
                        <p class="mb-1 fw-semibold">Demo Accounts:</p>
                        <p class="mb-0">Admin: admin / admin123</p>
                        <p class="mb-0">Trainer: trainer1 / trainer123</p>
                        <p class="mb-0">Student: student1 / student123</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI"
        crossorigin="anonymous"></script>
</body>
</html>
