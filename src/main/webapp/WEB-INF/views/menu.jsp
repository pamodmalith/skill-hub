<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillhub.model.User" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
%>
<nav class="header" role="navigation">
    <div class="nav container">
        <a class="nav-brand" href="<%= request.getContextPath() %>/dashboard"><%= application.getInitParameter("academyName") %></a>
        <ul class="nav-links">
            <li><a href="<%= request.getContextPath() %>/dashboard">Dashboard</a></li>
            <li><a href="<%= request.getContextPath() %>/courses">Courses</a></li>
            <% if (loggedUser != null && loggedUser.getRole() == com.skillhub.model.Role.ADMIN) { %>
                <li><a href="<%= request.getContextPath() %>/admin/add-course">Add Course</a></li>
            <% } %>
        </ul>
        <div class="nav-user">
            <span><%= loggedUser != null ? loggedUser.getFullName() : "" %></span>
            <span class="btn btn-secondary btn-sm"><%= loggedUser != null ? loggedUser.getRole() : "" %></span>
            <a href="<%= request.getContextPath() %>/profile" class="btn btn-secondary btn-sm">Profile</a>
            <a href="<%= request.getContextPath() %>/logout" class="btn btn-primary btn-sm">Logout</a>
        </div>
    </div>
</nav>
