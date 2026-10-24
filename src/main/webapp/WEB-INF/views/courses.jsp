<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillhub.model.Course, com.skillhub.model.Role, com.skillhub.model.User, java.util.List, java.util.Map" %>
<%
    List<Course> courses          = (List<Course>) request.getAttribute("courses");
    Map<Integer, User> trainerMap = (Map<Integer, User>) request.getAttribute("trainerMap");
    Role userRole                 = (Role) request.getAttribute("userRole");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Courses - <%= application.getInitParameter("academyName") %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
          rel="stylesheet"
          integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB"
          crossorigin="anonymous">
</head>
<body class="bg-light">
<jsp:include page="menu.jsp"/>

<main class="container py-4">
    <div class="d-flex justify-content-between align-items-start mb-4 flex-wrap gap-2">
        <div>
            <h1 class="h3 fw-bold mb-1">Available Courses</h1>
            <p class="text-muted mb-0">Browse and enroll in our training programs</p>
        </div>
        <% if (userRole == Role.ADMIN) { %>
            <a href="<%= request.getContextPath() %>/admin/add-course" class="btn btn-primary">
                + Add New Course
            </a>
        <% } %>
    </div>

    <% if ("added".equals(request.getParameter("msg"))) { %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            Course added successfully!
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>

    <div class="card shadow-sm border-0">
        <div class="card-body p-0">
            <% if (courses == null || courses.isEmpty()) { %>
                <div class="p-4 text-muted">No courses available at the moment.</div>
            <% } else { %>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
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
                                <td class="fw-medium"><%= course.getTitle() %></td>
                                <td><span class="badge bg-secondary bg-opacity-10 text-secondary"><%= course.getCategory() %></span></td>
                                <td class="text-muted"><%= trainer != null ? trainer.getFullName() : "" %></td>
                                <% if (userRole == Role.STUDENT) { %>
                                    <td>
                                        <form method="post" action="<%= request.getContextPath() %>/enroll" class="m-0">
                                            <input type="hidden" name="courseId" value="<%= course.getId() %>"/>
                                            <button type="submit" class="btn btn-primary btn-sm">Enrol</button>
                                        </form>
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

<footer class="bg-white border-top py-3 mt-4">
    <div class="container text-center text-muted small">
        &copy; 2026 <%= application.getInitParameter("academyName") %>. All rights reserved.
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI"
        crossorigin="anonymous"></script>
</body>
</html>
