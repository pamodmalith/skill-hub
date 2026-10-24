<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillhub.model.Course, com.skillhub.model.Role, com.skillhub.model.User, java.util.List, java.util.Map" %>
<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    Role role       = loggedUser != null ? loggedUser.getRole() : null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - <%= application.getInitParameter("academyName") %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<jsp:include page="menu.jsp"/>

<main class="main container">
    <div class="page-header">
        <h1 class="page-title">Dashboard</h1>
        <p class="page-subtitle">Welcome, <%= loggedUser != null ? loggedUser.getFullName() : "" %>!</p>
    </div>

    <% if ("enrolled".equals(request.getParameter("msg"))) { %>
        <div class="alert alert-success">Successfully enrolled in the course!</div>
    <% } %>
    <% if ("duplicate".equals(request.getParameter("msg"))) { %>
        <div class="alert alert-error">You are already enrolled in this course.</div>
    <% } %>
    <% if ("added".equals(request.getParameter("msg"))) { %>
        <div class="alert alert-success">Course added successfully!</div>
    <% } %>

    <%-- STUDENT view --%>
    <% if (role == Role.STUDENT) {
           List<Course> enrolledCourses = (List<Course>) request.getAttribute("enrolledCourses");
           Map<Integer, User> trainerMap = (Map<Integer, User>) request.getAttribute("trainerMap");
    %>
        <div class="card">
            <div class="card-header">My Enrolments</div>
            <div class="card-body">
                <% if (enrolledCourses == null || enrolledCourses.isEmpty()) { %>
                    <p style="color: #666;">You are not enrolled in any courses yet.
                        <a href="<%= request.getContextPath() %>/courses">Browse courses</a> to get started.</p>
                <% } else { %>
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                            <tr>
                                <th>Course</th>
                                <th>Category</th>
                                <th>Trainer</th>
                            </tr>
                            </thead>
                            <tbody>
                            <% for (Course course : enrolledCourses) {
                                   User trainer = trainerMap != null ? trainerMap.get(course.getId()) : null;
                            %>
                                <tr>
                                    <td><%= course.getTitle() %></td>
                                    <td><%= course.getCategory() %></td>
                                    <td><%= trainer != null ? trainer.getFullName() : "" %></td>
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
           List<Course> trainerCourses = (List<Course>) request.getAttribute("trainerCourses");
    %>
        <div class="card">
            <div class="card-header">My Courses</div>
            <div class="card-body">
                <% if (trainerCourses == null || trainerCourses.isEmpty()) { %>
                    <p style="color: #666;">No courses assigned to you.</p>
                <% } else {
                       for (Course course : trainerCourses) {
                           List<User> students = (List<User>) request.getAttribute("studentsForCourse_" + course.getId());
                %>
                    <div style="margin-bottom: 24px; padding-bottom: 24px; border-bottom: 1px solid #eef2f7;">
                        <h3 style="margin-bottom: 8px;"><%= course.getTitle() %></h3>
                        <p style="color: #666; margin-bottom: 16px;"><%= course.getCategory() %></p>
                        <h4 style="margin-bottom: 12px;">Enrolled Students</h4>
                        <% if (students == null || students.isEmpty()) { %>
                            <p style="color: #666;">No students enrolled yet.</p>
                        <% } else { %>
                            <div class="table-responsive">
                                <table class="table">
                                    <thead>
                                    <tr>
                                        <th>Student Name</th>
                                        <th>Email</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <% for (User student : students) { %>
                                        <tr>
                                            <td><%= student.getFullName() %></td>
                                            <td><%= student.getEmail() %></td>
                                        </tr>
                                    <% } %>
                                    </tbody>
                                </table>
                            </div>
                        <% } %>
                    </div>
                <%     }
                   } %>
            </div>
        </div>

    <%-- ADMIN view --%>
    <% } else if (role == Role.ADMIN) { %>
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-value"><%= request.getAttribute("userCount") %></div>
                <div class="stat-label">Total Users</div>
            </div>
            <div class="stat-card">
                <div class="stat-value"><%= request.getAttribute("courseCount") %></div>
                <div class="stat-label">Total Courses</div>
            </div>
            <div class="stat-card">
                <div class="stat-value"><%= request.getAttribute("enrollmentCount") %></div>
                <div class="stat-label">Total Enrolments</div>
            </div>
            <div class="stat-card">
                <div class="stat-value"><%= request.getAttribute("activeSessions") %></div>
                <div class="stat-label">Active Sessions</div>
            </div>
        </div>

        <div class="card">
            <div class="card-header">Quick Actions</div>
            <div class="card-body">
                <a href="<%= request.getContextPath() %>/admin/add-course" class="btn btn-primary">Add New Course</a>
                <a href="<%= request.getContextPath() %>/courses" class="btn btn-secondary" style="margin-left: 12px;">View All Courses</a>
            </div>
        </div>
    <% } %>
</main>

<footer class="footer container">
    <p>&copy; 2026 <%= application.getInitParameter("academyName") %>. All rights reserved.</p>
</footer>
</body>
</html>
