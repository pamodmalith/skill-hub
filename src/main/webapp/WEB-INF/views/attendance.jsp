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
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Attendance - <%= HtmlUtil.escape(application.getInitParameter("academyName")) %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body class="d-flex flex-column min-vh-100 bg-light">
<jsp:include page="menu.jsp"/>

<main class="container py-4 flex-grow-1">
    <div class="mb-4">
        <h1 class="h3 fw-bold mb-1">Attendance</h1>
        <p class="text-muted mb-0">Mark and view attendance records</p>
    </div>

    <%
        String msg = request.getParameter("msg");
        if ("attendanceSaved".equals(msg)) {
    %>
    <div class="alert alert-success" role="alert">Attendance saved successfully.</div>
    <%
        } else if ("futureDate".equals(msg)) {
    %>
    <div class="alert alert-danger" role="alert">Attendance cannot be recorded for a future date.</div>
    <%
        } else if ("invalidDate".equals(msg)) {
    %>
    <div class="alert alert-danger" role="alert">Invalid date.</div>
    <%
        } else if ("invalidCourse".equals(msg)) {
    %>
    <div class="alert alert-danger" role="alert">Invalid course.</div>
    <%
        }
    %>

    <%-- ── Course picker ── --%>
    <div class="card shadow-sm border-0 mb-4">
        <div class="card-header bg-white fw-semibold">Select Course</div>
        <div class="card-body">
            <% if (courses == null || courses.isEmpty()) { %>
            <p class="text-muted mb-0">No courses available.</p>
            <% } else { %>
            <div class="row g-2">
                <% for (Course c : courses) {
                    boolean isSelected = (course != null && course.getId() == c.getId());
                %>
                <div class="col-12 col-sm-6 col-lg-4">
                    <a href="<%= request.getContextPath() %>/attendance?courseId=<%= c.getId() %>"
                       class="btn <%= isSelected ? "btn-primary" : "btn-outline-primary" %> w-100 py-3 text-start">
                        <div class="fw-medium"><%= HtmlUtil.escape(c.getTitle()) %></div>
                        <div class="small opacity-75"><%= HtmlUtil.escape(c.getCategory()) %></div>
                    </a>
                </div>
                <% } %>
            </div>
            <% } %>
        </div>
    </div>

    <%-- ── Course detail ── --%>
    <% if (course != null) { %>
    <div class="card shadow-sm border-0 mb-4">
        <div class="card-header bg-white fw-semibold d-flex align-items-center gap-2">
            <span><%= HtmlUtil.escape(course.getTitle()) %></span>
            <span class="badge bg-secondary"><%= HtmlUtil.escape(course.getCategory()) %></span>
        </div>
        <div class="card-body">
            <%-- Date picker form --%>
            <form method="get" action="<%= request.getContextPath() %>/attendance" class="row g-3 align-items-end mb-4">
                <input type="hidden" name="courseId" value="<%= course.getId() %>"/>
                <div class="col-12 col-sm-5 col-md-4">
                    <label class="form-label fw-medium" for="date">Session Date</label>
                    <input type="date" id="date" name="date" class="form-control"
                           max="<%= today.toString() %>"
                           value="<%= date != null ? date.toString() : "" %>">
                </div>
                <div class="col-12 col-sm-3 col-md-2">
                    <button type="submit" class="btn btn-primary w-100">Load</button>
                </div>
            </form>

            <% if (students == null || students.isEmpty()) { %>
            <p class="text-muted">No students are enrolled in this course.</p>
            <% } else if (!readOnly) { %>
            <%-- Trainer: attendance form with btn-check toggle buttons --%>
            <form method="post" action="<%= request.getContextPath() %>/attendance">
                <input type="hidden" name="courseId" value="<%= course.getId() %>"/>
                <input type="hidden" name="date" value="<%= date != null ? date.toString() : "" %>"/>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                        <tr>
                            <th>Student</th>
                            <th>Username</th>
                            <th class="text-center">Attendance</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% for (User student : students) {
                            AttendanceStatus current = statuses != null ? statuses.get(student.getUsername()) : null;
                            boolean isPresent = current == AttendanceStatus.PRESENT;
                            boolean isAbsent  = current == AttendanceStatus.ABSENT;
                            // Default to Present if no record
                            if (current == null) isPresent = true;
                            String uid = "att_" + student.getUsername().replaceAll("[^a-zA-Z0-9]", "_");
                        %>
                        <tr>
                            <td class="fw-medium"><%= HtmlUtil.escape(student.getFullName()) %></td>
                            <td class="text-muted"><%= HtmlUtil.escape(student.getUsername()) %></td>
                            <td class="text-center">
                                <div class="btn-group" role="group">
                                    <input type="radio"
                                           class="btn-check"
                                           name="status_<%= student.getUsername() %>"
                                           id="<%= uid %>_present"
                                           value="PRESENT"
                                           <%= isPresent ? "checked" : "" %>
                                           required>
                                    <label class="btn btn-outline-success btn-sm" for="<%= uid %>_present">Present</label>

                                    <input type="radio"
                                           class="btn-check"
                                           name="status_<%= student.getUsername() %>"
                                           id="<%= uid %>_absent"
                                           value="ABSENT"
                                           <%= isAbsent ? "checked" : "" %>>
                                    <label class="btn btn-outline-danger btn-sm" for="<%= uid %>_absent">Absent</label>
                                </div>
                            </td>
                        </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
                <div class="mt-3">
                    <button type="submit" class="btn btn-primary">Save Attendance</button>
                </div>
            </form>
            <% } else { %>
            <%-- Admin: read-only view with coloured badges --%>
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
                        String badgeClass;
                        if (current == AttendanceStatus.PRESENT) {
                            statusText = "Present";
                            badgeClass = "bg-success";
                        } else if (current == AttendanceStatus.ABSENT) {
                            statusText = "Absent";
                            badgeClass = "bg-danger";
                        } else {
                            statusText = "Not recorded";
                            badgeClass = "bg-secondary";
                        }
                    %>
                    <tr>
                        <td class="fw-medium"><%= HtmlUtil.escape(student.getFullName()) %></td>
                        <td class="text-muted"><%= HtmlUtil.escape(student.getUsername()) %></td>
                        <td><span class="badge <%= badgeClass %>"><%= HtmlUtil.escape(statusText) %></span></td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
        </div>
    </div>

    <%-- Past sessions table --%>
    <% if (sessionSummaries != null && !sessionSummaries.isEmpty()) { %>
    <div class="card shadow-sm border-0">
        <div class="card-header bg-white fw-semibold">Past Sessions</div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                    <tr>
                        <th>Date</th>
                        <th class="text-success">Present</th>
                        <th class="text-danger">Absent</th>
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

<footer class="bg-primary text-white-50 text-center small py-3 mt-auto">
    <div class="container text-center">
        &copy; 2026 <%= HtmlUtil.escape(application.getInitParameter("academyName")) %>. All rights reserved.
    </div>
</footer>

<script src="<%= request.getContextPath() %>/js/bootstrap.bundle.min.js"></script>
</body>
</html>
