<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillhub.model.Course, com.skillhub.model.User, com.skillhub.model.AttendanceStatus, java.util.List, java.util.Map, java.time.LocalDate" %>
<%@ page import="com.skillhub.util.HtmlUtil" %>
<%
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    Course course = (Course) request.getAttribute("course");
    LocalDate date = (LocalDate) request.getAttribute("date");
    LocalDate today = (LocalDate) request.getAttribute("today");
    List<User> students = (List<User>) request.getAttribute("students");
    Map<String, AttendanceStatus> statuses = (Map<String, AttendanceStatus>) request.getAttribute("statuses");
    Map<LocalDate, int[]> sessionSummaries = (Map<LocalDate, int[]>) request.getAttribute("sessionSummaries");
    Boolean readOnly = (Boolean) request.getAttribute("readOnly");
    if (readOnly == null) readOnly = false;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Attendance - <%= HtmlUtil.escape(application.getInitParameter("academyName")) %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body class="bg-light">
<jsp:include page="menu.jsp"/>

<main class="container py-4">
    <div class="mb-4">
        <h1 class="h3 fw-bold mb-1">Attendance</h1>
        <p class="text-muted">Mark and view attendance records</p>
    </div>

    <%
        String msg = request.getParameter("msg");
        if ("attendanceSaved".equals(msg)) {
    %>
    <div class="alert alert-success">Attendance saved.</div>
    <%
        } else if ("futureDate".equals(msg)) {
    %>
    <div class="alert alert-error">Attendance cannot be recorded for a future date.</div>
    <%
        } else if ("invalidDate".equals(msg)) {
    %>
    <div class="alert alert-error">Invalid date.</div>
    <%
        } else if ("invalidCourse".equals(msg)) {
    %>
    <div class="alert alert-error">Invalid course.</div>
    <%
        }
    %>

    <%-- Course picker --%>
    <div class="card shadow-sm border-0 mb-4">
        <div class="card-header bg-white fw-semibold border-bottom">Select Course</div>
        <div class="card-body">
            <% if (courses == null || courses.isEmpty()) { %>
            <p class="text-muted mb-0">No courses available.</p>
            <% } else { %>
            <div class="row">
                <% for (Course c : courses) { %>
                <div class="col-12 col-md-6 col-lg-4 mb-3">
                    <a href="<%= request.getContextPath() %>/attendance?courseId=<%= c.getId() %>"
                       class="btn btn-outline-primary w-100 py-3 text-start">
                        <div class="fw-medium"><%= HtmlUtil.escape(c.getTitle()) %></div>
                        <div class="text-muted small"><%= HtmlUtil.escape(c.getCategory()) %></div>
                    </a>
                </div>
                <% } %>
            </div>
            <% } %>
        </div>
    </div>

    <%-- Course detail --%>
    <% if (course != null) { %>
    <div class="card shadow-sm border-0 mb-4">
        <div class="card-header bg-white fw-semibold border-bottom">
            <%= HtmlUtil.escape(course.getTitle()) %>
            <span class="badge bg-secondary ms-2"><%= HtmlUtil.escape(course.getCategory()) %></span>
        </div>
        <div class="card-body">
            <%-- Date picker form --%>
            <form method="get" action="<%= request.getContextPath() %>/attendance" class="row g-3 align-items-end mb-4">
                <input type="hidden" name="courseId" value="<%= course.getId() %>"/>
                <div class="col-12 col-md-4">
                    <label class="form-label" for="date">Date</label>
                    <input type="date" id="date" name="date" class="form-control"
                           max="<%= today.toString() %>"
                           value="<%= date != null ? date.toString() : "" %>">
                </div>
                <div class="col-12 col-md-2">
                    <button type="submit" class="btn btn-primary w-100">Load</button>
                </div>
            </form>

            <% if (students == null || students.isEmpty()) { %>
            <p class="text-muted">No students are enrolled in this course.</p>
            <% } else if (!readOnly) { %>
            <%-- Trainer: attendance form --%>
            <form method="post" action="<%= request.getContextPath() %>/attendance">
                <input type="hidden" name="courseId" value="<%= course.getId() %>"/>
                <input type="hidden" name="date" value="<%= date != null ? date.toString() : "" %>"/>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                        <tr>
                            <th>Student</th>
                            <th>Username</th>
                            <th class="text-center">Present</th>
                            <th class="text-center">Absent</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% for (User student : students) {
                            AttendanceStatus current = statuses != null ? statuses.get(student.getUsername()) : null;
                            boolean isPresent = current == AttendanceStatus.PRESENT;
                            boolean isAbsent = current == AttendanceStatus.ABSENT;
                            // Default to Present if no record
                            if (current == null) isPresent = true;
                        %>
                            <tr>
                                <td><%= HtmlUtil.escape(student.getFullName()) %></td>
                                <td class="text-muted"><%= HtmlUtil.escape(student.getUsername()) %></td>
                                <td class="text-center">
                                    <input type="radio" name="status_<%= student.getUsername() %>" value="PRESENT"
                                           class="form-check-input" <%= isPresent ? " checked" : "" %> required>
                                </td>
                                <td class="text-center">
                                    <input type="radio" name="status_<%= student.getUsername() %>" value="ABSENT"
                                           class="form-check-input" <%= isAbsent ? " checked" : "" %>>
                                </td>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
                <div class="mt-3">
                    <button type="submit" class="btn btn-primary">Save attendance</button>
                </div>
            </form>
            <% } else { %>
            <%-- Admin: read-only table --%>
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                    <tr>
                        <th>Student</th>
                        <th>Username</th>
                        <th>Status</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (User student : students) {
                        AttendanceStatus current = statuses != null ? statuses.get(student.getUsername()) : null;
                        String statusText;
                        if (current == AttendanceStatus.PRESENT) statusText = "Present";
                        else if (current == AttendanceStatus.ABSENT) statusText = "Absent";
                        else statusText = "Not recorded";
                    %>
                        <tr>
                            <td><%= HtmlUtil.escape(student.getFullName()) %></td>
                            <td class="text-muted"><%= HtmlUtil.escape(student.getUsername()) %></td>
                            <td><%= HtmlUtil.escape(statusText) %></td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
        </div>
    </div>

    <%-- Past sessions --%>
    <% if (sessionSummaries != null && !sessionSummaries.isEmpty()) { %>
    <div class="card shadow-sm border-0">
        <div class="card-header bg-white fw-semibold border-bottom">Past sessions</div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                    <tr>
                        <th>Date</th>
                        <th>Present</th>
                        <th>Absent</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (Map.Entry<LocalDate, int[]> entry : sessionSummaries.entrySet()) {
                        LocalDate d = entry.getKey();
                        int[] counts = entry.getValue();
                    %>
                        <tr>
                            <td>
                                <a href="<%= request.getContextPath() %>/attendance?courseId=<%= course.getId() %>&date=<%= d.toString() %>">
                                    <%= d.toString() %>
                                </a>
                            </td>
                            <td class="text-success fw-medium"><%= counts[0] %></td>
                            <td class="text-danger fw-medium"><%= counts[1] %></td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <% } %>
    <% } %>
</main>

<footer class="footer">
    <div class="container text-center text-muted small">
        &copy; 2026 <%= HtmlUtil.escape(application.getInitParameter("academyName")) %>. All rights reserved.
    </div>
</footer>
</body>
</html>