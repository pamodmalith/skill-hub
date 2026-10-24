<%@ page contentType="text/html;charset=UTF-8" language="java" session="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - <%= application.getInitParameter("academyName") %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
          rel="stylesheet"
          integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB"
          crossorigin="anonymous">
</head>
<body class="bg-light min-vh-100 d-flex align-items-center justify-content-center">

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-12 col-sm-9 col-md-7 col-lg-5">
            <div class="card shadow-sm border-0">
                <div class="card-body p-4 p-md-5">
                    <h1 class="h4 fw-bold text-center mb-1">Create Account</h1>
                    <p class="text-muted text-center mb-4">Register as a student to start learning</p>

                    <% if (request.getAttribute("error") != null) { %>
                        <div class="alert alert-danger py-2"><%= request.getAttribute("error") %></div>
                    <% } %>

                    <form method="post" action="<%= request.getContextPath() %>/register">
                        <div class="mb-3">
                            <label class="form-label fw-medium" for="username">Username</label>
                            <input type="text" id="username" name="username" class="form-control"
                                   required autocomplete="username" minlength="3" maxlength="30">
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-medium" for="fullName">Full Name</label>
                            <input type="text" id="fullName" name="fullName" class="form-control"
                                   required autocomplete="name" maxlength="100">
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-medium" for="email">Email</label>
                            <input type="email" id="email" name="email" class="form-control"
                                   required autocomplete="email" maxlength="100">
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-medium" for="password">Password</label>
                            <input type="password" id="password" name="password" class="form-control"
                                   required autocomplete="new-password" minlength="6">
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-medium" for="confirmPassword">Confirm Password</label>
                            <input type="password" id="confirmPassword" name="confirmPassword" class="form-control"
                                   required autocomplete="new-password">
                        </div>

                        <button type="submit" class="btn btn-primary w-100 py-2">Create Account</button>
                    </form>

                    <p class="text-center mt-3 mb-0 text-muted small">
                        Already have an account?
                        <a href="<%= request.getContextPath() %>/login">Sign In</a>
                    </p>
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
