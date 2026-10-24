<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillhub.model.User" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - <%= application.getInitParameter("academyName") %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
          rel="stylesheet"
          integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB"
          crossorigin="anonymous">
</head>
<body class="bg-light">
<jsp:include page="menu.jsp"/>

<main class="container py-4">
    <div class="mb-4">
        <h1 class="h3 fw-bold mb-1">My Profile</h1>
        <p class="text-muted">Your account information</p>
    </div>

    <div class="row">
        <div class="col-12 col-md-6">
            <div class="card shadow-sm border-0">
                <div class="card-body p-4">
                    <div class="mb-3">
                        <label class="form-label fw-medium">Full Name</label>
                        <input type="text" class="form-control bg-light"
                               value="<%= loggedUser != null ? loggedUser.getFullName() : "" %>" readonly>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-medium">Username</label>
                        <input type="text" class="form-control bg-light"
                               value="<%= loggedUser != null ? loggedUser.getUsername() : "" %>" readonly>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-medium">Email</label>
                        <input type="email" class="form-control bg-light"
                               value="<%= loggedUser != null ? loggedUser.getEmail() : "" %>" readonly>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-medium">Role</label>
                        <input type="text" class="form-control bg-light"
                               value="<%= loggedUser != null ? loggedUser.getRole() : "" %>" readonly>
                    </div>
                    <div class="mb-0">
                        <label class="form-label fw-medium">Academy</label>
                        <input type="text" class="form-control bg-light"
                               value="<%= application.getInitParameter("academyName") %>" readonly>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<footer class="bg-white border-top py-3 mt-4">
    <div class="container text-center text-muted small">
        &copy; 2026 <%= application.getInitParameter("academyName") %>. All rights reserved.
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI"
        crossorigin="anonymous"></script>
</body>
</html>
