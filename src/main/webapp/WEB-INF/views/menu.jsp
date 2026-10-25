<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillhub.model.User, com.skillhub.model.Role" %>
<%@ page import="com.skillhub.util.HtmlUtil" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    Role role = loggedUser != null ? loggedUser.getRole() : null;
%>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary sticky-top shadow-sm">
    <div class="container-lg">
        <a class="navbar-brand fw-bold" href="<%= request.getContextPath() %>/dashboard">
            <%= HtmlUtil.escape(application.getInitParameter("academyName")) %>
        </a>
        <button class="navbar-toggler" type="button"
                data-bs-toggle="collapse" data-bs-target="#navbarNav"
                aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/courses">Courses</a>
                </li>
                <% if (role == Role.ADMIN) { %>
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/admin/add-trainer">Add Trainer</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/admin/add-course">Add Course</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/admin/enroll">Enrol Student</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/attendance">Attendance</a>
                </li>
                <% } else if (role == Role.TRAINER) { %>
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/attendance">Attendance</a>
                </li>
                <% } %>
            </ul>
            <div class="d-flex align-items-center gap-2 flex-wrap">
                <span class="text-white fw-medium small">
                    <%= loggedUser != null ? HtmlUtil.escape(loggedUser.getFullName()) : "" %>
                </span>
                <span class="badge bg-light text-primary">
                    <%= role != null ? role.toString() : "" %>
                </span>
                <a href="<%= request.getContextPath() %>/profile" class="btn btn-outline-light btn-sm">Profile</a>
                <a href="<%= request.getContextPath() %>/logout" class="btn btn-light btn-sm">Logout</a>
            </div>
        </div>
    </div>
</nav>
