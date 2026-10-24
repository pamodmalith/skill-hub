<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillhub.model.Course, com.skillhub.model.Role, com.skillhub.model.User, java.util.List, java.util.Map" %>
<%
    List<Course> courses       = (List<Course>) request.getAttribute("courses");
    Map<Integer, User> trainerMap = (Map<Integer, User>) request.getAttribute("trainerMap");
    Role userRole              = (Role) request.getAttribute("userRole");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Courses - <%= request.getAttribute("academyName") %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<jsp:include page="menu.jsp"/>

<main class="main container">
    <div class="page-header">
        <h1 class="page-title">Available Courses</h1>
        <p class="page-subtitle">Browse and enroll in our training programs</p>
    </div>

    <% if ("added".equals(request.getParameter("msg"))) { %>
        <div class="alert alert-success">Course added successfully!</div>
    <% } %>

    <div class="card">
        <div class="card-body">
            <% if (courses == null || courses.isEmpty()) { %>
                <p style="color: #666;">No courses available at the moment.</p>
            <% } else { %>
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                        <tr>
                            <th>Title</th>
                            <th>Category</th>
                            <th>Trainer</th>
                            <% if (userRole == Role.STUDENT) { %><th>Action</th><% } %>
                        </tr>
                        </thead>
                        <tbody>
                        <% for (Course course : courses) {
                               User trainer = trainerMap != null ? trainerMap.get(course.getId()) : null;
                        %>
                            <tr>
                                <td><%= course.getTitle() %></td>
                                <td><%= course.getCategory() %></td>
                                <td><%= trainer != null ? trainer.getFullName() : "" %></td>
                                <% if (userRole == Role.STUDENT) { %>
                                    <td>
                                        <div class="course-actions">
                                            <form method="post" action="<%= request.getContextPath() %>/enroll">
                                                <input type="hidden" name="courseId" value="<%= course.getId() %>"/>
                                                <button type="submit" class="btn btn-primary btn-sm">Enrol</button>
                                            </form>
                                        </div>
                                    </td>
                                <% } %>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </div>
    </div>

    <% if (userRole == Role.ADMIN) { %>
        <div style="margin-top: 24px; text-align: right;">
            <a href="<%= request.getContextPath() %>/admin/add-course" class="btn btn-primary">Add New Course</a>
        </div>
    <% } %>
</main>

<footer class="footer container">
    <p>&copy; 2026 <%= request.getAttribute("academyName") %>. All rights reserved.</p>
</footer>
</body>
</html>
