<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillhub.model.User" %>
<%@ page import="com.skillhub.util.HtmlUtil" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    String academyName = (String) request.getAttribute("academyName");
    // Build avatar initials from full name
    String initials = "";
    if (loggedUser != null && loggedUser.getFullName() != null) {
        String[] parts = loggedUser.getFullName().trim().split("\\s+");
        if (parts.length >= 2) {
            initials = String.valueOf(parts[0].charAt(0)).toUpperCase()
                     + String.valueOf(parts[parts.length - 1].charAt(0)).toUpperCase();
        } else if (parts.length == 1 && parts[0].length() > 0) {
            initials = String.valueOf(parts[0].charAt(0)).toUpperCase();
        }
    }
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
<body>
<jsp:include page="menu.jsp"/>

<main class="container-lg py-4 px-3">
    <div class="mb-4">
        <h1 class="h3 fw-bold mb-1">My Profile</h1>
        <p class="text-muted mb-0">Your account information</p>
    </div>

    <div class="row">
        <div class="col-12 col-md-7 col-lg-5">
            <div class="card">
                <div class="card-body p-4">
                    <div class="d-flex align-items-center gap-3 mb-4">
                        <div class="sh-avatar" aria-hidden="true"><%= HtmlUtil.escape(initials) %></div>
                        <div>
                            <div class="fw-bold fs-5"><%= loggedUser != null ? HtmlUtil.escape(loggedUser.getFullName()) : "" %></div>
                            <div class="text-muted small"><%= loggedUser != null ? HtmlUtil.escape(loggedUser.getRole().toString()) : "" %></div>
                        </div>
                    </div>

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

<footer class="sh-footer mt-4">
    <div class="container-lg text-center">
        &copy; 2026 <%= HtmlUtil.escape(application.getInitParameter("academyName")) %>. All rights reserved.
    </div>
</footer>

<script src="<%= request.getContextPath() %>/js/bootstrap.bundle.min.js"></script>
</body>
</html>
