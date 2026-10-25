<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillhub.model.Course, com.skillhub.model.Role, com.skillhub.model.User, java.util.List, java.util.Map" %>
<%@ page import="com.skillhub.util.HtmlUtil" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    Role role = loggedUser != null ? loggedUser.getRole() : null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Dashboard - <%= HtmlUtil.escape(application.getInitParameter("academyName")) %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<jsp:include page="menu.jsp"/>

<main class="container-lg py-4 px-3">

    <div class="mb-4">
        <h1 class="h3 fw-bold mb-1">Dashboard</h1>
        <p class="text-muted mb-0">Welcome back, <strong><%= loggedUser != null ? HtmlUtil.escape(loggedUser.getFullName()) : "" %></strong>!</p>
    </div>

    <%
        String msg = request.getParameter("msg");
        if ("enrolled".equals(msg)) {
    %>
    <div class="alert alert-success" role="alert">You have been enrolled in the course.</div>
    <%
        } else if ("trainerAdded".equals(msg)) {
    %>
    <div class="alert alert-success" role="alert">Trainer account created.</div>
    <%
        } else if ("courseAdded".equals(msg)) {
    %>
    <div class="alert alert-success" role="alert">Course added successfully.</div>
    <%
        }
    %>

    <%-- ═══════════════════════ STUDENT view ═══════════════════════ --%>
    <% if (role == Role.STUDENT) {
        List<Course> myCourses = (List<Course>) request.getAttribute("myCourses");
        Map<Integer, int[]> attendanceSummaries = (Map<Integer, int[]>) request.getAttribute("attendanceSummaries");
    %>
    <h2 class="h5 fw-semibold mb-3">My Enrolments</h2>

    <% if (myCourses == null || myCourses.isEmpty()) { %>
    <div class="card">
        <div class="card-body text-center py-5 text-muted">
            <p class="mb-3">You are not enrolled in any course yet.</p>
            <a href="<%= request.getContextPath() %>/courses" class="btn btn-primary">Browse Courses</a>
        </div>
    </div>
    <% } else { %>
    <div class="row g-3">
        <% for (Course course : myCourses) {
            int[] summary = attendanceSummaries != null ? attendanceSummaries.get(course.getId()) : null;
            int present = summary != null ? summary[0] : 0;
            int total   = summary != null ? summary[1] : 0;
            int pct     = (total > 0) ? Math.round(100.0f * present / total) : 0;
            String attendanceClass = (total == 0) ? "" : (pct >= 75 ? "attendance-good" : (pct >= 50 ? "attendance-ok" : "attendance-poor"));
        %>
        <div class="col-12 col-md-6 col-xl-4">
            <div class="card h-100 sh-stat-card">
                <div class="card-body p-3">
                    <div class="d-flex justify-content-between align-items-start mb-2">
                        <h6 class="fw-semibold mb-0"><%= HtmlUtil.escape(course.getTitle()) %></h6>
                        <span class="badge bg-secondary ms-2"><%= HtmlUtil.escape(course.getCategory()) %></span>
                    </div>
                    <% if (total == 0) { %>
                    <p class="text-muted small mb-0">No sessions recorded yet.</p>
                    <% } else { %>
                    <p class="small text-muted mb-1">
                        Attendance: <strong><%= present %></strong> of <strong><%= total %></strong> sessions (<strong><%= pct %>%</strong>)
                    </p>
                    <div class="progress <%= attendanceClass %>" style="height: 8px;" role="progressbar"
                         aria-valuenow="<%= pct %>" aria-valuemin="0" aria-valuemax="100">
                        <div class="progress-bar" style="width: <%= pct %>%"></div>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
        <% } %>
    </div>
    <% } %>

    <%-- ═══════════════════════ TRAINER view ═══════════════════════ --%>
    <% } else if (role == Role.TRAINER) {
        List<Course> myCourses = (List<Course>) request.getAttribute("myCourses");
        Map<Integer, List<User>> studentsByCourse = (Map<Integer, List<User>>) request.getAttribute("studentsByCourse");
    %>
    <h2 class="h5 fw-semibold mb-3">My Courses</h2>

    <% if (myCourses == null || myCourses.isEmpty()) { %>
    <div class="card">
        <div class="card-body text-center py-5 text-muted">No courses assigned to you.</div>
    </div>
    <% } else {
        for (Course course : myCourses) {
            List<User> students = studentsByCourse != null ? studentsByCourse.get(course.getId()) : null;
    %>
    <div class="card mb-3">
        <div class="card-header d-flex justify-content-between align-items-center">
            <div>
                <span class="fw-semibold"><%= HtmlUtil.escape(course.getTitle()) %></span>
                <span class="badge bg-secondary ms-2"><%= HtmlUtil.escape(course.getCategory()) %></span>
            </div>
            <a href="<%= request.getContextPath() %>/attendance?courseId=<%= course.getId() %>"
               class="btn btn-accent btn-sm">Mark Attendance</a>
        </div>
        <div class="card-body p-0">
            <% if (students == null || students.isEmpty()) { %>
            <p class="text-muted small p-3 mb-0">No students enrolled yet.</p>
            <% } else { %>
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                    <tr>
                        <th>Student Name</th>
                        <th>Username</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (User student : students) { %>
                    <tr>
                        <td class="fw-medium"><%= HtmlUtil.escape(student.getFullName()) %></td>
                        <td class="text-muted"><%= HtmlUtil.escape(student.getUsername()) %></td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
        </div>
    </div>
    <%  }
    } %>

    <%-- ═══════════════════════ ADMIN view ═══════════════════════ --%>
    <% } else if (role == Role.ADMIN) { %>
    <h2 class="h5 fw-semibold mb-3">Academy Overview</h2>
    <div class="row g-3 mb-4">
        <div class="col-6 col-lg-4">
            <div class="card sh-stat-card accent-teal h-100">
                <div class="card-body py-3 px-4">
                    <div class="sh-stat-value"><%= request.getAttribute("userCount") %></div>
                    <div class="sh-stat-label">Total Users</div>
                </div>
            </div>
        </div>
        <div class="col-6 col-lg-4">
            <div class="card sh-stat-card accent-green h-100">
                <div class="card-body py-3 px-4">
                    <div class="sh-stat-value"><%= request.getAttribute("trainerCount") %></div>
                    <div class="sh-stat-label">Trainers</div>
                </div>
            </div>
        </div>
        <div class="col-6 col-lg-4">
            <div class="card sh-stat-card accent-amber h-100">
                <div class="card-body py-3 px-4">
                    <div class="sh-stat-value"><%= request.getAttribute("studentCount") %></div>
                    <div class="sh-stat-label">Students</div>
                </div>
            </div>
        </div>
        <div class="col-6 col-lg-4">
            <div class="card sh-stat-card accent-indigo h-100">
                <div class="card-body py-3 px-4">
                    <div class="sh-stat-value"><%= request.getAttribute("courseCount") %></div>
                    <div class="sh-stat-label">Courses</div>
                </div>
            </div>
        </div>
        <div class="col-6 col-lg-4">
            <div class="card sh-stat-card accent-slate h-100">
                <div class="card-body py-3 px-4">
                    <div class="sh-stat-value"><%= request.getAttribute("enrollmentCount") %></div>
                    <div class="sh-stat-label">Enrolments</div>
                </div>
            </div>
        </div>
        <div class="col-6 col-lg-4">
            <div class="card sh-stat-card accent-rose h-100">
                <div class="card-body py-3 px-4">
                    <div class="sh-stat-value"><%= request.getAttribute("activeSessions") %></div>
                    <div class="sh-stat-label">Active Sessions</div>
                </div>
            </div>
        </div>
    </div>

    <div class="card">
        <div class="card-header">Quick Actions</div>
        <div class="card-body d-flex gap-2 flex-wrap">
            <a href="<%= request.getContextPath() %>/admin/add-trainer" class="btn btn-primary">Add Trainer</a>
            <a href="<%= request.getContextPath() %>/admin/add-course" class="btn btn-primary">Add Course</a>
            <a href="<%= request.getContextPath() %>/admin/enroll" class="btn btn-primary">Enrol Student</a>
            <a href="<%= request.getContextPath() %>/attendance" class="btn btn-outline-secondary">View Attendance</a>
            <a href="<%= request.getContextPath() %>/courses" class="btn btn-outline-secondary">View All Courses</a>
        </div>
    </div>
    <% } %>

</main>

<footer class="sh-footer mt-4">
    <div class="container-lg text-center">
        &copy; 2026 <%= HtmlUtil.escape(application.getInitParameter("academyName")) %>. All rights reserved.
    </div>
</footer>

<script src="<%= request.getContextPath() %>/js/bootstrap.bundle.min.js"></script>
</body>
</html>
