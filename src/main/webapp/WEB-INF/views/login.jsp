<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - <%= application.getInitParameter("academyName") %>
    </title>
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
                    <h1 class="h4 fw-bold text-center mb-1">Welcome Back</h1>
                    <p class="text-muted text-center mb-4">Sign in to your SkillHub account</p>

                    <% if ("loggedout".equals(request.getParameter("msg"))) { %>
                    <div class="alert alert-info alert-dismissible fade show">
                        You have been logged out successfully.
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <% } %>
                    <% if ("registered".equals(request.getParameter("msg"))) { %>
                    <div class="alert alert-success alert-dismissible fade show">
                        Registration successful! Please log in.
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <% } %>
                    <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger alert-dismissible fade show">
                        <%= request.getAttribute("error") %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <% } %>

                    <% String rememberedUser = (String) request.getAttribute("rememberedUser"); %>

                    <form method="post" action="<%= request.getContextPath() %>/login">
                        <div class="mb-3">
                            <label class="form-label fw-medium" for="username">Username</label>
                            <input type="text" id="username" name="username" class="form-control"
                                   value="<%= rememberedUser != null ? rememberedUser : "" %>"
                                   required autocomplete="username">
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-medium" for="password">Password</label>
                            <input type="password" id="password" name="password" class="form-control"
                                   required autocomplete="current-password">
                        </div>

                        <div class="mb-3">
                            <div class="form-check">
                                <input type="checkbox" id="remember" name="remember" class="form-check-input"
                                    <%= (rememberedUser != null && !rememberedUser.isEmpty()) ? "checked" : "" %>>
                                <label class="form-check-label" for="remember">Remember my username</label>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-primary w-100 py-2">Sign In</button>
                    </form>

                    <p class="text-center mt-3 mb-0 text-muted small">
                        Don't have an account?
                        <a href="<%= request.getContextPath() %>/register">Register as a Student</a>
                    </p>

<%--                    <hr class="my-3">--%>
<%--                    <div class="text-muted text-center" style="font-size: 0.8rem;">--%>
<%--                        <p class="mb-1 fw-semibold">Demo Accounts:</p>--%>
<%--                        <p class="mb-0">Admin: admin / admin123</p>--%>
<%--                        <p class="mb-0">Trainer: trainer1 / trainer123</p>--%>
<%--                        <p class="mb-0">Student: student1 / student123</p>--%>
<%--                    </div>--%>
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
