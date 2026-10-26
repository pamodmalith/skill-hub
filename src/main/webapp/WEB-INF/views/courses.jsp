<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillhub.model.Course, com.skillhub.model.Role, com.skillhub.model.User, java.util.List, java.util.Map, java.util.Set" %>
<%@ page import="com.skillhub.util.HtmlUtil" %>
<%
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    Map<Integer, User> trainerNames = (Map<Integer, User>) request.getAttribute("trainerNames");
    Set<Integer> enrolledIds = (Set<Integer>) request.getAttribute("enrolledIds");
    Role userRole = (User) session.getAttribute("loggedUser") != null ?
        ((User) session.getAttribute("loggedUser")).getRole() : null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Courses - <%= HtmlUtil.escape(application.getInitParameter("academyName")) %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body class="d-flex flex-column min-vh-100 bg-light">
<jsp:include page="menu.jsp"/>

<main class="container py-4 flex-grow-1">
    <div class="d-flex justify-content-between align-items-start mb-4 flex-wrap gap-2">
        <div>
            <h1 class="h3 fw-bold mb-1">Available Courses</h1>
            <p class="text-muted mb-0">Browse and enroll in our training programs</p>
        </div>
        <% if (userRole == Role.ADMIN) { %>
        <a href="<%= request.getContextPath() %>/admin/add-course" class="btn btn-primary">+ Add New Course</a>
        <% } %>
    </div>

    <%
        String msg = request.getParameter("msg");
        if ("courseAdded".equals(msg)) {
    %>
    <div class="alert alert-success" role="alert">Course added successfully.</div>
    <%
        } else if ("alreadyEnrolled".equals(msg)) {
    %>
    <div class="alert alert-danger" role="alert">Already enrolled in that course.</div>
    <%
        } else if ("invalidCourse".equals(msg)) {
    %>
    <div class="alert alert-danger" role="alert">Invalid course.</div>
    <%
        }
    %>

    <div class="card shadow-sm border-0">
        <div class="card-body p-0">
            <% if (courses == null || courses.isEmpty()) { %>
            <div class="p-4 text-muted text-center py-5">No courses available at the moment.</div>
            <% } else { %>
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                    <tr>
                        <th>Id</th>
                        <th>Title</th>
                        <th>Category</th>
                        <th>Description</th>
                        <th>Trainer</th>
                        <% if (userRole == Role.STUDENT) { %><th>Action</th><% } %>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (Course course : courses) {
                        User trainer = trainerNames != null ? trainerNames.get(course.getId()) : null;
                        boolean isEnrolled = enrolledIds != null && enrolledIds.contains(course.getId());
                    %>
                    <tr>
                        <td class="fw-medium"><%= HtmlUtil.escape(String.valueOf(course.getId())) %></td>
                        <td class="fw-medium"><%= HtmlUtil.escape(course.getTitle()) %></td>
                        <td><span class="badge bg-secondary"><%= HtmlUtil.escape(course.getCategory()) %></span></td>
                        <td class="text-muted small"><%= HtmlUtil.escape(course.getDescription()) %></td>
                        <td class="text-muted"><%= trainer != null ? HtmlUtil.escape(trainer.getFullName()) : "" %></td>
                        <% if (userRole == Role.STUDENT) { %>
                        <td>
                            <% if (isEnrolled) { %>
                            <span class="badge bg-success">Enrolled</span>
                            <% } else { %>
                            <form method="post" action="<%= request.getContextPath() %>/enroll" class="m-0">
                                <input type="hidden" name="courseId" value="<%= course.getId() %>"/>
                                <button type="submit" class="btn btn-primary btn-sm">Enrol</button>
                            </form>
                            <% } %>
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
</main>

<footer class="bg-primary text-white-50 text-center small py-3 mt-auto">
    <div class="container text-center">
        &copy; 2026 <%= HtmlUtil.escape(application.getInitParameter("academyName")) %>. All rights reserved.
    </div>
</footer>

<script src="<%= request.getContextPath() %>/js/bootstrap.bundle.min.js"></script>
</body>
</html>
