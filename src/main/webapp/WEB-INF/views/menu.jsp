<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillhub.model.User" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
%>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary sticky-top shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-semibold" href="<%= request.getContextPath() %>/dashboard">
            <%= application.getInitParameter("academyName") %>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/courses">Courses</a>
                </li>
                <% if (loggedUser != null && loggedUser.getRole() == com.skillhub.model.Role.ADMIN) { %>
                <li class="nav-item">
                    <a class="nav-link" href="<%= request.getContextPath() %>/admin/add-course">Add Course</a>
                </li>
                <% } %>
            </ul>
            <div class="d-flex align-items-center gap-2">
                <span class="text-white fw-medium"><%= loggedUser != null ? loggedUser.getFullName() : "" %></span>
                <span class="badge bg-light text-primary"><%= loggedUser != null ? loggedUser.getRole() : "" %></span>
                <a href="<%= request.getContextPath() %>/profile" class="btn btn-outline-light btn-sm">Profile</a>
                <a href="<%= request.getContextPath() %>/logout" class="btn btn-light btn-sm">Logout</a>
            </div>
        </div>
    </div>
</nav>
