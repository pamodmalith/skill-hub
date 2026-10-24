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
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
          rel="stylesheet"
          integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB"
          crossorigin="anonymous">
</head>
<body class="bg-light">
<jsp:include page="menu.jsp"/>

<main class="container py-4">
    <div class="mb-4">
        <h1 class="h3 fw-bold mb-1">Dashboard</h1>
        <p class="text-muted">Welcome, <strong><%= loggedUser != null ? loggedUser.getFullName() : "" %></strong>!</p>
    </div>

    <% if ("enrolled".equals(request.getParameter("msg"))) { %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            Successfully enrolled in the course!
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>
    <% if ("duplicate".equals(request.getParameter("msg"))) { %>
        <div class="alert alert-warning alert-dismissible fade show" role="alert">
            You are already enrolled in this course.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>
    <% if ("added".equals(request.getParameter("msg"))) { %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            Course added successfully!
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>

    <%-- STUDENT view --%>
    <% if (role == Role.STUDENT) {
           List<Course> enrolledCourses = (List<Course>) request.getAttribute("enrolledCourses");
           Map<Integer, User> trainerMap = (Map<Integer, User>) request.getAttribute("trainerMap");
    %>
        <div class="card shadow-sm border-0">
            <div class="card-header bg-white fw-semibold fs-5 border-bottom">My Enrolments</div>
            <div class="card-body p-0">
                <% if (enrolledCourses == null || enrolledCourses.isEmpty()) { %>
                    <div class="p-4 text-muted">
                        You are not enrolled in any courses yet.
                        <a href="<%= request.getContextPath() %>/courses">Browse courses</a> to get started.
                    </div>
                <% } else { %>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
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
                                    <td class="fw-medium"><%= course.getTitle() %></td>
                                    <td><span class="badge bg-secondary bg-opacity-10 text-secondary"><%= course.getCategory() %></span></td>
                                    <td class="text-muted"><%= trainer != null ? trainer.getFullName() : "" %></td>
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
        <div class="card shadow-sm border-0">
            <div class="card-header bg-white fw-semibold fs-5 border-bottom">My Courses</div>
            <div class="card-body">
                <% if (trainerCourses == null || trainerCourses.isEmpty()) { %>
                    <p class="text-muted mb-0">No courses assigned to you.</p>
                <% } else {
                       for (Course course : trainerCourses) {
                           List<User> students = (List<User>) request.getAttribute("studentsForCourse_" + course.getId());
                %>
                    <div class="pb-4 mb-4 border-bottom">
                        <h5 class="fw-semibold mb-1"><%= course.getTitle() %></h5>
                        <p class="text-muted mb-3"><%= course.getCategory() %></p>
                        <h6 class="mb-2">Enrolled Students</h6>
                        <% if (students == null || students.isEmpty()) { %>
                            <p class="text-muted small mb-0">No students enrolled yet.</p>
                        <% } else { %>
                            <div class="table-responsive">
                                <table class="table table-sm table-hover align-middle mb-0">
                                    <thead class="table-light">
                                    <tr>
                                        <th>Student Name</th>
                                        <th>Email</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <% for (User student : students) { %>
                                        <tr>
                                            <td><%= student.getFullName() %></td>
                                            <td class="text-muted"><%= student.getEmail() %></td>
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
                        <div class="display-6 fw-bold text-success"><%= request.getAttribute("courseCount") %></div>
                        <div class="text-muted small mt-1">Total Courses</div>
                    </div>
                </div>
            </div>
            <div class="col-6 col-lg-3">
                <div class="card border-0 shadow-sm text-center h-100">
                    <div class="card-body py-4">
                        <div class="display-6 fw-bold text-warning"><%= request.getAttribute("enrollmentCount") %></div>
                        <div class="text-muted small mt-1">Total Enrolments</div>
                    </div>
                </div>
            </div>
            <div class="col-6 col-lg-3">
                <div class="card border-0 shadow-sm text-center h-100">
                    <div class="card-body py-4">
                        <div class="display-6 fw-bold text-info"><%= request.getAttribute("activeSessions") %></div>
                        <div class="text-muted small mt-1">Active Sessions</div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card shadow-sm border-0">
            <div class="card-header bg-white fw-semibold fs-5 border-bottom">Quick Actions</div>
            <div class="card-body d-flex gap-2 flex-wrap">
                <a href="<%= request.getContextPath() %>/admin/add-course" class="btn btn-primary">Add New Course</a>
                <a href="<%= request.getContextPath() %>/courses" class="btn btn-outline-secondary">View All Courses</a>
            </div>
        </div>
    <% } %>
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
