<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillhub.model.Course, com.skillhub.model.User, java.util.List" %>
<%@ page import="com.skillhub.util.HtmlUtil" %>
<%
    List<User> students = (List<User>) request.getAttribute("students");
    List<Course> courses = (List<Course>) request.getAttribute("courses");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Enrol Student - <%= HtmlUtil.escape(application.getInitParameter("academyName")) %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body class="d-flex flex-column min-vh-100 bg-light">
<jsp:include page="menu.jsp"/>

<main class="container py-4 flex-grow-1">
    <div class="mb-4">
        <h1 class="h3 fw-bold mb-1">Enrol Student</h1>
        <p class="text-muted mb-0">Enrol a student in a course</p>
    </div>

    <%
        String msg = request.getParameter("msg");
        if ("enrolledByAdmin".equals(msg)) {
    %>
    <div class="alert alert-success" role="alert">Student enrolled successfully.</div>
    <%
        } else if ("alreadyEnrolled".equals(msg)) {
    %>
    <div class="alert alert-danger" role="alert">Already enrolled in that course.</div>
    <%
        } else if ("invalid".equals(msg)) {
    %>
    <div class="alert alert-danger" role="alert">Invalid student or course.</div>
    <%
        }
    %>

    <div class="row">
        <div class="col-12 col-md-8 col-lg-6">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-white fw-semibold">Enrolment Details</div>
                <div class="card-body p-4">
                    <form method="post" action="<%= request.getContextPath() %>/admin/enroll">
                        <div class="mb-3">
                            <label class="form-label fw-medium" for="studentUsername">Student</label>
                            <select id="studentUsername" name="studentUsername" class="form-select" required>
                                <option value="">Select a student</option>
                                <% if (students != null) {
                                    for (User student : students) { %>
                                <option value="<%= student.getUsername() %>">
                                    <%= HtmlUtil.escape(student.getFullName()) %> (<%= HtmlUtil.escape(student.getUsername()) %>)
                                </option>
                                <% }
                                } %>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-medium" for="courseId">Course</label>
                            <select id="courseId" name="courseId" class="form-select" required>
                                <option value="">Select a course</option>
                                <% if (courses != null) {
                                    for (Course course : courses) { %>
                                <option value="<%= course.getId() %>">
                                    <%= course.getId() %> - <%= HtmlUtil.escape(course.getTitle()) %>
                                </option>
                                <% }
                                } %>
                            </select>
                        </div>

                        <div class="d-flex gap-2 mt-3">
                            <button type="submit" class="btn btn-primary">Enrol Student</button>
                            <a href="<%= request.getContextPath() %>/dashboard" class="btn btn-outline-secondary">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>
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
