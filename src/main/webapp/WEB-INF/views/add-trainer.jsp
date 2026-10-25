<%@ page contentType="text/html;charset=UTF-8" language="java" session="false" %>
<%@ page import="com.skillhub.util.HtmlUtil" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Add Trainer - <%= HtmlUtil.escape(application.getInitParameter("academyName")) %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<jsp:include page="menu.jsp"/>

<main class="container-lg py-4 px-3">
    <div class="mb-4">
        <h1 class="h3 fw-bold mb-1">Add Trainer</h1>
        <p class="text-muted mb-0">Create a new trainer account</p>
    </div>

    <%
        if (request.getAttribute("error") != null) {
    %>
    <div class="alert alert-error" role="alert"><%= HtmlUtil.escape((String) request.getAttribute("error")) %></div>
    <%
        }
    %>

    <div class="row">
        <div class="col-12 col-md-8 col-lg-6">
            <div class="card">
                <div class="card-header">Trainer Details</div>
                <div class="card-body p-4">
                    <form method="post" action="<%= request.getContextPath() %>/admin/add-trainer">
                        <div class="form-group">
                            <label class="form-label fw-medium" for="username">Username</label>
                            <input type="text" id="username" name="username" class="form-control"
                                   value="<%= HtmlUtil.escape((String) request.getAttribute("formUsername")) %>"
                                   required minlength="3" maxlength="20" autocomplete="username"
                                   placeholder="3–20 characters">
                        </div>

                        <div class="form-group">
                            <label class="form-label fw-medium" for="password">Password</label>
                            <input type="password" id="password" name="password" class="form-control"
                                   required minlength="4" autocomplete="new-password"
                                   placeholder="At least 4 characters">
                        </div>

                        <div class="form-group">
                            <label class="form-label fw-medium" for="fullName">Full Name</label>
                            <input type="text" id="fullName" name="fullName" class="form-control"
                                   value="<%= HtmlUtil.escape((String) request.getAttribute("formFullName")) %>"
                                   required maxlength="60" autocomplete="name"
                                   placeholder="Full name">
                        </div>

                        <div class="form-group">
                            <label class="form-label fw-medium" for="email">Email</label>
                            <input type="email" id="email" name="email" class="form-control"
                                   value="<%= HtmlUtil.escape((String) request.getAttribute("formEmail")) %>"
                                   required maxlength="100" autocomplete="email"
                                   placeholder="trainer@example.com">
                        </div>

                        <div class="d-flex gap-2 mt-3">
                            <button type="submit" class="btn btn-primary">Create Trainer</button>
                            <a href="<%= request.getContextPath() %>/dashboard" class="btn btn-outline-secondary">Cancel</a>
                        </div>
                    </form>
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
