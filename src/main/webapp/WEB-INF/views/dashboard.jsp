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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - <%= HtmlUtil.escape(application.getInitParameter("academyName")) %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body class="bg-light">
<jsp:include page="menu.jsp"/>

<main class="container py-4">
    <div class="mb-4">
        <h1 class="h3 fw-bold mb-1">Dashboard</h1>
        <p class="text-muted">Welcome, <strong><%= loggedUser != null ? HtmlUtil.escape(loggedUser.getFullName()) : "" %></strong>!</p>
    </div>

    <%
        String msg = request.getParameter("msg");
        if ("enrolled".equals(msg)) {
    %>
    <div class="alert alert-success">You have been enrolled in the course.</div>
    <%
        } else if ("trainerAdded".equals(msg)) {
    %>
    <div class="alert alert-success">Trainer account created.</div>
    <%
        } else if ("courseAdded".equals(msg)) {
    %>
    <div class="alert alert-success">Course added successfully.</div>
    <%
        }
    %>

    <%-- STUDENT view --%>
    <% if (role == Role.STUDENT) {
        List<Course> myCourses = (List<Course>) request.getAttribute("myCourses");
        Map<Integer, int[]> attendanceSummaries = (Map<Integer, int[]>) request.getAttribute("attendanceSummaries");
    %>
    <div class="card shadow-sm border-0">
        <div class="card-header bg-white fw-semibold fs-5 border-bottom">My Enrolments</div>
        <div class="card-body p-0">
            <% if (myCourses == null || myCourses.isEmpty()) { %>
            <div class="p-4 text-muted">
                You are not enrolled in any course.
                <a href="<%= request.getContextPath() %>/courses">Browse courses</a> to get started.
            </div>
            <% } else { %>
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                    <tr>
                        <th>Course</th>
                        <th>Category</th>
                        <th>Attendance</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (Course course : myCourses) {
                        int[] summary = attendanceSummaries != null ? attendanceSummaries.get(course.getId()) : null;
                        int present = summary != null ? summary[0] : 0;
                        int total = summary != null ? summary[1] : 0;
                    %>
                        <tr>
                            <td class="fw-medium"><%= HtmlUtil.escape(course.getTitle()) %></td>
                            <td><span class="badge bg-secondary"><%= HtmlUtil.escape(course.getCategory()) %></span></td>
                            <td>
                                <% if (total == 0) { %>
                                <span class="text-muted">No sessions yet</span>
                                <% } else {
                                    int pct = Math.round(100.0f * present / total);
                                %>
                                <%= present %> of <%= total %> sessions (<%= pct %>%)
                                <% } %>
                            </td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
        </div>
    </div>

    <%-- TRAINER view --%>
    <% } else if (role == Role.TRAINER) {
        List<Course> myCourses = (List<Course>) request.getAttribute("myCourses");
        Map<Integer, List<User>> studentsByCourse = (Map<Integer, List<User>>) request.getAttribute("studentsByCourse");
    %>
    <div class="card shadow-sm border-0">
        <div class="card-header bg-white fw-semibold fs-5 border-bottom">My Courses</div>
        <div class="card-body">
            <% if (myCourses == null || myCourses.isEmpty()) { %>
            <p class="text-muted mb-0">No courses assigned to you.</p>
            <% } else {
                for (Course course : myCourses) {
                    List<User> students = studentsByCourse != null ? studentsByCourse.get(course.getId()) : null;
            %>
            <div class="pb-4 mb-4 border-bottom">
                <h5 class="fw-semibold mb-1"><%= HtmlUtil.escape(course.getTitle()) %></h5>
                <p class="text-muted mb-3"><%= HtmlUtil.escape(course.getCategory()) %></p>
                <h6 class="mb-2">Enrolled Students</h6>
                <% if (students == null || students.isEmpty()) { %>
                <p class="text-muted small mb-0">No students enrolled yet.</p>
                <% } else { %>
                <div class="table-responsive">
                    <table class="table table-sm table-hover align-middle mb-0">
                        <thead class="table-light">
                        <tr>
                            <th>Student Name</th>
                            <th>Username</th>
                            <th>Action</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% for (User student : students) { %>
                            <tr>
                                <td><%= HtmlUtil.escape(student.getFullName()) %></td>
                                <td class="text-muted"><%= HtmlUtil.escape(student.getUsername()) %></td>
                                <td>
                                    <a href="<%= request.getContextPath() %>/attendance?courseId=<%= course.getId() %>"
                                       class="btn btn-primary btn-sm">Mark attendance</a>
                                </td>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
                <% } %>
            </div>
            <% }
            } %>
        </div>
    </div>

    <%-- ADMIN view --%>
    <% } else if (role == Role.ADMIN) { %>
    <div class="row g-3 mb-4">
        <div class="col-6 col-lg-3">
            <div class="card border-0 shadow-sm text-center h-100">
                <div class="card-body py-4">
                    <div class="display-6 fw-bold text-primary"><%= request.getAttribute("userCount") %></div>
                    <div class="text-muted small mt-1">Total Users</div>
                </div>
            </div>
        </div>
        <div class="col-6 col-lg-3">
            <div class="card border-0 shadow-sm text-center h-100">
                <div class="card-body py-4">
                    <div class="display-6 fw-bold text-success"><%= request.getAttribute("trainerCount") %></div>
                    <div class="text-muted small mt-1">Trainers</div>
                </div>
            </div>
        </div>
        <div class="col-6 col-lg-3">
            <div class="card border-0 shadow-sm text-center h-100">
                <div class="card-body py-4">
                    <div class="display-6 fw-bold text-warning"><%= request.getAttribute("studentCount") %></div>
                    <div class="text-muted small mt-1">Students</div>
                </div>
            </div>
        </div>
        <div class="col-6 col-lg-3">
            <div class="card border-0 shadow-sm text-center h-100">
                <div class="card-body py-4">
                    <div class="display-6 fw-bold text-info"><%= request.getAttribute("courseCount") %></div>
                    <div class="text-muted small mt-1">Courses</div>
                </div>
            </div>
        </div>
        <div class="col-6 col-lg-3">
            <div class="card border-0 shadow-sm text-center h-100">
                <div class="card-body py-4">
                    <div class="display-6 fw-bold text-secondary"><%= request.getAttribute("enrollmentCount") %></div>
                    <div class="text-muted small mt-1">Enrolments</div>
                </div>
            </div>
        </div>
        <div class="col-6 col-lg-3">
            <div class="card border-0 shadow-sm text-center h-100">
                <div class="card-body py-4">
                    <div class="display-6 fw-bold text-dark"><%= request.getAttribute("activeSessions") %></div>
                    <div class="text-muted small mt-1">Active Sessions</div>
                </div>
            </div>
        </div>
    </div>

    <div class="card shadow-sm border-0">
        <div class="card-header bg-white fw-semibold fs-5 border-bottom">Quick Actions</div>
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

<footer class="footer">
    <div class="container text-center text-muted small">
        &copy; 2026 <%= HtmlUtil.escape(application.getInitParameter("academyName")) %>. All rights reserved.
    </div>
</footer>
</body>
</html>