<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillhub.model.User" %>
<%@ page import="com.skillhub.util.HtmlUtil" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    String academyName = (String) request.getAttribute("academyName");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - <%= HtmlUtil.escape(application.getInitParameter("academyName")) %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
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
                    <div class="form-group">
                        <label class="form-label fw-medium">Full Name</label>
                        <input type="text" class="form-control bg-light"
                               value="<%= loggedUser != null ? HtmlUtil.escape(loggedUser.getFullName()) : "" %>" readonly>
                    </div>
                    <div class="form-group">
                        <label class="form-label fw-medium">Username</label>
                        <input type="text" class="form-control bg-light"
                               value="<%= loggedUser != null ? HtmlUtil.escape(loggedUser.getUsername()) : "" %>" readonly>
                    </div>
                    <div class="form-group">
                        <label class="form-label fw-medium">Email</label>
                        <input type="email" class="form-control bg-light"
                               value="<%= loggedUser != null ? HtmlUtil.escape(loggedUser.getEmail()) : "" %>" readonly>
                    </div>
                    <div class="form-group">
                        <label class="form-label fw-medium">Role</label>
                        <input type="text" class="form-control bg-light"
                               value="<%= loggedUser != null ? HtmlUtil.escape(loggedUser.getRole().toString()) : "" %>" readonly>
                    </div>
                    <div class="form-group mb-0">
                        <label class="form-label fw-medium">Academy</label>
                        <input type="text" class="form-control bg-light"
                               value="<%= HtmlUtil.escape(academyName) %>" readonly>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<footer class="footer">
    <div class="container text-center text-muted small">
        &copy; 2026 <%= HtmlUtil.escape(application.getInitParameter("academyName")) %>. All rights reserved.
    </div>
</footer>
</body>
</html>