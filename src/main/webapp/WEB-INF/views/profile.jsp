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
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Profile - <%= HtmlUtil.escape(application.getInitParameter("academyName")) %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body class="d-flex flex-column min-vh-100 bg-light">
<jsp:include page="menu.jsp"/>

<main class="container py-4 flex-grow-1">
    <div class="mb-4">
        <h1 class="h3 fw-bold mb-1">My Profile</h1>
        <p class="text-muted mb-0">Your account information</p>
    </div>

    <div class="row">
        <div class="col-12 col-md-8 col-lg-6">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-white fw-semibold">Account Details</div>
                <div class="card-body p-0">
                    <ul class="list-group list-group-flush">
                        <li class="list-group-item d-flex justify-content-between align-items-center py-3">
                            <span class="text-muted">Full Name</span>
                            <span class="fw-medium"><%= loggedUser != null ? HtmlUtil.escape(loggedUser.getFullName()) : "" %></span>
                        </li>
                        <li class="list-group-item d-flex justify-content-between align-items-center py-3">
                            <span class="text-muted">Username</span>
                            <span class="fw-medium"><%= loggedUser != null ? HtmlUtil.escape(loggedUser.getUsername()) : "" %></span>
                        </li>
                        <li class="list-group-item d-flex justify-content-between align-items-center py-3">
                            <span class="text-muted">Email</span>
                            <span class="fw-medium"><%= loggedUser != null ? HtmlUtil.escape(loggedUser.getEmail()) : "" %></span>
                        </li>
                        <li class="list-group-item d-flex justify-content-between align-items-center py-3">
                            <span class="text-muted">Role</span>
                            <span class="badge rounded-pill text-bg-primary"><%= loggedUser != null ? HtmlUtil.escape(loggedUser.getRole().toString()) : "" %></span>
                        </li>
                        <li class="list-group-item d-flex justify-content-between align-items-center py-3">
                            <span class="text-muted">Academy</span>
                            <span class="fw-medium"><%= HtmlUtil.escape(academyName) %></span>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</main>

<footer class="bg-primary text-white-50 text-center small py-3 mt-auto">
    <div class="container text-center">
        &copy; 2026 <%= HtmlUtil.escape(application.getInitParameter("academyName")) %>. All rights reserved.
    </div>
</footer>

<script src="<%= request.getContextPath() %>/js/bootstrap.bundle.min.js"></script>
</body>
</html>
