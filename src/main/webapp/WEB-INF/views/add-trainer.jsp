<%@ page contentType="text/html;charset=UTF-8" language="java" session="false" %>
<%@ page import="com.skillhub.util.HtmlUtil" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Trainer - <%= HtmlUtil.escape(application.getInitParameter("academyName")) %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body class="bg-light">
<jsp:include page="menu.jsp"/>

<main class="container py-4">
    <div class="mb-4">
        <h1 class="h3 fw-bold mb-1">Add Trainer</h1>
        <p class="text-muted">Create a new trainer account</p>
    </div>

    <%
        if (request.getAttribute("error") != null) {
    %>
    <div class="alert alert-error"><%= HtmlUtil.escape((String) request.getAttribute("error")) %></div>
    <%
        }
    %>

    <div class="row">
        <div class="col-12 col-md-7 col-lg-6">
            <div class="card shadow-sm border-0">
                <div class="card-body p-4">
                    <form method="post" action="<%= request.getContextPath() %>/admin/add-trainer">
                        <div class="form-group">
                            <label class="form-label fw-medium" for="username">Username</label>
                            <input type="text" id="username" name="username" class="form-control"
                                   value="<%= HtmlUtil.escape((String) request.getAttribute("formUsername")) %>"
                                   required minlength="3" maxlength="20" autocomplete="username">
                        </div>

                        <div class="form-group">
                            <label class="form-label fw-medium" for="password">Password</label>
                            <input type="password" id="password" name="password" class="form-control"
                                   required minlength="4" autocomplete="new-password">
                        </div>

                        <div class="form-group">
                            <label class="form-label fw-medium" for="fullName">Full Name</label>
                            <input type="text" id="fullName" name="fullName" class="form-control"
                                   value="<%= HtmlUtil.escape((String) request.getAttribute("formFullName")) %>"
                                   required maxlength="60" autocomplete="name">
                        </div>

                        <div class="form-group">
                            <label class="form-label fw-medium" for="email">Email</label>
                            <input type="email" id="email" name="email" class="form-control"
                                   value="<%= HtmlUtil.escape((String) request.getAttribute("formEmail")) %>"
                                   required maxlength="100" autocomplete="email">
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary">Create Trainer</button>
                            <a href="<%= request.getContextPath() %>/dashboard" class="btn btn-secondary">Cancel</a>
                        </div>
                    </form>
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