<%@ page contentType="text/html;charset=UTF-8" language="java" session="false" %>
<%@ page import="com.skillhub.util.HtmlUtil" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Login - <%= HtmlUtil.escape(application.getInitParameter("academyName")) %>
    </title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body class="bg-primary">

<main class="container d-flex align-items-center justify-content-center min-vh-100">
    <div class="card shadow col-12 col-md-6 col-lg-4">
        <div class="card-body p-4">
            <h1 class="h4 fw-bold text-center mb-1 text-primary"><%= HtmlUtil.escape(application.getInitParameter("academyName")) %>
            </h1>
            <p class="text-muted text-center mb-4 small">Sign in to your account</p>

            <%
                String registered = request.getParameter("registered");
                if ("true".equals(registered)) {
            %>
            <div class="alert alert-success" role="alert">Registration successful. Please log in.</div>
            <%
                }
                String loggedOut = request.getParameter("loggedOut");
                if ("true".equals(loggedOut)) {
            %>
            <div class="alert alert-success" role="alert">You have been logged out.</div>
            <%
                }
                if (request.getAttribute("error") != null) {
            %>
            <div class="alert alert-danger" role="alert"><%= HtmlUtil.escape((String) request.getAttribute("error")) %>
            </div>
            <%
                }
            %>

            <form method="post" action="<%= request.getContextPath() %>/login">
                <div class="mb-3">
                    <label class="form-label fw-medium" for="username">Username</label>
                    <input type="text" id="username" name="username" class="form-control"
                           value="<%= HtmlUtil.escape((String) request.getAttribute("savedUsername")) %>"
                           required autocomplete="username" placeholder="Your username">
                </div>

                <div class="mb-3">
                    <label class="form-label fw-medium" for="password">Password</label>
                    <input type="password" id="password" name="password" class="form-control"
                           required autocomplete="current-password" placeholder="Your password">
                </div>

                <% String rememberedUser = (String) request.getAttribute("savedUsername"); %>
                <% System.out.println("========>" + rememberedUser);%>
                <div class="mb-3 form-check">
                    <input type="checkbox" id="remember" name="remember" class="form-check-input"
                        <%= (rememberedUser != null && !rememberedUser.isEmpty()) ? "checked" : "" %>>
                    <label class="form-check-label" for="remember">Remember my username</label>
                </div>

                <button type="submit" class="btn btn-primary w-100 mt-2">Sign In</button>
            </form>

            <p class="text-center text-muted small mt-3 mb-0">
                Don't have an account?
                <a href="<%= request.getContextPath() %>/register">Register as a Student</a>
            </p>
        </div>
    </div>
</main>

<script src="<%= request.getContextPath() %>/js/bootstrap.bundle.min.js"></script>
</body>
</html>
